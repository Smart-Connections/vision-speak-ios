//
//  VocabularyState.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import Foundation

class VocabularyState: ObservableObject {
    private var datasource: VocabularyDataSource
    
    init(_ dataSource: VocabularyDataSource) {
        self.datasource = dataSource
    }
    
    func allVocabulary() -> [Vocabulary] {
        return datasource.getAll()
    }
}
