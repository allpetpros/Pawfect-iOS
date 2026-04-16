//
//  SitterReviewCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 13/07/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import Cosmos

class SitterReviewCell: UITableViewCell {

    @IBOutlet weak var employeeImage: UIImageView!
    @IBOutlet weak var employeeNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var employeeRating: CosmosView!
    
    @IBOutlet weak var commentlabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    override func layoutSubviews() {
//         super.layoutSubviews()
//        
//         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    }
//    
    
    // Custom Function
    
    func configure() {
        containerView.layer.cornerRadius = 20
            
        backgroundColor = .clear
        containerView.backgroundColor = .white
    }
}
