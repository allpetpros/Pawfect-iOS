//
//  DayCountCell.swift
//  p103-customer
//
//  Created by Alex Lebedev on 22.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class DayCountCell: UITableViewCell {
    enum DayCountCellRows: CaseIterable {
        case everyWeek
        case week2
        case week4
        
        var title: String {
            switch self {
                
            case .everyWeek:
                return "Every Week"
            case .week2:
                return "Every 2 Weeks"
            case .week4:
                return "Every 4 Weeks"
            }
        }
    }
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var chekboxImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configure()
    }
    private func configure() {
        separatorView.backgroundColor = .colorE8E9EB
        valueLabel.font = R.font.aileronRegular(size: 14)
        valueLabel.textColor = .color070F24
        valueLabel.textAlignment = .left
        chekboxImageView.tintColor = .colorE8E9EB
    }
    func perDaySetup(value: Int, selected: Bool) {
        valueLabel.text = "\(value + 1)"
        chekboxImageView.image = selected ? R.image.checbox_selected() : R.image.checkbox_unselected()
    }
    func recurringSetup(value: Int, selected: Bool) {
        valueLabel.text = "\(DayCountCellRows.allCases[value].title)"
        chekboxImageView.image = selected ? R.image.checbox_selected() : R.image.checkbox_unselected()
    }
}
