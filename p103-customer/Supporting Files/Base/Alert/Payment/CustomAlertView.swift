//
//  CustomAlertView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 19.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

enum CustomAlertViewStyle {
    case payment
    case noValidData
    
    var description: String {
         switch self {
            
         case .payment:
            return "Method of payment is\n required"
         case .noValidData:
            return "No valid data"
        }
    }
}
protocol CustomAlertViewDelegate: class {
    func okButtonTouched(alertType: AlertType)
}

class CustomAlertView: UIView {
    
      // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    // MARK: - Property
    weak var delegate: CustomAlertViewDelegate?
    var alertType: AlertType = .error
    // MARK: - Actions
    @IBAction func okButtonAction(_ sender: UIButton) {
        delegate?.okButtonTouched(alertType: self.alertType)
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
       
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = R.font.aileronBold(size: 18)
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .color070F24
        
        containerView.layer.cornerRadius = 8
        okButton.layer.cornerRadius = 15
        okButton.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        okButton.layer.shadowOpacity = 1
        okButton.layer.shadowRadius = 7
        okButton.layer.shadowColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1).cgColor
        okButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        okButton.titleLabel?.font = R.font.aileronBold(size: 18)
        okButton.setTitleColor(UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1), for: .normal)

        self.snp.makeConstraints {
            //$0.height.equalTo(160)
            $0.width.equalTo(330)
        }
    }
    func setupAlert(style: CustomAlertViewStyle) {
         let text = NSAttributedString(string: style.description)
        descriptionLabel.attributedText = text
    }
    func setupAlert(description: String, alertType: AlertType) {
        self.alertType = alertType
        switch alertType {
        case .error:
            
            descriptionLabel.text = description
        case .unAuthroized:
            descriptionLabel.text = description
        }
//        descriptionLabel.text = description
    }
}
