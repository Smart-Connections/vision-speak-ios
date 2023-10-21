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
    @State private var showCoachMark = false
    
    @Binding var showSearchModal: Bool
    
    init(showSearchModal: Binding<Bool>) {
        self._showSearchModal = showSearchModal
    }
    
    var body: some View {
        NavigationView{
            VStack{
                VocabularySearchConditions(
                    partOfSpeechOption: $partOfSpeechOption,
                    situationOption: $situationOption,
                    styleOption: $styleOption,
                    difficultyOption: $difficultyOption,
                    type: $type,
                    searchText: $searchText
                )
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
                    VocabularySearchActionButtons(showSearchModal: $showSearchModal).environmentObject(viewModel)
                }
            }
            .padding()
            .navigationBarTitle(Text("Vocabulary検索"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showSearchModal = false
            }) {
                Text("Close").bold()
            })
        }.onAppear {
            showCoachMarkIfNeeded()
        }
    }
    
    private func showCoachMarkIfNeeded() {
        if !UserDefaults.standard.bool(forKey: CoachMark.searchVocabulary.rawValue) { return }
        
        showCoachMark = true
        UserDefaults.standard.set(false, forKey: CoachMark.searchVocabulary.rawValue)
    }
}
