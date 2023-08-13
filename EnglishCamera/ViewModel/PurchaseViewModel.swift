//
//  PurchaseViewModel.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/12.
//

import Foundation

class PurchaseViewModel: ObservableObject {
    private let purchase = Purchase()
    
    func purchase(_ status: PurchaseStatus) {
        purchase.purchase(productId: status.rawValue, successfulPurchase: {}, cancelPurchase: {})
    }
    
    func getCurrentStatus() -> PurchaseStatus {
        return purchase.getStatus()
    }
}
