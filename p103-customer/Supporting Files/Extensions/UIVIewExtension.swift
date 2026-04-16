//
//  UIVIewExtension.swift
//  u74
//
//  Created by Ilya_ios on 2/5/19.
//  Copyright © 2019 Daniel Slupskiy. All rights reserved.
//
// swiftlint:disable all


import Foundation
import UIKit

//@IBDesignable
extension UIView {
    // Rounded corner raius
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    // Border width
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            return self.layer.borderWidth = newValue
        }
    }
    //Border Color
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    // Shadow color
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    // Shadow offsets
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    // Shadow opacity
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    // Shadow radius
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }
    
    /// Unarchives the contents of a nib file located in the receiver's bundle.
    class func loadNib<T: UIView>(owner: Any? = nil) -> T {
        guard let nib = Bundle.main.loadNibNamed(String(describing: T.self),
                                                 owner: owner,
                                                 options: nil)?.first as? T else {return T()}
        return nib
    }
    func addShadow(ofColor color: UIColor = UIColor(red: 0.07,
                                                    green: 0.47,
                                                    blue: 0.57,
                                                    alpha: 1.0),
                   radius: CGFloat = 3,
                   offset: CGSize = .zero,
                   opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    // Gradient color
    func applyGradient(colours: [UIColor]) {
        self.applyGradient(colours: colours, locations: nil)
    }
    func applyGradient(colours: [UIColor], locations: [Double]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        //gradient.locations = locations
        gradient.startPoint = CGPoint(x: locations![0], y: locations![1])
        gradient.endPoint = CGPoint(x: locations![2], y: locations![3])
        self.layer.insertSublayer(gradient, at: 0)
    }
    func addBlurOverlay() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.alpha = 0.5
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
    }
    func removeBlurOverlay() {
        let blurredEffectViews = subviews.filter { $0 is UIVisualEffectView }
        blurredEffectViews.forEach { $0.removeFromSuperview() }
    }
    func circleCornerRadius(width: CGFloat, height: CGFloat) {
        let radius = min(width, height)
        layer.cornerRadius = radius / 2
    }
    /// Set "isHidden" property animated
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 0.25 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    func setAnimatedHidden(_ hidden: Bool,
                           withDuration duration: TimeInterval = 0.25,
                           completion: ((Bool) -> Void)? = nil) {
        if !hidden { isHidden = hidden }
        UIView.animate(withDuration: duration, animations: { self.alpha = hidden ? 0 : 1 }, completion: completion)
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
    
    func addShadowToSide(top: Bool,
                   left: Bool,
                   bottom: Bool,
                   right: Bool,
                   shadowRadius: CGFloat , color: UIColor, offSet: CGSize, opacity: Float) {

//        self.layer.masksToBounds = false
//        self.layer.shadowOffset = offSet
//        self.layer.shadowRadius = shadowRadius
//        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0

        
        self.layer.shadowColor = UIColor.black.cgColor

        let path = UIBezierPath()
        var x: CGFloat = 0
        var y: CGFloat = 0
        var viewWidth = self.frame.width
        var viewHeight = self.frame.height

        // here x, y, viewWidth, and viewHeight can be changed in
        // order to play around with the shadow paths.
        if (!top) {
            y+=(shadowRadius+1)
        }
        if (!bottom) {
            viewHeight-=(shadowRadius+1)
        }
        if (!left) {
            x+=(shadowRadius+1)
        }
        if (!right) {
            viewWidth-=(shadowRadius+1)
        }
        // selecting top most point
        path.move(to: CGPoint(x: x, y: y))
        // Move to the Bottom Left Corner, this will cover left edges
        /*
         |☐
         */
        path.addLine(to: CGPoint(x: x, y: viewHeight))
        // Move to the Bottom Right Corner, this will cover bottom edge
        /*
         ☐
         -
         */
        path.addLine(to: CGPoint(x: viewWidth, y: viewHeight))
        // Move to the Top Right Corner, this will cover right edge
        /*
         ☐|
         */
        path.addLine(to: CGPoint(x: viewWidth, y: y))
        // Move back to the initial point, this will cover the top edge
        /*
         _
         ☐
         */
        path.close()
        self.layer.shadowPath = path.cgPath
    }
}




