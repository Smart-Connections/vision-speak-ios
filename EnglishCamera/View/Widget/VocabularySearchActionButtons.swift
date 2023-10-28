//
//  VocabularySearchActionButtons.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/20.
//

import Foundation
import SwiftUI

struct VocabularySearchActionButtons: View {
    @EnvironmentObject private var viewModel: SearchVocabularyViewModel
    @Binding var showSearchModal: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.clearResult()
            }) {
                Text("クリア")
                .padding(.vertical, 10)
                .foregroundColor(.blue)
                .frame(width: 80)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 0.5)
                )
            }
            Button(action: {
                viewModel.saveVocabulary()
                showSearchModal = false
            }) {
                HStack {
                    Text("保存する")
                    Image(systemName: "plus.circle")
                }
                .padding(.vertical, 10)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .background(viewModel.selectedVocabulary.isEmpty ? Color.gray : Color.blue)
                .cornerRadius(8)
            }.disabled(viewModel.selectedVocabulary.isEmpty)
        }
    }
}

