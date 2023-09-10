//
//  EnglishCameraApp.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/07/23.
//

import SwiftUI
import RevenueCat
import AWSMobileClient

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  
        // AWS サービス設定を作成.
        let serviceConfiguration: AWSServiceConfiguration = AWSServiceConfiguration(
            region: CognitoConstants.IdentityUserPoolRegion,
            credentialsProvider: nil
        )
        // ユーザプール設定を作成.
        let userPoolConfigration: AWSCognitoIdentityUserPoolConfiguration =
            AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoConstants.AppClientId,
                                                    clientSecret: CognitoConstants.AppClientSecret,
                                                    poolId: CognitoConstants.IdentityUserPoolId)
        // ユーザープールクライアントを初期化.
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration,
                                            userPoolConfiguration: userPoolConfigration,
                                            forKey: CognitoConstants.SignInProviderKey)
        
        Task {
            await Authenticator().signUpUser()
        }
        return true
    }
}

@main
struct EnglishCameraApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_pZvVSuGNhBFIUTMOWjQkgBfGisv")
    }
    
    var body: some Scene {
        return WindowGroup {
            ContentView()
        }
    }
}

struct CognitoConstants {
    // UserPool の各情報をもとにそれぞれの値を設定する.
    /// ユーザープールを設定しているリージョン.
    static let IdentityUserPoolRegion: AWSRegionType = .APNortheast1
    /// ユーザープールID.
    static let IdentityUserPoolId: String = "ap-northeast-1_YF8YazqW5"
    /// アプリクライアントID.
    static let AppClientId: String = "2orqdffkag8lrvuhv9bskmbv0h"
    /// アプリクライアントのシークレットキー.
    static let AppClientSecret: String? = nil
    /// プロバイダキー. "UserPool" で良さそう.
    static let SignInProviderKey: String = "UserPool"
    
    /// インスタンス生成禁止.
    private init() {}
}
