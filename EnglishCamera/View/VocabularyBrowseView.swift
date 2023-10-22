//
//  VocabularyBrowseView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/28.
//

import SwiftUI

struct VocabularyBrowserView: View {
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    @State private var showFilterSettingView = false
    
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 24)
                    HStack {
                        Text("Vocabulary").font(.largeTitle.bold())
                        Spacer()
                        Button(action: {
                            showFilterSettingView = true
                        }, label: {
                            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }).sheet(isPresented: $showFilterSettingView) {
                            VocabularyBrowseFilterSettingView(showFilterSettingView: $showFilterSettingView).environmentObject(vocabularyState)
                        }
                    }
                    Spacer().frame(height: 16)
                    VocabularyBrowseFilterCondition().environmentObject(vocabularyState)
                    Spacer().frame(height: 16)
                    ForEach(Array(vocabularyState.filterdVocabulary())) { vocabulary in
                        HStack(alignment: .center, spacing: 0) {
                            Image(systemName: vocabulary.learned ? "checkmark.circle.fill" : "circle")                        .font(.title)
                                .foregroundColor(.blue)
                                .padding(.vertical)
                            Spacer().frame(width: 16)
                            VocabularyItem(english: vocabulary.vocabulary, japanese: vocabulary.vocabularyJa).frame(maxWidth: .infinity, alignment: .leading)
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
