//
//  UIImageExtension.swift
//  EnglishCamera
//
//  Created by maruko_shion_default on 2023/10/22.
//

import Foundation
import SwiftUI

extension UIImage {
    
    func resizeImage(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
