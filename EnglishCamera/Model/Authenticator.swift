//
//  Authenticator.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/26.
//

import Security
import AWSMobileClient

class Authenticator {
    
    func signInOrUpUserIfNeeded(completion: @escaping (String?) -> Void) async {
        checkUserLoggedIn { isLoggedIn in
            debugPrint("ログインチェック結果: \(isLoggedIn)")
            if (isLoggedIn) { return }
            
            AWSMobileClient.default().signOut()
            let shouldSignUpResult = self.shouldSignUp()
            if shouldSignUpResult.shouldSignUp {
                debugPrint("ログイン情報がないため、初回登録を実行")
                self.signUp(completion: completion)
            } else {
                debugPrint("ログイン情報があるため、ログイン処理を実行")
                self.signIn(username: shouldSignUpResult.userName, password: shouldSignUpResult.password, completion: completion)
            }
        }
    }
    
    private func shouldSignUp() -> ShouldSignUpResult {
        var userNameResult: AnyObject?
        var passwordResult: AnyObject?
        SecItemCopyMatching(KeyChainKey.username.readQuery(), &userNameResult)
        SecItemCopyMatching(KeyChainKey.password.readQuery(), &passwordResult)
        guard let userNameData = userNameResult as? Data, let passwordData = passwordResult as? Data else { return ShouldSignUpResult(shouldSignUp: true) }
        return ShouldSignUpResult(
            shouldSignUp: false,
            userName: String(data: userNameData, encoding: .utf8)!,
            password: String(data: passwordData, encoding: .utf8)!
        )
    }
    
    private func signUp(completion: @escaping (String?) -> Void) {
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
    
    private func signIn(username: String, password: String, completion: @escaping (String?) -> Void) {
        AWSMobileClient.default().signIn(username: username, password: password) {signInResult, error in
            if let error = error  {
                debugPrint("ログインで例外発生: \(error.localizedDescription)")
            } else if let signInResult = signInResult {
                switch (signInResult.signInState) {
                case .signedIn:
                    debugPrint("User is signed in.")
                    self.saveLoginData(username: username, password: password)
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
        let userNameQuery = KeyChainKey.username.addQuery(value: username)
        let passwordQuery = KeyChainKey.password.addQuery(value: password)
        SecItemAdd(userNameQuery, nil)
        SecItemAdd(passwordQuery, nil)
    }
    
    private func checkUserLoggedIn(completion: @escaping (Bool) -> Void) {
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
    
    class ShouldSignUpResult {
        var shouldSignUp: Bool
        var userName: String
        var password: String
        
        init(shouldSignUp: Bool, userName: String = "", password: String = "") {
            self.shouldSignUp = shouldSignUp
            self.userName = userName
            self.password = password
        }
    }
}
