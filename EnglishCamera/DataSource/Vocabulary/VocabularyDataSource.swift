//
//  VocabularyDataSource.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import RealmSwift
import Foundation

class VocabularyDataSource: DataSource {
    typealias Target = Vocabulary
    
    var realm: Realm
    
    init() {
        print("VocabularyDataSource init")
        self.realm = try! RealmWrapper.sharedInstance()
    }
}

extension VocabularyDataSource {
    func updateVocabulary(_ data: Target, _ learned: Bool) {
        try! realm.write {
            data.learned = learned
        }
    }
}
