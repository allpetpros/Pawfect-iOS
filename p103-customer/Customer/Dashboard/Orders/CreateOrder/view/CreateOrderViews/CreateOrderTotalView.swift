//
//  CreateOrderTotalView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 27.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class CreateOrderTotalView: UIView {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CreateOrderTotalView", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.bounds
        self.isUserInteractionEnabled = true
        configure()
    }
    
    private func configure() {
        totalLabel.font = R.font.aileronBold(size: 30)
        totalLabel.textColor = .color293147
        totalLabel.text = "Total"
        
        descriptionLabel.font = R.font.aileronRegular(size: 14)
        descriptionLabel.textColor = .color606572
        descriptionLabel.text = "*for one sitting"
        
        priceLabel.font = R.font.aileronBold(size: 30)
        priceLabel.textColor = UIColor(red: 0.129, green: 0.588, blue: 0.325, alpha: 1)
    }
    
    func setAmount(newAmount: Int) {
        priceLabel.text = "$\(newAmount)"
    }
}
