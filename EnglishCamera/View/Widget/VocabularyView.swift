//
//  WordsWindow.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/10.
//

import SwiftUI

struct VocabularyView: View {
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    @Binding var showVocabulary: Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                ForEach(Array(viewModel.selectedVocabulary)) { vocabulary in
                    Text(vocabulary.vocabulary)
                    Divider().frame(height: 0.5)
                }.padding().frame(maxWidth: .infinity)
            }.background(.white).cornerRadius(8)
            Spacer().frame(height: 96)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black.opacity(0.4))
        .onTapGesture {
            showVocabulary = false
        }
    }
    
}
