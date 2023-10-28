//
//  PurchaseRestoreButton.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/09.
//

import SwiftUI

struct PurchaseRestoreButton: View {
    @EnvironmentObject private var purchaseViewModel: PurchaseViewModel
    @EnvironmentObject private var purchaseState: PurchaseState
    
    @State private var showSuccessRestore = false
    @State private var showErrorRestore = false
    
    var body: some View {
        Button(action: {
            purchaseViewModel.restore(successfulRestore: {
                purchaseState.updateStatus()
                showSuccessRestore = true
            }, errorRestore: {
                showErrorRestore = true
            })
        }) {
            Text("購入内容の復元")
                .frame(maxWidth: .infinity)
                .foregroundColor(.blue)
                .padding()
                .background(Color("surface"))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.blue), lineWidth: 0.5)
                )
        }.alert("復元に成功しました。", isPresented: $showSuccessRestore) {
            Button("OK") {
                showSuccessRestore = false
            }
        }.alert("復元に失敗しました。", isPresented: $showErrorRestore) {
            Button("OK") {
                showErrorRestore = false
            }
        }
        .frame(maxWidth: .infinity)
    }
}
