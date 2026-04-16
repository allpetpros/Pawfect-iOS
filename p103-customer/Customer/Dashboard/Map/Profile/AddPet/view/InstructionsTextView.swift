//
//  InstructionsTextView.swift
//  p103-customer
//
//  Created by Daria Pr on 12.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class InstructionsTextView: UIView {
    
    //MARK: - UIProperties
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = R.font.aileronRegular(size: 14)
        return tv
    } ()
    
    private let underTextViewView: UIView = {
        let v = UIView()
        v.backgroundColor = R.color.underTextViewLineColor()
        return v
    } ()
    
    private let placeholderLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        l.font = R.font.aileronRegular(size: 12)
        l.isHidden = true
        return l
    } ()
    
    private var placeholderText = String()
    
    private var text = String()
    
    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textView.delegate = self
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Layout
    
    private func setupLayout() {
        addSubviews([textView, underTextViewView, placeholderLabel])
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalTo(textView.snp.top).offset(2)
        }
        
        textView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(23)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(30)
        }
        
        underTextViewView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(2)
            $0.bottom.equalToSuperview()
        }
    }
}

//MARK: - UITextViewDelegate

extension InstructionsTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        underTextViewView.backgroundColor = R.color.activeLineColor()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
            placeholderLabel.isHidden = false
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightGray
            textView.text = placeholderText
            placeholderLabel.isHidden = true
            underTextViewView.backgroundColor = R.color.deactiveLineColor()
        } else {
            placeholderLabel.isHidden = false
            if let instructions = textView.text {
                text = instructions
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        return true
    }
    
}

//MARK: - Public funcs

extension InstructionsTextView {
    func setup(placeholder: String) {
        textView.text = placeholder
        textView.textColor = .lightGray
        placeholderLabel.text = placeholder
        placeholderText = placeholder
    }
    
    func getText() -> String {
        return text
    }
    
    func lineForPetView() {
        underTextViewView.backgroundColor = .white
    }
    
    func setup(text: String, placeholder: String) {
        textView.text = text
        textView.font = R.font.aileronRegular(size: 14)
        textView.textColor = .black
        placeholderLabel.textColor = .lightGray
        placeholderLabel.text = placeholder
        placeholderLabel.font = R.font.aileronRegular(size: 12)
        placeholderLabel.isHidden = false
    }
}
