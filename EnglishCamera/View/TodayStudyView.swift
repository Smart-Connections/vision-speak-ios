//
//  CameraView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/05.
//

import SwiftUI

struct TodayStudyView: View {
    @EnvironmentObject private var purchaseState: PurchaseState
    @EnvironmentObject private var studyHistoryState: StudyHistoryState
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    @State private var showMenu = false
    @State private var showPurchaseView = false
    @State private var showCoachMark = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Spacer().frame(height: 24)
                    HStack {
                        Text("学習").font(.largeTitle.bold())
                        Spacer()
                        Button(action:{
                            showMenu = true
                        }, label: {
                            Image(systemName: "line.3.horizontal.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }).sheet(isPresented: $showMenu , onDismiss : {
                            showCoachMarkIfNeeded()
                        }) {
                            MenuView(showMenu: $showMenu, showPurchaseView: $showPurchaseView).environmentObject(purchaseState)
                        }
                    }
                    Spacer().frame(height: 24)
                    VStack{
                        TodayStudy(showMenu: $showMenu, showPurchaseView: $showPurchaseView).environmentObject(purchaseState).environmentObject(studyHistoryState).environmentObject(vocabularyState).showCoachMark(show: $showCoachMark, text: "Vision Speakのインストールありがとうございます。使い方を説明させていただきます。\n\nこの画面から学習を始められます。Startを押して学習を開始しましょう。")
                    }.frame(height: 300)
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
        }.onAppear {
            showCoachMarkIfNeeded()
        }
    }
    
    private func showCoachMarkIfNeeded() {
        if !UserDefaults.standard.bool(forKey: CoachMark.todayStudy.rawValue) { return }
        
        showCoachMark = true
        UserDefaults.standard.set(false, forKey: CoachMark.todayStudy.rawValue)
    }
}
