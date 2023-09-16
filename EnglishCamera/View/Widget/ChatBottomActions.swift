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
                    viewModel.clearChatHistory()
                }) {
                    Text("clear")
                        .foregroundColor(.white)
                        .frame(maxWidth: 64, maxHeight: 48)
                        .background(Color.gray)
                        .cornerRadius(25)
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
        }
    }
}
