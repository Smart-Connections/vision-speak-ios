//
//  EnglishCameraApp.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/07/23.
//

import SwiftUI
import RevenueCat
import Amplify
import AmplifyPlugins

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("Amplify configured with auth plugin")
            Task {
                await Authenticator().signUpUser()
            }
        } catch {
            print("Failed to initialize Amplify with \(error)")
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
