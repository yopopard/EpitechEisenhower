//
//  values.swift
//  EpitechEisenhower
//
//  Created by Vincent Augrain on 09/03/2018.
//  Copyright © 2018 Epitech. All rights reserved.
//
import UIKit
import Foundation

struct Values {
    struct colors {
        static let imp_urg = UIColor(hex: "#ff3a07").withAlphaComponent(0.8)
        static let urg = UIColor(hex: "#7ed321").withAlphaComponent(0.8)
        static let imp = UIColor(hex: "#0da0b2").withAlphaComponent(0.8)
        static let none = UIColor(hex: "#f8e81c").withAlphaComponent(0.4)
    }
    
    struct radius{
        static let small = CGFloat(5.0)
    }
}


extension UIColor {
    
    convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted).lowercased()
        var int = UInt32()
        Scanner(string: hexString).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hexString.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
}

extension UIImage {
    
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}

