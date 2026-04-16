//
//  UIButton+Extension.swift
//  p103-customer
//
//  Created by Foram Mehta on 01/04/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import Foundation
import UIKit

class MyButton: UIButton {

    var myView: UIView? = UIView()
    var toolBarView: UIView? = UIView()
    
    override var inputView: UIView? {
        get {
            myView
        }
        set {
            myView = newValue
            becomeFirstResponder()
        }
    }

    override var inputAccessoryView: UIView? {
        get {
            toolBarView
        }
        set {
            toolBarView = newValue
        }
    }
    
    override var canBecomeFirstResponder: Bool {
       true
    }

}
