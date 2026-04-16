//
//  AddCardVCViewController.swift
//  p103-customer
//
//  Created by Alex Lebedev on 18.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField



class AddCardVC: UIViewController {
    // MARK: - UI Properties
    private let closebutton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.closeTest(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your card details"
        label.font = R.font.aileronRegular(size: 14)
        label.textColor = .color293147
        return label
    }()
    private let cardView: GradientView = {
        let view = GradientView()
        view.topColor = UIColor(red: 0.417, green: 0.417, blue: 0.417, alpha: 1)
        view.bottomColor =  UIColor(red: 0.304, green: 0.304, blue: 0.304, alpha: 1)
        view.layer.cornerRadius = 5
        return view
    }()
    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "Card Number"
        label.font = R.font.aileronLight(size: 12)
        label.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        return label
    }()
    private let thruLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        label.text = "Valid Thru"
        label.font = R.font.aileronLight(size: 12)
        return label
    }()
    private let cvvLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        label.text = "CVV"
        label.font = R.font.aileronLight(size: 12)
        return label
    }()
    lazy var cardNumberTextfield1: SkyFloatingLabelTextField = {
        let textfield = SkyFloatingLabelTextField().cardTextfield(placeholder: "XXXX")
        textfield.tag = 1
        return textfield
    }()
    lazy var  cardNumberTextfield2: SkyFloatingLabelTextField = {
        let textfield = SkyFloatingLabelTextField().cardTextfield(placeholder: "XXXX")
        textfield.tag = 2
        
        return textfield
    }()
    lazy var  cardNumberTextfield3: SkyFloatingLabelTextField = {
        let textfield = SkyFloatingLabelTextField().cardTextfield(placeholder: "XXXX")
        textfield.tag = 3
        
        return textfield
    }()
    lazy var  cardNumberTextfield4: SkyFloatingLabelTextField = {
        let textfield = SkyFloatingLabelTextField().cardTextfield(placeholder: "XXXX")
        textfield.tag = 4
        return textfield
    }()
    private let cardNumbersStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        return stack
    }()
    lazy var  thruTexfield1: SkyFloatingLabelTextField = {
        let textfield = SkyFloatingLabelTextField().cardTextfield(placeholder: "XX")
        textfield.tag = 5
        textfield.lineColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        textfield.addTarget(self, action: #selector(monthTextfieldAcion), for: .editingChanged)
        return textfield
    }()
    private let thruSlashLabel: SkyFloatingLabelTextField = {
        let textfield = SkyFloatingLabelTextField().cardTextfield(placeholder: "/")
        textfield.lineColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        textfield.isUserInteractionEnabled = false
        return textfield
    }()
    lazy var  thruTexfield2: SkyFloatingLabelTextField = {
        let textfield = SkyFloatingLabelTextField().cardTextfield(placeholder: "XX")
        textfield.tag = 6
        textfield.lineColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        textfield.addTarget(self, action: #selector(yearTextfieldAcion), for: .editingChanged)
        return textfield
    }()
    lazy var  cvvTexfield: SkyFloatingLabelTextField = {
        let textfield = SkyFloatingLabelTextField().cardTextfield(placeholder: "XXX")
        textfield.tag = 7
        textfield.lineColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        return textfield
    }()
    
    private let monthErrorField: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .white
        l.text = "Month is Invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
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
    lazy var alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.setupAlert(style: .payment)
        view.delegate = self
        return view
    }()
    // MARK: - Properties
    
    var activityView: UIActivityIndicatorView?
    var month: Int?
    var year: Int?
    var isValidMonth = false
    var isValidYear = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupLayouts()
        addTargetsToField()
    }
    
    // MARK: - Actions
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    @objc func fieldEndEditing(_ textField: SkyFloatingLabelTextField) {
        if textField.text?.count == 4 {
            textField.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
            textField.lineColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        } else {
            textField.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 0.3)
            textField.lineColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 0.3)
        }
    }
    @objc func monthTextfieldAcion() {
        let monthTxt = Int(thruTexfield1.text!) ?? 0
        let date = Date()
        if monthTxt > 12 {
            
            isValidMonth = false
            monthErrorField.isHidden = false
            monthErrorField.text = "Invalid Month"
            
            isValidMonth = false
            
        }
        else {
            isValidMonth = true
            if isValidYear && isValidMonth {
                monthErrorField.isHidden = true
            } else {
                if !isValidMonth && !isValidYear {
                    monthErrorField.isHidden = false
                    monthErrorField.text = "Invalid Month & Year"
                    isValidMonth = true
                    isValidYear = false
                }
            }
        }
    }
    
    @objc func yearTextfieldAcion() {
        let year = Int(thruTexfield2.text!)
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy"
        let yearFromCurrentDate = dateFormatter.string(from: date)
        let currentYear = Int(yearFromCurrentDate) ?? 0
        if thruTexfield2.text!.isEmpty {
            isValidYear = false
        } else if !thruTexfield2.text!.isEmpty {
            if year! < currentYear {
                isValidYear = false
                monthErrorField.isHidden = false
                monthErrorField.text = "Invalid Year"
            } else {
                isValidYear = true
                if isValidYear && isValidMonth {
                    monthErrorField.isHidden = true
                } else {
                    if isValidMonth && !isValidYear {
                        monthErrorField.isHidden = false
                        monthErrorField.text = "Invalid Year"
                        isValidMonth = true
                        isValidYear = false
                    } else if !isValidMonth && isValidYear {
                        monthErrorField.isHidden = false
                        monthErrorField.text = "Invalid Month"
                        isValidMonth = false
                        isValidYear = true
                    }
                }
            }
        }
    }
    
    @objc func fieldChanged(_ textField: SkyFloatingLabelTextField) {
        validation()
        switch textField.tag {
        case 1,2,3,4:
            if textField.text?.count == 4 {
                let tag = textField.tag + 1
                guard let nextResponder: UIResponder = textField.superview!.viewWithTag(tag) else {
                    textField.resignFirstResponder()
                    return
                }
                nextResponder.becomeFirstResponder()
            }
            if textField.text?.count ?? 5 > 4 {
                textField.text = ""
            }
        case 5,6:
            if textField.text?.count == 2 {
                let tag = textField.tag + 1
                guard let nextResponder: UIResponder = textField.superview!.viewWithTag(tag) else {
                    textField.resignFirstResponder()
                    return
                }
                nextResponder.becomeFirstResponder()
            }
            if textField.text?.count ?? 3 > 2 {
                textField.text = ""
            }
            
        case 7:
            if textField.text?.count == 3 {
                let tag = textField.tag + 1
                guard let nextResponder: UIResponder = textField.superview!.viewWithTag(tag) else {
                    textField.resignFirstResponder()
                    return
                }
                nextResponder.becomeFirstResponder()
            }
            if textField.text?.count ?? 4 > 3 {
                textField.text = ""
            }
            
        default:
            return
        }
    }
    
    func validation() {
        if cardNumberTextfield1.text?.count == 4, cardNumberTextfield2.text?.count == 4, cardNumberTextfield3.text?.count == 4, cardNumberTextfield4.text?.count == 4, thruTexfield1.text?.count == 2, thruTexfield2.text?.count == 2, cvvTexfield.text?.count == 3 {
            if isValidMonth && isValidYear {
                doneButton.redAndGrayStyleMain(active: true)
            } else {
                doneButton.redAndGrayStyleMain(active: false)
            }
        } else {
            doneButton.redAndGrayStyleMain(active: false)
        }
    }
    
    @objc func doneButtonTouched() {
        self.showActivityIndicator()
        let finalCardNumber = "\(cardNumberTextfield1.text!)" + "\(cardNumberTextfield2.text!)" + "\(cardNumberTextfield3.text!)" + "\(cardNumberTextfield4.text!)"
        print(finalCardNumber)
        let expirationNumber = "\(thruTexfield1.text!)" + "\(thruTexfield2.text!)"
        let addCard = AddCard(number: finalCardNumber, expiration: expirationNumber, cvc: cvvTexfield.text!)
        PaymentService().addCard(profile: addCard) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                CardRemoverManager.shared.isAdd = true
                self.hideActivityIndicator()
                self.navigationController?.popViewController(animated: true)
            case .failure(let error):
                self.setupErrorAlert(error: error)
                self.hideActivityIndicator()
            }
        }
    }
    

    // MARK: - Private functions
    private func addTargetsToField() {
        let cardFields = [cardNumberTextfield1, cardNumberTextfield2, cardNumberTextfield3, cardNumberTextfield4, thruTexfield1, thruTexfield2, cvvTexfield]
        for value in cardFields {
            value.keyboardType = .numberPad
            value.addTarget(self, action: #selector(fieldChanged), for: .editingChanged)
        }
        cardNumberTextfield1.addTarget(self, action: #selector(fieldEndEditing), for: .editingDidEnd)
        cardNumberTextfield2.addTarget(self, action: #selector(fieldEndEditing), for: .editingDidEnd)
        cardNumberTextfield3.addTarget(self, action: #selector(fieldEndEditing), for: .editingDidEnd)
        cardNumberTextfield4.addTarget(self, action: #selector(fieldEndEditing), for: .editingDidEnd)
    }
}

// MARK: - ActivityIndicator

extension AddCardVC {
    func showActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        }
        
        activityView?.layer.zPosition = 9999
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }

    func hideActivityIndicator(){
        activityView?.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
// MARK: - Set Error Alert
extension AddCardVC {
    func setupErrorAlert(error: Error) {
        if let error = error as? ErrorResponse {
            if error.localizedDescription.contains("Unauthorized") {
                
                self.alertView.setupAlert(description: "Your session has been expired, Please login again.", alertType: .unAuthroized)
            } else {
                self.alertView.setupAlert(description: error.localizedDescription, alertType: .error)
            }

        } else {
            self.alertView.setupAlert(description: error.localizedDescription, alertType: .error)
        }
        self.showCustomBlur()
        self.view.addSubview(self.alertView)
        self.alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
// MARK: - SetupLayouts
extension AddCardVC {
    
    func setupNavbar(){
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
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.title = "Add Payment Method"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Aileron-Bold", size: 18)!]
    }
    
    @objc func didTappedBack() {
        _ = navigationController?.popViewController(animated: true)

    }
    
    func setupLayouts() {
        view.backgroundColor = .white
        view.addSubviews([descriptionLabel, cardView])
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().inset(25)
        }
        cardView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(53)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(190)
        }
        setupCardView()
    }
    
    private func setupCardView() {
        cardView.addSubviews([cardNumberLabel, thruLabel, cvvLabel, cardNumbersStack])
        cardNumberLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(28)
            $0.leading.equalToSuperview().inset(25)
        }
        thruLabel.snp.makeConstraints {
            $0.top.equalTo(cardNumberLabel.snp.bottom).offset(68)
            $0.leading.equalTo(cardNumberLabel)
        }
        cvvLabel.snp.makeConstraints {
            $0.centerY.equalTo(thruLabel)
            $0.trailing.equalToSuperview().inset(39)
        }
        cardNumbersStack.addArrangedSubviews(views: cardNumberTextfield1, cardNumberTextfield2, cardNumberTextfield3, cardNumberTextfield4)
        cardNumbersStack.snp.makeConstraints {
            $0.top.equalTo(cardNumberLabel.snp.bottom).inset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        setupOtherFields()
    }
    
    private func setupOtherFields() {
        cardView.addSubviews([thruTexfield1, thruSlashLabel, thruTexfield2, monthErrorField,cvvTexfield])
        thruTexfield1.snp.makeConstraints {
            $0.top.equalTo(thruLabel.snp.bottom).inset(10)
            $0.leading.equalToSuperview().inset(25)
            $0.width.equalTo(30)
        }
        monthErrorField.snp.makeConstraints {
            $0.top.equalTo(thruTexfield1.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(25)
            
        }
        thruSlashLabel.snp.makeConstraints {
            $0.top.bottom.equalTo(thruTexfield1)
            $0.leading.equalTo(thruTexfield1.snp.trailing)
            $0.width.equalTo(10)
        }
        thruTexfield2.snp.makeConstraints {
            $0.top.bottom.equalTo(thruSlashLabel)
            $0.leading.equalTo(thruSlashLabel.snp.trailing)
            $0.width.equalTo(30)
        }
        cvvTexfield.snp.makeConstraints {
            $0.top.equalTo(cvvLabel.snp.bottom).inset(10)
            $0.trailing.equalToSuperview().inset(25)
            $0.width.equalTo(37)
        }
        self.view.addSubview(doneButton)
        doneButton.snp.makeConstraints {
            $0.top.equalTo(cardView.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
    }
}

// MARK: - CustomAlertViewDelegate

extension AddCardVC: CustomAlertViewDelegate {
    func okButtonTouched(alertType: AlertType) {
        if alertType == .error {
            navigationController?.popViewController(animated: true)
        } else if alertType == .unAuthroized {
            DBManager.shared.removeAccessToken()
            DBManager.shared.saveStatus(0)
            DBManager.shared.removeUserRole()
            let vc = UINavigationController(rootViewController: AuthorizationVC())
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

