//
//  SearchVocabulary.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import Foundation

protocol SearchVocabularyDelegate {
    func getVocabulary(_ vocabularyList: VocabularyList)
}

class SearchVocabulary {

    var delegate: SearchVocabularyDelegate?
    
    func searchVocabulary(_ searchVocabularyCondition: SearchVocabularyCondition) {
        VisionSpeakApiClient().call(endPoint: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_search_vocabulary", body: [
            "keyword": searchVocabularyCondition.keyword,
            "situation": searchVocabularyCondition.situation,
            "style": searchVocabularyCondition.style,
            "difficulty": searchVocabularyCondition.difficulty,
            "type": searchVocabularyCondition.type
        ]
        ) { (data, response, error) in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let vocabularyList = try decoder.decode(VocabularyList.self, from: data)
                        self.delegate?.getVocabulary(vocabularyList)
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
    }
}

struct SearchVocabularyCondition {
    let keyword: String
    let situation: String
    let style: String
    let difficulty: String
    let type: String
}

struct VocabularyList: Decodable {
    let english_vocabulary_list: [String]
}
