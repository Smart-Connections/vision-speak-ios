//
//  MenuStatusButton.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/20.
//

import SwiftUI

struct MenuStatusButton: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @EnvironmentObject private var purchaseState: PurchaseState
    
    @Binding var showPurchaseView: Bool
    
    var body: some View {
        NavigationLink(destination: PurchaseView().environmentObject(purchaseViewModel).environmentObject(purchaseState), isActive: $showPurchaseView) {
            ZStack {
                HStack {
                    Text("ステータス").font(.caption).foregroundColor(.black)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(purchaseState.status.name)
                        .font(.title)
                        .foregroundColor(.black)
                    Spacer()
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}
