//
//  VocabularyBrowseFilterCondition.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/30.
//

import SwiftUI

struct VocabularyBrowseFilterCondition: View {
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(vocabularyState.getFilterConditions(), id: \.key) { data in
                    Text(data.key).font(.callout).padding(.horizontal).padding(.vertical, 4).background(data.value).foregroundColor(.white).cornerRadius(16)
                }
            }
        }
    }
}
