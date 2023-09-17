//
//  ChatBottomActions.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/29.
//

import SwiftUI

struct ChatBottomActions: View {
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    @Binding var showVocabulary: Bool
    
    @State private var showingFinishAlert = false
    @State var showFeedbackView: Bool = false

    var body: some View {
        ZStack {
            if (viewModel.status == .inputtingReply) {
                Button(action: {
                    viewModel.transcript()
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
                        .frame(width: 72, height: 72)
                        .background(Color.blue)
                        .cornerRadius(36)
                }
            }
            HStack {
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
                    }
                    Button("フィードバックを見ずに終了") {
                        viewModel.clearChatHistory()
                        showingFinishAlert  = false
                    }
                    Button("会話を続ける") {
                        showingFinishAlert  = false
                    }
                }
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
        }.navigationDestination(isPresented: $showFeedbackView, destination: {
            FeedbackView(showFeedbackView: $showFeedbackView).environmentObject(viewModel)
        })
    }
}
