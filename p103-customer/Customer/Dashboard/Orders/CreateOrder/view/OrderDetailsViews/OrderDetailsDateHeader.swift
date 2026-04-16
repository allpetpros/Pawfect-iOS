//
//  OrderDetailsDateHeader.swift
//  p103-customer
//
//  Created by Alex Lebedev on 02.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class OrderDetailsDateHeader: UIView {
    
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
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
        Bundle.main.loadNibNamed("OrderDetailsDateHeader", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.bounds
        self.isUserInteractionEnabled = true
        configure()
    }
    
    private func configure() {
        containerView.backgroundColor = .clear
        self.backgroundColor = .clear
        dateLabel.font = R.font.aileronSemiBold(size: 16)
        dateLabel.textColor = .color606572
    }
    func setup(date: String) {
        dateLabel.text = date
    }
}
