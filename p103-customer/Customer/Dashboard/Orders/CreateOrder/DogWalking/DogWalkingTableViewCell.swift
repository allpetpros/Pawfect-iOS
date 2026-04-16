//
//  DogWalkingTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 08.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class DogWalkingTableViewCell: UITableViewCell {

    //MARK: - UIProperties
    
    private let serviceImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    } ()

    let serviceNameLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 18)
        return l
    }()
    
    let serviceSizeLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 18)
        l.textColor = .colorAAABAE
        return l
    } ()

    private let checkboxButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.checkboxBlack(), for: .normal)
        b.isUserInteractionEnabled = true
        return b
    }()

    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = R.color.greenColor()
        return l
    } ()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color606572
        return l
    } ()
    
    // MARK: - Lifecycle
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        
        selectionStyle = .none
        
        setupLayout()
    }
    
    //MARK: - Setup Layout
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func setupLayout() {
        addSubviews([serviceImageView, serviceNameLabel, serviceSizeLabel, checkboxButton, priceLabel, descriptionLabel])
        
        serviceImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(23)
        }
        
        serviceNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(serviceImageView.snp.right).offset(14)
        }
        
        checkboxButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
            $0.right.equalToSuperview().offset(-31)
        }
        
        serviceSizeLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalTo(serviceNameLabel.snp.right).offset(4)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(serviceNameLabel.snp.bottom).offset(8)
            $0.left.equalTo(serviceNameLabel)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(8)
            $0.left.equalTo(serviceNameLabel)
        }
    }
    
    func setup(section: IndexPath) {
        descriptionLabel.text = "Short Description"
        serviceImageView.image = R.image.dogWalkingImage()
        if section.row == 0 {
            serviceNameLabel.text = "20 Minute Dog Walk"
            priceLabel.text = "$20"
        } else if section.row == 1 {
            serviceNameLabel.text = "30 Minute Dog Walk"
            priceLabel.text = "$30"
        } else if section.row == 2 {
            serviceNameLabel.text = "60 Minute Dog Walk"
            priceLabel.text = "$40"
        }
    }
    
}

//MARK: - CheckBoxes Setup

extension DogWalkingTableViewCell {
    func cellPicked() {
        checkboxButton.setImage(R.image.checbox_selected(), for: .normal)
    }
    
    func cellUnpicked() {
        checkboxButton.setImage(R.image.checkboxBlack(), for: .normal)
    }
}

extension DogWalkingTableViewCell {
    func setup(title: String, description: String, price: Int, speciesType: String, size: String, imageUrl: String) {
        serviceNameLabel.text = title
        if size != "-" {
            serviceSizeLabel.text = "(\(size) \(speciesType))"
        } else {
            serviceSizeLabel.text = "(\(speciesType))"
        }
        priceLabel.text = "$\(price)"
        descriptionLabel.text = description
        if imageUrl != "-" {
            serviceImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: R.image.profile_test())
        }
    }
    
    func title(test: String) {
        serviceNameLabel.text = test
    }
}
