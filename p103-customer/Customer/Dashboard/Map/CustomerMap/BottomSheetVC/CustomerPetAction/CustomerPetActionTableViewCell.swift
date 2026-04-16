//
//  CustomerPetActionTableViewCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 17/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit

class CustomerPetActionTableViewCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var petDurationLabel: UILabel!
    @IBOutlet weak var petNameLabel: UILabel!
    
    //MARK: - Cell Methods
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
