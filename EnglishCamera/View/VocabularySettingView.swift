//
//  VocabularySettingView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import AVFoundation
import Foundation
import SwiftUI

struct VocabularySettingView: View {
    @EnvironmentObject private var vocabularyState: VocabularyState
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    @Binding var showVocabularySetting: Bool
    @Binding var showCameraCoachMark: Bool
    @Binding var showRealTimeView: Bool
    
    @State private var showSearchModal = false
    @State private var showCoachMark = false
    @State private var tryShowCameraPermission = false
    
    var body: some View {
        VStack{
            Spacer()
            VStack(alignment: .leading){
                Button(action: {
                    showRealTimeView = false
                }) {
                    Image(systemName: "chevron.left")
                        .frame(width: 32, height: 32)
                        .foregroundColor(Color("surface"))
                        .background(Color("onSurfaceStrong"))
                        .cornerRadius(16)
                }
                Text("使いたいVocabularyを設定しよう").font(.title3).frame(maxWidth: .infinity, alignment: .center)
                Spacer().frame(height: 16)
                ZStack {
                    HStack {
                        Spacer()
                        Text("未学習のVocabulary")
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button(action: {
                            showSearchModal = true
                        }) {
                            Group {
                                HStack {
                                    Text("追加")
                                    Image(systemName: "plus.circle")
                                }
                                .padding(.vertical, 8)
                                .foregroundColor(.white)
                                .frame(width: 80)
                                .background(Color.blue)
                                .cornerRadius(8)
                                .showCoachMark(show: $showCoachMark, text: "会話中に使いたいVocabularyをここから追加ができます")
                            }.frame(width: 80, height: 40)
                        }.sheet(isPresented: $showSearchModal) {
                            VocabularySearchView(showSearchModal: $showSearchModal).environmentObject(vocabularyState)
                        }
                    }
                }
                VocabularyHistoryList().environmentObject(vocabularyState)
                Button(action: {
                    if AVCaptureDevice.authorizationStatus(for: .video) != .authorized || AVCaptureDevice.authorizationStatus(for: .audio) != .authorized {
                        tryShowCameraPermission = true
                    } else {
                        showVocabularySetting = false
                        viewModel.startTimer()
                        showCameraCoachMarkIfNeeded()
                    }
                }) {
                    Text("Start")
                        .padding(.vertical, 10)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(viewModel.selectedVocabulary.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(8)
                }
                .disabled(viewModel.selectedVocabulary.isEmpty)
                .showCameraPermissionDialogIfNeeded(tryShow: $tryShowCameraPermission)
                .showMicPermissionDialogIfNeeded(tryShow: $tryShowCameraPermission)
            }
            .padding()
            .background(Color("surface"))
            .cornerRadius(8)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.4))
        .onAppear {
            showCoachMarkIfNeeded()
        }
    }
    
    private func showCoachMarkIfNeeded() {
        if !UserDefaults.standard.bool(forKey: CoachMark.vocabularySetting.rawValue) { return }
        
        showCoachMark = true
        UserDefaults.standard.set(false, forKey: CoachMark.vocabularySetting.rawValue)
    }
    
    private func showCameraCoachMarkIfNeeded() {
        if !UserDefaults.standard.bool(forKey: CoachMark.realTimeAnalyzeImage.rawValue) { return }
        
        showCameraCoachMark = true
        UserDefaults.standard.set(false, forKey: CoachMark.realTimeAnalyzeImage.rawValue)
    }
    
}

