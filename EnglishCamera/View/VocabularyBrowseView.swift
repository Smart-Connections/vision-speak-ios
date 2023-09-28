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
                VStack{
                    Spacer().frame(height: 24)
                    HStack {
                        Text("Vocabulary").font(.largeTitle.bold())
                        Spacer()
                    }
                    Spacer().frame(height: 24)
//                    allVocabularyを全て表示する
                    ForEach(Array(vocabularyState.allVocabulary())) { vocabulary in
                        HStack(alignment: .top) {
                            Text(vocabulary.vocabulary).frame(maxWidth: .infinity, alignment: .leading)
                        }.padding()
                    }
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
        }
    }
}
