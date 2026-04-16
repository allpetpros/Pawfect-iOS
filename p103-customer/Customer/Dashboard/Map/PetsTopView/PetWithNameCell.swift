//
//  PetWithNameCell.swift
//  p103-customer
//
//  Created by Alex Lebedev on 11.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class PetWithNameCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var petPhotoImageView: UIImageView!
    @IBOutlet weak var petNameLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    private func configure() {
        petPhotoImageView.layer.cornerRadius = 5
        petPhotoImageView.clipsToBounds = true
        petNameLabel.font = R.font.aileronBold(size: 18)
       
        petNameLabel.textColor = .color070F24
    }
}
