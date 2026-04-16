//
//  CheckYourEmailVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 05.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

enum CheckYourEmailVCState {
    case registration
    case forgotPassword
    case changePassword
}

class CheckYourEmailVC: UIViewController {
    
    // MARK: - UI Property
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
    
    private let forgotPassLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Aileron-Bold", size: 30)
        label.textColor = .color293147
        return label
    }()
    
    private let checkEmailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupLayouts()
    }
    
    // MARK: - Setup
    func setup(typeOfVC: CheckYourEmailVCState) {
        switch typeOfVC {
        
        case .registration:
            checkEmailImageView.image = R.image.email_link_registration()
            forgotPassLabel.text = "Email Verification"
            closebutton.isHidden = true
        case .forgotPassword:
            checkEmailImageView.image = R.image.reset_pass()
            forgotPassLabel.text = "Forgot Password"
        case .changePassword:
            checkEmailImageView.image = R.image.reset_pass()
            forgotPassLabel.text = "Change Password"
        }
    }
    
    // MARK: - Selectors
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - SetupLayouts
private extension CheckYourEmailVC {
    func setupLayouts() {
        view.backgroundColor = .white
        view.addSubviews([closebutton, forgotPassLabel, checkEmailImageView])
        closebutton.snp.makeConstraints {
            $0.size.equalTo(17)
            $0.leading.equalToSuperview().inset(50)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(38)
        }
        forgotPassLabel.snp.makeConstraints {
            $0.leading.equalTo(closebutton.snp.trailing).offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(26)
        }
        checkEmailImageView.snp.makeConstraints {
            $0.top.equalTo(forgotPassLabel.snp.bottom).offset(45)
            $0.height.equalTo(263)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(285)
        }
    }
}
