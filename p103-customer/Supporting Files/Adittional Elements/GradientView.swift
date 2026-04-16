//
//  GradientView.swift
//  Smack
//
//  Created by Alex Lebedev on 09.12.2019.
//  Copyright © 2019 Alex Lebedev. All rights reserved.
//

import UIKit
@IBDesignable

class GradientView: UIView {
    
    let gradientLayer = CAGradientLayer()
    
    @IBInspectable var topColor: UIColor = UIColor.blue{
        didSet{
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.red{
        didSet{
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.clipsToBounds = true
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    var isChoosen: Bool = true {
        didSet{
            if self.isChoosen {
                self.layer.insertSublayer(self.gradientLayer, at: 0)
            } else {
                self.gradientLayer.removeFromSuperlayer()
            }
        }
    }
    
}
