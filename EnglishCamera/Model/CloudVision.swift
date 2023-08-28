//
//  CloudVision.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/16.
//

import Amplify
import AmplifyPlugins
import AWSPluginsCore
import AWSMobileClient

protocol GoogleCloudOCRDelegate: AnyObject {
    func detectedImage(_ labels: DetectImageResult)
}

class GoogleCloudOCR {
    
    weak var delegate: GoogleCloudOCRDelegate?
    
    private var endpoint: URL {
        return URL(string: "https://2oi5uy417l.execute-api.ap-northeast-1.amazonaws.com/main/v1_setup_chat")!
    }
    
    func detectImage(imageBase64: String) {
        Amplify.Auth.fetchAuthSession() {
            result in
            switch result {
            case .success(let session):
                guard let cognitoTokenProvider = session as? AuthCognitoTokensProvider else { return }
                let tokens = try? cognitoTokenProvider.getCognitoTokens().get()
                let token = tokens?.refreshToken ?? ""

                var request = URLRequest(url: self.endpoint)
                request.httpMethod = "POST"
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                
                print(request.allHTTPHeaderFields!)
                
                // Build our API request
                let jsonRequest = [
                    "filename": Date().description,
                    "image": imageBase64
                ]
                request.httpBody = try? JSONSerialization.data(withJSONObject: jsonRequest)
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    debugPrint(response as Any)
                    debugPrint(error as Any)
                    // レスポンスが返ってきた時の処理
                    if let data = data {
                        do {
                            let jsonData = (String(data: data, encoding: .utf8) ?? "").data(using: .utf8)!
                            let json = try JSONSerialization.jsonObject(with: (String(data: data, encoding: .utf8) ?? "").data(using: .utf8)!, options: []) as? [String: Any]
                            debugPrint(json)
                            if let description = json?["description"] as? [String: Any],
                               let captions = description["captions"] as? [[String: Any]],
                               let firstCaption = captions.first,
                               let text = firstCaption["text"] as? String {
                                print(text)
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                }
                task.resume()
            case .failure(let error):
                print("Fetch auth session failed with error \(error)")
            }
        }
    }
}

struct DetectImageResult: Hashable {
    let message: String
    let tags: [String]
}
