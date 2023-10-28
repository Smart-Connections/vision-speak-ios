//
//  FeedbackView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/16.
//

import SwiftUI
import SpriteKit

struct FeedbackView: View {
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    @EnvironmentObject private var studyHistoryState: StudyHistoryState
    
    @Binding var showFeedbackView: Bool
    @Binding var showRealTimeView: Bool
    
    @State private var showCoachMark: Bool = false
    @State private var showConfetti: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView {
                    VStack {
                        Text("レッスン完了").font(.title).bold().frame(alignment: .center)
                        Group {
                            HStack {
                                Spacer()
                                VStack(alignment: .center) {
                                    Text("使えた数").frame(maxWidth: .infinity, alignment: .center).font(.title3)
                                    Spacer().frame(height: 4)
                                    Text("\(viewModel.selectedVocabulary.filter{ $0.learned }.count)/\(viewModel.selectedVocabulary.count)").frame(maxWidth: .infinity, alignment: .center).font(.title3).bold()
                                }
                                Spacer()
                                VStack(alignment: .center) {
                                    Text("使った単語").frame(maxWidth: .infinity, alignment: .center).font(.title3)
                                    Spacer().frame(height: 4)
                                    Text("\(viewModel.wordsCount)").frame(maxWidth: .infinity, alignment: .center).font(.title3).bold()
                                }
                                Spacer()
                            }.padding(.horizontal, 48).padding(.vertical, 16).showCoachMark(show: $showCoachMark, text: "会話の中で使用できたVocabulary、単語数を確認できます。適度に復習をして、次に学習に移りましょう。\n\nこれでアプリの説明は以上になります。ご覧いただきありがとうございました。")
                        }.frame(height: 80)
                        ForEach(Array(viewModel.selectedVocabulary)) { vocabulary in
                            HStack(alignment: .center) {
                                Text(vocabulary.vocabulary).frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                Image(systemName: "star.fill").resizable().frame(width: 24, height: 24).foregroundColor(vocabulary.learned ? .yellow : .gray)
                            }.padding(.vertical, 2)
                        }.padding(.horizontal, 48)
                        Spacer().frame(height: 32)
                        ChatMessages(isFeedbackView: true).environmentObject(viewModel)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("back"))
                }
                if $showConfetti.wrappedValue {
                    GeometryReader { geometry in
                        ZStack {
                            SpriteView(
                                scene: self.createRainParticleScene(size: geometry.size, color: .red),
                                options: [.allowsTransparency]
                            ).edgesIgnoringSafeArea(.all)
                            SpriteView(
                                scene: self.createRainParticleScene(size: geometry.size, color: .green),
                                options: [.allowsTransparency]
                            ).edgesIgnoringSafeArea(.all)
                            SpriteView(
                                scene: self.createRainParticleScene(size: geometry.size, color: .blue),
                                options: [.allowsTransparency]
                            ).edgesIgnoringSafeArea(.all)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("フィードバック", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: Button(action: {
            showFeedbackView = false
            showRealTimeView = false
        }) {
            Text("Done").bold()
        })
        .onAppear {
            showSendVoiceCoachMarkIfNeeded()
            showConfettiIfNeeded()
        }
        .onDisappear {
            studyHistoryState.refresh()
        }
    }
    
    private func showSendVoiceCoachMarkIfNeeded() {
        if !UserDefaults.standard.bool(forKey: CoachMark.feedbackView.rawValue) { return }
        
        showCoachMark = true
        UserDefaults.standard.set(false, forKey: CoachMark.feedbackView.rawValue)
    }
    
    private func createRainParticleScene(size: CGSize, color: UIColor) -> SKScene {
        let emitterNode = SKEmitterNode(fileNamed: "Confetti")!
        emitterNode.particleColorSequence = nil
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleColor = color
        let scene = SKScene(size: size)
        scene.addChild(emitterNode)
        scene.backgroundColor = .clear
        scene.anchorPoint = .init(x: 0.7, y: 1)
        
        return scene
    }
    
    private func showConfettiIfNeeded() {
        if (viewModel.selectedVocabulary.count == viewModel.selectedVocabulary.filter{ $0.learned }.count) {
            showConfetti = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.showConfetti = false
            }
        }
    }
}
