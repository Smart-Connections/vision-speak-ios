import AVFoundation
import Vision
import Combine
import CoreImage
import UIKit

class RealTimeImageClassificationViewModel: ObservableObject {
    private let videoCapture = VideoCapture()
    private let imageAnalysisModel = ImageAnalysisModel()
    private let chatGPT = ChatGPT()
    private let textToSpeak = TextToSpeak()
    private let recordVoice = RecordVoice()
    private let cloudVision = AnalyzeImage()
    private let purchase = Purchase()
    
    private let studyHistoryDataSource = StudyHistoryDataSource()
    private let vocabularyDataSource = VocabularyDataSource()
    var timer: Timer?
    
    @Published var wordsCount: Int = 0
    @Published var passedTime: TimeInterval = 0
    @Published var remainSeconds: TimeInterval = TimeInterval(AppValue.initSecondsSymbol)
    @Published var messagesWithChatGPT = [Message]()
    @Published var jaMessages = [Message]() // 日本語で表示するメッセージ
    @Published var feedbacks = [Feedback]() // Feedbackの数
    @Published var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    @Published var status: CameraStatus = .ready
    @Published var picture: Data?
    @Published var imageResult: AnalyzeImageResult?
    @Published var selectedVocabulary = Set<Vocabulary>()
    @Published var notSetVocabulary: Bool = false // Vocabularyを設定しない場合にtrue
    @Published var recognitionResults: [VNRecognizedObjectObservation] = []
    
    private var cancellables = Set<AnyCancellable>()
    private var lessonLimitSeconds: Double? = nil
    private var purchaseState: PurchaseState? = nil
    
    init(purchaseState: PurchaseState) {
        imageAnalysisModel.delegate = self
        videoCapture.delegate = self
        chatGPT.delegate = self
        textToSpeak.delegate = self
        cloudVision.delegate = self
        
        self.purchaseState = purchaseState
        self.lessonLimitSeconds = purchaseState.status.limitSeconds
    }
    
    func startTimer() {
        if (purchaseState?.status == .unlimited) { return }
        guard let lessonLimitSeconds = self.lessonLimitSeconds else { return }
        DispatchQueue.main.async {
            self.timer = Timer
                .scheduledTimer(
                    withTimeInterval: 1.0,
                    repeats: true
                ) { _ in
                    let seconds = Double(self.studyHistoryDataSource.todayHistory()?.studyTimeSeconds ?? 0)
                    self.passedTime += 1
                    self.remainSeconds = lessonLimitSeconds - seconds - self.passedTime
                }
        }
    }
    
    func startCapturing() {
        videoCapture.startCapturing()
    }
    
    func takePicture() {
        videoCapture.takePicture()
        status = .waitingVisionResults
    }
    
    func reset() {
        videoCapture.stopCapturing()
        self.recordVoice.cancelRecording()
    }
    
    @MainActor func transcript() {
        guard let url = self.recordVoice.stopRecording() else { return }
        guard let audioData = FileManager().contents(atPath: url.relativePath) else { return }
        self.recordVoice.cancelRecording()
        chatGPT.transcript(message: audioData.base64EncodedString())
        self.status = .waitingGptMessage
    }
    
    func clearChatHistory() {
        messagesWithChatGPT.removeAll()
        status = .ready
    }
    
    func toggleLanguage(message: Message) {
        if let index = jaMessages.firstIndex(of: message) {
            jaMessages.remove(at: index)
        } else {
            jaMessages.append(message)
        }
    }
    
    func getFeedback(message: Message) {
        chatGPT.feedback(message: message, targetVocabularies: Array(selectedVocabulary))
    }
    
    func resetTimer() {
        self.passedTime = TimeInterval(AppValue.initSecondsSymbol)
        self.remainSeconds = TimeInterval(AppValue.initSecondsSymbol)
    }
    
    private func callGPT(_ text: String) {
        chatGPT.sendMessage(message: text, threadId: imageResult?.chatThreadID ?? "")
        self.status = .waitingGptMessage
    }
}

extension RealTimeImageClassificationViewModel: VideoCaptureDelegate {
    func didTakePicture(_ data: Data) {
        self.picture = UIImage(data: data)?.resizeImage(withPercentage: 0.2)?.jpegData(compressionQuality: 0.2)
        cloudVision.analyzeImage(imageBase64: picture?.base64EncodedString() ?? "")
    }
    
    func didSet(_ previewLayer: AVCaptureVideoPreviewLayer) {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                self.previewLayer = previewLayer
            })
        }
    }
    
    func didCaptureFrame(from imageBuffer: CVImageBuffer) {
        imageAnalysisModel.performRequest(with: imageBuffer)
    }
}

extension RealTimeImageClassificationViewModel: ChatGPTDelegate {
    func receiveTranscript(_ text: String) {
        DispatchQueue.main.async {
            self.messagesWithChatGPT.append(Message(role: "user", english_message: text, japanese_message: ""))
            self.wordsCount += text.split(separator: " ").count
            self.callGPT(text)
            self.standLearnedFlagIfNeeded(text)
        }
    }
    
    func receiveMessage(_ message: Message) {
        DispatchQueue.main.async {
            self.textToSpeak.textToSpeak(text: message.english_message)
            self.messagesWithChatGPT.append(message)
        }
    }
    
    func receiveFeedback(feedback: Feedback) {
        DispatchQueue.main.async {
            self.feedbacks.append(feedback)
        }
    }
    
    private func standLearnedFlagIfNeeded(_ text: String) {
        selectedVocabulary.forEach { vocabulary in
            if (text.contains(vocabulary.vocabulary)) {
                vocabularyDataSource.updateVocabulary(vocabulary, true)
            }
        }
    }
}

extension RealTimeImageClassificationViewModel: TextToSpeakDelegate {
    func finishSpeak() {
        self.status = .inputtingReply
        self.recordVoice.startRecording()
    }
}

extension RealTimeImageClassificationViewModel: AnalyzeImageDelegate {
    func didAnalyzeImage(_ result: AnalyzeImageResult) {
        DispatchQueue.main.async {
            self.imageResult = result
            let message = Message(role: "assistant", english_message: result.englishMessage, japanese_message: result.japaneseMessage)
            self.messagesWithChatGPT.append(message)
            self.textToSpeak.textToSpeak(text: message.english_message)
        }
    }
}

extension RealTimeImageClassificationViewModel: ImageAnalysisModelDelegate {
    func didRecieve(_ results: [VNRecognizedObjectObservation]) {
        DispatchQueue.main.async {
            self.recognitionResults = results
        }
    }
}
