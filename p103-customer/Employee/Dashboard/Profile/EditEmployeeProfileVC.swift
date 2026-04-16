//
//  EditEmployeeProfileVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 15.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class EditEmployeeProfileVC: UIViewController {
    
    // MARK: - UI Property
    private let scrollView = UIScrollView()
    private let mainView = UIView()
    
    private let closebutton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.closeTest(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.clipsToBounds = true
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    }()
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Account"
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        return label
    }()
    private let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = R.image.employee_test()
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    private let profileEditImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = R.image.editPhoto()
        return profileImageView
    }()
    
    private let nameStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 20
        return stack
    }()
    private let nameTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Name")
        return textField
    }()
    private let lastnameTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Last Name")
        return textField
    }()
    private let timeTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Time available", iconImage: R.image.clock(), type: .usual)
        return textField
    }()
    private let contactsLabel: UILabel = {
        let label = UILabel()
        label.text = "Contacts"
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color606572
        return label
    }()
    private let contactsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    private let emailTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Email", iconImage: R.image.email(), type: .usual)
        return textField
    }()
    private let phoneTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Mobile Phone", iconImage: R.image.phone(), type: .usual)
        return textField
    }()
    // MARK: - Emergency Contacts
    private let emergency1ContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #1", iconImage: R.image.phone(), type: .usual)
        return textField
    }()
    private let emergency1ContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #1 Name", iconImage: R.image.phone(), type: .usual)
        return textField
    }()
    private let emergency2ContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #2", iconImage: R.image.phone(), type: .usual)
        textField.isHidden = true
        return textField
    }()
    private let emergency2ContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #2 Name", iconImage: R.image.phone(), type: .usual)
        textField.isHidden = true
        return textField
    }()
    private let emergency3ContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #3", iconImage: R.image.phone(), type: .usual)
        textField.isHidden = true
        return textField
    }()
    private let emergency3ContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #3 Name", iconImage: R.image.phone(), type: .usual)
        textField.isHidden = true
        return textField
    }()
    
    let addContactButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Add Contact", type: .plus, bordered: true)
        let addContactButtonAction = UIButton()
        addContactButtonAction.addTarget(self, action: #selector(addContactButtonTouched), for: .touchUpInside)
        button.addSubview(addContactButtonAction)
        addContactButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color606572
        return label
    }()
    private let addressTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Street Address", iconImage: R.image.location(), type: .usual)
        return textField
    }()
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 15
        button.redAndGrayStyle(active: true)
        button.setTitle("Confirm", for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
        button.addTarget(self, action: #selector(confirmButtonTouched), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setInfo()
    }
    
    // MARK: - Selectors
    @objc func closeButtonTouched() {
        navigationController?.popViewController(animated: true)
    }
    @objc func addContactButtonTouched(sender: UIButton) {
        if emergency2ContactTextField.isHidden {
            emergency2ContactTextField.isHidden = false
            emergency2ContactNameTextField.isHidden = false
            return
        }
        if emergency3ContactTextField.isHidden {
            emergency3ContactTextField.isHidden = false
            emergency3ContactNameTextField.isHidden = false
            addContactButton.redAndGrayStyleAdditional(active: false)
            return
        }
    }
    @objc func confirmButtonTouched() {
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Functions
    private func setInfo() {
        guard let profile = DBManager.shared.getEmployeeProfile() else {
            navigationController?.popViewController(animated: true)
            return
        }
        timeTextField.text = profile.workIntervalString
        nameTextField.text = profile.name
        lastnameTextField.text = profile.surname
        emailTextField.text = profile.email
        phoneTextField.text = profile.phoneNumber
        addressTextField.text = profile.homeAddress
        for (index, emergency) in profile.emergences.enumerated() {
            if index == 0 {
                emergency1ContactNameTextField.text = emergency.name
                emergency1ContactTextField.text = emergency.phoneNumber
            }
            if index == 1 {
                emergency2ContactNameTextField.text = emergency.name
                emergency2ContactTextField.text = emergency.phoneNumber
                emergency2ContactNameTextField.isHidden = false
                emergency2ContactTextField.isHidden = false
            }
            if index == 2 {
                emergency3ContactNameTextField.text = emergency.name
                emergency3ContactTextField.text = emergency.phoneNumber
                emergency3ContactNameTextField.isHidden = false
                emergency3ContactTextField.isHidden = false
            }
        }
        
    }
}

// MARK: - Extensions
extension EditEmployeeProfileVC {
    private func setupLayouts() {
        view.backgroundColor = .white
        setupScrollViewLayouts()
        setupTopPart()
        setupContacts()
        setupAddress()
    }
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
    private func setupTopPart() {
        mainView.addSubviews([closebutton, registerLabel, profileImageView, profileEditImageView, nameStackView, timeTextField])
        
        closebutton.snp.makeConstraints {
            $0.size.equalTo(17)
            $0.leading.equalToSuperview().inset(50)
            $0.top.equalToSuperview().inset(38)
        }
        registerLabel.snp.makeConstraints {
            $0.leading.equalTo(closebutton.snp.trailing).offset(20)
            $0.top.equalToSuperview().inset(26)
        }
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(55)
            $0.top.equalTo(registerLabel.snp.bottom).offset(48)
            $0.leading.equalToSuperview().inset(25)
        }
        profileEditImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerX.equalTo(profileImageView.snp.trailing).inset(5)
            $0.centerY.equalTo(profileImageView.snp.bottom).inset(5)
        }
        nameStackView.addArrangedSubviews(views: nameTextField, lastnameTextField)
        nameStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        timeTextField.snp.makeConstraints {
            $0.top.equalTo(nameStackView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
    }
    private func setupContacts() {
        mainView.addSubviews([contactsLabel,contactsStackView, addContactButton])
        contactsLabel.snp.makeConstraints {
            $0.top.equalTo(timeTextField.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(25)
        }
        contactsStackView.addArrangedSubviews(views: emailTextField, phoneTextField, emergency1ContactTextField,emergency1ContactNameTextField, emergency2ContactTextField, emergency2ContactNameTextField,emergency3ContactTextField, emergency3ContactNameTextField)
        contactsStackView.snp.makeConstraints {
            $0.top.equalTo(contactsLabel.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        addContactButton.snp.makeConstraints {
            $0.width.equalTo(146)
            $0.height.equalTo(30)
            $0.top.equalTo(contactsStackView.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().inset(25)
        }
    }
    private func setupAddress() {
        mainView.addSubviews([addressLabel, addressTextField, confirmButton])
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(contactsStackView.snp.bottom).offset(80)
            $0.leading.equalToSuperview().inset(25)
        }
        addressTextField.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        confirmButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.top.equalTo(addressTextField.snp.bottom).offset(36)
            $0.bottom.equalTo(mainView.safeAreaLayoutGuide).inset(36)
        }
    }
}

