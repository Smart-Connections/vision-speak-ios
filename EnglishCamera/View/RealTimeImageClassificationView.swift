//
//  RealTimeImageClassificationView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/04.
//

import SwiftUI
import AVFoundation

struct RealTimeImageClassificationView: View {
    @ObservedObject private var viewModel = RealTimeImageClassificationViewModel(purchaseState: PurchaseState())
    @EnvironmentObject private var studyHistoryState: StudyHistoryState
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    @State var showVocabulary: Bool = false
    @State var showVocabularySetting: Bool = false
    @State var showFeedbackView:Bool = false
    
    @Binding private var showRealTimeView: Bool
    
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
                    ChatHeader(ShowNextView: $showRealTimeView).environmentObject(viewModel)
                    Spacer()
                    ScrollView {
                        ChatMessages().environmentObject(viewModel)
                    }
                    ChatBottomActions(showVocabulary: $showVocabulary,
                                      showRealTimeView: $showRealTimeView,
                                      showFeedbackView: $showFeedbackView).environmentObject(viewModel).environmentObject(studyHistoryState)
                    Spacer().frame(height: 16)
                }.padding()
                if (self.showVocabulary) {
                    VocabularyView(showVocabulary: $showVocabulary).environmentObject(viewModel)
                }
                if (self.showVocabularySetting) {
                    VocabularySettingView(showVocabularySetting: $showVocabularySetting)
                        .environmentObject(viewModel)
                        .environmentObject(vocabularyState)
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
