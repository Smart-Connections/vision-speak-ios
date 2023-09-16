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
                Text("設定したVocabulary").font(.headline).bold()
                Divider().frame(height: 0.5)
                ForEach(Array(viewModel.selectedVocabulary)) { vocabulary in
                    HStack(alignment: .top) {
                        Image(systemName: "circle.fill").resizable().frame(width: 8, height: 8).foregroundColor(.green).padding(.top, 6)
                        Spacer().frame(width: 8)
                        Text(vocabulary.vocabulary).frame(maxWidth: .infinity, alignment: .leading)
                    }.padding()
                    Divider().frame(height: 0.5)
                }
            }.padding().background(.white).cornerRadius(8)
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
