//
//  FeedbackView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/16.
//

import SwiftUI

struct FeedbackView: View {
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    
    @Binding private var showFeedbackView: Bool
    
    init(showFeedbackView: Binding<Bool>) {
        self._showFeedbackView = showFeedbackView
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("レッスン完了").font(.title).bold().frame(alignment: .center)
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Text("使えた数").frame(maxWidth: .infinity, alignment: .center).font(.title3)
                        Spacer().frame(height: 4)
                        Text("\(1)/\(viewModel.selectedVocabulary.count)").frame(maxWidth: .infinity, alignment: .center).font(.title3).bold()
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        Text("使った単語").frame(maxWidth: .infinity, alignment: .center).font(.title3)
                        Spacer().frame(height: 4)
                        Text("\(viewModel.wordsCount)").frame(maxWidth: .infinity, alignment: .center).font(.title3).bold()
                    }
                    Spacer()
                }.padding(.horizontal, 48).padding(.vertical, 16)
                ForEach(Array(viewModel.selectedVocabulary)) { vocabulary in
                    HStack(alignment: .center) {
                        Text(vocabulary.vocabulary).frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Image(systemName: "star.fill").resizable().frame(width: 24, height: 24).foregroundColor(.yellow)
                    }.padding(.vertical, 2)
                }.padding(.horizontal, 48)
                Spacer().frame(height: 32)
                ChatMessages().environmentObject(viewModel)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
        }
        .navigationBarTitle("フィードバック", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(trailing: Button(action: {
            showFeedbackView = false
        }) {
            Text("Done").bold()
        })
    }
}
