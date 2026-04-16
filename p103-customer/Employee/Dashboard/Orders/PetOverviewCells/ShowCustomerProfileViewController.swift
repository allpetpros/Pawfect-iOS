//
//  ShowCustomerProfileViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 26.07.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ShowCustomerProfileViewController: BaseViewController {
    
    //MARK: - UIProperties
    
    private let scrollView = UIScrollView()
    private let mainView = UIView()
    
    private let backButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.backButtonImage(), for: .normal)
        b.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    } ()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronBold(size: 18)
        return l
    } ()
    
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
    
    private let borderView: UIView = {
        let v = UIView()
        v.backgroundColor = R.color.borderColor()
        return v
    } ()
    
    private let billingAddressTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Billing Address", iconImage: R.image.billingAddressIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let cityTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "City", iconImage: R.image.cityIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
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
        return stack
    }()
    
    private let borderSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = R.color.borderColor()
        return v
    } ()
    
    private let emergencyContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact Name*", iconImage: R.image.emergencyContactIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let emergencyContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact*", iconImage: R.image.phoneIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let emergencySecondContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact Name*", iconImage: R.image.emergencyContactIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let emergencySecondContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact*", iconImage: R.image.phoneIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let emergencyThirdContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact Name*", iconImage: R.image.emergencyContactIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let emergencyThirdContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Emergency Contact*", iconImage: R.image.phoneIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let borderThirdView: UIView = {
        let v = UIView()
        v.backgroundColor = R.color.borderColor()
        return v
    } ()
    
    private let lockBoxDoorTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Lockbox door code", iconImage: R.image.lockBoxIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let lockBoxLocationTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Lockbox Location", iconImage: R.image.lockboxLocationIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let homeAlarmSystemTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Lockbox Location", iconImage: R.image.homeAlarmSystemIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let otherHomeAccessTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Other Home Access Notes", iconImage: R.image.otherHomeAccessIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let mailBoxTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Mail box", iconImage: R.image.mailboxIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let otherRequestsTextField: SkyFloatingLabelTextFieldWithIcon = {
        let tf = SkyFloatingLabelTextFieldWithIcon().authTextfield(placeholder: "Other requests", iconImage: R.image.otherRequestsIcon(), type: .usual)
        tf.isUserInteractionEnabled = false
        tf.lineColor = .white
        return tf
    } ()
    
    private let mailKeyView: YesOrNoView = {
        let v = YesOrNoView()
        v.setup(type: .mailKeyProvided)
        v.isUserInteractionEnabled = false
        return v
    } ()
    
    private let turnLightView: YesOrNoView = {
        let v = YesOrNoView()
        v.setup(type: .turnLightsOnOrOff)
        v.isUserInteractionEnabled = false
        v.yesButton.setTitle("Off", for: .normal)
        return v
    } ()
    
    private let someoneWillBeHomeView: YesOrNoView = {
        let v = YesOrNoView()
        v.setup(type: .someoneWillBeHome)
        v.isUserInteractionEnabled = false
        return v
    } ()
    
    private let waterPlantsView: ButtonWithTrailingCheckbox = {
        let v = ButtonWithTrailingCheckbox()
        v.setup(component: .waterPlaints, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        v.isUserInteractionEnabled = false
        v.isEnable(false)
        return v
    } ()
    
    private let commentLabel: UILabel = {
        let l = UILabel()
        l.text = "Сomment"
        l.textColor = .colorAAABAE
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let commentIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.commentIcon()
        return iv
    } ()
    
    private let commentTextView: UITextView = {
        let tv = UITextView()
        tv.textColor = .color070F24
        tv.font = R.font.aileronRegular(size: 14)
        tv.isUserInteractionEnabled = false
        return tv
    } ()
    
    private let garbageView: GarbageView = {
        let v = GarbageView()
        v.setup(userInteraction: false, title: "Garbage")
        return v
    } ()
    
    //MARK: - Properties
    
    private var amountOfContact = 0
    var id = String()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupScrollViewLayouts()
        setupMainFields()
        
        getCustomerProfile()
    }
}

//MARK: - Setup Layout

