//
//  ServicesCell.swift
//  p103-customer
//
//  Created by Alex Lebedev on 25.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class ServicesCell: UITableViewCell {
    
    // MARK: - UIProperties
    
    private let serviceImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .color860000
        return iv
    } ()

    private let serviceNameLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 18)
        l.textColor = .color293147
        return l
    }()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.arrow_righ()
        return iv
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
    
     // MARK: - Setup Layout
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    private func setupLayout() {
        addSubviews([serviceImageView, serviceNameLabel, arrowImageView])
        
        serviceImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(23)
        }
        
        serviceNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(serviceImageView.snp.right).offset(14)
        }
        
        arrowImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(21)
            $0.height.equalTo(15)
            $0.right.equalToSuperview().offset(-31)
        } 	  
    }

    func setupAvailableServices(title: String, numberOfServices: Int, imageUrl: String) {
        serviceNameLabel.text = title
        if imageUrl != "-" {
            arrowImageView.sd_setImage(with: URL(string: imageUrl))
        }
    }
}
