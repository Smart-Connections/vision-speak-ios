//
//  ChatHistoryDetailView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/11/07.
//

import SwiftUI

struct ChatHistoryDetailView: View {
    @EnvironmentObject private var viewModel: RealTimeImageClassificationViewModel
    
    @Binding var showDetailView: Bool
    
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
                            }.padding(.horizontal, 48).padding(.vertical, 16)
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
            }
        }
        .navigationBarTitle("会話履歴", displayMode: .inline)
    }
}
