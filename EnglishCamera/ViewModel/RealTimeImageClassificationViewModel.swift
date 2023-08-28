import AVFoundation
import Vision
import Combine

class RealTimeImageClassificationViewModel: ObservableObject {
    private let videoCapture = VideoCapture()
    private let resnet50ModelManager = Resnet50ModelManager()
    private let chatGPT = ChatGPT()
    private let textToSpeak = TextToSpeak()
    private let recordVoice = RecordVoice()
    private let cloudVision = GoogleCloudOCR()
    
    private let studyHistoryDataSource = StudyHistoryDataSource()
    var timer: Timer?
    
    @Published var wordsCount: Int = 0
    @Published var passedTime: TimeInterval = 0
    @Published var remainSeconds: TimeInterval = TimeInterval(AppValue.initSecondsSymbol)
    @Published var messagesWithChatGPT = [Message]()
    @Published var jaMessages = [Message]()
    @Published var observationText: String = ""
    @Published var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    @Published var status: CameraStatus = .ready
    @Published var picture: Data?
    @Published var imageResult: DetectImageResult?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
//        resnet50ModelManager.delegate = self
        videoCapture.delegate = self
        chatGPT.delegate = self
        textToSpeak.delegate = self
        cloudVision.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.timer = Timer
                .scheduledTimer(
                    withTimeInterval: 1.0,
                    repeats: true
                ) { _ in
                    let seconds = Double(self.studyHistoryDataSource.todayHistory()?.studyTimeSeconds ?? 0)
                    self.passedTime += 1
                    self.remainSeconds = Double(AppValue.limitSeconds) - seconds - self.passedTime
                }
        }
    }
    
    func startCapturing() {
        videoCapture.startCapturing()
    }
    
    func takePicture() {
        videoCapture.takePicture()
    }
    
    func reset() {
        videoCapture.stopCapturing()
        self.recordVoice.cancelRecording()
    }
    
    @MainActor func sendReply() {
        guard let url = self.recordVoice.stopRecording() else { return }
        self.recordVoice.cancelRecording()
        chatGPT.transcript(url)
        self.status = .waitingGptMessage
    }
    
    func clearChatHistory() {
        messagesWithChatGPT.removeAll()
        observationText = ""
        status = .ready
    }
    
    func toggleLanguage(message: Message) {
        if let index = jaMessages.firstIndex(of: message) {
            jaMessages.remove(at: index)
        } else {
            jaMessages.append(message)
        }
    }
    
    private func callGPT() {
        let content = "You are a AI of learning English App. Please talk with me about one of \(observationText). Please use lower than 15 words. Please use this format \"[En] [Ja]\" and return English and Japanese."
        messagesWithChatGPT.append(Message(content: content, role: "user"))
        chatGPT.chat(messagesWithChatGPT.filter { $0.role != "symbol"} )
        self.status = .waitingGptMessage
    }
}

extension RealTimeImageClassificationViewModel: VideoCaptureDelegate {
    func didTakePicture(_ data: Data) {
        self.picture = data
        cloudVision.detectImage(imageBase64: data.base64EncodedString())
    }
    
    func didSet(_ previewLayer: AVCaptureVideoPreviewLayer) {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                self.previewLayer = previewLayer
            })
        }
    }
    
    func didCaptureFrame(from imageBuffer: CVImageBuffer) {
//        resnet50ModelManager.performRequet(with: imageBuffer)
    }
}

extension RealTimeImageClassificationViewModel: ChatGPTDelegate {
    func receiveTranscript(_ text: String) {
        DispatchQueue.main.async {
            self.messagesWithChatGPT.append(Message(content: text, role: "user"))
            self.wordsCount += text.split(separator: " ").count
            print("received Transcript: \(text)")
            self.chatGPT.chat(self.messagesWithChatGPT.filter { $0.role != "symbol"} )
        }
    }
    
    func receiveMessage(_ message: Message) {
        DispatchQueue.main.async {
            self.textToSpeak.textToSpeak(text: message.en)
            self.messagesWithChatGPT.append(message)
        }
    }
}

extension RealTimeImageClassificationViewModel: TextToSpeakDelegate {
    func finishSpeak() {
        self.status = .inputtingReply
        self.recordVoice.startRecording()
    }
}

extension RealTimeImageClassificationViewModel: GoogleCloudOCRDelegate {
    func detectedImage(_ result: DetectImageResult) {
        DispatchQueue.main.async {
            self.imageResult = result
        }
    }
}

extension Message {
    
    var ja: String {
        return String(content.split(separator: "[Ja] ").last ?? "")
    }
    
    var en: String {
        return String(content.split(separator: "[Ja] ").first ?? "").replacing("[En] ", with: "").replacing("\n", with: "")
    }
    
}
