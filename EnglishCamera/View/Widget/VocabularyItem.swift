//
//  VocabularyItem.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/22.
//

import Foundation
import SwiftUI

struct VocabularyItem: View {
    var english: String
    var japanese: String
    
    var body: some View {
        HStack{
            Text(english)
            Spacer().frame(width: 16)
            Text(japanese).font(.callout).foregroundColor(Color("onSurfaceLight"))
        }
    }
}
