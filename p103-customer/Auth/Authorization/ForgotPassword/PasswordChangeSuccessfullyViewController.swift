//
//  PasswordChangeSuccessfullyViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 31.03.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class PasswordChangeSuccessfullyViewController: UIViewController {

    //MARK: - UIProperties
    
    private let closebutton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.closeTest(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.clipsToBounds = true
        button.tintColor = .black
        button.setImage(R.image.leftArrow(), for: .normal)
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private let emailImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.changePasswordImage()
        return iv
    }()
    
    private let changePasswordLabel: UILabel = {
        let l = UILabel()
        l.text = "Your password changed\n successfully"
        l.font = R.font.aileronSemiBold(size: 18)
        l.textColor = .color606572
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupLayout()
    }
    //MARK: - Custom Functions
    
    func setupLayout() {
        view.addSubviews([emailImageView, changePasswordLabel])

        emailImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(245)
            $0.height.equalTo(215)
        }
        
        changePasswordLabel.snp.makeConstraints {
            $0.top.equalTo(emailImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
    
}

//MARK: - Selectors

extension PasswordChangeSuccessfullyViewController {
    @objc func closeButtonTouched() {
        PresentManager.shared.presentStartScreen()
    }
}
