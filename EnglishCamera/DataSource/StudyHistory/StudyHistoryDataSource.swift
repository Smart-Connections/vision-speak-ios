//
//  StudyHistoryDatasource.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/05.
//

import RealmSwift
import Foundation

class StudyHistoryDataSource: DataSource {
    typealias Target = StudyHistory
    
    var realm: Realm
    
    init() {
        print("StudyHistoryDataSource init")
        self.realm = try! RealmWrapper.sharedInstance()
    }
}

extension StudyHistoryDataSource {

    func todayHistory() -> Target? {
        return getWhere(Date().ymd).first
    }
    
    func getWhere(_ date: String) -> [Target] {
        return realm.objects(Target.self).where({ $0.createdAt == date}).map({$0})
    }
    
    func updateHistory(_ history: Target, _ studyTimeSeconds: Int, _ userCredits: Int) {
        try! realm.write {
            history.studyTimeSeconds += studyTimeSeconds
            history.userCredits += userCredits
        }
    }
}
