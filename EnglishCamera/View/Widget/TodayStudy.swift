//
//  TodayStudy.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/27.
//

import SwiftUI

struct TodayStudy: View {
    @EnvironmentObject private var purchaseState: PurchaseState
    @EnvironmentObject private var studyHistoryState: StudyHistoryState
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    @State private var showNextView = false
    
    private let studyHistoryDataSource = StudyHistoryDataSource()
    
    var body: some View {
        let history = studyHistoryDataSource.getWhere(Date().ymd).first
        let enable = isDebugMode || (purchaseState.status == .unlimited || (Double(history?.studyTimeSeconds ?? 0)) < purchaseState.status.limitSeconds)
        VStack {
            Text("今日の学習").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .leading, spacing: 16) {
                Text("学習時間").font(.subheadline)
                HStack {
                    Spacer()
                    Text(TimeInterval(history?.studyTimeSeconds ?? 0).ms).font(.title3)
                    Spacer()
                }
                Text("使用単語数").font(.subheadline)
                HStack {
                    Spacer()
                    Text(String(history?.userCredits ?? 0)).font(.title3)
                    Spacer()
                }
                Spacer().frame(height: 16)
                Button(action: {
                    showNextView = true
                }) {
                    Text("Start")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(enable ? Color.blue : Color.gray)
                        .cornerRadius(8)
                }
                .disabled(!enable)
                .frame(maxWidth: .infinity)
                .fullScreenCover(isPresented: $showNextView, content: {
                    RealTimeImageClassificationView(showNextView: $showNextView)
                        .environmentObject(studyHistoryState)
                        .environmentObject(vocabularyState)
                })
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(8)
        }
    }
    
    let isDebugMode: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()
}
