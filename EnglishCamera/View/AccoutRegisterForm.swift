//
//  AccoutRegisterForm.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/29.
//

import Foundation
import SwiftUI

struct AccountRegisterView : View {
    
    @State private var nameText: String = ""
    @State private var nameKanaText: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("ログイン情報")) {
                TextField("メールアドレス", text: $nameKanaText)
                TextField("パスワード", text: $nameKanaText)
            }
            Section(header: Text("基本情報")) {
                TextField("名前", text: $nameText)
                TextField("名前（カナ）", text: $nameKanaText)
            }
            Section(header: Text("連携コード")) {
                TextField("コード", text: $nameKanaText)
            }
            Button(action: {
                
            }) {
                Text("登録").frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
