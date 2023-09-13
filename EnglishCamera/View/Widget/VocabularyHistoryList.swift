//
//  VocabularyHistoryList.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import SwiftUI

struct VocabularyHistoryList: View {
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    var body: some View {
        return VStack() {
            Text("未学習のVocabulary")
            if (vocabularyState.allVocabulary().isEmpty) {
                Spacer()
                Text("未学習のVocabularyはありません")
                Spacer()
            } else {
                List{
                    ForEach(vocabularyState.allVocabulary()) { entry in
                        Text(entry.vocabulary).padding()
                    }
                }
            }
        }.frame(height: 240)
    }
}
