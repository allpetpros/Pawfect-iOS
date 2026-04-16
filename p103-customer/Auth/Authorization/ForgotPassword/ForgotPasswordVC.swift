//
//  ForgotPasswordVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 05.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordVC: BaseViewController {
    
    private var isVerificate: Bool = false
    
    // MARK: - UI Property
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
    private let emailLbl: UILabel = {
        let label = UILabel()
        label.text = "myemail@gmail.com"
        label.font = R.font.aileronRegular(size: 16)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your e-mail address and we'll send you a link to reset your password."
        label.font = R.font.aileronRegular(size: 14)
        label.numberOfLines = 0
        label.textColor = .color606572
        return label
    }()
    
    private let emailTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Email", iconImage: R.image.email(), type: .usual)
        textField.addTarget(self, action: #selector(checkStateOfField), for: .editingChanged)
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 15
        button.redAndGrayStyle(active: false)
        button.setTitle("Reset Password", for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
        button.addTarget(self, action: #selector(resetPasswordButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private let checkBoxValidationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.validationCheckBox()
        return iv
    }()
    
    private let errorLabel: UILabel = {
        let l = UILabel()
        l.text = "This email is not registered yet"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorC6222F
        l.isHidden = true
        return l
    } ()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupLayouts()
        setupNavbar()
        
    }
    
    // MARK: - Validation
    
    @objc func checkStateOfField(field : SkyFloatingLabelTextFieldWithIcon) {
        if let email = field.text {
            errorLabel.isHidden = true
            if isValidEmail(email) {
                setupValidationCheckBox()
                field.style(active: true)
                resetButton.redAndGrayStyle(active: true)
                isVerificate = true
            } else {
                field.style(active: false)
                resetButton.redAndGrayStyle(active: false)
                checkBoxValidationImageView.removeFromSuperview()
                isVerificate = false
            }
        }
    }
}

// MARK: - Setup Layout

extension ForgotPasswordVC {
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
        self.navigationItem.title = "Forgot Password"
        self.navigationController?.navigationBar.isHidden =  false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Aileron-Bold", size: 18)!]
    }
    
    @objc func didTappedBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setupLayouts() {
        view.backgroundColor = .white
        view.addSubviews([emailLbl,descriptionLabel, emailTextField, resetButton, errorLabel])

        emailLbl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(120)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emailLbl.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        errorLabel.snp.makeConstraints {
            $0.left.equalTo(emailTextField)
            $0.top.equalTo(emailTextField.snp.bottom).offset(6)
        }
        
        resetButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(87)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
    }
    
    func setupValidationCheckBox() {
        view.addSubview(checkBoxValidationImageView)
        
        checkBoxValidationImageView.snp.makeConstraints {
            $0.width.equalTo(11)
            $0.height.equalTo(7)
            $0.right.equalTo(emailTextField.snp.right).offset(-10)
            $0.bottom.equalTo(emailTextField.snp.bottom).offset(-15)
        }
    }
}

//MARK: - Navigation

extension ForgotPasswordVC {
    @objc func resetPasswordButtonTouched() {
        if isVerificate {
            checkingEmail()
        }
    }
    
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Network

private extension ForgotPasswordVC {
    func checkingEmail() {
        showActivityIndicator()
        
        guard let email = emailTextField.text else {return}
        
        AuthService().checkEmail(email: email.lowercased()) { result in
            switch result {
            case .success(let s):
                if s.success {
                    self.errorLabel.isHidden = true
                    self.forgotPassword()
                } else {
                    self.errorLabel.isHidden = false
                }
                self.hideActivityIndicator()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func forgotPassword() {
        self.showActivityIndicator()
        
        guard let email = emailTextField.text else {return}

        AuthService().forgotPassword(email: email.lowercased()) { result in
            switch result {

            case .success(_):
                let vc = CheckEmailViewController()
                self.navigationController?.pushViewController(vc, animated: true)
                self.hideActivityIndicator()
            case .failure(let error):
                self.setupErrorAlert(error: error)
                self.hideActivityIndicator()
                self.resetButton.isUserInteractionEnabled = true
            }
        }
    }
}
