//
//  SlidersView.swift
//  p103-customer
//
//  Created by Daria Pr on 12.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class SlidersView: UIView {
    
    //MARK: - UIProperties
    
    private let sizeOfDogTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "What the size of your dog (lbs) ?*"
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = .color293147
        return l
    } ()
    
    private let smallButtonView: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private let mediumButtonView: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    private let largeButtonView: ButtonWithTrailingCheckbox = {
        let b = ButtonWithTrailingCheckbox()
        b.isUserInteractionEnabled = true
        return b
    } ()
    
    let smallSlider: UISlider = {
        let s = UISlider()
        s.isUserInteractionEnabled = true
        return s
    } ()
    
    let mediumSlider: UISlider = {
        let s = UISlider()
        s.isUserInteractionEnabled = true
        return s
    } ()
    
    let largeSlider: UISlider = {
        let s = UISlider()
        s.isUserInteractionEnabled = true
        return s
    } ()
    
    private let smallSliderLabel: UILabel = {
        let l = UILabel()
        l.text = "0"
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 10)
        return l
    }()
    
    private let mediumSliderLabel: UILabel = {
        let l = UILabel()
        l.text = "36"
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 10)
        return l
    }()
    
    private let largeSliderLabel: UILabel = {
        let l = UILabel()
        l.text = "46"
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 10)
        return l
    }()
    
    //MARK: - Properties
    
    private var result = String()
    weak var delegate: SlidersDelegate?
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSizeOfPet()
        slidersInit()
        setupSliders()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Layout
    
    private func setupSizeOfPet() {
        addSubviews([sizeOfDogTitleLabel, smallButtonView, smallSlider, mediumButtonView, mediumSlider, largeButtonView, largeSlider, smallSliderLabel, mediumSliderLabel, largeSliderLabel])
        
        setupSliders()
        sizeOfDogTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(26)
        }
        
        smallButtonView.snp.makeConstraints {
            $0.top.equalTo(sizeOfDogTitleLabel.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(26)
            $0.height.equalTo(20)
            $0.width.equalTo(66)
        }
        
        smallSlider.snp.makeConstraints {
            $0.top.equalTo(smallButtonView.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(26)
            $0.right.equalToSuperview().offset(-26)
            $0.height.equalTo(20)
        }
        
        mediumButtonView.snp.makeConstraints {
            $0.top.equalTo(smallSlider.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(26)
            $0.height.equalTo(20)
            $0.width.equalTo(66)
        }
        
        mediumSlider.snp.makeConstraints {
            $0.top.equalTo(mediumButtonView.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(26)
            $0.right.equalToSuperview().offset(-26)
            $0.height.equalTo(20)
        }
        
        largeButtonView.snp.makeConstraints {
            $0.top.equalTo(mediumSlider.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(26)
            $0.height.equalTo(20)
            $0.width.equalTo(66)
        }
        
        largeSlider.snp.makeConstraints {
            $0.top.equalTo(largeButtonView.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(26)
            $0.right.equalToSuperview().offset(-26)
            $0.height.equalTo(20)
        }
    }
}

//MARK: - Setup sliders settings

private extension SlidersView {
    func setupSliders() {
        
        smallButtonView.setup(component: .small, typeOfCheckbox: .point, typeOfText: .activeBlackDisactiveGray)
        mediumButtonView.setup(component: .medium, typeOfCheckbox: .point, typeOfText: .activeBlackDisactiveGray)
        largeButtonView.setup(component: .large, typeOfCheckbox: .point, typeOfText: .activeBlackDisactiveGray)
        
        smallSlider.minimumTrackTintColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        smallSlider.maximumTrackTintColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        smallSlider.tintColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        mediumSlider.minimumTrackTintColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        mediumSlider.maximumTrackTintColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        mediumSlider.tintColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        largeSlider.minimumTrackTintColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        largeSlider.maximumTrackTintColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        largeSlider.tintColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        smallSlider.setThumbImage(R.image.ellipse(), for: .normal)
        smallSlider.setThumbImage(R.image.ellipse(), for: .highlighted)
        
        mediumSlider.setThumbImage(R.image.ellipse(), for: .normal)
        mediumSlider.setThumbImage(R.image.ellipse(), for: .highlighted)
        
        largeSlider.setThumbImage(R.image.ellipse(), for: .normal)
        largeSlider.setThumbImage(R.image.ellipse(), for: .highlighted)
        
    }
    
    func slidersInit() {
        
        smallSlider.addTarget(self, action: #selector(changeValueSmall(_:)), for: .valueChanged)
        mediumSlider.addTarget(self, action: #selector(changeValueMedium(_:)), for: .valueChanged)
        largeSlider.addTarget(self, action: #selector(changeValueLarge(_:)), for: .valueChanged)
        
        smallButtonView.delegate = self
        mediumButtonView.delegate = self
        largeButtonView.delegate = self
        
        smallSlider.isEnabled = false
        mediumSlider.isEnabled = false
        largeSlider.isEnabled = false
        
        setupSmallSliderLabelInit()
        setupMediumSliderLabelInit()
        setupLargeSliderLabelInit()
        
        smallSlider.minimumValue = 0
        smallSlider.maximumValue = 35
        
        mediumSlider.minimumValue = 36
        mediumSlider.maximumValue = 45
        
        largeSlider.minimumValue = 46
        largeSlider.maximumValue = 100
    }
    
    func setupSmallSliderLabelInit() {
        smallSliderLabel.text = "0"
        
        smallSliderLabel.snp.makeConstraints {
            $0.top.equalTo(smallButtonView.snp.bottom).offset(5)
            $0.left.equalTo(smallSlider.snp.left).offset(8)
        }
    }
    
    func setupMediumSliderLabelInit() {
        mediumSliderLabel.text = "36"
        
        mediumSliderLabel.snp.makeConstraints {
            $0.top.equalTo(mediumButtonView.snp.bottom).offset(5)
            $0.left.equalTo(mediumSlider.snp.left).offset(8)
        }
    }
    
    func setupLargeSliderLabelInit() {
        largeSliderLabel.text = "46"
        
        largeSliderLabel.snp.makeConstraints {
            $0.top.equalTo(largeButtonView.snp.bottom).offset(5)
            $0.left.equalTo(largeSlider.snp.left).offset(8)
        }
    }
}

//MARK: - Actions

private extension SlidersView {
    
    @objc func changeValueSmall(_ sender: UISlider) {
        
        smallSliderLabel.snp.removeConstraints()
        
        let val = roundf(sender.value)
        smallSliderLabel.text = String(Int(val))
        
        let trackRect = sender.trackRect(forBounds: sender.frame)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: val)
        smallSliderLabel.snp.makeConstraints {
            $0.centerX.equalTo(thumbRect.midX)
            $0.top.equalTo(smallButtonView.snp.bottom).offset(5)
        }
        
        if let small = smallSliderLabel.text {
            result = small
            delegate?.getSize(amount: result)
        }
    }
    
    @objc func changeValueMedium(_ sender: UISlider) {
        
        mediumSliderLabel.snp.removeConstraints()
        let val = roundf(sender.value)
        mediumSliderLabel.text = String(Int(val))
        
        let trackRect = sender.trackRect(forBounds: sender.frame)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: val)
        mediumSliderLabel.snp.makeConstraints {
            $0.centerX.equalTo(thumbRect.midX)
            $0.top.equalTo(mediumButtonView.snp.bottom).offset(5)
        }
        
        if let medium = mediumSliderLabel.text {
            result = medium
            delegate?.getSize(amount: result)
        }
    }
    
    @objc func changeValueLarge(_ sender: UISlider) {
        
        largeSliderLabel.snp.removeConstraints()
        let val = roundf(sender.value)
        largeSliderLabel.text = String(Int(val))
        
        let trackRect = sender.trackRect(forBounds: sender.frame)
        let thumbRect = sender.thumbRect(forBounds: sender.bounds, trackRect: trackRect, value: val)
        largeSliderLabel.snp.makeConstraints {
            $0.centerX.equalTo(thumbRect.midX)
            $0.top.equalTo(largeButtonView.snp.bottom).offset(5)
        }
        
        if let large = largeSliderLabel.text {
            result = large
            delegate?.getSize(amount: result)
        }
    }
}

//MARK: - ButtonWithTrailingCheckboxDelegate

extension SlidersView: ButtonWithTrailingCheckboxDelegate {
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool) {
        if questions == .small {
            
            delegate?.getPet(size: "small")
            delegate?.getSize(amount: "0")
            mediumSliderLabel.snp.removeConstraints()
            largeSliderLabel.snp.removeConstraints()
            
            setupMediumSliderLabelInit()
            setupLargeSliderLabelInit()
            
            mediumSlider.setValue(0, animated: false)
            largeSlider.setValue(0, animated: false)
            
            smallSlider.isEnabled = true
            mediumSlider.isEnabled = false
            largeSlider.isEnabled = false
            mediumButtonView.vukl()
            largeButtonView.vukl()
        }
        if questions == .medium {
            
            delegate?.getPet(size: "medium")
            delegate?.getSize(amount: "36")
            smallSliderLabel.snp.removeConstraints()
            largeSliderLabel.snp.removeConstraints()
            
            setupSmallSliderLabelInit()
            setupLargeSliderLabelInit()
            
            smallSlider.setValue(0, animated: false)
            largeSlider.setValue(0, animated: false)
            
            smallSlider.isEnabled = false
            mediumSlider.isEnabled = true
            largeSlider.isEnabled = false
            
            smallButtonView.vukl()
            largeButtonView.vukl()
        }
        if questions == .large {
            
            delegate?.getPet(size: "large")
            delegate?.getSize(amount: "46")
            smallSliderLabel.snp.removeConstraints()
            mediumSliderLabel.snp.removeConstraints()
            
            setupSmallSliderLabelInit()
            setupMediumSliderLabelInit()
            
            mediumSlider.setValue(0, animated: false)
            mediumSlider.setValue(0, animated: false)
            
            smallSlider.isEnabled = false
            mediumSlider.isEnabled = false
            largeSlider.isEnabled = true
            
            smallButtonView.vukl()
            mediumButtonView.vukl()
        }
    }
}

//MARK: - Public funcs

extension SlidersView {
    func getSize() -> String {
        return result
    }
    
    func setSize(size: Int, sizeType: String) {
        switch sizeType {
        case "small":
            smallSlider.setValue(Float(size), animated: true)
            smallButtonView.vkl()
            smallSlider.isEnabled = true
            smallSliderLabel.text = String(size)
        case "medium":
            mediumSlider.setValue(Float(size), animated: true)
            mediumButtonView.vkl()
            mediumSlider.isEnabled = true
            mediumSliderLabel.text = String(size)
        case "large":
            largeSlider.setValue(Float(size), animated: true)
            largeButtonView.vkl()
            largeSlider.isEnabled = true
            largeSliderLabel.text = String(size)
        default:
            break
        }
    }
}
