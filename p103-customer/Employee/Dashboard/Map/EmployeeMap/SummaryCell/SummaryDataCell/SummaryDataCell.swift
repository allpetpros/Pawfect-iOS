//
//  SummaryDataCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 25/05/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit

class SummaryDataCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var actionLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
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
