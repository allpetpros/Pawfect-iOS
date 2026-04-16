//
//  SkyFloatingLabelTextFieldWithIconAndAccessory.swift
//  
//
//  Created by Alex Lebedev on 07.05.2020.
//

import UIKit
import SkyFloatingLabelTextField

enum SkyFloatingViewTypes {
    case password
    case withChekIcon
}

class SkyFloatingLabelTextFieldWithIconAndAccessory: UIView {
    
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var skyTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var accessoryButtonOutlet: UIButton!
    
    // MARK: - Actions
    @IBAction func AccessoryButtonAction(_ sender: UIButton) {
        guard let type = type, type == .password else { return }
        
        let isValidate = sender.currentImage?.description.contains("validationCheckBox")
        
        if isValidate == true {
            accessoryButtonOutlet.setImage(R.image.validationCheckBox(), for: .normal)
        } else {
            skyTextField.isSecureTextEntry = !skyTextField.isSecureTextEntry
            if skyTextField.isSecureTextEntry {
                 accessoryButtonOutlet.setImage(R.image.eye(), for: .normal)
            } else {
                accessoryButtonOutlet.setImage(R.image.close_eye(), for: .normal)
            }
        }
    }
    
    // MARK: - Property
    private var type: SkyFloatingViewTypes?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: - Private functions
    private func commonInit() {
        Bundle.main.loadNibNamed("SkyFloatingLabelTextFieldWithIconAndAccessory", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.bounds
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Setup
    func setup(type: SkyFloatingViewTypes, placeholder: String, iconImage: UIImage?) {
        skyTextField.iconImage = iconImage
        skyTextField.placeholder = placeholder
        skyTextField.placeholderFont = R.font.aileronLight(size: 14)
        skyTextField.font = R.font.aileronRegular(size: 14)
        skyTextField.iconMarginBottom = 6
        
        skyTextField.iconType = .image
        
        skyTextField.lineHeight = 2
        skyTextField.selectedLineHeight = 2
        
        skyTextField.lineColor = UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 0.5)
        skyTextField.selectedLineColor = .colorC6222F
        
        skyTextField.iconColor = UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 0.5)
        skyTextField.selectedIconColor = .colorC6222F

        skyTextField.selectedTitleColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        skyTextField.titleFormatter = { $0 }
        accessoryButtonOutlet.backgroundColor = .white
        switch type {
            
        case .password:
            accessoryButtonOutlet.setImage(R.image.eye(), for: .normal)
            accessoryButtonOutlet.tintColor = .colorC6222F
            skyTextField.isSecureTextEntry = true
        case .withChekIcon:
            accessoryButtonOutlet.setImage(R.image.ok(), for: .normal)
            accessoryButtonOutlet.tintColor = .colorC6222F
        }
        self.type = type
    }
}

