//
//  PetCell.swift
//  p103-customer
//
//  Created by Alex Lebedev on 15.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class PetCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var petTypeLabel: UILabel!
    @IBOutlet weak var peGender: UIImageView!
    
     @IBOutlet weak var editingView: UIView!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        configure()
    }

    // MARK: - Setup
    private func configure() {
        editingView.backgroundColor = .clear
        containerView.layer.cornerRadius = 20
            
        backgroundColor = .clear
        containerView.backgroundColor = .white

        profileImageView.snp.remakeConstraints {
            $0.height.equalTo(500)
        }
        peGender.tintColor = UIColor(red: 0.525, green: 0, blue: 0, alpha: 1)
        profileImageView.layer.cornerRadius = 13
        petNameLabel.font = R.font.aileronBold(size: 30)
       
        petNameLabel.textColor = .color070F24
        
        petTypeLabel.font = R.font.aileronRegular(size: 14)
        petTypeLabel.textColor = .color606572
    }
    
    func setup(name: String, breed: String, gender: String) {
        petNameLabel.text = name
        if breed == "-" {
            petTypeLabel.text = ""
        } else {
            petTypeLabel.text = breed
        }
        
        switch gender {
        case "male":
            peGender.isHidden = false
            peGender.image = R.image.boy()
        case "female":
            peGender.isHidden = false
            peGender.image =  R.image.girl()
        default:
            peGender.isHidden = true
        }
    }
    // MARK: - Functions
    func editingStyle(_ active: Bool) {
        if active {
            editingView.backgroundColor = R.color.deleteTableCellColor()
            editingView.snp.remakeConstraints {
                $0.height.equalTo(50)
            }
        } else {
            editingView.backgroundColor = .clear
        }
    }
}
