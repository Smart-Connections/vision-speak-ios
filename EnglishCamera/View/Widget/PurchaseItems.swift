//
//  PurchaseItems.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/16.
//

import SwiftUI

struct PurchaseItems: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @EnvironmentObject private var purchaseState: PurchaseState
    
    @Binding var showProgressView: Bool
    
    var body: some View {
        ForEach(0..<PurchaseStatus.allCases.count) { index in
            VStack {
                VStack {
                    HStack {
                        Text("\(PurchaseStatus.allCases[index].name) プラン").font(.title2)
                        Spacer()
                        Text(["", "¥680/月", "¥1800/月"][index])
                    }
                    Spacer().frame(height: 8)
                    HStack {
                        Text("・\(PurchaseStatus.allCases[index].description)")
                        Spacer()
                        if (index != 0 && currentPlan() != PurchaseStatus.allCases[index]) {
                            Button() {
                                showProgressView = true
                                self.purchaseViewModel.purchase(PurchaseStatus.allCases[index], successPurchase: {
                                    showProgressView = false
                                    purchaseState.updateStatus()
                                }, cancelPurchase: {
                                    showProgressView = false
                                    purchaseState.updateStatus()
                                })
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
    }
    
    private func currentPlan() -> PurchaseStatus {
        return purchaseState.status
    }
}
