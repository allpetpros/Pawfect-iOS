//
//  MapTopViewCllTableViewCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 16/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import Cosmos

class MapTopViewCll: UITableViewCell {
    //MARK: - IBOutlet
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondLine: UIView!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceImage: UIImageView!
    
    @IBOutlet weak var employeeImage: UIImageView!
    
    @IBOutlet weak var employeeRatings: CosmosView!
    @IBOutlet weak var employeeName: UILabel!

    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - SetupLayouts
    func configureUI() {
        
        firstLabel.font = R.font.aileronBold(size: 12)
        firstLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        firstLabel.backgroundColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        firstLabel.layer.cornerRadius = firstLabel.frame.width/2
        firstLabel.layer.masksToBounds = true

        secondLabel.font = R.font.aileronBold(size: 12)
        secondLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        secondLabel.layer.cornerRadius = secondLabel.frame.width/2
        secondLabel.backgroundColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        secondLabel.layer.masksToBounds = true
        
        thirdLabel.font = R.font.aileronBold(size: 12)
        thirdLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        thirdLabel.backgroundColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        thirdLabel.layer.cornerRadius = thirdLabel.frame.width/2
        thirdLabel.layer.masksToBounds = true
        
    }


    
}
