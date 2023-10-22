//
//  VocabularyHistoryList.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import SwiftUI

struct VocabularyHistoryList: View {
    @EnvironmentObject private var realTimeImageClassificationViewModel: RealTimeImageClassificationViewModel
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    var body: some View {
        return VStack() {
            if (vocabularyState.unlearnedVocabulary().isEmpty) {
                Spacer()
                Text("未学習のVocabularyはありません")
                Spacer()
            } else {
                List(vocabularyState.unlearnedVocabulary(), id: \.self, selection: $realTimeImageClassificationViewModel.selectedVocabulary) { vocabulary in
                    VocabularyItem(english: vocabulary.vocabulary, japanese: vocabulary.vocabularyJa)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if realTimeImageClassificationViewModel.selectedVocabulary.contains(vocabulary) {
                                realTimeImageClassificationViewModel.selectedVocabulary.remove(vocabulary)
                            } else {
                                realTimeImageClassificationViewModel.selectedVocabulary.insert(vocabulary)
                            }
                        }
                }.environment(\.editMode, .constant(.active))
            }
        }.frame(height: 360)
    }
}
