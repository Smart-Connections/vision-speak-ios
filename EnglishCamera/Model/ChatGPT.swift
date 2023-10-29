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
    func receiveFeedback(feedback: Feedback)
}

class ChatGPT {
    weak var delegate: ChatGPTDelegate?
    
    func sendMessage(message: String, threadId: String, onError: @escaping (Error) -> Void) {
        VisionSpeakApiClient().call(endPoint: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_send_message", body: [
            "message": message, "chat_thread_id": threadId]) { (data, response, error) in
                if let error = error {
                    onError(error)
                    return
                }
                if let data = data {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                        let message = Message(role: "assistant", english_message: result["english_message"] ?? "", japanese_message: result["japanese_message"] ?? "")
                        self.delegate?.receiveMessage(message)
                    } catch {
                        debugPrint("Error parsing JSON: \(error)")
                    }
                }
            }
    }
    
    func transcript(message: String, onError: @escaping (Error) -> Void) {
        VisionSpeakApiClient().call(endPoint: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_transcript", body: [
            "message_voice": message]) { (data, response, error) in
                if let error = error {
                    onError(error)
                    return
                }
                if let data = data {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                        self.delegate?.receiveTranscript(result["text"] ?? "")
                    } catch {
                        debugPrint("Error parsing JSON: \(error)")
                    }
                }
            }
    }
    
    func feedback(message: Message, targetVocabularies: [Vocabulary], onError: @escaping (Error) -> Void) {
        VisionSpeakApiClient().call(endPoint: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_feedback", body: [
            "message": message.english_message, "words": targetVocabularies.map{ $0.vocabulary }]) { (data, response, error) in
                if let error = error {
                    onError(error)
                    return
                }
                if let data = data {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        let evaluation = Evaluation(rawValue: result["evaluation"] as? Int ?? 0) ?? .implementable
                        let feedbackForTargetWord = result["feedback_for_target_word"] as! String
                        let feedbackString = result["feedback"] as! String
                        let feedback = Feedback(evaluation: evaluation, feedback: feedbackString, feedback_for_target_word: feedbackForTargetWord, message: message)
                        self.delegate?.receiveFeedback(feedback: feedback)
                    } catch {
                        debugPrint("Error parsing JSON: \(error)")
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

// 以下がレスポンスでjsonで帰ってきた時のクラス
// evaluationはenumでintegerで返される
struct Feedback: Hashable {
    let evaluation: Evaluation
    let feedback: String
    let feedback_for_target_word: String
    let message: Message
}

// 以下がレスポンスで帰ってくる時の値（Python）
enum Evaluation: Int {
    case good = 1
    case implementable = 2
    case bad = 3
}
