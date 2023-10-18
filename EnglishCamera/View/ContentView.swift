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
    @ObservedObject private var purchaseState: PurchaseState = .init()
    
    @State private var tabPage: Int = 0

    init() {
        let appearance = UITabBarAppearance()
        appearance.shadowImage = UIImage(named: "tab-shadow")?.withRenderingMode(.alwaysTemplate)
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        return TabView(selection: $tabPage) {
            TodayStudyView()
                .environmentObject(studyHistoryState)
                .environmentObject(vocabularyState)
                .environmentObject(purchaseState)
                .tag(0)
                .tabItem {
                    Image(systemName: "camera")
                    Text("学習")
                }
            
            VocabularyBrowserView()
                .environmentObject(vocabularyState)
                .tag(1)
                .tabItem {
                    Image(systemName: "checklist")
                    Text("Vocabulary")
                }
            StudyHistoryView()
                .environmentObject(studyHistoryState)
                .tag(2)
                .tabItem {
                    Image(systemName: "note")
                    Text("学習記録")
                }
        }.onAppear {
            studyHistoryState.refresh()
        }
        .onChange(of: tabPage) { _ in
            if (tabPage == 1) {
                vocabularyState.objectWillChange.send()
            }
        }
    }
}
