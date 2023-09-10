//
//  CloudVision.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/16.
//

import AWSMobileClient

protocol AnalyzeImageDelegate: AnyObject {
    func didAnalyzeImage(_ result: AnalyzeImageResult)
}

class AnalyzeImage {
    
    weak var delegate: AnalyzeImageDelegate?
    
    func analyzeImage(imageBase64: String) {
        VisionSpeakApiClient().call(endPoint: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_setup_chat", body: ["filename": Date().description, "image": imageBase64]) { (data, response, error) in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(AnalyzeImageResult.self, from: data)
                    self.delegate?.didAnalyzeImage(result)
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }
        }
    }
}

struct AnalyzeImageResult: Codable {
    let description: String
    let presignedURL: URL
    let chatThreadID: String
    let tags: [Tag]
    
    enum CodingKeys: String, CodingKey {
        case description
        case presignedURL = "presigned_url"
        case chatThreadID = "chat_thread_id"
        case tags
    }
    
    struct Tag: Codable {
        let confidence: Double
        let tag: String
    }
}