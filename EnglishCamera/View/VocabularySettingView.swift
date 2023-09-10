//
//  VocabularySettingView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import Foundation
import SwiftUI

struct VocabularySettingView: View {
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    @Binding var showVocabularySetting: Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                ForEach(0..<3) { index in
                    Text("\(index)")
                    Divider().frame(height: 0.5)
                }.padding().frame(maxWidth: .infinity)
            }.background(.white).cornerRadius(8)
            Spacer().frame(height: 96)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.4))
        .onTapGesture {
            showVocabularySetting = false
        }
    }
    
}

