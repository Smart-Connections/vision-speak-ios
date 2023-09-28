//
//  VocabularyBrowseView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/28.
//

import SwiftUI

struct VocabularyBrowserView: View {
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 24)
                    HStack {
                        Text("Vocabulary").font(.largeTitle.bold())
                        Spacer()
                    }
                    Spacer().frame(height: 24)
                    ForEach(Array(vocabularyState.allVocabulary())) { vocabulary in
                        HStack(alignment: .center, spacing: 0) {
                            Image(systemName: vocabulary.learned ? "checkmark.circle.fill" : "circle")                        .font(.title)
                                .foregroundColor(.green)
                                .padding(.vertical)
                            Spacer().frame(width: 16)
                            Text(vocabulary.vocabulary).frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                        }.padding(.horizontal)
                    }.background(.white).cornerRadius(8)
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
        }
    }
}
