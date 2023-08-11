//
//  StudyHistory.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/05.
//

import RealmSwift
import Foundation


class StudyHistory: Object, Identifiable {
    @Persisted var id = UUID()
    @Persisted var studyTimeSeconds: Int
    @Persisted var userCredits: Int
    @Persisted var systemCredits: Int
    @Persisted var createdAt: String // yyyy/MM/dd
    
    convenience init(
        studyTimeSeconds: Int,
        userCredits: Int,
        systemCredits: Int = 0,
        createdAt: String
    ) {
        self.init()
        self.studyTimeSeconds = studyTimeSeconds
        self.userCredits = userCredits
        self.systemCredits = systemCredits
        self.createdAt = createdAt
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
