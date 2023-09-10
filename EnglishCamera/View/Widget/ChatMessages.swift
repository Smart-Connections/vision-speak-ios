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
    
    
    var body: some View {
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
    }
}
