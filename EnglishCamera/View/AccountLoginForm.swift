//
//  AccountLoginView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/29.
//

import Foundation
import SwiftUI

struct AccountLoginForm: View {
    
    @State private var id: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("ログイン情報")) {
                TextField("メールアドレス", text: $id)
                TextField("パスワード", text: $password)
            }
            Button(action: {
                
            }) {
                Text("ログイン").frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
