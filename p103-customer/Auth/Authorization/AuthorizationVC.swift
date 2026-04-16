//
//  AuthorizationVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 05.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField
import Moya

class AuthorizationVC: BaseViewController {
    
    // MARK: - UI Property
    private let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = R.image.logo()
        return view
    }()
    private lazy var emailTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Email", iconImage: R.image.email(), type: .usual)
        textField.keyboardType = .emailAddress
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 1
        return textField
    }()
    
    private let errorEmailLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textColor = .colorC6222F
        label.font = R.font.aileronLight(size: 12)
        return label
    }()
    
    private lazy var passwordTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Password", iconImage: R.image.keyTest(), type: .usual)
        textField.delegate = self
        textField.isSecureTextEntry = true
        textField.returnKeyType = UIReturnKeyType.done
        textField.tag = 2
        return textField
    } ()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 15
        button.redAndGrayStyle(active: false)
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
        button.addTarget(self, action: #selector(signInButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Do not have an account?"
        label.font = R.font.aileronRegular(size: 14)
        label.textColor = .color606572
        label.textAlignment = .right
        label.snp.makeConstraints {
            $0.width.equalTo(156)
        }
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let registerButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Register", type: .nextSmall, bordered: true)
        button.borderColor = .colorC6222F
        button.snp.makeConstraints {
            $0.width.equalTo(110)
            $0.height.equalTo(30)
        }
        let registerButtonAction = UIButton()
        registerButtonAction.addTarget(self, action: #selector(registerButtonTouched), for: .touchUpInside)
        button.addSubview(registerButtonAction)
        registerButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    private let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Forgot Password?", for: .normal)
        button.titleLabel?.font = R.font.aileronRegular(size: 14)
        button.setTitleColor(.colorC6222F, for: .normal)
        button.addTarget(self, action: #selector(forgotPasswordButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private let checkBoxValidationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.validationCheckBox()
        return iv
    }()
    
    private var passwordBtnTapped: UIButton {
        let b = UIButton()
        b.setImage(R.image.close_eye(), for: .normal)
        return b
    }
    
    private let errorCrossButton: UIButton = {
        let iv = UIButton()
        iv.setImage(R.image.crossForTextFieldError(), for: .normal)
        iv.addTarget(self, action: #selector(errorCrossAction), for: .touchUpInside)
        return iv
    }()
    
    //MARK: - Properties
    
    private var isValid = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
       
        setupLayouts()
        addTargetsToFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        emailTextField.text = ""
        passwordTextField.text = ""
        checkBoxValidationImageView.isHidden = true
        errorEmailLabel.isHidden = true
        errorCrossButton.isHidden = true
        signInButton.redAndGrayStyle(active: false)
        hideActivityIndicator()
    }
}

// MARK: - Network

extension AuthorizationVC {
    private func signIn() {
        let email = emailTextField.text!
        let loginRequestParameter = SignInRequest(email: email.lowercased(), password: passwordTextField.text!, deviceToken: DBManager.shared.getDeviceToken() ?? "", deviceType: 1)
        print("loginRequestParameter",loginRequestParameter)
        AuthService().signIn(profile: loginRequestParameter) { result in
            switch result {
            case .success(let userData):
                print("Access Token",result)
                self.errorEmailLabel.isHidden = true
                DBManager.shared.saveAccessToken(userData.accessToken)
                DBManager.shared.saveUserRole(userData.role)
                if userData.role == "employee" {
                    let vc = EmployeeDashboardTabBarController()
                    self.navigationController?.navigationBar.isHidden = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    self.hideActivityIndicator()
                } else {
                    DBManager.shared.saveStatus(userData.status!)
                    let status = DBManager.shared.getStatus()
                    if status == 1 {
                        let vc = CustomerDashboardTabBarController()
                        self.hideActivityIndicator()
                        self.navigationController?.navigationBar.isHidden = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = RegistrationMainVC()
                        self.hideActivityIndicator()
                        self.navigationController?.navigationBar.isHidden = false
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            case .failure(let error):
                self.setupErrorCross()
                self.signInButton.isUserInteractionEnabled = false
                self.signInButton.redAndGrayStyle(active: false)
                if let error = error as? ErrorResponse {
                    self.errorEmailLabel.isHidden = false
                    self.errorEmailLabel.text = "\(error.localizedDescription)"
                } else if let error = error as? Moya.MoyaError {
                    
                }
                self.hideActivityIndicator()
            }
        }
    }
}

// MARK: - Setup Layouts

private extension AuthorizationVC {
    func setupLayouts() {
        view.addSubviews([logoImageView, emailTextField,errorEmailLabel, passwordTextField, signInButton,forgotPasswordButton, bottomStackView])
        logoImageView.snp.makeConstraints {
            $0.height.equalTo(110)
            $0.width.equalTo(90)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(65)
            $0.centerX.equalToSuperview()
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(54)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        errorEmailLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(4)
            $0.leading.equalTo(emailTextField)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        forgotPasswordButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(10)
            $0.leading.equalTo(passwordTextField)
        }
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(88)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
        bottomStackView.addArrangedSubviews(views: dontHaveAccountLabel, registerButton)
        bottomStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(34)
        }
        
    }
    
    func setupValidationCheckBox() {
        
        view.addSubview(checkBoxValidationImageView)
        checkBoxValidationImageView.isHidden = false

        checkBoxValidationImageView.snp.makeConstraints {
            $0.width.equalTo(11)
            $0.height.equalTo(7)
            $0.right.equalTo(emailTextField.snp.right).offset(-10)
            $0.bottom.equalTo(emailTextField.snp.bottom).offset(-15)
        }
    }
    
    func setupErrorCross() {
        checkBoxValidationImageView.isHidden = true
        view.addSubview(errorCrossButton)
        errorCrossButton.isHidden = false
        errorCrossButton.snp.makeConstraints {
            $0.width.equalTo(8)
            $0.height.equalTo(8)
            $0.right.equalTo(emailTextField.snp.right).offset(-10)
            $0.bottom.equalTo(emailTextField.snp.bottom).offset(-15)
        }
    }
}

//MARK: - Add target to properties

extension AuthorizationVC {
    private func addTargetsToFields() {
        let massOfField = [emailTextField, passwordTextField]
        for field in massOfField {
            field.addTarget(self, action: #selector(checkStateOfField), for: .editingChanged)
        }
    }
}

//MARK: - UITextField Delegate

extension AuthorizationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         // Try to find next responder
         if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
         } else {
            textField.resignFirstResponder()
         }
         return false
      }
}

