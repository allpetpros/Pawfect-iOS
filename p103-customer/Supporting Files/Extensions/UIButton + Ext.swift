//
//  UiBatton + Ext.swift
//  p103-customer
//
//  Created by Alex Lebedev on 07.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func redAndGrayStyle(active: Bool) {
        if active {
            self.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
            self.layer.shadowOpacity = 0.5
            self.layer.shadowRadius = 7
            self.layer.shadowColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1).cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 5)
        } else {
            self.backgroundColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
            self.shadowColor = .clear
            self.shadowOpacity = 0
            self.shadowRadius = 0
        }
    }
    
    func underline() {
        guard let title = self.titleLabel, let tittleText = title.text
        else {
            return
        }
        let attributedString = NSMutableAttributedString(string: (tittleText))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: (tittleText.count)))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
