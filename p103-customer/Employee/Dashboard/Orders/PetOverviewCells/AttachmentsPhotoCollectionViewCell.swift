//
//  AttachmentsPhotoCollectionViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 19.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class AttachmentsPhotoCollectionViewCell: UICollectionViewCell {
    
    //MARK: - UIProperties
    
    let attachmentImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        return iv
    } ()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Layout
    
    func setupLayout() {
        addSubview(attachmentImageView)
        
        attachmentImageView.snp.makeConstraints {
            $0.size.equalTo(100)
        }
    }
}

