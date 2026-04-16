//
//  SkyFloatingLabelTextField + Ext.swift
//  p103-customer
//
//  Created by Alex Lebedev on 05.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import SkyFloatingLabelTextField
import UIKit

enum TypeOfTextField {
    case password
    case usual
    case address
}

extension SkyFloatingLabelTextField {
    
    func authTextfield(placeholder: String, iconImage: UIImage?, type: TypeOfTextField) -> SkyFloatingLabelTextFieldWithIcon {
        let textfield = SkyFloatingLabelTextFieldWithIcon()
        textfield.iconImage = iconImage
        textfield.placeholder = placeholder
        textfield.placeholderFont = R.font.aileronLight(size: 14)
        textfield.font = R.font.aileronRegular(size: 14)
        textfield.iconMarginBottom = 9
        textfield.iconImageView.contentMode = .bottom
        
        textfield.iconType = .image
        
        textfield.lineHeight = 2
        textfield.selectedLineHeight = 2
        
        textfield.lineColor = UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 0.5)
        textfield.selectedLineColor = .colorC6222F
        
        textfield.iconColor = UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 0.5)
        textfield.selectedIconColor = .colorC6222F
        
        textfield.selectedTitleColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        textfield.titleFormatter = { $0 }
        textfield.snp.makeConstraints {
            $0.height.equalTo(47)
        }

        if type == .address {
            textfield.lineColor = .white
            textfield.selectedLineColor = .white
        }
        return textfield
    }
    
    
    func authTextfieldWithoutIcon(placeholder: String) -> SkyFloatingLabelTextField {
        let textfield = SkyFloatingLabelTextField()
        textfield.configure(placeholder: placeholder)
        textfield.snp.makeConstraints {
            $0.height.equalTo(47)
        }
        return textfield
    }
    func cardTextfield(placeholder: String) -> SkyFloatingLabelTextField {
        let textfield = SkyFloatingLabelTextField()
        textfield.cardConfigure(placeholder: placeholder)
        textfield.snp.makeConstraints {
            $0.height.equalTo(47)
        }
        return textfield
    }
}

extension SkyFloatingLabelTextFieldWithIcon {
    override func style(active: Bool) {
        if active {
            self.lineColor = .colorC6222F
            self.iconColor = .colorC6222F
        } else {
            self.lineColor = UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 0.5)
            self.iconColor = UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 0.5)
        }
    }
    override func configure(placeholder: String) {
        self.placeholder = placeholder
        self.placeholderFont = R.font.aileronLight(size: 14)
        self.font = R.font.aileronRegular(size: 14)
        self.titleLabel.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        self.lineHeight = 2
        self.selectedLineHeight = 2
        self.lineColor = UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 0.5)
        self.selectedLineColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        self.selectedTitleColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        self.titleFormatter = { $0 }
    }
}



extension SkyFloatingLabelTextField: UITextFieldDelegate {
    @objc func style(active: Bool) {
        if active {
            self.lineColor = .colorC6222F
        } else {
            self.lineColor = UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 0.5)
        }
    }
    @objc func cardStyle(active: Bool) {
        if active {
            self.lineColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        } else {
            self.lineColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 0.3)
        }
    }
    
    @objc func configure(placeholder: String) {
        self.placeholder = placeholder
        self.placeholderFont = R.font.aileronLight(size: 14)
        self.font = R.font.aileronRegular(size: 14)
        self.titleLabel.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        self.lineHeight = 2
        self.selectedLineHeight = 2
        self.lineColor = UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 0.5)
        self.selectedLineColor = .colorC6222F
        self.selectedTitleColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        self.titleFormatter = { $0 }
    }

    @objc func cardConfigure(placeholder: String) {
        self.placeholder = placeholder
        self.placeholderFont = R.font.aileronBold(size: 18)
        self.font = R.font.aileronBold(size: 18)
        self.titleLabel.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        self.lineHeight = 1
        self.selectedLineHeight = 1
        self.lineColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 0.3)
        self.selectedLineColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        self.textColor =  UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        self.selectedTitleColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        self.titleFormatter = { _ in
            return ""
        }
    }
    
}

