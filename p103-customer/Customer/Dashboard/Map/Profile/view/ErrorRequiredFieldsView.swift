//
//  ErrorRequiredFieldsView.swift
//  p103-customer
//
//  Created by Daria Pr on 18.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class ErrorRequiredFieldsView: UIView {
    //MARK: - UIProperties
    
    private let errorLabel: UILabel = {
        let l = UILabel()
        l.text = "This field should not be empty*"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorC6222F
        return l
    } ()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Layout

private extension ErrorRequiredFieldsView {
    func setupLayout() {
        addSubview(errorLabel)
        
        errorLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview()
        }
    }
}

//MARK: - Public func

extension ErrorRequiredFieldsView {
    func setup(isHidden: Bool, text: String) {
        errorLabel.isHidden = isHidden
        errorLabel.text = text
    }
}
