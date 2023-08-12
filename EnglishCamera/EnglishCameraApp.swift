//
//  EnglishCameraApp.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/07/23.
//

import SwiftUI
import RevenueCat

@main
struct EnglishCameraApp: App {
    
    init(){
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: "appl_pZvVSuGNhBFIUTMOWjQkgBfGisv")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
