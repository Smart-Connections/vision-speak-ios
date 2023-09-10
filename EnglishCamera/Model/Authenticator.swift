//
//  Authenticator.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/26.
//

import Security
import AWSMobileClient

class Authenticator {
    
    func signUpUser() async {
        checkUserLoggedIn { isLoggedIn in
            print("Is user signed in - \(isLoggedIn)")
            if (isLoggedIn) { return }
            let username = self.randomString(length: 10)
            let password = self.randomPassword()
            // Cognitoでusernameとpasswordでユーザーを作成する
            AWSMobileClient.default().signUp(username: username, password: password) {result, error in
                print("result: \(result)")
                print("error: \(error)")
                // usernameとpasswordでログインする
                AWSMobileClient.default().signIn(username: username, password: password) {result, error in
                    print("result: \(result)")
                    print("error: \(error)")
                }
            }
        }
    }

    enum AuthError: Error {
        case signedUpToConfirm
        case signInIncomplete
        case unknown
    }
    
    func checkUserLoggedIn(completion: @escaping (Bool) -> Void) {
        AWSMobileClient.default().initialize { userState, error in
            if let error = error {
                print("error: \(error)")
                completion(false)
                return
            }
            guard let userState = userState else {
                completion(false)
                return
            }
            switch userState {
            case .signedIn:
                completion(true)
            default:
                completion(false)
            }
        }
    }
    
    private func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz1234567890"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    private func randomPassword() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()"
        return String((0..<12).map{ _ in letters.randomElement()! })
    }
}
