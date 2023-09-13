//
//  ChatGPT.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/01.
//

import Foundation

protocol ChatGPTDelegate: AnyObject {
}

extension ChatGPTDelegate {
    func receiveMessage(_ message: Message){}
    func receiveTranscript(_ text: String){}
    func getVocabulary(_ vocabulary: [String]){}
}

class ChatGPT {
    weak var delegate: ChatGPTDelegate?
    
    func sendMessage(message: String, threadId: String) {
        VisionSpeakApiClient().call(endPoint: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_send_message", body: [
            "message": message, "chat_thread_id": threadId]) { (data, response, error) in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(Message.self, from: data)
                        self.delegate?.receiveMessage(result)
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
    }
    
    func sendVoice(voiceBase64Decoded: String, threadId: String) {
        VisionSpeakApiClient().call(endPoint: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_send_message", body: [
            "message_voice": voiceBase64Decoded, "chat_thread_id": threadId]) { (data, response, error) in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(Message.self, from: data)
                        self.delegate?.receiveMessage(result)
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
    }
}

struct Message: Codable, Hashable {
    let role: String = ""
    let english_message: String
    let japanese_message: String
}

