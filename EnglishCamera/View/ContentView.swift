//
//  ContentView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/07/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var studyHistoryState: StudyHistoryState = .init(StudyHistoryDataSource())
    @ObservedObject private var vocabularyState: VocabularyState = .init(VocabularyDataSource())

    init() {
        let appearance = UITabBarAppearance()
        appearance.shadowImage = UIImage(named: "tab-shadow")?.withRenderingMode(.alwaysTemplate)
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        return TabView {
            CameraView()
                .environmentObject(studyHistoryState)
                .environmentObject(vocabularyState)
                .tabItem {
                    Image(systemName: "camera")
                    Text("学習")
                }
            StudyHistoryView()
                .environmentObject(studyHistoryState)
                .tabItem {
                    Image(systemName: "note")
                    Text("学習記録")
                }
        }.onAppear {
            studyHistoryState.refresh()
        }
    }
}
