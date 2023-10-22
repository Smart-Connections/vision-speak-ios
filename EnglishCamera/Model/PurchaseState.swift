//
//  PurchaseState.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/09/21.
//

import Foundation
import StoreKit

class PurchaseState: ObservableObject {
    @Published var status: PurchaseStatus = .free
    
    init() {
        updateStatus()
    }
    
    func updateStatus() {
        Task {
            await self.getStatus()
        }
    }
    
    func getStatus() async {
        let productId = await self.updateSubscriptionStatus()
        DispatchQueue.main.async {
            self.status = PurchaseStatus.init(rawValue: productId) ?? .free
        }
    }
    
    func updateSubscriptionStatus() async -> String {
        var validSubscription: Transaction?
        for await verificationResult in Transaction.currentEntitlements {
            if case .verified(let transaction) = verificationResult,
               transaction.productType == .autoRenewable && !transaction.isUpgraded {
                validSubscription = transaction
            }
        }

        let productId = validSubscription?.productID ?? ""
        
        if !productId.isEmpty {
            // 特典を付与
            debugPrint("enablePrivilege productId: \(productId)")
        } else {
            // 特典を削除
            debugPrint("disablePrivilege()")
        }
        return productId
    }
}
