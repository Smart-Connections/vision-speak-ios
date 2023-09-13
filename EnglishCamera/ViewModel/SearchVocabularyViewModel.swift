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
    
    init() {
        searchVocabulary.delegate = self
    }
    
    func search(_ searchVocabularyCondition: SearchVocabularyCondition) {
        searchVocabulary.searchVocabulary(searchVocabularyCondition)
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
