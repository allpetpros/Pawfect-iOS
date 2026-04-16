//
//  CreateOrderSectionHeaderView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 27.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
enum CreateHeaderTypes{
    case pets
    case services
}
class CreateOrderSectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    private func configure() {
        mainView.backgroundColor = .clear
        headerLabel.font = R.font.aileronSemiBold(size: 16)
        headerLabel.textColor = .color293147
    }
    func createSetup(type: CreateHeaderTypes) {
        switch type {
            
        case .pets:
            headerLabel.text = "Select Your Pets"
        case .services:
            headerLabel.text = "Select Services"
        }
    }
    func detailsSetup(type: CreateHeaderTypes) {
        switch type {
            
        case .pets:
            headerLabel.text = "Pets"
        case .services:
            headerLabel.text = "Services"
        }
    }
    func setupHeader(text: String) {
        headerLabel.text = text
    }
}
