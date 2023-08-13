//
//  CameraView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/05.
//

import SwiftUI

struct CameraView: View {
    @EnvironmentObject private var studyHistoryState: StudyHistoryState
    
    @State private var showNextView = false
    @State private var showMenu = false
    
    private let studyHistoryDataSource = StudyHistoryDataSource()
    
    var body: some View {
        let history = studyHistoryDataSource.getWhere(Date().ymd).first
        let enable = (history?.studyTimeSeconds ?? 0) < AppValue.limitSeconds
        return NavigationView{
            VStack{
                Spacer().frame(height: 24)
                HStack {
                    Text("Camera").font(.largeTitle.bold())
                    Spacer()
                    Button(action: {
                        showMenu = true
                    }, label: {
                        Image(systemName: "line.3.horizontal.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }).sheet(isPresented: $showMenu) {
                        MenuView(showMenu: $showMenu)
                    }
                }
                VStack(alignment: .leading, spacing: 16) {
                    Text("今日の学習").font(.headline)
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
                        RealTimeImageClassificationView(showNextView: $showNextView).environmentObject(studyHistoryState)
                    })
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(8)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
        }
    }
}
