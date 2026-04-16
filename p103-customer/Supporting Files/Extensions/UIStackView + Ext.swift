//
//  UIStackView + Ext.swift
//  p103-customer
//
//  Created by Alex Lebedev on 06.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func addArrangedSubviews(views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}
