//
//  AddressView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 22.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class AddressView: UIView {
    // MARK: - IBOutlet
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var addressImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
  
    
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
        Bundle.main.loadNibNamed(AddressView.className, owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.bounds
        self.isUserInteractionEnabled = true
        configure()
    }
    private func configure() {
        addressImageView.tintColor = .colorE24000
        addressLabel.font = R.font.aileronRegular(size: 14)
        addressLabel.textColor = .color070F24
    }
    func setAddress(address: String) {
        addressLabel.text = address
    }
}
