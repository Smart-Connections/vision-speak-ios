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
    
    var body: some View {
        VStack{
            ForEach(0..<PurchaseStatus.allCases.count) { index in
                VStack {
                    VStack {
                        HStack {
                            Text("\(PurchaseStatus.allCases[index].name) プラン").font(.title2)
                            Spacer()
                            Text(["", "¥600/月", "¥1800/月"][index])
                        }
                        Spacer().frame(height: 8)
                        HStack {
                            Text("・\(PurchaseStatus.allCases[index].description)")
                            Spacer()
                            if (index != 0 && currentPlan() != PurchaseStatus.allCases[index]) {
                                Button() {
                                    self.purchaseViewModel.purchase(PurchaseStatus.allCases[index], successPurchase: {
                                        purchaseState.updateStatus()
                                    }, cancelPurchase: {})
                                } label: {
                                    Text("購入")
                                        .frame(width: 88, height: 32)
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(32)
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(currentPlan() == PurchaseStatus.allCases[index] ? Color.orange : Color.white)
                    .cornerRadius(8)
                    Spacer().frame(height: 32)
                }
            }
            Spacer()
            PurchaseRestoreButton().environmentObject(purchaseViewModel)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 247/255, green: 247/255, blue: 247/255))
        .navigationTitle("ステータス")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func currentPlan() -> PurchaseStatus {
        return purchaseState.status
    }
}
