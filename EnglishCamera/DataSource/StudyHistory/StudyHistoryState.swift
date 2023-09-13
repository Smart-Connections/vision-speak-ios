//
//  StudyHistoryState.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/05.
//

import Foundation

class StudyHistoryState: ObservableObject {
    @Published private(set) var studyHistory: [StudyHistory] = []
    
    private var datasource: StudyHistoryDataSource
    
    init(_ dataSource: StudyHistoryDataSource) {
        self.datasource = dataSource
    }
    
    func refresh() {
        self.studyHistory = datasource.getAll()
    }
}
