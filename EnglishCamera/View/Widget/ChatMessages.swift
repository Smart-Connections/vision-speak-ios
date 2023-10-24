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
        if (viewModel.messagesWithChatGPT.count >= 0) {
            ForEach(viewModel.messagesWithChatGPT, id: \.hashValue) { message in
                HStack {
                    Spacer().frame(width: leftMargin(message.role == "user"))
                    VStack{
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
                        if isFeedback && message.role == "user" && viewModel.feedbacks.first(where: {$0.message == message}) == nil {
                            ZStack(alignment: .center) {
                                Image(systemName: "chevron.down").foregroundColor(.gray)
                            }
                        }
                        if let feedback = viewModel.feedbacks.first(where: {$0.message == message}) {
                            VStack(alignment: .leading) {
                                Divider().frame(height: 0.5)
                                Spacer().frame(height: 12)
                                Text(feedback.feedback).foregroundColor(.gray).frame(alignment: .leading)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(message.role == "user" ? Color.white : Color.init(red: 0.92, green: 0.92, blue: 0.92))
                    .cornerRadius(8)
                    Spacer().frame(width: rightMargin(message.role == "user"))
                }.onTapGesture {
                    if (isFeedback && message.role == "user") {
                        viewModel.getFeedback(message: message)
                    }
                }
            }
        }
    }
    
    private func leftMargin(_ isUser: Bool) -> Double {
        return isUser ? 32.0 : 0.0
    }
    
    private func rightMargin(_ isUser: Bool) -> Double {
        return isUser ? 0.0  : 32.0
    }
}
