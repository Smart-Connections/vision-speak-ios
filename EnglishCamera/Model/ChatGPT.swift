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
    
    var seacretKey: String = "Bearer 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"
    
    // HTTPリクエストを送信する
    func chat(_ messages: [Message]) {
        let messsagesParam = messages.map({ ["role": $0.role, "content": $0.content] })
        let endPoint = "https://api.openai.com/v1/chat/completions"
        let url = URL(string: endPoint)!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = ["Authorization": "\(seacretKey)"]
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: [
            "model": "gpt-3.5-turbo",
            "messages": messsagesParam,
            "temperature": 0.3,
            "top_p": 0.3,
            "max_tokens": 100
        ] as [String : Any], options: [])
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            debugPrint(response as Any)
            debugPrint(error as Any)
            // レスポンスが返ってきた時の処理
            if let data = data {
                do {
                    let jsonString = String(data: data, encoding: .utf8) ?? ""
                    let jsonData = jsonString.data(using: .utf8)!
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ChatCompletionResponse.self, from: jsonData)
                    if let firstChoice = response.choices.first {
                        print("Finish Reason: \(firstChoice.finishReason)")
                        self.delegate?.receiveMessage(firstChoice.message)
                        print("Message Content: \(firstChoice.message.content)")
                        print("Message Role: \(firstChoice.message.role)")
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()
    }
    
    func transcript(_ path: URL) {
        guard let audioData = FileManager().contents(atPath: path.relativePath) else { return }
        let endPoint = "https://api.openai.com/v1/audio/transcriptions"
        let url = URL(string: endPoint)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("\(seacretKey)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=boundary", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
            
        body.append("--boundary\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
        body.append("whisper-1\r\n".data(using: .utf8)!)
        
        body.append("--boundary\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"openai.mp3\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: audio/mpeg\r\n\r\n".data(using: .utf8)!)
        body.append(audioData)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--boundary\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n".data(using: .utf8)!)
        body.append("en\r\n".data(using: .utf8)!)
        
        body.append("--boundary--\r\n".data(using: .utf8)!)
        
        request.httpBody = body as Data
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            debugPrint(response as Any)
            debugPrint(error as Any)
            // レスポンスが返ってきた時の処理
            if let data = data {
                do {
                    let jsonString = String(data: data, encoding: .utf8) ?? ""
                    let json = try JSONSerialization.jsonObject(with: jsonString.data(using: .utf8)!, options: []) as? [String: Any]
                    self.delegate?.receiveTranscript(json?["text"] as! String)
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
        task.resume()
    }
}

class ChatCompletionResponse: Codable {
    let object: String
    let created: Int
    let choices: [Choice]
    let id: String
    let usage: Usage
    let model: String
}

class Choice: Codable {
    let index: Int
    let message: Message
    let finishReason: String

    private enum CodingKeys: String, CodingKey {
        case index, message
        case finishReason = "finish_reason"
    }
}

struct Message: Codable, Hashable {
    var content: String
    var role: String
}

class Usage: Codable {
    let totalTokens: Int
    let completionTokens: Int
    let promptTokens: Int

    private enum CodingKeys: String, CodingKey {
        case totalTokens = "total_tokens"
        case completionTokens = "completion_tokens"
        case promptTokens = "prompt_tokens"
    }
}
