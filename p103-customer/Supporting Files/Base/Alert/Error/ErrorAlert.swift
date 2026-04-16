//
//  ErrorAlert.swift
//  p103-customer
//
//  Created by Alex Lebedev on 30.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class ErrorAlert: UIView {
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonAction(_ sender: UIButton) {
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CustomAlertView", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.bounds
        self.isUserInteractionEnabled = true
//        let text = NSAttributedString(string: "Method of payment is\n required")
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = R.font.aileronBold(size: 18)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .color070F24
        
        containerView.layer.cornerRadius = 8
        button.layer.cornerRadius = 15
        button.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 7
        button.layer.shadowColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
        button.setTitleColor(UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1), for: .normal)
    }
    
    
}
