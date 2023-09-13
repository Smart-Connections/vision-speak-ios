//
//  VocabularySearchView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import SwiftUI

struct VocabularySearchView: View {
    @StateObject private var viewModel = SearchVocabularyViewModel()
    
    @State private var partOfSpeechOption: Part = .noun
    @State private var situationOption: Situation = .daily
    @State private var styleOption: ConversationStyle = .casual
    @State private var difficultyOption: Difficulty = .easy
    @State private var type: VocabularyType = .word
    @State private var searchText = ""
    
    @Binding var showSearchModal: Bool
    
    init(showSearchModal: Binding<Bool>) {
        self._showSearchModal = showSearchModal
    }
    
    var body: some View {
        NavigationView {
            VStack{
                HStack(alignment: .center) {
                    Text("キーワード")
                    Spacer()
                    TextField("例: 美味しい！のリアクション、水回りの単語", text: $searchText)
                        .font(.subheadline)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("シチュエーション")
                    Spacer()
                    Picker("", selection: $situationOption) {
                        ForEach(Situation.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }
                }
                HStack {
                    Text("シーン")
                    Spacer()
                    Picker("", selection: $styleOption) {
                        ForEach(ConversationStyle.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }
                }
                HStack {
                    Text("難しさ")
                    Spacer()
                    Picker("", selection: $difficultyOption) {
                        ForEach(Difficulty.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }
                }
                HStack {
                    Text("種類")
                    Spacer()
                    Picker("", selection: $type) {
                        ForEach(VocabularyType.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }
                }
                Button(action: {
                    viewModel.search(
                        SearchVocabularyCondition(
                            keyword: $searchText.wrappedValue,
                            situation: $situationOption.wrappedValue.rawValue,
                            style: $styleOption.wrappedValue.rawValue,
                            difficulty: $difficultyOption.wrappedValue.rawValue,
                            type: $type.wrappedValue.rawValue
                        ))
                }) {
                    HStack {
                        Text("検索する")
                        Image(systemName: "magnifyingglass")
                    }
                    .padding(.vertical, 8)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background($searchText.wrappedValue.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(8)
                }
                .disabled($searchText.wrappedValue.isEmpty)
                List {
                    ForEach(viewModel.vocabularyList, id: \.hashValue) { vocabulary in
                        Text(vocabulary)
                    }
                }
            }
            .padding()
            .navigationBarTitle(Text("Vocabulary検索"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                    showSearchModal = false
                }) {
                    Text("Close").bold()
                })
        }
    }
}
