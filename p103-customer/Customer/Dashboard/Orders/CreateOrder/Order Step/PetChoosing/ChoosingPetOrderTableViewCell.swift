//
//  ChoosingPetOrderTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 29.06.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class ChoosingPetOrderTableViewCell: UITableViewCell {
    
    //MARK: - UIProperties
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    } ()
    
    private let petNameLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color070F24
        l.font = R.font.aileronBold(size: 30)
        return l
    } ()
    
    private let petTypeLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let checkboxButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.checkboxBlack(), for: .normal)
        b.isUserInteractionEnabled = true
        return b
    }()
    
    //MARK: - Properties
    
    private let selectedChekboxImage = R.image.checbox_selected()
    private let unselectedChekboxImage  = R.image.checkbox_unselected()
    
    var picked = false

    //MARK: - Init
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
        setupLayout()

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        
        selectionStyle = .none
    }
        
    override func layoutSubviews() {
         super.layoutSubviews()
        
         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}

//MARK: - Setup Layout

private extension ChoosingPetOrderTableViewCell {
    func setupLayout() {
        addSubviews([profileImageView, petNameLabel, petTypeLabel, checkboxButton])
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        petNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(profileImageView.snp.right).offset(20)
        }

        petTypeLabel.snp.makeConstraints {
            $0.top.equalTo(petNameLabel.snp.bottom).offset(10)
            $0.left.equalTo(profileImageView.snp.right).offset(20)
        }
        
        checkboxButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-25)
        }
    }
}

//MARK: - Public methods

extension ChoosingPetOrderTableViewCell {
    func setupPets(name: String, breed: String, imageUrl: String, checked: Bool) {
        if breed != "-" {
            petTypeLabel.text = breed
        }
        if imageUrl != "-" {
            profileImageView.sd_setImage(with: URL(string: imageUrl))
        }
        petNameLabel.text = name
        
        if checked {
            cellUnpicked()
        } else {
            cellPicked()
        }
    }
    
    func cellPicked() {
        picked = false
        checkboxButton.setImage(unselectedChekboxImage, for: .normal)
    }
    
    func cellUnpicked() {
        picked = true
        checkboxButton.setImage(selectedChekboxImage, for: .normal)
    }
}
