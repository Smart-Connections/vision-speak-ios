//
//  ChatHistories.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/11/02.
//

import Foundation

protocol ChatHistoryDelegate: AnyObject {
    func didGetThreads(threads: [ChatThread])
}

class ChatHistory: NSObject {
    weak var delegate: ChatHistoryDelegate?
    
    func getThreads(count: Int, onError: @escaping (Error) -> Void) {
        VisionSpeakApiClient().get(endPoint: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_get_chat_threads", header: ["THREADS_COUNT": "\(count)"]) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            if let data = data {
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String:Any]]] ?? [:]
                    let threads = result["chat_threads"].map {$0.map {
                        ChatThread(imageUrl: URL(string: $0["image_url"] as? String ?? "")!, text: $0["latest_message"] as? String ?? "")
                    }}
                    debugPrint("ChatHistoryViewModel: \(threads)")
                    self.delegate?.didGetThreads(threads: threads ?? [])
                } catch {
                    debugPrint("Error parsing JSON: \(error)")
                }
            }
        }
    }
}
