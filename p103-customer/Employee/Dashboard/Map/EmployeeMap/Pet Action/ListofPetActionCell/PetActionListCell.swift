//
//  PetActionListCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 03/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit

class PetActionListCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var actionName: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    //MARK: - Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
