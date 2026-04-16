//
//  UIImageView + Ext.swift
//  p103-customer
//
//  Created by Yaroslav on 10/1/19.
//  Copyright © 2019 PULS Software. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func setupCloseButton (with homeVC: UIViewController, currentVC: UIViewController) {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backToRootVC(homeVC:currentVC:))))
    }
    
    @objc func backToRootVC (homeVC: UIViewController, currentVC: UIViewController) {
        homeVC.modalTransitionStyle = .crossDissolve
        homeVC.modalPresentationStyle = .fullScreen
        currentVC.present(homeVC, animated: true)
    }
    
    func setupCheckMark (state: Bool) {
        self.isUserInteractionEnabled = true
        if state {
            self.image = R.image.checbox_selected()!
            
        } else {
            self.image = R.image.checkbox_unselected()!
            if #available(iOS 13, *) {
                self.tintColor = .label
            }
            else {
                self.tintColor = .black
            }
        }
    }
}
