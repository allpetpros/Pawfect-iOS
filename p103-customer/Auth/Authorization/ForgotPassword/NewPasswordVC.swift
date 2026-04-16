//
//  ForgotPasswordNewPasswordVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 05.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

enum NewPasswordVCState {
    case forgotPassword
    case changePassword
}

class NewPasswordVC: BaseViewController {
    
    // MARK: - UI Properties
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
    private let forgotPassLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.font = R.font.aileronBold(size: 18)
        label.textColor = .color293147
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose new password"
        label.font = R.font.aileronBold(size: 18)
        return label
    }()
    private let passwordsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private let oldPasswordTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Old Password", iconImage: R.image.keyTest(), type: .password)
        return textField
    }()
    
    private let newPasswordTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Password", iconImage: R.image.keyTest(), type: .password)
        return textField
    }()
    
    private let passwordErrorLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorC6222F
        return l
    }()
    
    private let confirmNewPasswordTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Confirm Password", iconImage: R.image.keyTest(), type: .password)
        return textField
    }()
    
    private  let doneButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Done", type: .ok, bordered: true)
        
        button.redAndGrayStyleMain(active: false)
        let doneButtonAction = UIButton()
        doneButtonAction.addTarget(self, action: #selector(doneButtonTouched), for: .touchUpInside)
        button.addSubview(doneButtonAction)
        doneButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()

    // MARK: - Properties
    
    private var stateOfScreen: NewPasswordVCState
    
    var passwordChanged = false
    
    var code = String()
    
    //MARK: - Init
    
    init(state: NewPasswordVCState) {
        self.stateOfScreen = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        hideKeyboardWhenTappedAround()
        setupLayouts()
        addTargetsToFields()
        configScreen()
    }
    
    // MARK: - Selectors
    @objc func closeButtonTouched() {
        PresentManager.shared.presentStartScreen()
    }
    
    @objc func doneButtonTouched() {
        guard let newPass = newPasswordTextField.text, let confirmNewPass = confirmNewPasswordTextField.text, let oldPass = oldPasswordTextField.text else { return }
        if newPass == confirmNewPass {
            switch stateOfScreen {
            case .forgotPassword:
                AuthService().forgotPasswordComplite(code: code, newPass: newPass) { (result) in
                    switch result {
                    case .success(_):
                        let vc = PasswordChangeSuccessfullyViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .failure(let error):
                        self.doneButton.redAndGrayStyleMain(active: false)
                        self.showCustomBlur()
                        if let error = error as? ErrorResponse {
                            self.setupErrorAlert(error: error)
                        } else {
                            self.setupErrorAlert(error: error)
                        }
                    }
                }
            case .changePassword:
                AuthService().changePassword(oldPass: oldPass, newPass: confirmNewPass) { result in
                    switch result {
                    
                    case .success(_):
                        let vc = PasswordChangeSuccessfullyViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    case .failure(let error):
                        if let error = error as? ErrorResponse {
                            self.passwordErrorLabel.text = error.localizedDescription
                        }
                    }
                }
            }
        }
    }
    
    @objc func checkStateOfField(field: SkyFloatingLabelTextFieldWithIcon) {
        if field.text?.isEmpty ?? true {
            field.style(active: false)
        } else {
            field.style(active: true)
        }
        
        switch stateOfScreen {
            
        case .forgotPassword:
            if let passwordText = newPasswordTextField.text, let confirmText = confirmNewPasswordTextField.text, !passwordText.isEmpty, !confirmText.isEmpty {
                if passwordText.count >= 5, passwordText == confirmText {
                    doneButton.redAndGrayStyleMain(active: true)
                } else {
                    doneButton.redAndGrayStyleMain(active: false)
                }
            }
        case .changePassword:
            if let passwordText = newPasswordTextField.text, let confirmText = confirmNewPasswordTextField.text, let oldPassword = oldPasswordTextField.text, !passwordText.isEmpty, !confirmText.isEmpty, !oldPassword.isEmpty {
                if passwordText == confirmText {
                    doneButton.redAndGrayStyleMain(active: true)
                } else {
                    doneButton.redAndGrayStyleMain(active: false)
                }
            } else {
                doneButton.redAndGrayStyleMain(active: false)
            }
        }
    }
    
    @objc func didTappedBack() {
        _ = navigationController?.popViewController(animated: true)

    }
    // MARK: - Private functions
    private func configScreen() {
        switch stateOfScreen {
        case .forgotPassword:
            forgotPassLabel.text = "Forgot Password"
            oldPasswordTextField.isHidden = true
        case .changePassword:
            break

        }
    }
    
    private func addTargetsToFields() {
        let massOfField = [newPasswordTextField, confirmNewPasswordTextField, oldPasswordTextField]
        for field in massOfField {
            field.addTarget(self, action: #selector(checkStateOfField), for: .editingChanged)
        }
    }
}

// MARK: - Set Up Layout
extension NewPasswordVC {
    
    func setupNavbar() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        let backButtonImg : UIButton = UIButton.init(type: .custom)
        backButtonImg.setImage(R.image.leftArrow(), for: .normal)
        backButtonImg.addTarget(self, action: #selector(didTappedBack), for: .touchUpInside)
        backButtonImg.frame = CGRect(x: 35, y: 0, width: 30, height: 30)
        let addButton = UIBarButtonItem(customView: backButtonImg)
        self.navigationItem.setLeftBarButtonItems([addButton], animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.title = "Change Password"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Aileron-Bold", size: 18)!]
    }
    
    
    
    func setupLayouts() {
        view.backgroundColor = .white
        view.addSubviews([ descriptionLabel, passwordsStackView, doneButton, passwordErrorLabel])
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        passwordsStackView.addArrangedSubviews(views: oldPasswordTextField, newPasswordTextField, confirmNewPasswordTextField)
        passwordsStackView.snp.makeConstraints {
             $0.top.equalTo(descriptionLabel.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        passwordErrorLabel.snp.makeConstraints {
            $0.top.equalTo(oldPasswordTextField.snp.bottom).offset(3)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        doneButton.snp.makeConstraints {
            $0.top.equalTo(passwordsStackView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
    }
}
