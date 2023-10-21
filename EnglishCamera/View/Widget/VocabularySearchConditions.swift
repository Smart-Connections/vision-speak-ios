//
//  VocabularySearchConditions.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/20.
//

import Foundation
import SwiftUI

struct VocabularySearchConditions: View {
    
    @Binding var partOfSpeechOption: Part
    @Binding var situationOption: Situation
    @Binding var styleOption: ConversationStyle
    @Binding var difficultyOption: Difficulty
    @Binding var type: VocabularyType
    @Binding var searchText: String
    
    var body: some View {
        VStack{
            HStack(alignment: .center) {
                Text("キーワード")
                Spacer()
                TextField("例: 美味しい！のリアクション、水回りの単語", text: $searchText)
                    .font(.subheadline)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            HStack {
                Text("シチュエーション")
                Spacer()
                Picker("", selection: $situationOption) {
                    ForEach(Situation.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
            }
            HStack {
                Text("シーン")
                Spacer()
                Picker("", selection: $styleOption) {
                    ForEach(ConversationStyle.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
            }
            HStack {
                Text("難しさ")
                Spacer()
                Picker("", selection: $difficultyOption) {
                    ForEach(Difficulty.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
            }
            HStack {
                Text("種類")
                Spacer()
                Picker("", selection: $type) {
                    ForEach(VocabularyType.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
            }
        }
    }
}
