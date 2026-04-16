//
//  YesOrNoView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 06.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

enum YesOrNoViewGroups {
    case mailKeyProvided
    case someoneWillBeHome
    case turnLightsOnOrOff
    case neutered
    case medications
    case doggyDoor
}

protocol YesOrNoViewDelegate: class {
    func tapOnQuestion(question: YesOrNoViewGroups, answer: Bool)
}

class YesOrNoView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var conteinerView: UIView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var checkboxYes: UIImageView!
    @IBOutlet weak var checkboxNo: UIImageView!
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    // MARK: - Actions
    @IBAction func yesButtonAction(_ sender: UIButton) {
        if let type = type {
                 delegate?.tapOnQuestion(question: type, answer: true )
             } else { return }
        isActive = true
        checkboxYes.image = R.image.checkbox_selected_point()
        checkboxNo.image = R.image.checkbox_unselected()
    }
    
    @IBAction func noButtonAction(_ sender: UIButton) {
        if let type = type {
            delegate?.tapOnQuestion(question: type, answer: false )
        } else { return }
        isActive = true
        checkboxYes.image = R.image.checkbox_unselected()
        checkboxNo.image = R.image.checkbox_selected_point()
    }
    
    // MARK: - Property
    weak var delegate: YesOrNoViewDelegate?
    var type: YesOrNoViewGroups?
    var isActive = false
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("YesOrNoView", owner: self, options: nil)
        self.addSubview(conteinerView)
        conteinerView.frame = self.bounds
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Setup
    func setup(type: YesOrNoViewGroups) {
        self.type = type
        descriptionLabel.font = R.font.aileronSemiBold(size: 16)
        yesButton.titleLabel?.font = R.font.aileronRegular(size: 14)
        noButton.titleLabel?.font = R.font.aileronRegular(size: 14)
        descriptionLabel.textColor = .color293147
        checkboxYes.tintColor = .color606572
        checkboxNo.tintColor = .color606572
        yesButton.setTitleColor(.color070F24, for: .normal)
        noButton.setTitleColor(.color070F24, for: .normal)
        checkboxNo.image = R.image.checkbox_selected_point()
        
        switch type {
        case .mailKeyProvided:
            descriptionLabel.text = "Mail key provided?"
        case .someoneWillBeHome:
            descriptionLabel.text = "Someone Will be Home?"
        case .turnLightsOnOrOff:
            descriptionLabel.text = "Turn lights on or off?"
        case .neutered:
            descriptionLabel.text = "Neutered/spayed"
        case .medications:
            descriptionLabel.text = "Medications"
        case .doggyDoor:
            descriptionLabel.text = "Doggy Door"
        }
    }
    func setValue(_ value: Bool) {
        if value {
            checkboxYes.image = R.image.checkbox_selected_point()
            checkboxNo.image = R.image.checkbox_unselected()
        } else {
            checkboxYes.image = R.image.checkbox_unselected()
            checkboxNo.image = R.image.checkbox_selected_point()
        }
    }
}
