//
//  EnglishCameraApp.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/07/23.
//

import SwiftUI
import AWSMobileClient
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureFirebase()
        configureCognito()
        turnOnCoachMark()
        signIn()
        saveVersionCode()
        return true
    }
    
    private func saveVersionCode() {
        // 起動バージョンコードを保存
        UserDefaults.standard.set(Int(Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String), forKey: AppValue.appVersionCode)
    }
    
    private func signIn() {
        // サインイン
        Task {
            await Authenticator().signInOrUpUserIfNeeded() { userId in
                debugPrint("userId: \(String(describing: userId))")
            }
        }
    }
    
    private func turnOnCoachMark() {
        // 初回起動時にすべてのコーチマーク表示フラグをTrueにする
        if UserDefaults.standard.integer(forKey: AppValue.appVersionCode) == 0 {
            CoachMark.turnOnCoachMark()
        }
    }
    
    private func configureCognito() {
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
    }
    
    private func configureFirebase() {
        #if DEBUG
        if let filePath = Bundle.main.path(forResource: "GoogleService-Info-dev", ofType: "plist") {
            guard let options = FirebaseOptions(contentsOfFile: filePath) else {
                assert(false, "Could not load config file.")
            }
            FirebaseApp.configure(options: options)
        }
        #else
        FirebaseApp.configure()
        #endif
    }
}

@main
struct EnglishCameraApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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
