//
//  Authenticator.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/26.
//

import Security
import AWSMobileClient

class Authenticator {
    
    func signUpUser(completion: @escaping (String?) -> Void) async {
        checkUserLoggedIn { isLoggedIn in
            debugPrint("Is user signed in - \(isLoggedIn)")
            if (isLoggedIn) { return }
            let username = self.randomString(length: 10)
            let password = self.randomPassword()
            
            AWSMobileClient.default().signUp(username: username, password: password) {signUpResult, error in
                if let signUpResult = signUpResult {
                    switch(signUpResult.signUpConfirmationState) {
                    case .confirmed:
                        self.signIn(username: username, password: password, completion: completion)
                    case .unconfirmed:
                        debugPrint("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                    case .unknown:
                        debugPrint("Unexpected case")
                    }
                } else if let error = error {
                    debugPrint("ユーザー登録で例外発生: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func signIn(username: String, password: String, completion: @escaping (String?) -> Void) {
        AWSMobileClient.default().signIn(username: username, password: password) {signInResult, error in
            if let error = error  {
                debugPrint("ログインで例外発生: \(error.localizedDescription)")
            } else if let signInResult = signInResult {
                switch (signInResult.signInState) {
                case .signedIn:
                    debugPrint("User is signed in.")
                    completion(username)
                case .smsMFA:
                    debugPrint("SMS message sent to \(signInResult.codeDetails!.destination!)")
                default:
                    debugPrint("Sign In needs info which is not et supported.")
                }
            }
        }
    }
    
    private func saveLoginData(username: String, password: String) {
        guard let bundleId = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") else { fatalError("BundleId取得失敗") }
        let userNameQuery = [
            kSecValueData: username.data(using: .utf8)!,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundleId,
            kSecAttrAccount: "vision.speak.user.name",
        ] as CFDictionary
        
        let passwordQuery = [
            kSecValueData: password.data(using: .utf8)!,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundleId,
            kSecAttrAccount: "vision.speak.password",
        ] as CFDictionary
        
        SecItemAdd(userNameQuery, nil)
        SecItemAdd(passwordQuery, nil)
    }
    
    enum AuthError: Error {
        case signedUpToConfirm
        case signInIncomplete
        case unknown
    }
    
    func checkUserLoggedIn(completion: @escaping (Bool) -> Void) {
        completion(false)
        return
        AWSMobileClient.default().initialize { userState, error in
            if let error = error {
                debugPrint("error: \(error)")
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
