//
//  RealTimeImageClassificationView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/04.
//

import SwiftUI
import AVFoundation
import Speech

struct RealTimeImageClassificationView: View {
    @ObservedObject private var viewModel = RealTimeImageClassificationViewModel()
    @EnvironmentObject private var studyHistoryState: StudyHistoryState
    @Binding var ShowNextView: Bool
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    private let studyHistoryDataSource = StudyHistoryDataSource()
    
    init(showNextView: Binding<Bool>) {
        self._ShowNextView = showNextView
    }

    var body: some View {
        if (viewModel.remainSeconds <= 0) {
            ShowNextView = false
        }
        return ZStack {
            CameraPreviewView().environmentObject(viewModel)
            VStack {
                Spacer().frame(height: 32)
                ZStack {
                    HStack {
                        Button(action: {
                            ShowNextView = false
                        }) {
                            Image(systemName: "chevron.left")
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .background(Color.black)
                                .cornerRadius(25)
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        if (viewModel.remainSeconds == TimeInterval(AppValue.initSecondsSymbol)) {
                            Text("--:--")
                        } else {
                            Text("\(viewModel.remainSeconds.ms)")
                        }
                        Spacer()
                    }
                }
                Spacer()
                if (viewModel.messagesWithChatGPT.count >= 0) {
                    ForEach(viewModel.messagesWithChatGPT.dropFirst(2), id: \.hashValue) { message in
                        HStack {
                            Text(viewModel.jaMessages.contains(message) ? message.ja : message.en)
                            Spacer()
                            if (message.role != "user") {
                                Button(action: {
                                    viewModel.toggleLanguage(message: message)
                                }) {
                                    Text("あ/A").font(.caption)
                                }
                            }
                         }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(message.role == "user" ? Color.white : Color.init(red: 0.92, green: 0.92, blue: 0.92))
                        .cornerRadius(8)
                    }
                }
                ZStack {
                    if (viewModel.status == .inputtingReply) {
                        Button(action: {
                            viewModel.sendReply()
                        }) {
                            Image(systemName: "arrow.up")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 64, height: 64)
                                .background(Color.blue)
                                .cornerRadius(32)
                        }
                    }
                    if (viewModel.status == .ready) {
                        Button(action: {
                            viewModel.takePicture()
                        }) {
                            Image(systemName: "camera")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 64, height: 64)
                                .background(Color.blue)
                                .cornerRadius(32)
                        }
                    }
                    HStack {
                        Button(action: {
                            viewModel.clearChatHistory()
                        }) {
                            Text("Clear")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(25)
                        }
                        Spacer()
                    }
                }
                Spacer().frame(height: 16)
            }.padding()
        }
        .onAppear {
            viewModel.startCapturing()
        }
        .onDisappear {
            viewModel.reset()
            saveStudyHistory()
            studyHistoryState.refresh()
        }
        .ignoresSafeArea()
    }
    
    func saveStudyHistory() {
        if let historyValue = studyHistoryDataSource.todayHistory() {
            studyHistoryDataSource.updateHistory(historyValue, Int(viewModel.passedTime), viewModel.wordsCount)
        } else {
            let history: StudyHistory = StudyHistory(studyTimeSeconds: Int(viewModel.passedTime), userCredits: viewModel.wordsCount, createdAt: Date().ymd)
            studyHistoryDataSource.update(history)
        }
    }
}

struct CameraPreviewView: UIViewRepresentable {
    @EnvironmentObject var viewModel: RealTimeImageClassificationViewModel

    func makeUIView(context: Context) -> BaseCameraView {
        BaseCameraView(previewLayer: viewModel.previewLayer)
    }

    func updateUIView(_ uiView: BaseCameraView, context: Context) {
        viewModel.previewLayer.frame = uiView.frame
        if (uiView._previewLayer.session == nil) {
            uiView._previewLayer = viewModel.previewLayer
            uiView.initCaptureSession()
        }
    }
}

class BaseCameraView: UIView {
    var _previewLayer: AVCaptureVideoPreviewLayer

    init(previewLayer: AVCaptureVideoPreviewLayer) {
        _previewLayer = previewLayer
        super.init(frame: _previewLayer.frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        initCaptureSession()
        (layer.sublayers?.first as? AVCaptureVideoPreviewLayer)?.frame = frame
    }

    func initCaptureSession() {
        _previewLayer.videoGravity = .resizeAspectFill
        layer.insertSublayer(_previewLayer, at: 100)
    }
}
