//
//  extensions.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/08/05.
//

import Foundation

extension Date {
    func toString(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var ymd: String {
        return toString("yyyy/MM/dd")
    }
}

extension Float {
    var convertPercent: Int {
        let percentage = Int(self * 100)
        return percentage
    }
}

extension TimeInterval {
    var ms: String {
        let dateFormatter = DateComponentsFormatter()
        dateFormatter.unitsStyle = .positional
        dateFormatter.zeroFormattingBehavior = .pad
        dateFormatter.allowedUnits = [.minute, .second]
        return dateFormatter.string(from: self) ?? "00:00"
    }
}
