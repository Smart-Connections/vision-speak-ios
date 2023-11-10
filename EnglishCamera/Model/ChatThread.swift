//
//  ChatThread.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/11/07.
//

import Foundation

struct ChatThread: Hashable {
    let imageUrl: URL
    let text: String
    let learnedVocabulary: [String]
    let setVocabulary: [String]
    let updatedAt: Date
    
    init(imageUrl: URL, text: String) {
        self.imageUrl = imageUrl
        self.text = text
        self.learnedVocabulary = ["some", "words"]
        self.setVocabulary = ["some", "good", "words"]
        self.updatedAt = Date()
    }
}
