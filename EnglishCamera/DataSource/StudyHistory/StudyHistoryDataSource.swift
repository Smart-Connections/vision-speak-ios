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
        debugPrint("StudyHistoryDataSource init")
        self.realm = try! RealmWrapper.sharedInstance()
    }
}

extension StudyHistoryDataSource {
    
    func saveStudyHistory(passedTime: TimeInterval, wordsCount: Int) {
        debugPrint("saveStudyHistory: \(passedTime), \(wordsCount)")
        if let historyValue = todayHistory() {
            updateHistory(historyValue, Int(passedTime), wordsCount)
        } else {
            let history: StudyHistory = StudyHistory(studyTimeSeconds: Int(passedTime),
                                                     userCredits: wordsCount, createdAt: Date().ymd)
            update(history)
        }
    }
    
    func todayHistory() -> Target? {
        let today = getWhere(Date().ymd).first
        debugPrint("todayHistory: \(String(describing: today))")
        return today
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
