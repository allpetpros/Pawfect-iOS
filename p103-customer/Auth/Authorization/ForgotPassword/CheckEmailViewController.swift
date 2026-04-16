//
//  CheckEmailViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 16.07.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class CheckEmailViewController: UIViewController {

    //MARK: - UIProperties
    
    private let crossButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.closeTest(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.clipsToBounds = true
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    } ()
    
    private let forgotPassLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        return label
    }()
    
    private let forgotPasswordImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.forgotPasswordImage()
        return iv
    } ()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupLayout()
        setupNavbar()
    }

}

//MARK: - Setup Layout

private extension CheckEmailViewController {
    func setupNavbar() {
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
        self.navigationItem.title = "Forgot Password"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Aileron-Bold", size: 18)!]
    }
    
   
    
    func setupLayout() {
        view.addSubviews([forgotPasswordImageView])

        forgotPasswordImageView.snp.makeConstraints {
            $0.width.equalTo(283)
            $0.height.equalTo(263)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

//MARK: - Selectors

extension CheckEmailViewController {
    @objc func closeButtonTouched() {
        PresentManager.shared.presentStartScreen()
    }
    
    @objc func didTappedBack() {
        _ = navigationController?.popViewController(animated: true)

    }
}
