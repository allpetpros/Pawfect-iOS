//
//  UITableViewCell + Ext.swift
//  p103-customer
//
//  Created by Alex Lebedev on 22.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import UIKit
extension UITableViewCell {
    func addGrayShadow(offset: CGSize, radius: CGFloat) {
        self.shadowColor = UIColor(red: 0.376, green: 0.396, blue: 0.447, alpha: 0.3)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        self.shadowRadius = radius
        self.shadowOffset = offset
        self.shadowOpacity = 1
        self.clipsToBounds = false
//        self.layer.masksToBounds = false
    }
    
    func addShadow(backgroundColor: UIColor = .white, cornerRadius: CGFloat = 55, shadowRadius: CGFloat = 5, shadowOpacity: Float = 1, shadowPathInset: (dx: CGFloat, dy: CGFloat), shadowPathOffset: (dx: CGFloat, dy: CGFloat)) {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            layer.shadowRadius = shadowRadius
            layer.shadowOpacity = shadowOpacity
            layer.shadowPath = UIBezierPath(roundedRect: bounds.insetBy(dx: shadowPathInset.dx, dy: shadowPathInset.dy).offsetBy(dx: shadowPathOffset.dx, dy: shadowPathOffset.dy), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
            
            let whiteBackgroundView = UIView()
            whiteBackgroundView.backgroundColor = backgroundColor
            whiteBackgroundView.layer.cornerRadius = cornerRadius
            whiteBackgroundView.layer.masksToBounds = true
            whiteBackgroundView.clipsToBounds = false
            
            whiteBackgroundView.frame = bounds.insetBy(dx: shadowPathInset.dx, dy: shadowPathInset.dy)
            insertSubview(whiteBackgroundView, at: 0)
        }
    
}


extension UIView {
    func addGrayShadowView(offset: CGSize, radius: CGFloat) {
        self.shadowColor = UIColor(red: 0.376, green: 0.396, blue: 0.447, alpha: 0.3)
        layer.cornerRadius = 20
        layer.masksToBounds = true
        self.shadowRadius = radius
        self.shadowOffset = offset
        self.shadowOpacity = 1
        self.clipsToBounds = false
//        self.layer.masksToBounds = false
    }
}
