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
            Spacer()
            VStack {
                Text("使いたいVocabularyを設定しよう").font(.title3)
                Spacer().frame(height: 16)
                ZStack {
                    HStack {
                        Spacer()
                        Text("未学習のVocabulary")
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            showSearchModal = true
                        }) {
                            HStack {
                                Text("追加")
                                Image(systemName: "plus.circle")
                            }
                            .padding(.vertical, 8)
                            .foregroundColor(.white)
                            .frame(width: 80)
                            .background(Color.blue)
                            .cornerRadius(8)
                        }.sheet(isPresented: $showSearchModal) {
                            VocabularySearchView(showSearchModal: $showSearchModal)
                        }
                    }
                }
                VocabularyHistoryList().environmentObject(vocabularyState)
                Button(action: {
                    showVocabularySetting = false
                    viewModel.startTimer()
                }) {
                    Text("Start")
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedVocabulary.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(8)
                }.disabled(viewModel.selectedVocabulary.isEmpty)
            }
            .padding()
            .background(.white)
            .cornerRadius(8)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.4))
    }
}

