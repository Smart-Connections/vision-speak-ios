//
//  VocabularySettingView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import Foundation
import SwiftUI

struct VocabularySettingView: View {
    @EnvironmentObject private var vocabularyState: VocabularyState
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    @Binding var showVocabularySetting: Bool
    
    @State private var showSearchModal = false
    
    var body: some View {
        VStack {
            VStack {
                Text("使いたいVocabularyを設定しよう").font(.title3)
                Spacer().frame(height: 16)
                VocabularyHistoryList().environmentObject(vocabularyState)
                Button(action: {
                    showSearchModal = true
                }) {
                    HStack {
                        Text("追加する")
                        Image(systemName: "plus.circle")
                    }
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                }.sheet(isPresented: $showSearchModal) {
                    VocabularySearchView(showSearchModal: $showSearchModal)
                }
            }
            .padding()
            .background(.white)
            .cornerRadius(8)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.4))
        .onTapGesture {
            showVocabularySetting = false
        }
    }
}

