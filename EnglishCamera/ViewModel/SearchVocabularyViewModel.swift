//
//  SearchVocabularyViewModel.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/12.
//

import Combine
import Foundation

class SearchVocabularyViewModel: ObservableObject {
    private let searchVocabulary = SearchVocabulary()
    
    @Published var vocabularyList = [String]()
    @Published var selectedVocabulary = Set<String>()
    @Published var lastSearchVocabularyCondition: SearchVocabularyCondition?
    
    init() {
        searchVocabulary.delegate = self
    }
    
    func search(_ searchVocabularyCondition: SearchVocabularyCondition) {
        lastSearchVocabularyCondition = searchVocabularyCondition
        searchVocabulary.searchVocabulary(searchVocabularyCondition)
    }
    
    func saveVocabulary() {
        let vocabularyList = self.vocabularyList.filter { selectedVocabulary.contains($0) }
        let vocabularies = vocabularyList.map {
            Vocabulary(
                vocabulary: $0,
                situcation: lastSearchVocabularyCondition!.situation,
                scene: lastSearchVocabularyCondition!.style,
                difficulty: lastSearchVocabularyCondition!.difficulty,
                type: lastSearchVocabularyCondition!.type
            )
        }
        VocabularyDataSource().add(vocabularies)
    }
    
    func clearResult() {
        vocabularyList.removeAll()
        selectedVocabulary.removeAll()
        lastSearchVocabularyCondition = nil
    }
}

extension SearchVocabularyViewModel: SearchVocabularyDelegate {
    func getVocabulary(_ vocabularyList: VocabularyList) {
        print("getVocabulary \(vocabularyList.english_vocabulary_list)")
        DispatchQueue.main.async {
            self.vocabularyList = vocabularyList.english_vocabulary_list
        }
    }
}
