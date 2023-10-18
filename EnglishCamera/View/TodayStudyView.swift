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
    @State private var showCoachMark = false
    
    var body: some View {
        NavigationView{
            ScrollView {
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
                        }).sheet(isPresented: $showMenu) {
                            MenuView(showMenu: $showMenu).environmentObject(purchaseState)
                        }
                    }
                    Spacer().frame(height: 24)
                    VStack{
                        TodayStudy().environmentObject(purchaseState).environmentObject(studyHistoryState).environmentObject(vocabularyState).showCoachMark(show: $showCoachMark, text: "この画面から学習を始められます。Startを押して学習を開始しましょう。")
                    }.frame(height: 270)
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
        }
    }
}
