//
//  DateChooserCollectionViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 15.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class DateChooserCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UIProperty
    
    var dateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .colorAAABAE
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup layout
    
    private func setupLayout() {
        addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

//MARK: - Setup Choosed Dates

extension DateChooserCollectionViewCell {
    
    func setup(isSelect: Bool) {
        if isSelect {
            dateLabel.font = R.font.aileronBold(size: 16)
        } else {
            dateLabel.font = R.font.aileronRegular(size: 16)
        }
    }
    
    func setupHighlighted() {
        dateLabel.font = R.font.aileronBold(size: 16)
        dateLabel.textColor = .colorC6222F
    }
    
    func setupUnhighlighted() {
        dateLabel.font = R.font.aileronRegular(size: 16)
        dateLabel.textColor = .colorAAABAE
    }

}
