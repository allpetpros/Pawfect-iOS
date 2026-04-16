//
//  RegisterEmailVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 06.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterEmailVC: BaseViewController {
    
    
    // MARK: - UI Properties

    
    private lazy var emailTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Email*", iconImage: R.image.email(), type: .usual)
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(emailAction), for: .editingChanged)
        textField.tag = 2
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        return textField
    }()
    
    private lazy var passwordTextField: SkyFloatingLabelTextFieldWithIcon = {
        
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Password*", iconImage: R.image.keyTest(), type: .usual)
        textField.isSecureTextEntry = true
        textField.tag = 3
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        return textField
    } ()
    
    private lazy var confirmPasswordTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Confirm Password*", iconImage: R.image.keyTest(), type: .usual)
        textField.isSecureTextEntry = true
        textField.tag = 4
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    } ()
  
    private let leftArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .color070F24
        imageView.image = R.image.leftArrow()
        return imageView
    }()
    private lazy var zipTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Zip*", iconImage: R.image.zip(), type: .usual)
        textField.addTarget(self, action: #selector(zipAction), for: .editingChanged)
        textField.keyboardType = .numberPad
        textField.tag = 1
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        return textField
    }()
    
    private let policyAgreementLabel: UILabel = {
        let label = UILabel()
        let text = NSMutableAttributedString(string: "View policy agreement", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.attributedText = text
        label.font = R.font.aileronRegular(size: 14)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var policyAgreementButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.delegate = self
        button.setup(component: .policyAgreement, typeOfCheckbox: .ok, typeOfText: .black)
        return button
    }()
    
    private let nextButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Agree and Next", type: .nextBig, bordered: true)
        button.redAndGrayStyleMain(active: false)
        let doneButtonAction = UIButton()
        doneButtonAction.addTarget(self, action: #selector(nextButtonTouched), for: .touchUpInside)
        button.addSubview(doneButtonAction)
        doneButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    private let checkBoxValidationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.validationCheckBox()
        return iv
    }()
    
    private let checkBoxConfirmPasswordValidationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.validationCheckBox()
        return iv
    }()
    
    private let errorUnderEmailLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderZipLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderPasswordLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()

    // MARK: - Property
    
    private var isPolicyAgree = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        hideKeyboardWhenTappedAround()
        setupLayouts()
        addTargetsToFields()
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        policyAgreementLabel.addGestureRecognizer(guestureRecognizer)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        nextButton.isUserInteractionEnabled = false
    }
    
   
    
   
}

//MARK: - Alert Action
extension RegisterEmailVC {
    func showSimpleAlert() {
        let alert = UIAlertController(title: "", message: "Policy Agreement is not available currently",preferredStyle:UIAlertController.Style.alert)
        
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - UITextField Delegate
extension RegisterEmailVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
         } else {
            textField.resignFirstResponder()
         }
         return false
      }
}

// MARK: - Validation

extension RegisterEmailVC {
    @objc func checkStateOfField(field: SkyFloatingLabelTextFieldWithIcon) {
        if field.text?.isEmpty ?? true {
            field.style(active: false)
        } else {
            field.style(active: true)
        }
        
        checkStateOfNextButton()
    }
    
    private func checkStateOfNextButton() {
        if let email = emailTextField.text,
           let password = passwordTextField.text,
           let confirmText = confirmPasswordTextField.text,
           let zip = zipTextField.text,
           !email.isEmpty,
           !password.isEmpty,
           !confirmText.isEmpty,
           !zip.isEmpty {
            if zip.isValidZip, isValidEmail(email), !password.isEmpty, password.count >= 5, password == confirmText, isPolicyAgree {
                nextButton.redAndGrayStyleMain(active: true)
            } else {
                nextButton.redAndGrayStyleMain(active: false)
            }
        }
    }
    
    private func setupValidationPasswordCheckBox() {
        view.addSubview(checkBoxValidationImageView)
        
        checkBoxValidationImageView.snp.makeConstraints {
            $0.width.equalTo(11)
            $0.height.equalTo(7)
            $0.right.equalTo(passwordTextField.snp.right).offset(-10)
            $0.bottom.equalTo(passwordTextField.snp.bottom).offset(-15)
        }
    }
    
