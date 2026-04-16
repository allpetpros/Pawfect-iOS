//
//  DescriptionCell.swift
//  p103-customer
//
//  Created by Alex Lebedev on 18.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

@objc protocol DescriptionCellDelegate: AnyObject {
    func noCardsSetup()
    func addCardsSetup()
}

class DescriptionCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!

    // MARK: - Cell Method
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        let vc = CustomerProfileVC()
        vc.delegateDescriptionHide = self
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
    
    // MARK: - Setup
extension DescriptionCell{
    private func setup() {
        mainLabel.font = R.font.aileronSemiBold(size: 16)
        descriptionLabel.font = R.font.aileronLight(size: 12)
        descriptionLabel.textColor = .color606572
        descriptionLabel.text = "Payment required***in order to request service\n\n*Payment is charged 1-7 days prior to service\nrequest once approved."
        let text = NSMutableAttributedString(string: "Our Privacy Policy", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
       
        privacyPolicyLabel.attributedText = text
        privacyPolicyLabel.font = R.font.aileronLightItalic(size: 12)
        privacyPolicyLabel.textColor = UIColor(red: 0.525, green: 0, blue: 0, alpha: 1)
    }
}
// MARK: - Action

extension DescriptionCell {
    @IBAction func addAmountBtnAction(_ sender: UIButton) {
        
    }

}



//MARK: - DescriptionCellDelegate

extension DescriptionCell: DescriptionCellDelegate {
    func addCardsSetup() {
        mainLabel.isHidden = false
        descriptionLabel.isHidden = false
        privacyPolicyLabel.isHidden = false
    }
    
    func noCardsSetup() {
        mainLabel.isHidden = true
        descriptionLabel.isHidden = true
        privacyPolicyLabel.isHidden = true
    }
}
