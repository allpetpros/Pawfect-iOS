//
//  CardViewController.swift
//  CardViewAnimation
//
//  Created by Brian Advent on 26.10.18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit
import Cosmos
import SkyFloatingLabelTextField

class SitterRatingCardVC: BaseViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var swipeArea: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var reviewTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var sendButtonBottomConstraint: NSLayoutConstraint!
    
    weak var delegateSend: SendReviewDelegate?
    var orderId: String?
    var employeeId: String?
    var comment = String()
    var delegate: ReloadEmployeeComment?
    
    override func viewDidLoad() {
        hideKeyboardWhenTappedAround()
        configure()
    }

    private func configure() {
        sendButton.setTitle("Send Review", for: .normal)
        sendButton.setTitleColor(UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1), for: .normal)
        sendButton.titleLabel?.font = R.font.aileronBold(size: 18)
        sendButton.layer.cornerRadius = 15
        sendButton.redAndGrayStyle(active: false)
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        
        mainLabel.font = R.font.aileronBold(size: 18)
        mainLabel.textColor = .color293147
        mainLabel.text = "Leave a review for James"
        scoreLabel.text = "Score"
        scoreLabel.font  = R.font.aileronLight(size: 12)
        scoreLabel.textColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        reviewTextField.configure(placeholder: "Review")
        reviewTextField.delegate = self
        reviewTextField.tag = 1
        reviewTextField.addTarget(self, action: #selector(checkStateOfField), for: .editingChanged)
    }
}

//MARK: - Actions

extension SitterRatingCardVC {
    
    @objc func checkStateOfField(field: SkyFloatingLabelTextFieldWithIcon) {
        
        comment = field.text ?? ""
        
        if field.text?.isEmpty ?? true {
            field.style(active: false)
            sendButton.redAndGrayStyle(active: false)
        } else {
            field.style(active: true)
            sendButton.redAndGrayStyle(active: true)
        }
    }
    
    @objc func sendButtonAction() {
        
        cosmosView.didFinishTouchingCosmos = { rating in
            print(rating)
        }
        print(cosmosView.rating)
//        delegateSend?.sendReview()
        callRatingAPI()
//        dismiss(animated: true)
    }
}

extension SitterRatingCardVC {
    
    func callRatingAPI() {
        showActivityIndicator()
        
        CustomerService().rateEmployee(emplId: employeeId ?? "", orderId: orderId ?? "", comment: comment, rate: cosmosView.rating) { [self] result in
            switch result {
            case .success(_):
                
                self.hideActivityIndicator()
                self.dismiss(animated: true) {
                    delegate?.getEmployeeRating()
                }
                
            case .failure(let error):
               
                errorHandle(error: error)
                hideActivityIndicator()
//                dismiss(animated: true)
            }
            
        }
    }
    func errorHandle(error: Error) {
        if let error = error as? ErrorResponse {
           
            Toast.show(message: error.localizedDescription, controller: self)
        
        } else {
            Toast.show(message: error.localizedDescription, controller: self)
            
        }
        
    }
}
// MARK: - UITextfield Delegates
extension SitterRatingCardVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
             // Try to find next responder
             if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
             } else {
                // Not found, so remove keyboard.
                textField.resignFirstResponder()
             }
             // Do not add a line break
             return false
    }
}

