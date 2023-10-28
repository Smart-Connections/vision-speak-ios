//
//  RealTimeImageClassificationView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/04.
//

import SwiftUI
import AVFoundation
import Vision

struct RealTimeImageClassificationView: View {
    @ObservedObject private var viewModel = RealTimeImageClassificationViewModel(purchaseState: PurchaseState())
    @EnvironmentObject private var studyHistoryState: StudyHistoryState
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    @Binding private var showRealTimeView: Bool
    
    @State private var showVocabulary: Bool = false
    @State private var showVocabularySetting: Bool = false
    @State private var showFeedbackView: Bool = false
    @State private var showCoachMark: Bool = false
    @State private var showSendVoiceCoachMark: Bool = false
    @State private var text: String = ""
    
    @State private var showTextField: Bool = false
    @FocusState private var focus:Bool
    
    private let studyHistoryDataSource = StudyHistoryDataSource()
    
    init(showNextView: Binding<Bool>) {
        self._showRealTimeView = showNextView
    }
    
    var body: some View {
        showFeedbackViewIfNeeded()
        showVoiceRecognitionView()
        return NavigationStack {
            ZStack {
                CameraPreviewView().environmentObject(viewModel)
                VStack {
                    Spacer().frame(height: 32)
                    ChatHeader(ShowNextView: $showRealTimeView)
                        .environmentObject(viewModel)
                        .environmentObject(studyHistoryState)
                    Spacer()
                    ScrollView {
                        ChatMessages().environmentObject(viewModel)
                    }
                    ChatBottomActions(showVocabulary: $showVocabulary,
                                      showRealTimeView: $showRealTimeView,
                                      showCameraCoachMark: $showCoachMark,
                                      showSendVoiceCoachMark: $showSendVoiceCoachMark,
                                      showFeedbackView: $showFeedbackView,
                                      showTextField: $showTextField,
                                      focused: $focus
                    ).environmentObject(viewModel).environmentObject(studyHistoryState)
                    Spacer().frame(height: 16)
                }.padding()
                if (self.showVocabulary) {
                    VocabularyView(showVocabulary: $showVocabulary).environmentObject(viewModel)
                }
                if (self.showVocabularySetting) {
                    VocabularySettingView(showVocabularySetting: $showVocabularySetting, showCameraCoachMark: $showCoachMark, showRealTimeView: $showRealTimeView)
                        .environmentObject(viewModel)
                        .environmentObject(vocabularyState)
                }
                ForEach(viewModel.recognitionResults, id: \.self) { result in
                    if let objectObservation = result as? VNRecognizedObjectObservation {
                        let bounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(UIScreen.main.bounds.width), Int(UIScreen.main.bounds.height))
                        Text(objectObservation.labels.first?.identifier ?? "")
                            .foregroundColor(.green)
                            .position(x: bounds.minX + 16, y: bounds.minY - 16)
                        Path { path in path.addRect(bounds) }
                            .stroke(lineWidth: 5)
                            .fill(Color.green)
                    }
                }
                if showTextField {
                    HStack {
                        Spacer()
                        ZStack {
                            TextField("TextField", text: self.$text).focused(self.$focus).padding().padding(.trailing, 36).background(.white).cornerRadius(8)
                            HStack {
                                Spacer()
                                Button(action: {
                                    if $text.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return }
                                    viewModel.sendReply($text.wrappedValue)
                                    self.$text.wrappedValue = ""
                                    self.$focus.wrappedValue = false
                                    self.$showTextField.wrappedValue = false
                                    viewModel.inputtingByMic = true
                                }) {
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.white)
                                        .frame(width: 36, height: 36)
                                        .background(Color.blue)
                                        .cornerRadius(18)
                                }
                                Spacer().frame(width: 16)
                            }
                        }
                        Spacer()
                    }
                }
            }.ignoresSafeArea()
        }.onAppear {
            viewModel.startCapturing()
        }
        .onDisappear {
            viewModel.reset()
        }
    }
    
    private func showFeedbackViewIfNeeded() {
        if (viewModel.remainSeconds == 0 && showFeedbackView == false) {
            // 制限時間を超えていればFB画面に遷移する
            DispatchQueue.main.async {
                showFeedbackView = true
                StudyHistoryDataSource().saveStudyHistory(passedTime: viewModel.passedTime, wordsCount: viewModel.wordsCount)
                viewModel.resetTimer()
            }
        }
    }
    
    private func showVoiceRecognitionView() {
        if (!viewModel.selectedVocabulary.isEmpty || viewModel.notSetVocabulary) { return }
        // ボキャブラリーが未設定の場合は1秒後にモーダルを表示する
        DispatchQueue.main.async {
            self.showVocabularySetting = true
            viewModel.notSetVocabulary = true
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
