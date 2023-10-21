//
//  PurchaseView.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/12.
//

import SwiftUI

struct PurchaseView: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @EnvironmentObject private var purchaseState: PurchaseState
    
    @State private var showProgressView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            PurchaseItems(showProgressView: $showProgressView).environmentObject(purchaseViewModel).environmentObject(purchaseState)
            VStack(alignment: .leading) {
                Text("利用規約・プライバシーポリシー").bold().font(.subheadline)
                Spacer().frame(height: 4)
                Text("サブスクリプションへの加入で、利用規約とプライバシーポリシーに同意いただいたとみなします。").font(.caption)
                Spacer().frame(height: 4)
                Text("利用規約").bold().font(.caption).foregroundColor(.blue).onTapGesture {
                    UIApplication.shared.open((URL(string: "https://smart-connections-smart-connections-appsmart-connections-qx8mp1.streamlit.app/%E5%88%A9%E7%94%A8%E8%A6%8F%E7%B4%84")!))
                }
                Text("プライバシーポリシー").bold().font(.caption).foregroundColor(.blue).onTapGesture {
                    UIApplication.shared.open((URL(string: "https://smart-connections-smart-connections-appsmart-connections-qx8mp1.streamlit.app/%E3%83%97%E3%83%A9%E3%82%A4%E3%83%90%E3%82%B7%E3%83%BC%E3%83%9D%E3%83%AA%E3%82%B7%E3%83%BC")!))
                }
            }.padding()
            Spacer()
            PurchaseRestoreButton().environmentObject(purchaseViewModel)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 247/255, green: 247/255, blue: 247/255))
        .navigationTitle("ステータス")
        .navigationBarTitleDisplayMode(.inline)
        .showProgressView(show: $showProgressView)
    }
}
