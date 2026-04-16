//
//  ReviewEmployeeTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 27.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class ReviewEmployeeTableViewCell: UITableViewCell {

    //MARK: - UIProperties
    
    private let reviewersPhotoImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    } ()
    
    private let reviewersNameLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronBold(size: 18)
        return l
    } ()
    
    private let rateView: CosmosView = {
        let v = CosmosView()
        v.settings.starSize = 15
        v.settings.starMargin = 3
        v.isUserInteractionEnabled = false
        return v
    } ()
    
    private let commentLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color606572
        return l
    } ()
    
    //MARK: - Lifecycle
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 20
        
        selectionStyle = .none
        
        setupLayout()
    }
    
    //MARK: - Setup Layout
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    private func setupLayout() {
        addSubviews([reviewersPhotoImageView, reviewersNameLabel, rateView, commentLabel])
        
        reviewersPhotoImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.left.equalToSuperview().offset(25)
            $0.top.equalToSuperview().offset(25)
        }
        
        reviewersNameLabel.snp.makeConstraints {
            $0.left.equalTo(reviewersPhotoImageView.snp.right).offset(25)
            $0.top.equalToSuperview().offset(24)
        }
        
        rateView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(reviewersPhotoImageView.snp.bottom).offset(10)
        }
        
        commentLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(rateView.snp.bottom).offset(10)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}

//MARK: - Public methods

extension ReviewEmployeeTableViewCell {
    func setupReview(ratings: RatingItems) {
        reviewersNameLabel.text = "\(ratings.name) \(ratings.surname)"
        commentLabel.text = ratings.comment
        rateView.rating = Double(ratings.rate ?? 0.0)
        reviewersPhotoImageView.image = R.image.pet_photo_placeholder()
    }
}
