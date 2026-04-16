//
//  ButtonWithTrailingCheckbox.swift
//  p103-customer
//
//  Created by Alex Lebedev on 07.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SwiftUI

protocol ButtonWithTrailingCheckboxDelegate: AnyObject {
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool)
}

enum ButtonWithTrailingCheckboxComponents {
    case sameAsHomeAddressCheckBox
    case waterPlaints
    
    case policyAgreement
    
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    case small
    case medium
    case large
    
    case walk1
    case walk2
    case walk3
    case walk4
    
    case someone1
    case someone2
    case someone3
    case someone4
    case someone5
    
    case dogFriendly
    case catFriendly
    case shy
    
    case recurring
    case medications
    
    case morning
    case afternoon
    case evening
    
    case fewDays
    case separatedDays
    
    var titleOflabel: String {
        switch self {
        case .sameAsHomeAddressCheckBox:
            return "Same As Home Address"
        case .waterPlaints:
            return "Water Plants"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        case .saturday:
            return "Saturday"
        case .sunday:
            return "Sunday"
        case .policyAgreement:
            return "Policy Agreement"
            
        case .small:
            return "Small"
        case .medium:
            return "Medium"
        case .large:
            return "Large"
            
        case .walk1:
            return "Is leash trained"
        case .walk2:
            return "Doesn't like interacting with other dogs/people"
        case .walk3:
            return "Chases small animals/birds"
        case .walk4:
            return "Pulls on leash "
            
        case .someone1:
            return "Protective (barks at strangers) "
        case .someone2:
            return "Tries to rush out for walk/playtime"
        case .someone3:
            return "Pees from excitement"
        case .someone4:
            return "Shy, but warms up eventually"
        case .someone5:
            return "Will give you lots of puppy kisses and tail wags"
        case .dogFriendly:
            return "Dog friendly"
        case .catFriendly:
            return "Cat friendly"
        case .shy:
            return "Shy"
        case .recurring:
            return "Recurring"
        case .medications:
            return "Medications"
        case .morning:
            return "Morning"
        case .afternoon:
            return "Afternoon"
        case .evening:
            return "Evening"
            
        case .fewDays:
            return "Multiple Days"
        case .separatedDays:
            return "Single Day"
        
        }
    }
}
enum TypeOfCheckbox {
    case point
    case ok
    case blackPoint
}
enum TypeOfText {
    case black
    case visitBlack
    case activeRedDisactiveGray
    case activeBlackDisactiveGray
}
class ButtonWithTrailingCheckbox: UIView {
    
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var checkbox: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    // MARK: - Property
    private var type: ButtonWithTrailingCheckboxComponents?
    
    private var active = false {
        willSet {
            checkbox.image = newValue ? selectedImage : R.image.checkbox_unselected()
            questionLabel.textColor = newValue ? activeTextColor : disactiveTextColor
        }
    }
    
    var isActive = false

    private var selectedImage = R.image.checbox_selected()
    private var activeTextColor: UIColor = .color070F24
    private var disactiveTextColor: UIColor = .color070F24
    
    weak var delegate: ButtonWithTrailingCheckboxDelegate?
    
    // MARK: - Actions
    @IBAction func tapButton(_ sender: UIButton) {
        guard let question = self.type else { return }
        if (question == .small || question == .medium || question == .large) && active {
            return
        }
        active = !active
        isActive = active
        questionLabel.textColor = active ? activeTextColor : disactiveTextColor
        delegate?.buttonTapped(questions: question, answer: active)
    }
    
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
        Bundle.main.loadNibNamed("ButtonWithTrailingCheckbox", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.bounds
        self.isUserInteractionEnabled = true
    }
    
    func setup(component: ButtonWithTrailingCheckboxComponents, typeOfCheckbox: TypeOfCheckbox, typeOfText: TypeOfText) {
        checkbox.tintColor = .color606572
        questionLabel.font = R.font.aileronRegular(size: 14)
        questionLabel.text = component.titleOflabel
        self.type = component
        switch typeOfCheckbox {
        case .point:
            selectedImage = R.image.checkbox_selected_point()
        case .ok:
            selectedImage = R.image.checbox_selected()
        case .blackPoint:
            selectedImage = R.image.calendarFullCheckbox()
        }
        
        switch typeOfText {
            
        case .black:
            return
        case .activeRedDisactiveGray:
            activeTextColor = .colorC6222F
            disactiveTextColor = .color606572
        case .activeBlackDisactiveGray:
            activeTextColor = .color070F24
            disactiveTextColor = .color606572
        case .visitBlack:
            activeTextColor = UIColor(red: 0.161, green: 0.194, blue: 0.279, alpha: 1)
            disactiveTextColor = UIColor(red: 0.161, green: 0.194, blue: 0.279, alpha: 1)
            checkbox.tintColor = UIColor(red: 0.161, green: 0.194, blue: 0.279, alpha: 1)
            selectedImage = R.image.checkbox_selected_point_black()
            questionLabel.font = R.font.aileronSemiBold(size: 16)
        }
        questionLabel.textColor = disactiveTextColor
    }
    func vkl() {
        self.active = true
        isActive = true
    }
    func vukl() {
        self.active = false
        isActive = false
    }
    func isEnable(_ enable: Bool) {
        button.isUserInteractionEnabled = enable
    }
    func setupCalendarFont() {
        questionLabel.font = R.font.aileronRegular(size: 16)
        questionLabel.textColor = .color293147
    }
}
