//
//  ChatGPT.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/01.
//

import Foundation

protocol ChatGPTDelegate: AnyObject {
    func receiveMessage(_ message: Message)
    func receiveTranscript(_ text: String)
}

class ChatGPT {
    weak var delegate: ChatGPTDelegate?
    
    func sendMessage(message: String, threadId: String) {
        VisionSpeakApiClient().call(endPoint: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_send_message", body: [
            "message": message, "chat_thread_id": threadId]) { (data, response, error) in
                if let data = data {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                        let message = Message(role: "assistant", english_message: result["english_message"] ?? "", japanese_message: result["japanese_message"] ?? "")
                        self.delegate?.receiveMessage(message)
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
    }
    
    func transcript(message: String) {
        VisionSpeakApiClient().call(endPoint: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_transcript", body: [
            "message_voice": message]) { (data, response, error) in
                if let data = data {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                        self.delegate?.receiveTranscript(result["text"] ?? "")
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
    }
}

struct Message: Codable, Hashable {
    var role: String = ""
    let english_message: String
    let japanese_message: String
}

