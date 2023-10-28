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
    
    @Binding var showMenu: Bool
    @Binding var showPurchaseView: Bool
    
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
                if enable {
                    Spacer().frame(height: 8)
                }
                if !enable && purchaseState.status == .free {
                    HStack {
                        Spacer()
                        Button(action: {
                            showMenu = true
                            showPurchaseView = true
                        }) {
                            Text("プラン変更")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .foregroundColor(.white)
                                .background(.orange)
                                .cornerRadius(32)
                                .shimmering()
                        }
                    }
                }
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
            .background(Color("surface"))
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
