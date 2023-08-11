import AVFoundation
import Vision
import Combine

class RealTimeImageClassificationViewModel: ObservableObject {
    private let videoCapture = VideoCapture()
    private let resnet50ModelManager = Resnet50ModelManager()
    private let chatGPT = ChatGPT()
    private let textToSpeak = TextToSpeak()
    private let recordVoice = RecordVoice()
    var timer: Timer?
    
    @Published var wordsCount: Int = 0
    @Published var passedTime: TimeInterval = 0
    @Published var remainSeconds: TimeInterval = TimeInterval(AppValue.initSecondsSymbol)
    @Published var messagesWithChatGPT = [Message]()
    @Published var observationText: String = ""
    @Published var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    @Published var status: CameraStatus = .ready
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        resnet50ModelManager.delegate = self
        videoCapture.delegate = self
        chatGPT.delegate = self
        textToSpeak.delegate = self
        
        $observationText
            .receive(on: DispatchQueue.main)
            .sink { _ in }
            .store(in: &cancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.timer = Timer
                .scheduledTimer(
                    withTimeInterval: 1.0,
                    repeats: true
                ) { _ in
                    let seconds = Double(StudyHistoryDataSource().todayHistory()?.studyTimeSeconds ?? 0)
                    self.passedTime += 1
                    self.remainSeconds = Double(AppValue.limitSeconds) - seconds - self.passedTime
                }
        }
    }
    
    func startCapturing() {
        videoCapture.startCapturing()
    }
    
    func stopCapturing() {
        videoCapture.stopCapturing()
    }
    
    @MainActor func sendReply() {
        guard let url = self.recordVoice.stopRecording() else { return }
        chatGPT.transcript(url)
        self.status = .waitingGptMessage
    }
    
    func clearChatHistory() {
        messagesWithChatGPT.removeAll()
        observationText = ""
        status = .ready
    }
    
    private func callGPT() {
        let content = "You are a AI of learning English App. Please start to talk with me about one of \(observationText) from making a question in a fun mood. Please use lower than 16 words."
        messagesWithChatGPT.append(Message(content: content, role: "user"))
        chatGPT.chat(messagesWithChatGPT.filter { $0.role != "symbol"} )
        self.status = .waitingGptMessage
    }
}

extension RealTimeImageClassificationViewModel: VideoCaptureDelegate {
    func didSet(_ previewLayer: AVCaptureVideoPreviewLayer) {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                self.previewLayer = previewLayer
            })
        }
    }
    
    func didCaptureFrame(from imageBuffer: CVImageBuffer) {
        resnet50ModelManager.performRequet(with: imageBuffer)
    }
}

extension RealTimeImageClassificationViewModel: Resnet50ModelManagerDelegate {
    func didRecieve(_ observation: VNClassificationObservation) {
        DispatchQueue.main.async {
            let observationText = "\(observation.identifier)"
            
            // 50%以上の確率で識別できた場合に会話対象を更新する
            if (observation.confidence.convertPercent >= 50) {
                self.observationText = observationText
            }
            
            // 現在会話がなく、かつ会話対象がある場合にはChatGPTにリクエストを投げる
            if (self.messagesWithChatGPT.isEmpty && !self.observationText.isEmpty) {
                self.messagesWithChatGPT.append(Message(content: "=====Start=====", role: "symbol"))
                self.callGPT()
            }
        }
    }
}

extension RealTimeImageClassificationViewModel: ChatGPTDelegate {
    func receiveTranscript(_ text: String) {
        DispatchQueue.main.async {
            self.messagesWithChatGPT.append(Message(content: text, role: "user"))
            self.wordsCount += text.split(separator: " ").count
        }
        chatGPT.chat(messagesWithChatGPT.filter { $0.role != "symbol"} )
    }
    
    func receiveMessage(_ message: String) {
        DispatchQueue.main.async {
            self.textToSpeak.textToSpeak(text: message)
            self.messagesWithChatGPT.append(Message(content: message, role: "system"))
        }
    }
}

extension RealTimeImageClassificationViewModel: TextToSpeakDelegate {
    func finishSpeak() {
        self.status = .inputingReply
        self.recordVoice.startRecording()
    }
}
