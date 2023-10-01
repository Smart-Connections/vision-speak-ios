//
//  VocabularyState.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import Foundation
import SwiftUI

class VocabularyState: ObservableObject {
    private var datasource: VocabularyDataSource
    
    @Published var situcationCondition: Optional<Situation> = .none
    @Published var sceneCondition: Optional<ConversationStyle> = .none
    @Published var difficultyCondition: Optional<Difficulty> = .none
    @Published var typeCondition: Optional<VocabularyType>  = .none
    @Published var learnedCondition: Optional<Bool> = .none
    
    init(_ dataSource: VocabularyDataSource) {
        self.datasource = dataSource
    }
    
    func allVocabulary() -> [Vocabulary] {
        return datasource.getAll()
    }
    
    func addAll(_ vocabularies: [Vocabulary]) {
        datasource.add(vocabularies)
    }
}

extension VocabularyState {
    
    func unlearnedVocabulary() -> [Vocabulary] {
        return datasource.getAll().filter { !$0.learned }
    }
    
    func filterdVocabulary() -> [Vocabulary] {
        var vocabularies = datasource.getAll()
        if let situcationCondition = situcationCondition {
            vocabularies = vocabularies.filter { $0.situcation == situcationCondition }
        }
        if let sceneCondition = sceneCondition {
            vocabularies = vocabularies.filter { $0.scene == sceneCondition }
        }
        if let difficultyCondition = difficultyCondition {
            vocabularies = vocabularies.filter { $0.difficulty == difficultyCondition }
        }
        if let typeCondition = typeCondition {
            vocabularies = vocabularies.filter { $0.type == typeCondition }
        }
        if let learnedCondition = learnedCondition {
            vocabularies = vocabularies.filter { $0.learned == learnedCondition }
        }
        return vocabularies
    }
    
    func getFilterConditions() -> [(key: String, value: Color)] {
        var conditions: [(key: String, value: Color)] = []
        if let situcationCondition = situcationCondition {
            conditions.append((key: situcationCondition.rawValue, value: Color.blue))
        }
        if let sceneCondition = sceneCondition {
            conditions.append((key: sceneCondition.rawValue, value: Color.blue))
        }
        if let difficultyCondition = difficultyCondition {
            conditions.append((key: difficultyCondition.rawValue, value: Color.blue))
        }
        if let typeCondition = typeCondition {
            conditions.append((key: typeCondition.rawValue, value: Color.blue))
        }
        if let learnedCondition = learnedCondition {
            conditions.append((key: learnedCondition ? "学習済み" : "未学習", value: Color.blue))
        }
        return conditions
    }
}
