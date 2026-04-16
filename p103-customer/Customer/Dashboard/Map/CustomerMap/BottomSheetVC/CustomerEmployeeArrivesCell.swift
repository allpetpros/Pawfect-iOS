//
//  CustomerEmployeeArrivesCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 17/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit

class CustomerEmployeeArrivesCell: UITableViewCell {
    //MARK: - @IBOutlet
    @IBOutlet weak var employeeArriveImage: UIImageView!
    
    @IBOutlet weak var employeeLineView: UIView!
    @IBOutlet weak var employeeArrivesLabel: UILabel!
    
    @IBOutlet weak var firstLabel: UILabel!
    
    //MARK: - Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
}
// MARK: - Set UI
extension CustomerEmployeeArrivesCell {
    func setupUI() {
        
        firstLabel.font = R.font.aileronBold(size: 12)
        firstLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        firstLabel.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        firstLabel.layer.cornerRadius = firstLabel.frame.width/2
        firstLabel.layer.masksToBounds = true
        
        employeeLineView.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        employeeLineView.layer.masksToBounds = true
    
    }
}
