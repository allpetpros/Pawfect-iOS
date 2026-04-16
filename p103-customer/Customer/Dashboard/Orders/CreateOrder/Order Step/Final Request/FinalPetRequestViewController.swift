//
//  FinalPetRequestViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 09.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class FinalPetRequestViewController: UIViewController {
    
    //MARK: - UIProperties
    
    private let checkImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.checkImage()
        return iv
    } ()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Thank you, your pet care request has been received!  We will confirm your order within 24 hours or less."
        l.textColor = .color606572
        l.font = R.font.aileronBold(size: 18)
        l.numberOfLines = 3
        l.textAlignment = .center
        return l
    } ()
    
    private let backToHomeButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.backToHomeImage(), for: .normal)
        b.addTarget(self, action: #selector(backToHomeAction), for: .touchUpInside)
        return b
    } ()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupLayout()
    }
    
    //MARK: - Setup Layout
    
    private func setupLayout() {
        view.addSubviews([checkImageView, descriptionLabel, backToHomeButton])
        
        checkImageView.snp.makeConstraints {
            $0.size.equalTo(222)
            $0.top.equalToSuperview().offset(176)
            $0.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(checkImageView.snp.bottom).offset(80)
            $0.left.equalToSuperview().offset(33)
            $0.centerX.equalToSuperview()
        }
        
        backToHomeButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(65)
            $0.width.equalTo(275)
        }
    }
}

//MARK: - Action

extension FinalPetRequestViewController {
    @objc func backToHomeAction() {
        NotificationCenter.default.post(name: Notification.Name("order"), object: nil)
        let vc = CustomerDashboardTabBarController()
        vc.selectedIndex = 1
        vc.modalPresentationStyle = .currentContext
        self.present(vc, animated: true, completion: nil)
    }
}
