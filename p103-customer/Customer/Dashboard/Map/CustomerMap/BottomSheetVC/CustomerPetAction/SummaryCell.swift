//
//  SummaryCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 17/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit

class SummaryCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var summaryDurationLabel: UILabel!
    @IBOutlet weak var summaryNameLabel: UILabel!
    
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
