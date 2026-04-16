//
//  UITableView+Extension.swift
//  p103-customer
//
//  Created by SOTSYS371 on 15/07/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import Foundation
import UIKit
class IntrinsicTableView: UITableView {
    
    override var contentSize:CGSize {
        didSet {
            self.layoutIfNeeded()
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        
        self.layoutIfNeeded()
        var size = super.contentSize
        
        if size.height == 0 || size.width == 0 {
            size = self.contentSize
        }
        return size
        //        return CGSize(width: UIViewNoIntrinsicMetric, height: contentSize.height)
    }
}
