//
//  PurchaseViewModel.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/12.
//

import Foundation

class PurchaseViewModel: ObservableObject {
    
    private let purchase = Purchase()
    
    func purchase(_ status: PurchaseStatus, successPurchase: @escaping () -> Void, cancelPurchase: @escaping () -> Void) {
        Task {
            await purchase.purchase(productId: status.rawValue, successfulPurchase: {
                debugPrint("課金成功")
                successPurchase()
            }, cancelPurchase: {
                debugPrint("課金キャンセル")
                cancelPurchase()
            })
        }
    }
    
    func restore(successfulRestore:@escaping() -> Void, errorRestore:@escaping() -> Void) {
        purchase.restore(successfulRestore: {successfulRestore()}, errorRestore: {errorRestore()})
    }
}
