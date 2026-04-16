//
//  UIColor + Ext.swift
//  u92
//
//  Created by Developer on 4/11/19.
//  Copyright © 2019 Anastasia Zhdanova. All rights reserved.
//
// swiftlint:disable all


import UIKit

extension UIColor {
    
    
    static var color070F24: UIColor {
        return UIColor(red: 0.028, green: 0.06, blue: 0.142, alpha: 1)
    }
    static var colorAAABAE: UIColor {
           return UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
       }
    static var color293147: UIColor {
          return UIColor(red: 0.161, green: 0.194, blue: 0.279, alpha: 1)
      }
    
    static var color606572: UIColor {
             return UIColor(red: 0.375, green: 0.395, blue: 0.446, alpha: 1)
         }
    static var colorC6222F: UIColor {
        return UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 1)
    }
    static var color860000: UIColor {
           return  UIColor(red: 0.525, green: 0, blue: 0, alpha: 1)
       }
    static var colorE8E9EB: UIColor {
           return  UIColor(red: 0.909, green: 0.913, blue: 0.921, alpha: 1)
       }
   
    static var colorE24000: UIColor {
           return  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
       }
//    /// UITextField placeholder Color
//    static var placeholder: UIColor {
//        return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
//    }
        
    /// Create Color from RGB values with optional transparency.
    ///
    /// - Parameters:
    ///   - red: red component.
    ///   - green: green component.
    ///   - blue: blue component.
    ///   - transparency: optional transparency value (alpha) (default is 1).
    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        let colorRange = 0...255
        guard colorRange ~= red, colorRange ~= green, colorRange ~= blue else { return nil }
        var alpha = transparency
        if alpha < 0 { alpha = 0 }
        if alpha > 1 { alpha = 1 }
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    /// Create Color from hexadecimal value with optional transparency.
    ///
    /// - Parameters:
    ///   - hex: hex Int (example: 0xDECEB5).
    ///   - transparency: optional transparency value (alpha) (default is 1).
    convenience init?(hex: Int, transparency: CGFloat = 1) {
        var alpha = transparency
        if alpha < 0 { alpha = 0 }
        if alpha > 1 { alpha = 1 }
        
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: red, green: green, blue: blue, transparency: alpha)
    }
    convenience init(hexString: String) {
        let hexString: NSString = hexString.trimmingCharacters(in:
            NSCharacterSet.whitespacesAndNewlines) as NSString
        let scanner            = Scanner(string: hexString as String)
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let rMask = Int(color >> 16) & mask
        let gMask = Int(color >> 8) & mask
        let bMask = Int(color) & mask
        let red   = CGFloat(rMask) / 255.0
        let green = CGFloat(gMask) / 255.0
        let blue  = CGFloat(bMask) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
    func toHexString() -> String {
        var rHex: CGFloat = 0
        var gHex: CGFloat = 0
        var bHex: CGFloat = 0
        var aHex: CGFloat = 0
        getRed(&rHex, green: &gHex, blue: &bHex, alpha: &aHex)
        let rgb: Int = (Int)(rHex*255)<<16 | (Int)(gHex*255)<<8 | (Int)(bHex*255)<<0
        return NSString(format: "#%06x", rgb) as String
    }
}
