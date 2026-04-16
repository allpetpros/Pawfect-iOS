//
//  PaymentAlertViewController.swift
//  p103-customer
//
//  Created by Foram Mehta on 10/03/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField



class PaymentAlertView: BaseViewController, UITextFieldDelegate {
    
//     var alertView = UIView()
    
    @IBOutlet weak var amountTxtField: UITextField!
    
    @IBOutlet weak var addButtonOutlet: UIButton!
    var isValid = false
    var cardDetails: Item?
    var delegate: AmountCardDelegate?
    var amount: Int?
    init() {
        super.init(nibName: "PaymentAlertView", bundle: Bundle(for: PaymentAlertView.self))
        self.modalPresentationStyle = .overFullScreen
        self.modalTransitionStyle = .crossDissolve
        hidesBottomBarWhenPushed = true
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: amountTxtField.frame.height - 2, width: amountTxtField.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 134, green: 0, blue: 0,alpha: 1).cgColor
//        rgb(134,0,0)
        amountTxtField.borderStyle = .none
        amountTxtField.layer.addSublayer(bottomLine)
        amountTxtField.keyboardType = .decimalPad
        addButtonOutlet.isUserInteractionEnabled = false
        addButtonOutlet.redAndGrayStyle(active: false)
        amountTxtField.delegate = self
        
        amountTxtField.addTarget(self, action: #selector(amountTextFieldAction), for: .editingChanged)
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
    }
    
    @objc func amountTextFieldAction() {
        if let amount = amountTxtField.text {
            if amount.isEmpty {
                isValid = false
                addButtonOutlet.redAndGrayStyle(active: false)
                addButtonOutlet.isUserInteractionEnabled = false
            } else {
                isValid = true
                addButtonOutlet.redAndGrayStyle(active: true)
                addButtonOutlet.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        addButtonOutlet.redAndGrayStyle(active: false)
        addButtonOutlet.isUserInteractionEnabled = false
        if isValid{
            addAmount()
        } else {
            
        }
        
    }
 
    @IBAction func crossBtnTapped(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func addAmount() {
        showActivityIndicator()
        
        let amount = Double(amountTxtField.text ?? "")
        let amountProfile = AddAmount(total: amount ?? 0.0, token: cardDetails!.token!)
        PaymentService().addAmount(id: cardDetails!.id, body: amountProfile) { [weak self] result in
        guard let self = self else { return }
        switch result {
        case .success(let result):
            CardRemoverManager.shared.isAmountAdded = true
            self.delegate?.addAmount()
            print(result)
            self.hideActivityIndicator()
            self.dismiss(animated: true, completion: nil)
        case .failure(let error):
            self.setupErrorAlert(error: error)
            print(error)
            self.hideActivityIndicator()
//                self.setupErrorAlert(error: error)
        }
//           
        }
    }
    func validation() {
        
    }

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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newString: NSString?
        let maxLength = 8
       
        let currentString: NSString = (textField.text ?? "") as NSString
        newString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString!.length <= maxLength

    }
}

