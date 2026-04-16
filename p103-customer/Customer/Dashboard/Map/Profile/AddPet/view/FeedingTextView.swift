//
//  FeedingTextView.swift
//  p103-customer
//
//  Created by Daria Pr on 24.03.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class FeedingTextView: UITextView {
    
    var bottomBorder = UIView()
    
    init(frame: CGRect) {
        super.init(frame: frame, textContainer: nil)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = .red
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        
        self.superview!.addSubview(bottomBorder)
        
        bottomBorder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorder.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        bottomBorder.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 1).isActive = true // Set Border-Strength
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
