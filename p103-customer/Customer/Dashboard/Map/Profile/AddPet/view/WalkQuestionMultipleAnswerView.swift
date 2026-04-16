//
//  WalkQuestionMultipleAnswerView.swift
//  p103-customer
//
//  Created by Daria Pr on 14.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class WalkQuestionMultipleAnswerView: UIView {

    //MARK: - UIProperties
    
    private let dogLabel: UILabel = {
        let l = UILabel()
        l.text = "On Walks, my dog..."
        l.textColor = .color293147
        l.font = R.font.aileronSemiBold(size: 16)
        return l
    } ()
    
    private let walkButton: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private let walkSecondButton: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private let walkThirdButton: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private let walkFourthButton: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private var walkArr = Set<String>()
    
    private var walkDict = [String: Bool]()
    
    var walkButtons = [ButtonWithTrailingCheckbox]()
    
    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        walkButton.delegate = self
        walkSecondButton.delegate = self
        walkThirdButton.delegate = self
        walkFourthButton.delegate = self
        
        walkButton.setup(component: .walk1, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        walkSecondButton.setup(component: .walk2, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        walkThirdButton.setup(component: .walk3, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        walkFourthButton.setup(component: .walk4, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    //MARK: - Setup Layout
private extension WalkQuestionMultipleAnswerView {
    func setupWalkHabit() {
        addSubviews([dogLabel, walkButton, walkSecondButton, walkThirdButton, walkFourthButton])
        
        dogLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
        }
        
        walkButton.snp.makeConstraints {
            $0.top.equalTo(dogLabel.snp.bottom).offset(21)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        walkSecondButton.snp.makeConstraints {
            $0.top.equalTo(walkButton.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        walkThirdButton.snp.makeConstraints {
            $0.top.equalTo(walkSecondButton.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        walkFourthButton.snp.makeConstraints {
            $0.top.equalTo(walkThirdButton.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupLayoutForViewPet() {
        if walkButtons.count == 1 {
            dogLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.left.equalToSuperview().offset(25)
            }
            walkButtons[0].snp.makeConstraints {
                $0.top.equalTo(dogLabel.snp.bottom).offset(21)
                $0.left.equalToSuperview().offset(25)
                $0.right.equalToSuperview().offset(-25)
                $0.bottom.equalToSuperview()
            }
        } else {
            dogLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.left.equalToSuperview().offset(25)
            }
            walkButtons[0].snp.makeConstraints {
                $0.top.equalTo(dogLabel.snp.bottom).offset(21)
                $0.left.equalToSuperview().offset(25)
                $0.right.equalToSuperview().offset(-25)
            }
        }

        walkButtons[0].isUserInteractionEnabled = false
        var i = 1
        while i != walkButtons.count {
            walkButtons[i].isUserInteractionEnabled = false
            if walkButtons.count - 1 == i {
                walkButtons[i].snp.makeConstraints {
                    $0.top.equalTo(walkButtons[i-1].snp.bottom).offset(21)
                    $0.left.equalToSuperview().offset(25)
                    $0.right.equalToSuperview().offset(-25)
                    $0.bottom.equalToSuperview()
                }
            } else {
                walkButtons[i].snp.makeConstraints {
                    $0.top.equalTo(walkButtons[i-1].snp.bottom).offset(21)
                    $0.left.equalToSuperview().offset(25)
                    $0.right.equalToSuperview().offset(-25)
                }
            }
            i+=1
        }
    }
    
}

//MARK: - ButtonWithTrailingCheckboxDelegate

extension WalkQuestionMultipleAnswerView: ButtonWithTrailingCheckboxDelegate {
    
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool) {
        if answer {
            if questions == .walk1 {
                walkDict["Is leash trained"] = true
            } else if questions == .walk2 {
                walkDict["Doesn't like interacting with other dogs/people"] = true
            } else if questions == .walk3 {
                walkDict["Chases small animals/birds"] = true
            } else {
                walkDict["Pulls on leash "] = true
            }
        } else {
            if questions == .walk1 {
                walkDict["Is leash trained"] = false
            } else if questions == .walk2 {
                walkDict["Doesn't like interacting with other dogs/people"] = false
            } else if questions == .walk3 {
                walkDict["Chases small animals/birds"] = false
            } else {
                walkDict["Pulls on leash "] = false
            }
        }
    }
}

//MARK: - Public func

extension WalkQuestionMultipleAnswerView {
    func setupLayout() {
        setupWalkHabit()
    }
    
    func getCheckedWalkQuestion() -> [String] {
        for i in walkDict {
            if i.value {
                walkArr.insert(i.key)
            }
        }
        return Array(walkArr)
    }
    
    func setupProfileView(answersArr: [String]) {
        addSubviews([dogLabel, walkButton, walkSecondButton, walkThirdButton, walkFourthButton])
        
        for i in answersArr {
            if i == "Is leash trained" {
                walkButton.vkl()
                walkButtons.append(walkButton)
            } else if i == "Doesn't like interacting with other dogs/people" {
                walkSecondButton.vkl()
                walkButtons.append(walkSecondButton)
            } else if i == "Chases small animals/birds" {
                walkThirdButton.vkl()
                walkButtons.append(walkThirdButton)
            } else {
                walkFourthButton.vkl()
                walkButtons.append(walkFourthButton)
            }
        }

        if !walkButtons.isEmpty {
            setupLayoutForViewPet()
        }
    }
    
    func setupEditView(answersDict: [String: Bool]) {
        walkDict = answersDict
        for i in answersDict {
            if i.value {
                if i.key == "Is leash trained" {
                    walkButton.vkl()
                } else if i.key == "Doesn't like interacting with other dogs/people" {
                    walkSecondButton.vkl()
                } else if i.key == "Chases small animals/birds" {
                    walkThirdButton.vkl()
                } else {
                    walkFourthButton.vkl()
                }
            }
        }
    }
}
