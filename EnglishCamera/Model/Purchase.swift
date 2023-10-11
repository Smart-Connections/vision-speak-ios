//
//  Purchase.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/12.
//

import Foundation
import StoreKit

class Purchase {
    
    private let entitlementId = "tech.smartconnections.daily.speak"
    
    func purchase(productId:String, successfulPurchase:@escaping() -> Void, cancelPurchase:@escaping() -> Void) async {
        print("課金アイテムID: \(productId)")
        do {
            let products = try await Product.products(for: [productId])
            if let item = products.first {
                let transaction = try await self.purchase(product: item)
                await transaction.finish()
            }
        } catch  {
            print("===================purchase error===================")
            print(error)
        }
    }
    
    func restore(successfulRestore:@escaping() -> Void, errorRestore:@escaping() -> Void) {
        Task {
            do {
                try await AppStore.sync()
                successfulRestore()
            } catch {
                errorRestore()
            }
        }
    }
    
    private func purchase(product: Product) async throws -> Transaction  {
        // Product.PurchaseResultの取得
        let purchaseResult: Product.PurchaseResult
        do {
            purchaseResult = try await product.purchase()
        } catch Product.PurchaseError.productUnavailable {
            throw SubscribeError.productUnavailable
        } catch Product.PurchaseError.purchaseNotAllowed {
            throw SubscribeError.purchaseNotAllowed
        } catch {
            throw SubscribeError.otherError
        }

        // VerificationResultの取得
        let verificationResult: VerificationResult<Transaction>
        switch purchaseResult {
        case .success(let result):
            print("課金成功")
            verificationResult = result
        case .userCancelled:
            print("user canceled")
            throw SubscribeError.userCancelled
        case .pending:
            print("pending")
            throw SubscribeError.pending
        @unknown default:
            throw SubscribeError.otherError
        }

        // Transactionの取得
        switch verificationResult {
        case .verified(let transaction):
            print("verified")
            return transaction
        case .unverified:
            print("unverified")
            throw SubscribeError.failedVerification
        }
    }
}

enum SubscribeError: LocalizedError {
    case userCancelled // ユーザーによって購入がキャンセルされた
    case pending // クレジットカードが未設定などの理由で購入が保留された
    case productUnavailable // 指定した商品が無効
    case purchaseNotAllowed // OSの支払い機能が無効化されている
    case failedVerification // トランザクションデータの署名が不正
    case otherError // その他のエラー
}

enum PurchaseStatus: String, CaseIterable {
    case free = ""
    case basic = "com.smartconnections.daily.speak.basic.subscription.2"
    case unlimited = "com.smartconnections.daily.speak.unlimited.subscription.2"
    
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
