//
//  PetSittingTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 08.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class PetSittingTableViewCell: UITableViewCell {
    
    //MARK: - UIProperties

    private let serviceImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    } ()

    private let serviceNameLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 18)
        return l
    }()
    
    private let serviceSizeLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 18)
        l.numberOfLines = 0
        l.minimumScaleFactor = 0.3
        l.adjustsFontSizeToFitWidth = true
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
    
    //MARK: - Properties
    
    private var isCheckboxed: Bool = false

    // MARK: - Lifecycle
    
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
            $0.right.equalToSuperview()
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
}

//MARK: - Setup State Checkboxes

extension PetSittingTableViewCell {
    func cellPicked() {
        checkboxButton.setImage(R.image.checbox_selected(), for: .normal)
    }
    
    func cellUnpicked() {
        checkboxButton.setImage(R.image.checkboxBlack(), for: .normal)
    }
}

//MARK: - Setup cells

extension PetSittingTableViewCell {
    func setup(title: String, description: String, price: Int, typeOfAnimal: String, imageUrl: String) {
        serviceNameLabel.text = title
        serviceSizeLabel.text = "(\(typeOfAnimal))"
        if typeOfAnimal.count >= 8 {
            serviceSizeLabel.font = R.font.aileronBold(size: 14)
        } else {
            serviceSizeLabel.font = R.font.aileronBold(size: 18)
        }
        priceLabel.text = "$\(price)"
        descriptionLabel.text = description
        if imageUrl != "-" {
            serviceImageView.sd_setImage(with: URL(string: imageUrl))
        }
    }
}