    private func setupValidationConfirmedPasswordCheckBox() {
        view.addSubview(checkBoxConfirmPasswordValidationImageView)
        
        checkBoxConfirmPasswordValidationImageView.snp.makeConstraints {
            $0.width.equalTo(11)
            $0.height.equalTo(7)
            $0.right.equalTo(confirmPasswordTextField.snp.right).offset(-10)
            $0.bottom.equalTo(confirmPasswordTextField.snp.bottom).offset(-15)
        }
    }
}

//MARK: - Password`s actions

extension RegisterEmailVC {
    @objc func passwordAction() {
        if let password = passwordTextField.text {
            if password.count >= 4 && password.count <= 27 {
                setupValidationPasswordCheckBox()
            } else {
                checkBoxValidationImageView.removeFromSuperview()
            }

            if let password = passwordTextField.text , let passwordConfirmed = confirmPasswordTextField.text {
               
                    if passwordConfirmed == password {
                        setupValidationConfirmedPasswordCheckBox()
                    } else {
                        checkBoxConfirmPasswordValidationImageView.removeFromSuperview()
                    }
                if password == "" && passwordConfirmed == "" {
                    checkBoxConfirmPasswordValidationImageView.removeFromSuperview()
                }
                
            }
        }
    }
    
    @objc func repeatPasswordAction() {
        checkBoxConfirmPasswordValidationImageView.removeFromSuperview()
        if let passwordConfirmed = confirmPasswordTextField.text, let password = passwordTextField.text {
            if passwordConfirmed.count >= 4 && passwordConfirmed.count <= 27 {
                if password == passwordConfirmed {
                    setupValidationConfirmedPasswordCheckBox()
                } else {
                    checkBoxConfirmPasswordValidationImageView.removeFromSuperview()
                }
            }
        }
    }
}

// MARK: - ButtonWithTrailingCheckboxDelegate

extension RegisterEmailVC: ButtonWithTrailingCheckboxDelegate {
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool) {
        if questions == .policyAgreement {
            self.isPolicyAgree = answer
        }
        checkStateOfNextButton()
    }
}

//MARK: - Setup Properties targets

private extension RegisterEmailVC {
    func addTargetsToFields() {
        let massOfField = [emailTextField, passwordTextField, confirmPasswordTextField, zipTextField]
        for field in massOfField {
            field.addTarget(self, action: #selector(checkStateOfField), for: .editingChanged)
        }
        passwordTextField.addTarget(self, action: #selector(passwordAction), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(repeatPasswordAction), for: .editingChanged)
    }
}

//MARK: - Actions

extension RegisterEmailVC {

    @objc func didTappedBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //
    @objc func labelClicked(_ sender: Any) {
//        Toast.show(message: "Policy Agreement is not available currently", controller: self)
        showSimpleAlert()
    }
    
    @objc func nextButtonTouched() {
       
        signUp()
        nextButton.isUserInteractionEnabled = false
        
        if let zip = zipTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
            RegistrationManager.shared.email = email.lowercased()
            RegistrationManager.shared.password = password
            RegistrationManager.shared.zip = zip
            checkEmail(email: email.lowercased())
        }
        
    }
    
    @objc func zipAction() {
        if let zip = zipTextField.text {
            if zip.count >= 5 {
                errorUnderZipLabel.isHidden = true
                errorUnderZipLabel.text = ""
            } else {
                errorUnderZipLabel.text = "Zip is invalid"
                errorUnderZipLabel.isHidden = false
            }
        }
    }
    
    @objc func emailAction() {
        if let email = emailTextField.text {
            if isValidEmail(email) {
                errorUnderEmailLabel.isHidden = true
                errorUnderEmailLabel.text = ""
            } else {
                errorUnderEmailLabel.isHidden = false
                errorUnderEmailLabel.text = "Email is invalid"
            }
        }
    }
}

//MARK: - Network

extension RegisterEmailVC {
    
