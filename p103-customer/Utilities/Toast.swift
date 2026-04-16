//
//  Toast.swift
//  p103-customer
//
//  Created by SOTSYS371 on 22/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import Foundation
import UIKit

class Toast {
    static func show(message: String, controller: UIViewController) {
            let toastContainer = UIView(frame: CGRect())
            toastContainer.backgroundColor = .black
            toastContainer.alpha = 0.0
            toastContainer.layer.cornerRadius = 12;
            toastContainer.clipsToBounds  =  true

            let toastLabel = UILabel(frame: CGRect())
            toastLabel.font = UIFont.systemFont(ofSize: 14)
            toastLabel.textColor = .white
            toastLabel.textAlignment = .center
            toastLabel.text = message
            toastLabel.clipsToBounds  =  true
            toastLabel.numberOfLines = 0
            toastContainer.addSubview(toastLabel)
            controller.view.endEditing(true)
            controller.view.addSubview(toastContainer)

            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            toastContainer.translatesAutoresizingMaskIntoConstraints = false
            
            let leadingConstraint =  NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 12)
            let trailingConstraint = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -12)
            let topConstraint = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 12)
            let bottomConstraint = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: toastLabel , attribute: .bottom, multiplier: 1, constant: 12)
            toastContainer.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
            

            let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 20)
            let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -20)
            let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottomMargin, multiplier: 1, constant: -20)
            controller.view.addConstraints([c1, c2, c3])

            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                toastContainer.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                    toastContainer.alpha = 0.0
                }, completion: {_ in
                    toastContainer.removeFromSuperview()
                })
            })
        }
}

