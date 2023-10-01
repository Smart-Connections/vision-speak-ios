//
//  VocabularyBrowseFilterSettingView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/30.
//

import SwiftUI

struct VocabularyBrowseFilterSettingView: View {
    @EnvironmentObject private var vocabularyState: VocabularyState
    
    @Binding var showFilterSettingView: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("習得状況")
                    Spacer()
                    Picker("", selection: $vocabularyState.learnedCondition) {
                        Text("選択してください").tag(Optional<Bool>.none)
                        Text("学習済み").tag(Optional<Bool>.some(true))
                        Text("末学習").tag(Optional<Bool>.some(false))
                    }
                }
                HStack {
                    Text("シチュエーション")
                    Spacer()
                    Picker("", selection: $vocabularyState.situcationCondition) {
                        Text("選択してください").tag(Optional<Situation>.none)
                        ForEach(Situation.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(Optional.some(option))
                        }
                    }
                }
                HStack {
                    Text("シーン")
                    Spacer()
                    Picker("", selection: $vocabularyState.sceneCondition) {
                        Text("選択してください").tag(Optional<ConversationStyle>.none)
                        ForEach(ConversationStyle.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(Optional.some(option))
                        }
                    }
                }
                HStack {
                    Text("難しさ")
                    Spacer()
                    Picker("", selection: $vocabularyState.difficultyCondition) {
                        Text("選択してください").tag(Optional<Difficulty>.none)
                        ForEach(Difficulty.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(Optional.some(option))
                        }
                    }
                }
                HStack {
                    Text("種類")
                    Spacer()
                    Picker("", selection: $vocabularyState.typeCondition) {
                        Text("選択してください").tag(Optional<VocabularyType>.none)
                        ForEach(VocabularyType.allCases, id: \.self) { option in
                            Text(option.rawValue).tag(Optional.some(option))
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
            .navigationBarTitle(Text("Menu"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                showFilterSettingView = false
            }) {
                Text("Done").bold()
            })
        }
    }
}