//MARK: - Selectors

extension AuthorizationVC {
    @objc func errorCrossAction() {
        emailTextField.text = ""
        passwordTextField.text = ""
        errorEmailLabel.text = ""
        errorCrossButton.isHidden = true
        addTargetsToFields()
    }
    
    @objc func checkStateOfField(field : SkyFloatingLabelTextFieldWithIcon) {
        errorCrossButton.removeFromSuperview()
        if field.text?.isEmpty ?? true {
            field.style(active: false)
        } else {
            field.style(active: true)
            errorEmailLabel.isHidden = true
        }
        
        if let checkEmail = emailTextField.text {
            isValidEmail(checkEmail) ? setupValidationCheckBox() : checkBoxValidationImageView.removeFromSuperview()
        }
        
        if let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty {
            if isValidEmail(email) , password.count >= 5 {
                isValid = true
                signInButton.redAndGrayStyle(active: true)
                signInButton.isUserInteractionEnabled = true
            } else {
                isValid = false
                signInButton.redAndGrayStyle(active: false)
            }
        } else {
            isValid = false
            signInButton.redAndGrayStyle(active: false)
        }
    }
    
    @objc func forgotPasswordButtonTouched() {
        let vc = ForgotPasswordVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func registerButtonTouched() {
        let vc = RegisterEmailVC()
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.navigationBar.isHidden = false

    }
    
    @objc func signInButtonTouched() {
        
        if isValid {
            guard let email = emailTextField.text,
                  let pass = passwordTextField.text else { return }
            signInButton.isUserInteractionEnabled = false
            showActivityIndicator()
            if !email.isEmpty, !pass.isEmpty {
                if isValidEmail(email) , pass.count >= 5 {
                    errorEmailLabel.isHidden = true
                    signIn()
                } else {
                    setupErrorCross()
                    errorEmailLabel.isHidden = false
                    checkBoxValidationImageView.removeFromSuperview()
                    passwordTextField.text = ""
                    self.hideActivityIndicator()
                }
            }
        }
    }
}
