//
//  TransactionCell.swift
//  p103-customer
//
//  Created by Alex Lebedev on 18.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

@objc protocol TransactionCellDelegate: class {
    func transactionHideSetup()
    func transactionShowSetup()
}

class TransactionCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var transactionNameLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var transactionCostLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        let vc = CustomerProfileVC()
        vc.delegateTransactionHide = self
        
        setup()
    }

    // MARK: - Setup
    private func setup() {
        transactionNameLabel.font = R.font.aileronRegular(size: 14)
        transactionDateLabel.font = R.font.aileronLight(size: 12)
        transactionCostLabel.font = R.font.aileronRegular(size: 14)
        
        transactionNameLabel.textColor = .color293147
        transactionCostLabel.textColor = .color070F24
        transactionDateLabel.textColor = .color606572
        
        separatorView.backgroundColor = UIColor(red: 0.909, green: 0.913, blue: 0.921, alpha: 1)
        transactionCostLabel.text = "$-20"
        transactionDateLabel.text = "18.05.2020"
        transactionNameLabel.text = "Order for Fluffy"
    }
}
// MARK: - TransactionCellDelegate
extension TransactionCell: TransactionCellDelegate {
    func transactionHideSetup() {
        transactionNameLabel.isHidden = true
        transactionDateLabel.isHidden = true
        transactionCostLabel.isHidden = true
        separatorView.isHidden = true
    }
    
    func transactionShowSetup() {
        transactionNameLabel.isHidden = false
        transactionDateLabel.isHidden = false
        transactionCostLabel.isHidden = false
        separatorView.isHidden = false
    }
}
