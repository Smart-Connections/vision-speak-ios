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
                            situation: $situationOption.wrappedValue,
                            style: $styleOption.wrappedValue,
                            difficulty: $difficultyOption.wrappedValue,
                            type: $type.wrappedValue
                        ))
                }) {
                    HStack {
                        Text("検索する")
                        Image(systemName: "magnifyingglass")
                    }
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .background($searchText.wrappedValue.isEmpty || viewModel.lastSearchVocabularyCondition != nil ? Color.gray : Color.blue)
                    .cornerRadius(8)
                }.disabled($searchText.wrappedValue.isEmpty || viewModel.lastSearchVocabularyCondition != nil)
                List(viewModel.vocabularyList, id: \.self, selection: $viewModel.selectedVocabulary) { vocabulary in
                    Text(vocabulary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if viewModel.selectedVocabulary.contains(vocabulary) {
                                viewModel.selectedVocabulary.remove(vocabulary)
                            } else {
                                viewModel.selectedVocabulary.insert(vocabulary)
                            }
                        }
                }.environment(\.editMode, .constant(.active))
                if !viewModel.vocabularyList.isEmpty {
                    HStack {
                        Button(action: {
                            viewModel.clearResult()
                        }) {
                            HStack {
                                Text("クリア")
                            }
                            .padding(.vertical, 10)
                            .foregroundColor(.blue)
                            .frame(width: 80)
                            .background(Color.white)
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
