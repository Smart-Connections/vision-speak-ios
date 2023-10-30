//
//  KeyChainKey.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/30.
//

import Security
import Foundation

enum KeyChainKey {
    case username
    case password;
    
    func addQuery(value: String) -> CFDictionary {
        guard let bundleId = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") else { fatalError("BundleId取得失敗") }
        switch(self) {
        case .username:
            return [
                kSecValueData: value.data(using: .utf8)!,
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: bundleId,
                kSecAttrAccount: "vision.speak.user.name",
                kSecReturnData: true
            ] as CFDictionary
        case .password:
            return [
                kSecValueData: value.data(using: .utf8)!,
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: bundleId,
                kSecAttrAccount: "vision.speak.password",
                kSecReturnData: true
            ] as CFDictionary
        }
    }
    
    func readQuery() -> CFDictionary {
        guard let bundleId = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") else { fatalError("BundleId取得失敗") }
        switch(self) {
        case .username:
            return [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: bundleId,
                kSecAttrAccount: "vision.speak.user.name",
                kSecReturnData: true
            ] as CFDictionary
        case .password:
            return [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: bundleId,
                kSecAttrAccount: "vision.speak.password",
                kSecReturnData: true
            ] as CFDictionary
        }
    }
}
