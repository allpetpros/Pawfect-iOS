//
//  AccountView.swift
//  p103-customer
//
//  Created by Daria Pr on 10.06.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

@objc protocol AccountDelegate: class {
    func setup(error: Error)
}

class AccountView: UIView {
    
    //MARK: - UIProperties
    
    private let scrollView = UIScrollView()
    private let mainView = UIView()
    
    private let emailTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Email", iconImage: R.image.emalIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()

    private let phoneNumberTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Mobile Phone", iconImage: R.image.phoneIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let workPhoneTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Work Phone", iconImage: R.image.phoneIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()

    private let homeAddressTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Home Address*", iconImage: R.image.homeAddressIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let showAllButton: UIButton = {
        let b = UIButton()
        b.isUserInteractionEnabled = true
        b.setTitle("Show All", for: .normal)
        b.setTitleColor(R.color.buttonColor(), for: .normal)
        b.titleLabel?.font = R.font.aileronLight(size: 12)
        b.underline()
        b.addTarget(self, action: #selector(showAllButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let borderView: UIView = {
        let v = UIView()
        v.backgroundColor = R.color.borderColor()
        v.isHidden = true
        return v
    } ()
    
    private let billingAddressTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Billing Address", iconImage: R.image.billingAddressIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let cityTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "City", iconImage: R.image.cityIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let stateTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "State", iconImage: R.image.stateIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let zipTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Zip", iconImage: R.image.zipIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let stateStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 30
        stack.distribution = .fillEqually
        stack.isHidden = true
        return stack
    }()
    
    private let borderSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = R.color.borderColor()
        v.isHidden = true
        return v
    } ()
    
    private let emergencyContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact Name*", iconImage: R.image.emergencyContactIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let emergencyContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact*", iconImage: R.image.phoneIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let emergencySecondContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact Name*", iconImage: R.image.emergencyContactIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let emergencySecondContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact*", iconImage: R.image.phoneIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let emergencyThirdContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact Name*", iconImage: R.image.emergencyContactIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let emergencyThirdContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact*", iconImage: R.image.phoneIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let emergencyStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private let borderThirdView: UIView = {
        let v = UIView()
        v.backgroundColor = R.color.borderColor()
        v.isHidden = true
        return v
    } ()
    
    private let lockBoxDoorTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Lockbox door code", iconImage: R.image.lockBoxIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let lockBoxLocationTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Lockbox Location", iconImage: R.image.lockboxLocationIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let homeAlarmSystemTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Lockbox Location", iconImage: R.image.homeAlarmSystemIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let otherHomeAccessTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Other Home Access Notes", iconImage: R.image.otherHomeAccessIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let mailBoxTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Mail box", iconImage: R.image.mailboxIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let otherRequestsTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Other requests", iconImage: R.image.otherRequestsIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        tf.isHidden = true
        return tf
    } ()
    
    private let mailKeyView: YesOrNoView = {
        let v = YesOrNoView()
        v.setup(type: .mailKeyProvided)
        v.isUserInteractionEnabled = false
        v.isHidden = true
        v.noButton.isHidden = true
        v.checkboxNo.isHidden = true
        return v
    } ()
    
    private let turnLightView: YesOrNoView = {
        let v = YesOrNoView()
        v.isHidden = true
        v.setup(type: .turnLightsOnOrOff)
        v.isUserInteractionEnabled = false
        v.yesButton.setTitle("Off", for: .normal)
        v.noButton.isHidden = true
        v.checkboxNo.isHidden = true
        return v
    } ()
    
    private let someoneWillBeHomeView: YesOrNoView = {
        let v = YesOrNoView()
        v.isHidden = true
        v.setup(type: .someoneWillBeHome)
        v.isUserInteractionEnabled = false
        v.noButton.isHidden = true
        v.checkboxNo.isHidden = true
        return v
    } ()
    
    private let waterPlantsView: ButtonWithTrailingCheckbox = {
        let v = ButtonWithTrailingCheckbox()
        v.isHidden = true
        v.setup(component: .waterPlaints, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        v.isUserInteractionEnabled = false
        v.isEnable(false)
        return v
    } ()
    
    private let commentLabel: UILabel = {
        let l = UILabel()
        l.text = "Сomment"
        l.isHidden = true
        l.textColor = .colorAAABAE
        l.font = R.font.aileronRegular(size: 12)
        l.isHidden = true
        return l
    } ()
    
    private let commentIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = true
        iv.image = R.image.commentIcon()
        return iv
    } ()
    
    private let commentTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .color070F24
        tv.isHidden = true
        tv.font = R.font.aileronRegular(size: 14)
        tv.isUserInteractionEnabled = false
        return tv
    } ()
    
    private let garbageView: GarbageView = {
        let v = GarbageView()
        v.setup(userInteraction: false, title: "Garbage")
        return v
    } ()
    
    private let hideAllButton: UIButton = {
        let b = UIButton()
        b.isUserInteractionEnabled = true
        b.setTitle("Hide All", for: .normal)
        b.setTitleColor(R.color.buttonColor(), for: .normal)
        b.titleLabel?.font = R.font.aileronLight(size: 12)
        b.underline()
        b.isHidden = true
        b.addTarget(self, action: #selector(hideAllButtonAction), for: .touchUpInside)
        return b
    } ()
        
    //MARK: - Properties
    
    private var amountOfContact = 0
    
    weak var delegate: AccountDelegate?
    
    private var activityView: UIActivityIndicatorView?
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScrollViewLayouts()
        setupMainFields()
        setInfo()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Layout

private extension AccountView {
    func setupScrollViewLayouts() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.left.right.equalTo(self.scrollView.contentLayoutGuide)
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
    }
    
    func setupMainFields() {
        mainView.addSubviews([emailTextField, phoneNumberTextField, workPhoneTextField, homeAddressTextField, showAllButton])
        
        emailTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(47)
        }

        phoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(47)
        }
        
        workPhoneTextField.snp.makeConstraints {
            $0.top.equalTo(phoneNumberTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(47)
        }

        homeAddressTextField.snp.makeConstraints {
            $0.top.equalTo(workPhoneTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(47)
        }
        
        showAllButton.snp.makeConstraints {
            $0.top.equalTo(homeAddressTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalToSuperview()
        }
        setupAdditionalFields()
    }
    
    func setupAdditionalFields() {
        mainView.addSubviews([borderView, billingAddressTextField, cityTextField, stateStackView, borderSecondView])
        
        stateStackView.addArrangedSubviews(views: stateTextField, zipTextField)
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(homeAddressTextField.snp.bottom).offset(30)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(27)
            $0.right.equalToSuperview()
        }

        cityTextField.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        stateStackView.snp.makeConstraints {
            $0.top.equalTo(cityTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        billingAddressTextField.snp.makeConstraints {
            $0.top.equalTo(stateStackView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        borderSecondView.snp.makeConstraints {
            $0.top.equalTo(billingAddressTextField.snp.bottom).offset(25)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(27)
            $0.right.equalToSuperview()
        }
        
        setupEmergencyContactFields()
    }
    
    func setupEmergencyContactFields() {
        emergencyStackView.addArrangedSubviews(views: emergencyContactNameTextField, emergencyContactTextField, emergencySecondContactNameTextField,emergencySecondContactTextField,  emergencyThirdContactNameTextField, emergencyThirdContactTextField)
        mainView.addSubviews([emergencyStackView, borderThirdView])
        emergencyStackView.snp.makeConstraints {
            $0.top.equalTo(borderSecondView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
           
        }
        
        borderThirdView.snp.remakeConstraints {
            $0.top.equalTo(emergencyStackView.snp.bottom).offset(25)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(27)
            $0.right.equalToSuperview()
        }

        setupHomeInfoFields()
    }
    
    func setupHomeInfoFields() {
        mainView.addSubviews([lockBoxDoorTextField, lockBoxLocationTextField, homeAlarmSystemTextField, otherHomeAccessTextField, mailBoxTextField, otherRequestsTextField])
        
        lockBoxDoorTextField.snp.makeConstraints {
            $0.top.equalTo(borderThirdView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        lockBoxLocationTextField.snp.makeConstraints {
            $0.top.equalTo(lockBoxDoorTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        homeAlarmSystemTextField.snp.makeConstraints {
            $0.top.equalTo(lockBoxLocationTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        otherHomeAccessTextField.snp.makeConstraints {
            $0.top.equalTo(homeAlarmSystemTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        mailBoxTextField.snp.makeConstraints {
            $0.top.equalTo(otherHomeAccessTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        otherRequestsTextField.snp.makeConstraints {
            $0.top.equalTo(mailBoxTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        setupCheckboxes()
    }
    
    func setupCheckboxes() {
        mainView.addSubviews([mailKeyView, turnLightView, someoneWillBeHomeView, waterPlantsView])
        
        mailKeyView.snp.makeConstraints {
            $0.top.equalTo(otherRequestsTextField.snp.bottom).offset(50)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        turnLightView.snp.makeConstraints {
            $0.top.equalTo(mailKeyView.snp.bottom).offset(42)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        someoneWillBeHomeView.snp.makeConstraints {
            $0.top.equalTo(turnLightView.snp.bottom).offset(42)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        waterPlantsView.snp.makeConstraints {
            $0.top.equalTo(someoneWillBeHomeView.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        setupCommentGarbageFields()
    }
    
    func setupCommentGarbageFields() {
        mainView.addSubviews([commentLabel, commentIconImageView, commentTextView, garbageView, hideAllButton])
                
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(waterPlantsView.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
        }
        
        commentIconImageView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(18)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(16)
            $0.height.equalTo(13)
        }
        
        commentTextView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(7)
            $0.left.equalTo(commentIconImageView.snp.right).offset(11)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(95)
        }
        
        garbageView.snp.makeConstraints {
            $0.top.equalTo(commentTextView.snp.bottom).offset(10)
            $0.height.equalTo(300)
            $0.left.right.equalToSuperview()
        }
        
        hideAllButton.snp.makeConstraints {
            $0.top.equalTo(garbageView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.height.equalTo(47)
        }
    }
}

//MARK: - Actions

extension AccountView {
    @objc func showAllButtonAction(sender: UIButton) {
        sender.isHidden = true
        
        hideAllButton.isHidden = false
        
        showAllButton.snp.remakeConstraints {
            $0.top.equalTo(homeAddressTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(25)
        }

        hideAllButton.snp.remakeConstraints {
            $0.top.equalTo(garbageView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.height.equalTo(47)
            $0.bottom.equalToSuperview()
        }
        
        setupHiddenFields(isHidden: false)
    }
    
    @objc func hideAllButtonAction(sender: UIButton) {
        sender.isHidden = true
        showAllButton.isHidden = false

        hideAllButton.snp.remakeConstraints {
            $0.top.equalTo(garbageView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.height.equalTo(47)
        }
        
        showAllButton.snp.remakeConstraints {
            $0.top.equalTo(homeAddressTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalToSuperview()
        }

        setupHiddenFields(isHidden: true)
    }
}

//MARK: - Setup additional fields

private extension AccountView {
    func setupHiddenFields(isHidden: Bool) {
        borderView.isHidden = isHidden
        billingAddressTextField.isHidden = isHidden
        cityTextField.isHidden = isHidden
        stateStackView.isHidden = isHidden
        borderSecondView.isHidden = isHidden
        emergencyContactTextField.isHidden = isHidden
        emergencyContactNameTextField.isHidden = isHidden
        borderThirdView.isHidden = isHidden
        lockBoxDoorTextField.isHidden = isHidden
        lockBoxLocationTextField.isHidden = isHidden
        homeAlarmSystemTextField.isHidden = isHidden
        otherHomeAccessTextField.isHidden = isHidden
        mailBoxTextField.isHidden = isHidden
        otherRequestsTextField.isHidden = isHidden
        mailKeyView.isHidden = isHidden
        turnLightView.isHidden = isHidden
        someoneWillBeHomeView.isHidden = isHidden
        waterPlantsView.isHidden = isHidden
        commentLabel.isHidden = isHidden
        commentIconImageView.isHidden = isHidden
        commentTextView.isHidden = isHidden
        garbageView.isHidden = isHidden
        if amountOfContact == 2 {
            emergencySecondContactTextField.isHidden = isHidden
            emergencySecondContactNameTextField.isHidden = isHidden
        } else if amountOfContact == 3 {
            emergencySecondContactTextField.isHidden = isHidden
            emergencySecondContactNameTextField.isHidden = isHidden
            emergencyThirdContactTextField.isHidden = isHidden
            emergencyThirdContactNameTextField.isHidden = isHidden
        }
    }
}

//MARK: - Network

private extension AccountView {
    func setInfo() {
        showActivityIndicator()
        
        CustomerService().getCurrentCustomer { result in
            switch result {
            case .success(let userData):
                let profile = userData
                self.setupView(profile: profile)
                self.hideActivityIndicator()
            case .failure(let error):
                self.delegate?.setup(error: error)
                self.hideActivityIndicator()
            }
        }
    }
    
    func setupEmergencies(emergency: EmergenciesGetResponse) {
        if emergency.items.count == 0 {
            emergencyContactNameTextField.isHidden = true
            emergencyContactTextField.isHidden = true
            emergencySecondContactNameTextField.isHidden = true
            emergencySecondContactTextField.isHidden = true
            emergencyThirdContactNameTextField.isHidden = true
            emergencyThirdContactTextField.isHidden = true
        } else if emergency.items.count == 1 {
            emergencyContactNameTextField.text = emergency.items[0].name
            if emergency.items[0].phoneNumber.count == 10 {
            emergencyContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            }else {
                emergencyContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
            emergencySecondContactNameTextField.isHidden = true
            emergencySecondContactTextField.isHidden = true
            emergencyThirdContactNameTextField.isHidden = true
            emergencyThirdContactTextField.isHidden = true
        } else if emergency.items.count == 2 {
            emergencySecondContactNameTextField.isHidden = false
            emergencySecondContactTextField.isHidden = false
            emergencyThirdContactNameTextField.isHidden = true
            emergencyThirdContactTextField.isHidden = true
            emergencyContactNameTextField.text = emergency.items[0].name
            emergencySecondContactNameTextField.text = emergency.items[1].name
            if emergency.items[0].phoneNumber.count == 10  {
            emergencyContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
              }else {
                emergencyContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
            
            if  emergency.items[1].phoneNumber.count == 10 {
                emergencySecondContactTextField.text = emergency.items[1].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            } else {
                emergencySecondContactTextField.text = emergency.items[1].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
        } else if emergency.items.count == 3 {
            emergencySecondContactNameTextField.isHidden = false
            emergencySecondContactTextField.isHidden = false
            emergencyThirdContactNameTextField.isHidden = false
            emergencyThirdContactTextField.isHidden = false
            emergencyContactNameTextField.text = emergency.items[0].name
            emergencySecondContactNameTextField.text = emergency.items[1].name
            emergencyThirdContactNameTextField.text = emergency.items[2].name
            if emergency.items[0].phoneNumber.count == 10  {
            emergencyContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
              }else {
                emergencyContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
            
            if  emergency.items[1].phoneNumber.count == 10 {
                emergencySecondContactTextField.text = emergency.items[1].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            } else {
                emergencySecondContactTextField.text = emergency.items[1].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
            if  emergency.items[2].phoneNumber.count == 10 {
                emergencyThirdContactTextField.text = emergency.items[2].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            } else {
                emergencyThirdContactTextField.text = emergency.items[2].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
  
        }
        setupEmergencyContactFields()
    }
    
    func setupView(profile: CustomerStruct) {
        emailTextField.text = profile.email
        phoneNumberTextField.text = profile.phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        if profile.workPhoneNumber.isEmpty {
            workPhoneTextField.isHidden = true
        } else {
            workPhoneTextField.isHidden = false
            workPhoneTextField.text = profile.workPhoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        }
        homeAddressTextField.text = profile.address
        billingAddressTextField.text = profile.billingAddress
        cityTextField.text = profile.city
        stateTextField.text = profile.state
        zipTextField.text = profile.zipCode
        lockBoxDoorTextField.text = profile.lockboxDoorCode
        lockBoxLocationTextField.text = profile.lockboxLocation
        homeAlarmSystemTextField.text = profile.homeAlarmSystem
        otherHomeAccessTextField.text = profile.otherHomeAccessNotes
        mailBoxTextField.text = profile.mailBox
        otherRequestsTextField.text = profile.otherRequestsNotes
        if let isMailKey = profile.isMailKeyProvided {
            mailKeyView.checkboxYes.image = R.image.checkbox_selected_point()
            if isMailKey == true {
                mailKeyView.yesButton.setTitle("Yes", for: .normal)
            } else {
                mailKeyView.yesButton.setTitle("No", for: .normal)
            }
        }
        if let isLight = profile.isTurnLight {
            turnLightView.checkboxYes.image = R.image.checkbox_selected_point()

            if isLight == true {
                turnLightView.yesButton.setTitle("On", for: .normal)
            } else {
                turnLightView.yesButton.setTitle("Off", for: .normal)
            }
        }
        if let isHome = profile.isSomeoneAtHome {
            someoneWillBeHomeView.checkboxYes.image = R.image.checkbox_selected_point()

            if isHome == true {
                someoneWillBeHomeView.yesButton.setTitle("Yes", for: .normal)
            } else {
                someoneWillBeHomeView.yesButton.setTitle("No", for: .normal)
            }
        }
        
        commentTextView.text = profile.comment
        
        if let garbageArr = profile.garbage {
            garbageView.setupProfileView(garbageArr: garbageArr)
        }
        
        if let isWater = profile.isWaterPlantsExists {
            if isWater {
                waterPlantsView.vkl()
            } else {
                waterPlantsView.vukl()
            }
        }
        
        CustomerService().getEmergencies { result in
            print("Get Emergencies", result)
            switch result {
            case .success(let emergency):
                self.amountOfContact = emergency.items.count
                self.setupEmergencies(emergency: emergency)
                self.reloadInputViews()
                self.hideActivityIndicator()
            case .failure(let error):
                self.delegate?.setup(error: error)
                self.hideActivityIndicator()
            }
        }
    }
}

//MARK: - Public Methods

extension AccountView {
    func reloadAccount() {
        CustomerService().getCurrentCustomer { result in
            print("Profile is",result)
            switch result {
            case .success(let userData):
                let profile = userData
                self.setupView(profile: profile)
                self.reloadInputViews()
                self.hideActivityIndicator()
            case .failure(let error):
                self.delegate?.setup(error: error)
                self.hideActivityIndicator()
            }
        }
    }
}

//MARK: - ActivityIndicator

extension AccountView {
    private func showActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        }
        activityView?.center = self.center
        self.addSubview(activityView!)
        activityView?.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    private func hideActivityIndicator(){
        activityView?.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
