//
//  ChatHistoryItem.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/11/02.
//

import Foundation
import SwiftUI

struct ChatHistoryItem: View {
    
    var chatThread: ChatThread
    
    var body: some View {
        HStack {
            AsyncImage(url: chatThread.imageUrl) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80)
            } placeholder: {
                ProgressView()
            }.cornerRadius(8)
            Spacer().frame(width: 16)
            VStack(alignment: .leading) {
                HStack {
                    ForEach(0..<chatThread.setVocabulary.count) { number in
                        Image(systemName: "star.fill").resizable().frame(width: 22, height: 22).foregroundColor(number < chatThread.learnedVocabulary.count ? .yellow : Color("onSurfaceLight").opacity(0.3))
                    }
                }
                Spacer().frame(height: 8)
                Text(chatThread.updatedAt.toString("yyyy年M月d日")).font(.caption).foregroundColor(Color("onSurfaceLight"))
                Spacer().frame(height: 8)
                Text(chatThread.text).font(.callout).foregroundColor(Color("onSurface")).lineLimit(2)
            }
        }
    }
}