    func checkZipCode(zipCode: String) {
        
        AuthService().checkZip(zip: zipCode) { (result) in
            switch result {
            case .success(let s):
                if s.success {
                } else {
                    self.setupZipErrorAlert()
                }
            case .failure(_):
                self.hideActivityIndicator()
                self.setupZipErrorAlert()
            }
        }
    }
    
    func checkEmail(email: String) {
        
        AuthService().checkEmail(email: email) { (result) in
            switch result {
            case .success(let s):
                if s.success {
                    self.errorUnderEmailLabel.text = "This email is already exist"
                    self.errorUnderEmailLabel.isHidden = false
                    self.nextButton.redAndGrayStyleMain(active: false)
                } else {
                    self.checkZipCode(zipCode: RegistrationManager.shared.zip)
                }
            case .failure(let error):
                self.hideActivityIndicator()
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    private func signUp() {
        showActivityIndicator()
        let email = emailTextField.text
        let profile = RegistrationFile(email: email!.lowercased(), password: passwordTextField.text!, zipCode: zipTextField.text!, deviceToken: DBManager.shared.getDeviceToken() ?? "", deviceType: 1)
        
        AuthService().signUpStep(profile: profile, completion: {[self] result in
            print("Result",result)
            switch result {
            case .success(let response):
                DBManager.shared.saveAccessToken(response.accesToken)
                let vc = RegistrationMainVC()
                DBManager.shared.saveStatus(0)
                DBManager.shared.saveUserRole("customer")
                self.navigationController?.pushViewController(vc, animated: true)
                self.hideActivityIndicator()
            case .failure(let error):
                self.hideActivityIndicator()
                self.setupErrorAlert(error: error)
                nextButton.isUserInteractionEnabled = true
                
            }
        })
    }
}
//MARK: - Setup Alert

private extension RegisterEmailVC {
    func setupZipErrorAlert() {
        setupWarning(alert: "Unfortunately we aren't providing services in your City", isOrders: false)
        nextButton.redAndGrayStyleMain(active: false)
    }
}

// MARK: - SetupLayouts

private extension RegisterEmailVC {
    func setupNavbar() {
        self.navigationController?.navigationBar.isHidden = false
        let backButtonImg : UIButton = UIButton.init(type: .custom)
        backButtonImg.setImage(R.image.leftArrow(), for: .normal)
        backButtonImg.addTarget(self, action: #selector(didTappedBack), for: .touchUpInside)
        backButtonImg.frame = CGRect(x: 35, y: 0, width: 30, height: 30)
        let addButton = UIBarButtonItem(customView: backButtonImg)
        self.navigationItem.setLeftBarButtonItems([addButton], animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.title = "Step 1. Email and Password"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Aileron-Bold", size: 18)!]
    }
    
    func setupLayouts() {
        view.backgroundColor = .white
        view.addSubviews([emailTextField, passwordTextField, confirmPasswordTextField, zipTextField, policyAgreementLabel, policyAgreementButton, nextButton, errorUnderEmailLabel, errorUnderZipLabel, errorUnderPasswordLabel])

        zipTextField.snp.makeConstraints {

            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(25)
            $0.trailing.equalToSuperview().inset(45)
        }
        errorUnderZipLabel.snp.makeConstraints {
            $0.top.equalTo(zipTextField.snp.bottom).offset(4)
            $0.leading.equalTo(zipTextField)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(zipTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(25)
            $0.trailing.equalToSuperview().inset(45)
        }
        errorUnderEmailLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(4)
            $0.leading.equalTo(emailTextField)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(25)
            $0.trailing.equalToSuperview().inset(45)
        }
        errorUnderPasswordLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(4)
            $0.leading.equalTo(passwordTextField)
        }
        confirmPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(25)
            $0.trailing.equalToSuperview().inset(45)
        }
        policyAgreementLabel.snp.makeConstraints {
            $0.top.equalTo(confirmPasswordTextField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(25)
        }
        policyAgreementButton.snp.makeConstraints {
            $0.top.equalTo(policyAgreementLabel.snp.bottom).offset(21)
            $0.height.equalTo(20)
            $0.width.equalTo(144)
            $0.leading.equalToSuperview().inset(25)
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(policyAgreementButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
    }
}
