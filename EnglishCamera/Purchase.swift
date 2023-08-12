//
//  Purchase.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/12.
//

import Foundation
import RevenueCat

class Purchase {
    
    func purchase(_ item: PurchaseItems) {}
    
}

enum PurchaseItems: String {
    case basic = "com.smartconnections.daily.speak.basic"
}
