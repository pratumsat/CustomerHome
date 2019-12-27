//
//  UIColorExtension.swift
//  VRT Mobile
//
//  Created by Kemin Suenggittawisuthi on 20/6/2562 BE.
//  Copyright © 2562 Kemin Suenggittawisuthi. All rights reserved.
//


import Foundation
import UIKit
extension UIColor {
    
    class func RGB(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor.RGB(red, green: green, blue: blue, alpha: 1)
    }
    
    class func RGB(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension UIColor {
    static var mediumGreen: UIColor {
        return UIColor.RGB(55, green: 150, blue: 55)
    }
    static var waterBlueTwo: UIColor {
        return UIColor.RGB(12, green: 156, blue: 216)
    }
    static var scarlet: UIColor {
        return UIColor.RGB(208, green: 1, blue: 27)
    }
    static var macaroniAndCheeseTwo: UIColor {
        return UIColor.RGB(241, green: 202, blue: 58)
    }
    
    static var appThemeColor: UIColor {
        return UIColor(named: "Theme-Color") ?? clear
    }
    
    static var redThemeColor: UIColor {
        return UIColor(named: "Red-Theme") ?? clear
    }
    
    static var borderThemeColor: UIColor {
        return UIColor(named: "border-color") ?? clear
    }
    
    static var blueGrayThemeColor: UIColor {
        return UIColor(named: "blue-grey") ?? clear
    }
    static var paleTwoThemeColor: UIColor {
        return UIColor(named: "pale-two") ?? clear
    }
    
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
    
}

