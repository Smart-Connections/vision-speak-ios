//
//  Authenticator.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/26.
//

import Amplify
import AmplifyPlugins
import Security

class Authenticator {
    
    func signUpUser() async {
        checkUserLoggedIn { isLoggedIn in
            print("Is user signed in - \(isLoggedIn)")
            if (isLoggedIn) { return }
            let username = self.randomString(length: 10)
            let password = self.randomPassword()
            _ = Amplify.Auth.signUp(username: username, password: password)
            _ = Amplify.Auth.signIn(username: username, password: password)
        }
    }

    enum AuthError: Error {
        case signedUpToConfirm
        case signInIncomplete
        case unknown
    }
    
    func checkUserLoggedIn(completion: @escaping (Bool) -> Void) {
        Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
                completion(session.isSignedIn)
            case .failure(let error):
                print("Fetch auth session failed with error \(error)")
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