private extension ShowCustomerProfileViewController {
    func setupScrollViewLayouts() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
        mainView.addSubviews([backButton, emailTextField, avatarImageView, nameLabel, phoneNumberTextField, workPhoneTextField, homeAddressTextField])
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview().offset(25)
        }
        
        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.centerY.equalTo(backButton)
            $0.left.equalTo(backButton.snp.right).offset(25)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.left.equalTo(avatarImageView.snp.right).offset(15)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(30)
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
        
        billingAddressTextField.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        cityTextField.snp.makeConstraints {
            $0.top.equalTo(billingAddressTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        stateStackView.snp.makeConstraints {
            $0.top.equalTo(cityTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        borderSecondView.snp.makeConstraints {
            $0.top.equalTo(stateStackView.snp.bottom).offset(25)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(27)
            $0.right.equalToSuperview()
        }
        
        setupEmergencyContactFields()
    }
    
    func setupEmergencyContactFields() {
        mainView.addSubviews([emergencyContactNameTextField, emergencyContactTextField, emergencySecondContactTextField, emergencySecondContactNameTextField, emergencyThirdContactNameTextField, emergencyThirdContactTextField, borderThirdView])
        
        emergencyContactNameTextField.snp.makeConstraints {
            $0.top.equalTo(borderSecondView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(47)
        }
        
        emergencyContactTextField.snp.makeConstraints {
            $0.top.equalTo(emergencyContactNameTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(47)
        }
        
        emergencySecondContactNameTextField.snp.makeConstraints {
            $0.top.equalTo(emergencyContactTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(47)
        }
        
        emergencySecondContactTextField.snp.makeConstraints {
            $0.top.equalTo(emergencySecondContactNameTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(47)
        }
        
        emergencyThirdContactNameTextField.snp.makeConstraints {
            $0.top.equalTo(emergencySecondContactTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(47)
        }
        
        emergencyThirdContactTextField.snp.makeConstraints {
            $0.top.equalTo(emergencyThirdContactNameTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(47)
        }
        
        borderThirdView.snp.remakeConstraints {
            $0.top.equalTo(emergencyThirdContactTextField.snp.bottom).offset(25)
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
        mainView.addSubviews([commentLabel, commentIconImageView, commentTextView, garbageView])
                
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
            $0.bottom.equalToSuperview()
        }
    }
}

//MARK: - Network

private extension ShowCustomerProfileViewController {
    func getCustomerProfile() {
        showActivityIndicator()
        EmployeeService().getCustomerProfile(id: id) { result in
            switch result {
            case .success(let s):
                self.emailTextField.text = s.email
                self.phoneNumberTextField.text = s.phoneNumber
                self.workPhoneTextField.text = s.workPhoneNumber
                self.homeAddressTextField.text = s.address
                if let image = s.imageUrl {
                    self.avatarImageView.sd_setImage(with: URL(string: image), placeholderImage: R.image.alertBox())
                } else {
                    self.avatarImageView.image = R.image.alertBox()
                }
                self.nameLabel.text = "\(s.name) \(s.surname)"
                self.billingAddressTextField.text = s.billingAddress
                self.cityTextField.text = s.city
                self.stateTextField.text = s.state
                self.zipTextField.text = s.zipCode

                if s.emergencies?.count == nil {
                    self.emergencyContactTextField.isHidden = true
                    self.emergencyContactNameTextField.isHidden = true
                    self.emergencySecondContactTextField.isHidden = true
                    self.emergencySecondContactNameTextField.isHidden = true
                    self.emergencyThirdContactTextField.isHidden = true
                    self.emergencyThirdContactNameTextField.isHidden = true
                    
                    self.borderSecondView.isHidden = true
                    
                    self.borderThirdView.snp.remakeConstraints {
                        $0.top.equalTo(self.stateStackView.snp.bottom).offset(20)
                        $0.height.equalTo(1)
                        $0.left.equalToSuperview().offset(27)
                        $0.right.equalToSuperview()
                    }
                }
                self.lockBoxDoorTextField.text = s.lockboxDoorCode
                self.lockBoxLocationTextField.text = s.lockboxLocation
                self.homeAlarmSystemTextField.text = s.homeAlarmSystem
                self.otherHomeAccessTextField.text = s.otherHomeAccessNotes
                self.mailBoxTextField.text = s.mailbox
                self.otherRequestsTextField.text = s.otherRequests
                
                if let isMailKey = s.isMailKeyProvided {
                    self.mailKeyView.setValue(isMailKey)
                }
                if let isHome = s.isSomeoneWillBeAtHome {
                    self.someoneWillBeHomeView.setValue(isHome)
                }
                self.commentTextView.text = s.comment
                if let garbageArr = s.garbages {
                    self.garbageView.setupProfileView(garbageArr: garbageArr)
                }
                if let isWater = s.isWaterPlantsExists {
                    if isWater {
                        self.waterPlantsView.vkl()
                    } else {
                        self.waterPlantsView.vukl()
                    }
                }
                self.hideActivityIndicator()
            case .failure(let error):
                self.setupErrorAlert(error: error)
                self.hideActivityIndicator()
            }
        }
    }
}

//MARK: - Actions

extension ShowCustomerProfileViewController {
    @objc func backButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
