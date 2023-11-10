//
//  ChatHistoryViewModel.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/11/02.
//

import Foundation

class ChatHistoryViewModel: ObservableObject {
    private let chatHistory: ChatHistory = ChatHistory()
    
    @Published var latestThreeThreads: [ChatThread] = []
    @Published var threadsList: [ChatThread] = []
    
    init() {
        chatHistory.delegate = self
    }
    
    func getThreads() {
        chatHistory.getThreads(count: 3) { error in
            debugPrint(error)
        }
    }
}

extension ChatHistoryViewModel: ChatHistoryDelegate {
    func didGetThreads(threads: [ChatThread]) {
        DispatchQueue.main.async {
            debugPrint("ChatHistoryViewModel: didGetThreads")
            self.latestThreeThreads = threads
        }
    }
}
