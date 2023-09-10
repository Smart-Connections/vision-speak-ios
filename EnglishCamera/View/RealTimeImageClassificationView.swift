//
//  RealTimeImageClassificationView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/04.
//

import SwiftUI
import AVFoundation

struct RealTimeImageClassificationView: View {
    @ObservedObject private var viewModel = RealTimeImageClassificationViewModel()
    @EnvironmentObject private var studyHistoryState: StudyHistoryState
    @State var showVocabulary: Bool = false
    @Binding var ShowNextView: Bool
    
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
                ChatHeader(ShowNextView: $ShowNextView).environmentObject(viewModel)
                Spacer()
                if (viewModel.messagesWithChatGPT.count >= 0) {
                    ForEach(viewModel.messagesWithChatGPT, id: \.hashValue) { message in
                        HStack {
                            Text(viewModel.jaMessages.contains(message) ? message.japanese_message : message.english_message)
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
                ChatBottomActions(showVocabulary: $showVocabulary).environmentObject(viewModel)
                Spacer().frame(height: 16)
            }.padding()
            if (self.showVocabulary) {
                VocabularyView(showVocabulary: $showVocabulary).environmentObject(viewModel)
            }
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
