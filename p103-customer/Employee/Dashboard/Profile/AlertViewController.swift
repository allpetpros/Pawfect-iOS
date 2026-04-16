//
//  AlertViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 23.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
    
    //MARK: - UIProperties
    
    private let mainView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        return v
    } ()
    
    private let alertBoxImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.alertBox()
        return iv
    } ()
    
    private let messageLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 18)
        l.textColor = .color070F24
        l.textAlignment = .center
        l.numberOfLines = 3
        return l
    } ()
    
    private let okButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.okBtnImage(), for: .normal)
        b.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        return b
    } ()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    //MARK: - Setup Layoutt
    
    func setupLayout() {
        view.addSubviews([mainView, alertBoxImageView, messageLabel, okButton])
        
        mainView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        alertBoxImageView.snp.makeConstraints {
            $0.width.equalTo(327)
            $0.height.equalTo(164)
            $0.center.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints {
            $0.top.equalTo(alertBoxImageView.snp.top).offset(24)
            $0.left.equalTo(alertBoxImageView).offset(24)
            $0.right.equalTo(alertBoxImageView).offset(-24)
        }
        
        okButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(120)
            $0.bottom.equalTo(alertBoxImageView)
            $0.centerX.equalToSuperview()
        }
    }
}

//MARK: - Open func

extension AlertViewController {
    func setupAlertMessage(message: String) {
        messageLabel.text = message
    }
}

//MARK: - Action

extension AlertViewController {
    @objc func okButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}
