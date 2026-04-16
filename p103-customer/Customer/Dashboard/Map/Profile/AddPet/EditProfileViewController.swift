//
//  EditProfileViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 19.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

@objc protocol EditAccountDelegate: class {
    func reloadAccount()
}

class EditProfileViewController: UIViewController, CNContactPickerDelegate {

    //MARK: - UIProperties
    
    private var editView = EditProfileView()
    
    private var imagePicker = UIImagePickerController()
    
    private lazy var alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.delegate = self
        return view
    }()
    
    weak var delegate: EditAccountDelegate?

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.startUpdatingLocation()
        view = editView
        editView.delegate = self
        setupNavbar()
    }
}

//MARK: - EditProfileDelegate

extension EditProfileViewController: EditProfileDelegate {
    func setupNavbar(){
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        let backButtonImg : UIButton = UIButton.init(type: .custom)
        backButtonImg.setImage(R.image.leftArrow(), for: .normal)
        backButtonImg.addTarget(self, action: #selector(didTappedBack), for: .touchUpInside)
        backButtonImg.frame = CGRect(x: 35, y: 0, width: 30, height: 30)
        let addButton = UIBarButtonItem(customView: backButtonImg)
        self.navigationItem.setLeftBarButtonItems([addButton], animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.title = "Edit Account"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Aileron-Bold", size: 18)!]
    }
    
    @objc func didTappedBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func setup(error: Error) {
        if let error = error as? ErrorResponse {
            if error.localizedDescription.contains("Unauthorized") {
                self.alertView.setupAlert(description: "Your session has been expired, Please login again.", alertType: .unAuthroized)
            } else {
                self.alertView.setupAlert(description: error.localizedDescription, alertType: .error)
            }

        } else {
            self.alertView.setupAlert(description: error.localizedDescription, alertType: .error)
        }
        self.showCustomBlur()
        self.view.addSubview(self.alertView)
        self.alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func toChangePassword() {
        let vc = NewPasswordVC(state: .changePassword)

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func chooseProfilePhoto() {
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func closeScreen() {
        LocationManager.sharedInstance.stopUpdatingLocation()
        _ = navigationController?.popViewController(animated: true, completion: {
            self.delegate?.reloadAccount()
        })
        }
    func allowContacts() {
        DispatchQueue.main.async {
            let vc = CNContactPickerViewController()
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let contact1Name = editView.emergency1ContactNameTextField.text ?? ""
        let contact1Phone = editView.emergency1ContactTextField.text ?? ""
        
        let contact2Name = editView.emergency2ContactNameTextField.text ?? ""
        let contact2Phone = editView.emergency2ContactTextField.text ?? ""
        
        let contact3Name = editView.emergency3ContactNameTextField.text ?? ""
        let contact3Phone = editView.emergency3ContactTextField.text ?? ""
        
        if contact1Name.isEmpty || contact1Phone.isEmpty {
           editView.emergency1ContactNameTextField.text = contact.givenName
           let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
           let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
           var number = ((contact.phoneNumbers.first?.value)! as CNPhoneNumber).stringValue
           number = NSString(string: number.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")) as String
           if number.count <= 10 {
               editView.emergency1ContactTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
           } else if number.count > 10 && number.count < 14  {
               editView.emergency1ContactTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
           } else if number.count < 14 {
               editView.emergency1ContactTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
               editView.emergPhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
               editView.doneButton.redAndGrayStyle(active: false)
           }
           
           editView.emergenciesPhoneFirst = (editView.emergency1ContactTextField.text ?? "").applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            if editView.emergenciesPhoneFirst.isEmergencyValidPhone {
               editView.emergPhoneErrorLabel.setup(isHidden: true, text: "Invalid Phone Number")
               editView.checkStateOfDoneButton()
           } else {
               editView.emergPhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
               editView.doneButton.redAndGrayStyle(active: false)
           }
            editView.emergNameErrorLabel.isHidden = true
           editView.emergenciesNameFirst = contact.givenName
       }
        else if contact2Phone.isEmpty && contact2Name.isEmpty {
            editView.emergency2ContactNameTextField.text = contact.givenName
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            var number = ((contact.phoneNumbers.first?.value)! as CNPhoneNumber).stringValue
            number = NSString(string: number.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")) as String
            if number.count <= 10 {
                editView.emergency2ContactTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            } else if number.count > 10 && number.count < 14  {
                editView.emergency2ContactTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            } else if number.count < 14 {
                editView.emergency2ContactTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
                editView.emerg2PhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                editView.doneButton.redAndGrayStyle(active: false)
            }
            
            editView.emergenciesPhoneSecond = editView.emergency2ContactTextField.text?.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
            if editView.emergenciesPhoneSecond!.isEmergencyValidPhone {
                editView.emerg2PhoneErrorLabel.setup(isHidden: true, text: "Invalid Phone Number")
                editView.checkStateOfDoneButton()
            } else {
                editView.emerg2PhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                editView.doneButton.redAndGrayStyle(active: false)
            }
            editView.emergenciesPhoneSecond = editView.emergency2ContactTextField.text?.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
            editView.emergenciesNameSecond = contact.givenName
        } else if contact3Phone.isEmpty && contact3Name.isEmpty {
            editView.emergency3ContactNameTextField.text = contact.givenName
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            var number = ((contact.phoneNumbers.first?.value)! as CNPhoneNumber).stringValue
            number = NSString(string: number.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")) as String
            if number.count <= 10 {
                editView.emergency3ContactTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            } else if number.count > 10 && number.count < 14  {
                editView.emergency3ContactTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            } else if number.count < 14 {
                editView.emergency3ContactTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
                editView.emerg3PhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                editView.doneButton.redAndGrayStyle(active: false)
            }
            
            editView.emergenciesPhoneThird = editView.emergency3ContactTextField.text?.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
            if editView.emergenciesPhoneThird!.isEmergencyValidPhone {
                editView.emerg3PhoneErrorLabel.setup(isHidden: true, text: "Invalid Phone Number")
                editView.checkStateOfDoneButton()
            } else {
                editView.emerg3PhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                editView.doneButton.redAndGrayStyle(active: false)
            }
            editView.emergenciesPhoneThird = editView.emergency3ContactTextField.text?.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
            editView.emergenciesNameThird = contact.givenName
        }
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        editView.setupProfile(image: image)
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

//MARK: - CustomAlertViewDelegate

extension EditProfileViewController: CustomAlertViewDelegate {
    func okButtonTouched(alertType: AlertType) {
        if alertType == .error {
            self.removeCustomBlur()
            self.alertView.removeFromSuperview()
        } else if alertType == .unAuthroized {
            DBManager.shared.removeAccessToken()
            DBManager.shared.saveStatus(0)
            DBManager.shared.removeUserRole()
            let vc = UINavigationController(rootViewController: AuthorizationVC())
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
    
   
}
