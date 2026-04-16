//
//  ShareWithFriendAlertViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 30.03.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ShareWithFriendAlertViewController: BaseViewController {

    //MARK: - UIProperties
    
    private let mainView = UIView()
    
    private let alertBoxImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.alertFriendsBoxImageView()
        return iv
    } ()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Share with a friend"
        l.textColor = .color070F24
        l.font = R.font.aileronBold(size: 18)
        return l
    } ()
    
    private let emailTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Enter email address")
        tf.keyboardType = .emailAddress
        tf.addTarget(self, action: #selector(emailTextFieldAction), for: .editingChanged)
        return tf
    } ()

    private let sendButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Send", type: .create, bordered: true)
        button.redAndGrayStyleMain(active: false)
        let doneButtonAction = UIButton()
        doneButtonAction.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        button.addSubview(doneButtonAction)
        doneButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    //MARK: - Properties
    
    private var emailString = ""
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(mainView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideScreen))
        tap.delegate = self
        mainView.addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 1

        alertBoxImageView.isUserInteractionEnabled = true
        setupLayout()
    }
}

//MARK: - Setup Layout

private extension ShareWithFriendAlertViewController {
    
    func setupLayout() {
        view.addSubviews([alertBoxImageView, titleLabel, emailTextField, sendButton])
        
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertBoxImageView.snp.makeConstraints {
            $0.height.equalTo(194)
            $0.width.equalTo(327)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(alertBoxImageView.snp.top).offset(25)
            $0.centerX.equalTo(alertBoxImageView)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(alertBoxImageView.snp.top).offset(72)
            $0.width.equalTo(307)
            $0.left.equalTo(alertBoxImageView).offset(10)
        }
        
        sendButton.snp.makeConstraints {
            $0.top.equalTo(alertBoxImageView.snp.top).offset(139)
            $0.width.equalTo(120)
            $0.centerX.equalTo(alertBoxImageView)
        }
    }
}

//MARK: - Actions

extension ShareWithFriendAlertViewController {
    @objc func sendButtonAction() {
        print("Email", emailString)
        let email = emailString.lowercased()
        CustomerService().shareWithFriends(email: email) { result in

            switch result {

            case .success(_):
                
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func emailTextFieldAction() {
        if let email = emailTextField.text {
            emailString = email
            if emailConform(to: email) {
                sendButton.redAndGrayStyleMain(active: true)
            } else {
                sendButton.redAndGrayStyleMain(active: false)
            }
        }
    }
    
    @objc func hideScreen() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UIGestureRecognizerDelegate

extension ShareWithFriendAlertViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
