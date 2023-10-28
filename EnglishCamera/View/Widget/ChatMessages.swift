//
//  ChatMessages.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import Foundation
import SwiftUI

struct ChatMessages: View {
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    
    private var isFeedback: Bool
    
    init(isFeedbackView: Bool = false) {
        self.isFeedback = isFeedbackView
    }
    
    var body: some View {
        VStack {
            ForEach(viewModel.messagesWithChatGPT, id: \.hashValue) { message in
                HStack {
                    Spacer().frame(width: leftMargin(message.role == "user"))
                    VStack{
                        HStack {
                            Text(viewModel.jaMessages.contains(message) ? message.japanese_message : message.english_message).fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            if (message.role != "user") {
                                Button(action: {
                                    viewModel.toggleLanguage(message: message)
                                }) {
                                    Text("あ/A").font(.caption)
                                }
                            }
                        }
                        if isFeedback && message.role == "user" && viewModel.feedbacks.first(where: {$0.message == message}) == nil {
                            Spacer().frame(height: 8)
                            ZStack(alignment: .center) {
                                Image(systemName: "chevron.down").foregroundColor(.gray)
                            }
                            if viewModel.waitingFeedbackMessage == message {
                                loadingAnimation
                            }
                        }
                        if let feedback = viewModel.feedbacks.first(where: {$0.message == message}) {
                            VStack(alignment: .leading) {
                                Divider().frame(height: 0.5)
                                Spacer().frame(height: 12)
                                Text(feedback.feedback).fixedSize(horizontal: false, vertical: true).foregroundColor(Color("onSurfaceLight")).frame(alignment: .leading)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(message.role == "user" ? Color("surface") : Color("gptMessageBackground"))
                    .cornerRadius(8)
                    Spacer().frame(width: rightMargin(message.role == "user"))
                }.onTapGesture {
                    if (isFeedback && message.role == "user" && viewModel.feedbacks.first(where: {$0.message == message}) == nil) {
                        viewModel.getFeedback(message: message)
                    }
                }
            }
            if waitingResponse() {
                HStack {
                    if !viewModel.messagesWithChatGPT.isEmpty && viewModel.messagesWithChatGPT.last?.role != "user" {
                        Spacer()
                    }
                    loadingAnimation
                    if viewModel.messagesWithChatGPT.isEmpty || viewModel.messagesWithChatGPT.last?.role == "user" {
                        Spacer()
                    }
                }
            }
        }
    }
    
    var loadingAnimation: some View {
        LottieView(name: "lottie_dots_animation").frame(width: 160, height: 80).background(!viewModel.messagesWithChatGPT.isEmpty && viewModel.messagesWithChatGPT.last?.role != "user" ? Color("surface") : Color("gptMessageBackground")).cornerRadius(8)
    }
    
    private func waitingResponse() -> Bool {
        return viewModel.status == .waitingGptMessage || viewModel.status == .waitingVisionResults
    }
    
    private func leftMargin(_ isUser: Bool) -> Double {
        return isUser ? 32.0 : 0.0
    }
    
    private func rightMargin(_ isUser: Bool) -> Double {
        return isUser ? 0.0  : 32.0
    }
}
