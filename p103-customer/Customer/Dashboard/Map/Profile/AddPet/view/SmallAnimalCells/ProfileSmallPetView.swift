//
//  ProfileSmallPetView.swift
//  p103-customer
//
//  Created by Daria Pr on 13.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

@objc protocol EditPetDelegate: class {
    func toEdit()
}

class ProfileSmallPetView: UIView {
    
    //MARK: - UIProperties

    private let medicationNotesTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Medical notes/concerns")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.isUserInteractionEnabled = false
        tv.lineColor = .white
        return tv
    } ()
    
    private let veterinarianNameTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Veterinarian Name")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.isUserInteractionEnabled = false
        tv.lineColor = .white
        return tv
    } ()
    
    private let veterinarianPhoneNumberTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Veterinarian Phone Number")
        tv.keyboardType = .phonePad
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.isUserInteractionEnabled = false
        tv.lineColor = .white
        return tv
    } ()
    
    private let editButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.editButton(), for: .normal)
        b.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        return b
    }()
    
    weak var delegate: EditPetDelegate?
    private var activityView: UIActivityIndicatorView?
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    //MARK: - Setup Layout

private extension ProfileSmallPetView {
    func setupLayout() {
        
        addSubviews([medicationNotesTextField, veterinarianNameTextField, veterinarianPhoneNumberTextField, editButton])
        
        medicationNotesTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        veterinarianNameTextField.snp.makeConstraints {
            $0.top.equalTo(medicationNotesTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        veterinarianPhoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(veterinarianNameTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(veterinarianPhoneNumberTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}

//MARK: - Actions

extension ProfileSmallPetView {
    @objc func editButtonAction() {
        delegate?.toEdit()
    }
}

//MARK: - Public funcs

extension ProfileSmallPetView {
    func setupView(profile: SmallPetGet) {
        
        if let name = profile.veterinarian?.name {
            veterinarianNameTextField.text = name
        }
        if let phone = profile.veterinarian?.phoneNumber {
            veterinarianPhoneNumberTextField.text = phone.applyPatternOnNumbers(pattern: "(###) ###-####",replacementCharacter: "#")
        }
        medicationNotesTextField.text = profile.medicalNotes
    }
    
    func setupSmall(profile: PetStruct) {
        medicationNotesTextField.text = profile.medicationInstructions
        veterinarianNameTextField.text = profile.veterinarian?.name
        veterinarianPhoneNumberTextField.text = profile.veterinarian?.phoneNumber
    }
    
}
extension ProfileSmallPetView {
    private func showActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        }
        activityView?.center = self.center
        self.addSubview(activityView!)
        
        activityView?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        activityView?.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }

    private func hideActivityIndicator(){
        activityView?.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
}
