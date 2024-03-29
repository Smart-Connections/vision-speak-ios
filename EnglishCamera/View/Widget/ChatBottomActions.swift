//
//  ChatBottomActions.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/29.
//

import SwiftUI

struct ChatBottomActions: View {
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    @EnvironmentObject private var studyHistoryState: StudyHistoryState
    @Binding var showVocabulary: Bool
    @Binding var showRealTimeView: Bool
    
    @State private var showingFinishAlert = false
    @State private var showFinishConversationCoachMark = false
    @Binding var showCameraCoachMark: Bool
    @Binding var showSendVoiceCoachMark: Bool
    @Binding var showFeedbackView: Bool
    @Binding var showTextField: Bool
    
    var focused: FocusState<Bool>.Binding
    
    var body: some View {
        VStack {
            if (viewModel.recordingVoice) {
                HStack {
                    Spacer()
                    Text("Recording...").foregroundColor(.orange)
                    Spacer()
                }
            }
            ZStack(alignment: .center) {
                if (viewModel.status == .inputtingReply) {
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.stopRecording()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .frame(width: 36, height: 36)
                                .background(Color.gray)
                                .cornerRadius(18)
                        }
                        Spacer().frame(width: 16)
                        Group {
                            Button(action: {
                                if (viewModel.recordingVoice) {
                                    viewModel.transcript()
                                } else if viewModel.inputtingByMic {
                                    viewModel.startRecording()
                                } else {
                                    showTextField = true
                                    focused.wrappedValue = true
                                }
                            }) {
                                Image(systemName: viewModel.recordingVoice ? "arrow.up" : viewModel.inputtingByMic ? "mic" : "keyboard")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .frame(width: 64, height: 64)
                                    .background(Color.blue)
                                    .cornerRadius(32)
                            }.showCoachMark(show: $showSendVoiceCoachMark, text: "メッセージが来たら自動的に録音が始まります。話し終わったら、このボタンをタップして返答しましょう", showOnWidget: true)
                        }.frame(width: 64, height: 64)
                        Spacer().frame(width: 16)
                        Button(action: {
                            viewModel.stopRecording()
                            viewModel.inputtingByMic.toggle()
                            showTextField = !viewModel.inputtingByMic
                        }) {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .foregroundColor(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.blue)
                                .cornerRadius(18)
                        }
                        Spacer()
                    }
                }
                if (viewModel.status == .ready) {
                    Group {
                        Button(action: {
                            viewModel.takePicture()
                        }) {
                            Image(systemName: "camera")
                                .font(.title)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color.blue)
                                .cornerRadius(36)
                        }.showCoachMark(show: $showCameraCoachMark, text: "会話したいものを撮影してみましょう", showOnWidget: true)
                    }.frame(width: 72, height: 72)
                }
                HStack {
                    Group {
                        Button(action: {
                            showingFinishAlert = true
                        }) {
                            Text("終了")
                                .foregroundColor(.white)
                                .frame(maxWidth: 64, maxHeight: 48)
                                .background(Color.gray)
                                .cornerRadius(25)
                        } .alert("トピックを終了しますか？", isPresented: $showingFinishAlert) {
                            Button("フィードバックを見る") {
                                showFeedbackView = true
                                StudyHistoryDataSource().saveStudyHistory(passedTime: viewModel.passedTime, wordsCount: viewModel.wordsCount)
                            }
                            Button("フィードバックを見ずに終了") {
                                viewModel.clearChatHistory()
                                showingFinishAlert  = false
                            }
                            Button("会話を続ける") {
                                showingFinishAlert  = false
                            }
                        }.showCoachMark(show: $showFinishConversationCoachMark, text: "会話が終わったら終了を押しましょう。フィードバックをもらったり、他の会話に移ることができます", showOnWidget: true)
                    }.frame(maxWidth: 64, maxHeight: 48)
                    Spacer()
                    Button(action: {
                        showVocabulary = true
                    }) {
                        Image(systemName: "note.text")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.blue)
                            .cornerRadius(24)
                    }
                }
            }
        }.navigationDestination(isPresented: $showFeedbackView, destination: {
            FeedbackView(showFeedbackView: $showFeedbackView, showRealTimeView: $showRealTimeView)
                .environmentObject(viewModel)
                .environmentObject(studyHistoryState)
        }).onChange(of: viewModel.status) { newValue in
            if newValue == .inputtingReply {
                showSendVoiceCoachMarkIfNeeded()
                if viewModel.messagesWithChatGPT.count >= 2 {
                    showFinishConversationCoachMarkIfNeeded()
                }
            }
        }
    }
    
    private func showSendVoiceCoachMarkIfNeeded() {
        if !UserDefaults.standard.bool(forKey: CoachMark.sendVoice.rawValue) { return }
        
        showSendVoiceCoachMark = true
        UserDefaults.standard.set(false, forKey: CoachMark.sendVoice.rawValue)
    }
    
    private func showFinishConversationCoachMarkIfNeeded() {
        if !UserDefaults.standard.bool(forKey: CoachMark.finishConversation.rawValue) { return }
        
        showFinishConversationCoachMark = true
        UserDefaults.standard.set(false, forKey: CoachMark.finishConversation.rawValue)
    }
}
