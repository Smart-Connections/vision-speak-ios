//
//  VisionSpeakApiClient.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/02.
//

import AWSMobileClient

class VisionSpeakApiClient {
    
    func call(endPoint: String, body: [String: Any], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        debugPrint("API Call: \(endPoint)")
        AWSMobileClient.default().getTokens { (tokens, error) in
            if let error = error {
                debugPrint("call API Token取得で例外発生")
                debugPrint(error)
                return
            }
            guard let idToken = tokens?.idToken?.tokenString else { return }
            var request = URLRequest(url: URL(string: endPoint)!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(idToken, forHTTPHeaderField: "Authorization")
            let body = try? JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = body
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if (data != nil) {
                    debugPrint((try? JSONSerialization.jsonObject(with: data ?? Data(), options: [])) ?? "")
                }
                debugPrint(response as Any)
                debugPrint(error as Any)
                completion(data, response, error)
            }
            task.resume()
        }
    }
}
