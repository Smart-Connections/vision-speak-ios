//
//  AppProgressView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/16.
//

import SwiftUI

struct AppProgressView: View {
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
            ProgressView()
                .scaleEffect(x: 2, y: 2, anchor: .center)
                .padding(.all, 24)
                .background(Color.gray.opacity(0.6))
                .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                .cornerRadius(16)
        }
    }
}
