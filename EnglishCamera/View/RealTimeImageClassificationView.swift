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
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    @State var showVocabulary: Bool = false
    @State var showVocabularySetting: Bool = false
    
    @Binding var ShowNextView: Bool
    
    private let studyHistoryDataSource = StudyHistoryDataSource()
    
    init(showNextView: Binding<Bool>) {
        self._ShowNextView = showNextView
    }
    
    var body: some View {
        if (viewModel.remainSeconds <= 0) {
            // 制限時間を超えていれば前の画面に戻る
            ShowNextView = false
        }
        if (viewModel.vocabulary.isEmpty && !viewModel.notSetVocabulary) {
            // ボキャブラリーが未設定の場合はモーダルを表示する
            // 3秒後に実行
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showVocabularySetting = true
                viewModel.notSetVocabulary = true
            }
        }
        return ZStack {
            CameraPreviewView().environmentObject(viewModel)
            VStack {
                Spacer().frame(height: 32)
                ChatHeader(ShowNextView: $ShowNextView).environmentObject(viewModel)
                Spacer()
                ChatMessages().environmentObject(viewModel)
                ChatBottomActions(showVocabulary: $showVocabulary).environmentObject(viewModel)
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
