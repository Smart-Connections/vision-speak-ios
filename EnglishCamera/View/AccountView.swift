//
//  AccountView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/29.
//

import Foundation
import SwiftUI

struct AccountView: View {
    @Binding var showAccountView: Bool
    
    @State private var nameText: String = ""
    @State private var nameKanaText: String = ""
    @State private var isLogin: Bool = false
    
    var body: some View {
        VStack {
            if isLogin {
                AccountLoginForm()
            }  else {
                AccountRegisterView()
            }
            Spacer()
            Button(action: {
                isLogin.toggle()
            }) {
                Text(isLogin ? "登録する" : "ログインする").frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationBarTitle(Text("アカウント"), displayMode: .inline)
    }
}
