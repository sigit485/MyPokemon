//
//  Colors.swift
//  MyPokemon
//
//  Created by Sigit on 17/01/23.
//

import UIKit

class Colors {
    public static let shared = Colors()
    
    public func hexStringColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    var lightGrayPrimary: UIColor {
        return hexStringColor(hex: "fafafa")
    }
    
    var skyBlue: UIColor {
        return hexStringColor(hex: "58ABF6")
    }
    
    var starYellow: UIColor {
        return hexStringColor(hex: "FFC007")
    }
    
}
