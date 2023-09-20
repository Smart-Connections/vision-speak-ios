//
//  Purchase.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/12.
//

import Foundation
import RevenueCat

class Purchase {
    
    private let entitlementId = "tech.smartconnections.daily.speak"
    
    func login(_ userId: String) {
        Purchases.shared.logIn(userId) { info, result, error in
            print("==========Login==========\n\(String(describing: info))\n\(String(describing: result))\n\(String(describing: error))\n=========================")
        }
    }
    
    func getStatus() -> PurchaseStatus {
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            print("==========CustomrInfo==========\n\(String(describing: customerInfo))\n===============================")
            if let error = error { print(error) }
        }
        return .basic
    }
    
    func purchase(productId:String, successfulPurchase:@escaping() -> Void, cancelPurchase:@escaping() -> Void) {
        print("課金アイテムID: \(productId)")
        Purchases.shared.getProducts([productId]) { (products) in
            debugPrint("課金アイテム: \(products)")
            
            if !products.isEmpty {
                let skProduct = products[0]
                Purchases.shared.purchase(product: skProduct) {
                    (transaction, purchaserInfo, error, userCancelled) in
                    debugPrint("transaction: \(String(describing: transaction))")
                    debugPrint("purchaserInfo: \(String(describing: purchaserInfo))")
                    debugPrint("error: \(String(describing: error))")
                    debugPrint("userCancelled: \(String(describing: userCancelled))")
                    
                    if purchaserInfo?.entitlements["pro"]?.isActive == true {
                        successfulPurchase()
                    } else {
                        cancelPurchase()
                    }
                }
            }
        }
    }
}

enum PurchaseStatus: String, CaseIterable {
    case free = ""
    case basic = "com.smartconnections.daily.speak.basic.subscription"
    case unlimited = "com.smartconnections.daily.speak.unlimited.subscription"
    
    var name: String {
        switch (self) {
        case .free:
            return "Free"
        case .basic:
            return "Basic"
        case .unlimited:
            return "Unlimited"
        }
    }
    
    var description: String {
        switch (self) {
        case .free:
            return "毎日3分間の英会話が可能"
        case .basic:
            return "毎日10分間の英会話が可能"
        case .unlimited:
            return "無制限に英会話が可能"
        }
    }
    
    var limitSeconds: Double {
        switch (self) {
        case .free:
            return 60 * 3
        case .basic:
            return 60 * 10
        case .unlimited:
            return 0
        }
    }
}
