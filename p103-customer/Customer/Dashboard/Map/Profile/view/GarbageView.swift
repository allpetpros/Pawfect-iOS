//
//  GarbageView.swift
//  p103-customer
//
//  Created by Daria Pr on 18.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class GarbageView: UIView {

    //MARK: - UIProperties
    
    private let garbageLabel: UILabel = {
        let l = UILabel()
        l.text = "Garbage"
        l.textColor = .color070F24
        l.font = R.font.aileronSemiBold(size: 16)
        return l
    } ()
    
    private let daysStackView: UIStackView = {
        let st = UIStackView()
        st.axis = .vertical
        st.spacing = 20
        return st
    } ()
    
    private let mondayButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .monday, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        return button
    }()
    
    private let tuesdayButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .tuesday, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        return button
    }()
    
    private let wednesdayButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .wednesday, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        return button
    }()
    
    private let thursdayButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .thursday, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        return button
    }()
    
    private let fridayButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .friday, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        return button
    }()
    
    private let saturdayButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .saturday, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        return button
    }()
    
    private let sundayButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .sunday, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        return button
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Layout

private extension GarbageView {
    func setupLayout() {
        addSubviews([garbageLabel, daysStackView])
        
        daysStackView.addArrangedSubviews(views: mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton)
        
        garbageLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
        }
        
        daysStackView.snp.makeConstraints {
            $0.top.equalTo(garbageLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview()
        }
    }
}

//MARK: - Public func

extension GarbageView {
    func setupProfileView(garbageArr: [String]) {
        mondayButton.vukl()
        tuesdayButton.vukl()
        wednesdayButton.vukl()
        thursdayButton.vukl()
        fridayButton.vukl()
        saturdayButton.vukl()
        sundayButton.vukl()
        for i in garbageArr {
            switch i {
            case "monday":
                mondayButton.vkl()
            case "tuesday":
                tuesdayButton.vkl()
            case "wednesday":
                wednesdayButton.vkl()
            case "thursday":
                thursdayButton.vkl()
            case "friday":
                fridayButton.vkl()
            case "saturday":
                saturdayButton.vkl()
            default:
                sundayButton.vkl()
            }
        }
    }
    
    func fillArrayWithAnswers() -> [String] {
        var arrayAnswers = [String]()
        let buttonsArr = [mondayButton, tuesdayButton, wednesdayButton, thursdayButton, fridayButton, saturdayButton, sundayButton]
        
        for i in buttonsArr {
            if i.isActive {
                arrayAnswers.append(i.questionLabel.text!.lowercased())
            }
        }
        
        return arrayAnswers
    }
    
    func setup(userInteraction: Bool, title: String) {
        daysStackView.isUserInteractionEnabled = userInteraction
        garbageLabel.text = title
    }
}
