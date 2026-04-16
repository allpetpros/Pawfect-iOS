//
//  CardCollectionViewCell.swift
//  p103-customer
//
//  Created by Alex Lebedev on 18.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var cardView: GradientView!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var mainPaymentCheckImage: UIImageView!
    @IBOutlet weak var mainPaymentLabel: UILabel!
    @IBOutlet weak var lastFourDigits:UILabel!
    
    //MARK: - Properties
    var isTapped: Bool = false
    var parent = CardCell()
    var rowIndex = Int()
    
    //MARK: - Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainPaymentCheckImage.image = R.image.placeForButtonImage()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
            mainPaymentCheckImage.isUserInteractionEnabled = true
            mainPaymentCheckImage.addGestureRecognizer(tapGestureRecognizer)
        setup()
    }

    private func setup() {
        bankNameLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        cardView.topColor = R.color.choosenCardTopColor()!
        cardView.bottomColor = R.color.choosenBottomCardColor()!
        cardView.layer.cornerRadius = 5
        bankNameLabel.font = R.font.aileronBold(size: 18)
        mainPaymentLabel.font = R.font.aileronBold(size: 12)
        mainPaymentLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
    }
    
    
}

//MARK: - tapGestureRecognizer

extension CardCollectionViewCell {
    @objc func imageTapped()
    {
        for i in 0..<parent.arrbuttonState.count {
            self.parent.arrbuttonState[i] = false
        }
        isTapped = !isTapped
        CardRemoverManager.shared.indexChoosen = rowIndex
        mainPaymentCheckImage.image = R.image.white_checbox()
        self.parent.arrbuttonState[rowIndex] = true

        self.parent.cardCollectionView.reloadData()
    }
}
