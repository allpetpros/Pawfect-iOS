//
//  HomeQuestionMultipleAnswerView.swift
//  p103-customer
//
//  Created by Daria Pr on 14.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class HomeQuestionMultipleAnswerView: UIView {
    
    //MARK: - UIProperties
    
    private let homeLabel: UILabel = {
        let l = UILabel()
        l.text = "When someone enters my home, my dog...."
        l.textColor = .color293147
        l.font = R.font.aileronSemiBold(size: 16)
        return l
    } ()
    
    private let homeButton: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private let homeSecondButton: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private let homeThirdButton: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private let homeFourthButton: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private let homeFifthButton: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private var homeArr = Set<String>()
    
    private var homeDict = [String: Bool]()
    
    var homeButtons = [ButtonWithTrailingCheckbox]()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        homeButton.delegate = self
        homeSecondButton.delegate = self
        homeThirdButton.delegate = self
        homeFourthButton.delegate = self
        homeFifthButton.delegate = self
        
        homeButton.setup(component: .someone1, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        homeSecondButton.setup(component: .someone2, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        homeThirdButton.setup(component: .someone3, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        homeFourthButton.setup(component: .someone4, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        homeFifthButton.setup(component: .someone5, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Layout
private extension HomeQuestionMultipleAnswerView {
    
    func setupHomeHabit() {
        addSubviews([homeLabel, homeButton, homeSecondButton, homeThirdButton, homeFourthButton,homeFifthButton])
        
        homeLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
        }
        
        homeButton.snp.makeConstraints {
            $0.top.equalTo(homeLabel.snp.bottom).offset(21)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        homeSecondButton.snp.makeConstraints {
            $0.top.equalTo(homeButton.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        homeThirdButton.snp.makeConstraints {
            $0.top.equalTo(homeSecondButton.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        homeFourthButton.snp.makeConstraints {
            $0.top.equalTo(homeThirdButton.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
//            $0.bottom.equalToSuperview()
        }
        
        homeFifthButton.snp.makeConstraints {
            $0.top.equalTo(homeFourthButton.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupLayoutForViewPet() {
        if homeButtons.count == 1 {
            homeLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.left.equalToSuperview().offset(25)
            }
            homeButtons[0].snp.makeConstraints {
                $0.top.equalTo(homeLabel.snp.bottom).offset(21)
                $0.left.equalToSuperview().offset(25)
                $0.right.equalToSuperview().offset(-25)
                $0.bottom.equalToSuperview()
            }
        } else {
            homeLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.left.equalToSuperview().offset(25)
            }
            homeButtons[0].snp.makeConstraints {
                $0.top.equalTo(homeLabel.snp.bottom).offset(21)
                $0.left.equalToSuperview().offset(25)
                $0.right.equalToSuperview().offset(-25)
            }
        }
        homeButtons[0].isUserInteractionEnabled = false
        var i = 1
        if homeButtons.count == 1 {
            homeButtons[0].snp.remakeConstraints {
                $0.top.equalTo(homeLabel.snp.bottom).offset(21)
                $0.left.equalToSuperview().offset(25)
                $0.right.equalToSuperview().offset(-25)
                $0.bottom.equalToSuperview()
            }
        } else {
            while i != homeButtons.count {
                homeButtons[i].isUserInteractionEnabled = false
                if homeButtons.count - 1 == i {
                    homeButtons[i].snp.makeConstraints {
                        $0.top.equalTo(homeButtons[i-1].snp.bottom).offset(21)
                        $0.left.equalToSuperview().offset(25)
                        $0.right.equalToSuperview().offset(-25)
                        $0.bottom.equalToSuperview()
                    }
                } else {
                    homeButtons[i].snp.makeConstraints {
                        $0.top.equalTo(homeButtons[i-1].snp.bottom).offset(21)
                        $0.left.equalToSuperview().offset(25)
                        $0.right.equalToSuperview().offset(-25)
                    }
                }
                i+=1
            }
        }
    }
}

//MARK: - ButtonWithTrailingCheckboxDelegate

extension HomeQuestionMultipleAnswerView: ButtonWithTrailingCheckboxDelegate {
    
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool) {
        if answer {
            if questions == .someone1 {
                homeDict["Protective (barks at strangers) "] = true
            } else if questions == .someone2 {
                homeDict["Tries to rush out for walk/playtime"] = true
            } else if questions == .someone3 {
                homeDict["Pees from excitement"] = true
            } else if questions == .someone4{
                homeDict["Shy, but warms up eventually"] = true
            } else {
                homeDict["Will give you lots of puppy kisses and tail wags"] = true
            }
        } else {
            if questions == .someone1 {
                homeDict["Protective (barks at strangers) "] = false
            } else if questions == .someone2 {
                homeDict["Tries to rush out for walk/playtime"] = false
            } else if questions == .someone3 {
                homeDict["Pees from excitement"] = false
            } else if questions == .someone4{
                homeDict["Shy, but warms up eventually"] = false
            } else {
                homeDict["Will give you lots of puppy kisses and tail wags"] = false
            }
        }
    }
}

//MARK: - Public funcs

extension HomeQuestionMultipleAnswerView {
    func setupLayout() {
        setupHomeHabit()
    }
    
    func getCheckedHomeQuestion() -> [String] {
        for i in homeDict {
            if i.value {
                homeArr.insert(i.key)
            }
        }
        return Array(homeArr)
    }
    
    func setupProfileView(answersArr: [String]) {
        addSubviews([homeLabel, homeButton, homeThirdButton, homeSecondButton, homeFourthButton])

        for i in answersArr {
            if i == "Protective (barks at strangers) " {
                homeButton.vkl()
                homeButtons.append(homeButton)
            } else if i == "Tries to rush out for walk/playtime" {
                homeSecondButton.vkl()
                homeButtons.append(homeSecondButton)
            } else if i == "Pees from excitement" {
                homeThirdButton.vkl()
                homeButtons.append(homeThirdButton)
            } else {
                homeFourthButton.vkl()
                homeButtons.append(homeFourthButton)
            }
        }
        if !homeButtons.isEmpty {
            setupLayoutForViewPet()
        }
    }
    
    func setupEditView(answersDict: [String: Bool]) {
        homeDict = answersDict
        for i in answersDict {
            if i.value {
                if i.key == "Protective (barks at strangers) " {
                    homeButton.vkl()
                } else if i.key == "Tries to rush out for walk/playtime" {
                    homeSecondButton.vkl()
                } else if i.key == "Pees from excitement" {
                    homeThirdButton.vkl()
                } else if i.key == "Shy, but warms up eventually"{
                    homeFourthButton.vkl()
                } else {
                    homeFifthButton.vkl()
                }
            }
        }
    }
}
