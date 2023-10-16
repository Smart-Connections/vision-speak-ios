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
        ZStack{
            VStack{
                PurchaseItems(showProgressView: $showProgressView).environmentObject(purchaseViewModel).environmentObject(purchaseState)
                Spacer()
                PurchaseRestoreButton().environmentObject(purchaseViewModel)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 247/255, green: 247/255, blue: 247/255))
            .navigationTitle("ステータス")
            .navigationBarTitleDisplayMode(.inline)
            if showProgressView {
                AppProgressView()
            }
        }
    }
}
