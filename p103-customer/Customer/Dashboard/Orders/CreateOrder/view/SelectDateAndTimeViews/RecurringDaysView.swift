//
//  RecurringDaysView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 28.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class RecurringDaysView: UIView {
    
    // MARK: - Properties
     private let titleLabel: UILabel = {
         let label = UILabel()
         return label
     }()
    private let daysStackView: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        return stack
    }()
    let sunButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1), for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 12)
        button.setTitle("Sun", for: .normal)
        return button
    }()
    let monButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1), for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 12)
        button.setTitle("Mon", for: .normal)
        return button
    }()
    let tueButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1), for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 12)
        button.setTitle("Tue", for: .normal)
        return button
    }()
    let wedButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1), for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 12)
        button.setTitle("Wed", for: .normal)
        return button
    }()
    let thuButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1), for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 12)
        button.setTitle("Thu", for: .normal)
        return button
    }()
    let friButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1), for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 12)
        button.setTitle("Fri", for: .normal)
        return button
    }()
    let satButton: UIButton = {
       let button = UIButton()
        button.setTitleColor(UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1), for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 12)
        button.setTitle("Sat", for: .normal)
        return button
    }()
    
    
    
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        titleLabel.font = R.font.aileronRegular(size: 14)
        titleLabel.textColor = .color606572
        titleLabel.text = "Days Recurring"
        titleLabel.textAlignment = .left
        
        daysStackView.addArrangedSubviews(views: sunButton, monButton, tueButton, wedButton, thuButton, friButton, satButton)
        addSubviews([titleLabel, daysStackView])
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        daysStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.bottom.leading.trailing.equalToSuperview()
        }
    }
}
