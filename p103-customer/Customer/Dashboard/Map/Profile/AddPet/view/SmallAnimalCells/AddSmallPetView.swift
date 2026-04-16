//
//  AddSmallPetView.swift
//  p103-customer
//
//  Created by Daria Pr on 12.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

@objc protocol SmallPetErrorDelegate: AnyObject {
    func emptyNameFieldError(isHidden: Bool)
    func closeScreen()
}

@objc protocol SmallPetDelegate: AnyObject {
    func closingScreen()
    
    func setupError(error: Error)
}

@objc protocol ErrorDelegate: AnyObject {
    func showBlur()
    func hideBlur()
}

class AddSmallPetView: UIView {
    
    
    
    //MARK: - UIProperties
    var customerProfile = CustomerProfileVC()
    
    private lazy var breedTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Breed")
        tf.keyboardType = .alphabet
        tf.delegate = self
        tf.returnKeyType = UIReturnKeyType.next
        tf.tag = 2
        tf.addTarget(self, action: #selector(breedTextFieldAction), for: .editingChanged)
        return tf
    } ()
    
    private lazy var medicationNotesTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Medical notes/concerns")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.addTarget(self, action: #selector(notesTextFieldAction), for: .editingChanged)
        tv.delegate = self
        tv.returnKeyType = UIReturnKeyType.next
        tv.tag = 3
        return tv
    } ()
    
    
    
    private lazy var veterinarianNameTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Veterinarian Name*")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.addTarget(self, action: #selector(veterinarianNameTextFieldAction), for: .editingChanged)
        tv.delegate = self
        tv.keyboardType = .alphabet
        tv.returnKeyType = UIReturnKeyType.next
        tv.tag = 4
        return tv
    } ()
    
    
    private var veterinarianNameErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Name field should not be empty")
        return l
    } ()
    
    private lazy var veterinarianPhoneNumberTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Veterinarian Phone Number*")
        tv.keyboardType = .phonePad
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.addTarget(self, action: #selector(veterianPhoneTextFieldAction), for: .editingChanged)
        tv.delegate = self
        tv.returnKeyType = UIReturnKeyType.done
        tv.tag = 5
        return tv
    } ()
    
//    private lazy var ageTextField: SkyFloatingLabelTextField = {
//        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Age")
//        tf.keyboardType = .numberPad
//        tf.addTarget(self, action: #selector(ageTextFieldAction), for: .editingChanged)
//        tf.delegate = self
//        return tf
//    } ()
//
    let veterinarianPhoneNumberErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Phone Number  should not be empty")
        return l
    } ()
    
     let saveButton: UIButton = {
        let b = UIButton()
//         b.backgroundColor = .gray
         b.cornerRadius = 15
         b.setTitle("Create", for: .normal)
         b.titleLabel?.font = R.font.aileronBold(size: 18)
         b.redAndGrayStyle(active: false)
         b.isUserInteractionEnabled = false
//        b.setImage(R.image.createUnselectedButton(), for: .normal)
        b.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        return b
    }()
    
    
    
    private var activityView: UIActivityIndicatorView?
    
    //MARK: - Properties
    private var isValidate: Bool = true

    var petName = String()
    var genderType = String()
    var breedPet = "-"
    var petPhoto: UIImage?
    var addPetView: AddPetView?
    
    private var medicalNotes: String?
    private var vetId: String?
    var vetName: String?
    var vetPhone: String?
    var veterianArr: [[String: String]]?

    private var petId = String()
    
    weak var delegate: SmallPetErrorDelegate?
    weak var delegateHandle: VaccinationCatDelegate?
    weak var editDelegate: EditPetProfileDelegate?
    
    weak var petDelegate: SmallPetDelegate?
    
    weak var errorDelegate: ErrorDelegate?
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
//        veterinarianPhoneNumberTextField.delegate = self
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Layout
    
    private func setupLayout() {
        addSubviews([breedTextField, veterinarianPhoneNumberTextField, veterinarianNameTextField, saveButton, medicationNotesTextField, veterinarianNameErrorLabel,veterinarianPhoneNumberErrorLabel])

        breedTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        medicationNotesTextField.snp.makeConstraints {
            $0.top.equalTo(breedTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        veterinarianNameTextField.snp.makeConstraints {
            $0.top.equalTo(medicationNotesTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        veterinarianNameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(veterinarianNameTextField.snp.bottom).offset(4)
            $0.leading.equalTo(veterinarianNameTextField)
        }
        
        veterinarianPhoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(veterinarianNameTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        veterinarianPhoneNumberErrorLabel.snp.makeConstraints {
            $0.top.equalTo(veterinarianPhoneNumberTextField.snp.bottom).offset(4)
            $0.leading.equalTo(veterinarianPhoneNumberTextField)
        }
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(veterinarianPhoneNumberTextField.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
//            $0.leading.equalTo(veterinarianPhoneNumberTextField.snp.leading).offset(40)
//            $0.left.equalToSuperview().offset(25)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
}

//MARK: - Public funcs
extension AddSmallPetView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newString: NSString?
        let maxLength = 14
        if textField.tag == 5 {
       
        let currentString: NSString = (textField.text ?? "") as NSString
        newString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            let text = textField.text
            textField.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            return newString!.length <= maxLength
        }
        return true
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
    
   
}
extension AddSmallPetView {
    
    func sendRequiredInfo(name: String, speciesType: String, gender: String, avatar: UIImage, veterianName: String, veterianPhone: String) {
        petName = name
        genderType = gender
        petPhoto = avatar
        vetName = veterianName
        vetPhone = veterianPhone
        checkState()
//        saveButton.setImage(R.image.createSelectedButton(), for: .normal)
    }
    
    func setupView(profile: SmallPetGet, id: String, name: String, breed: String, gender: String) {
        showActivityIndicator()
        petName = name
        petId = id
        if breed != "-" {
            breedPet = breed
        }
        breedPet = breed
        genderType = gender
        breedTextField.isHidden = true
        
        medicationNotesTextField.snp.remakeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        medicationNotesTextField.text = profile.medicalNotes
        medicalNotes = profile.medicalNotes
        if let id = profile.veterinarian?.id {
//            veterinarianNameTextField.text = name
            vetId = id
        }
        if let name = profile.veterinarian?.name {
            veterinarianNameTextField.text = name
            vetName = name
        }
        if let phone = profile.veterinarian?.phoneNumber {
            vetPhone = phone
            veterinarianPhoneNumberTextField.text = phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        }
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = R.font.aileronBold(size: 18)
        saveButton.redAndGrayStyle(active: true)
        saveButton.isUserInteractionEnabled = true
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        hideActivityIndicator()
//        saveButton.setImage(R.image.saveButton(), for: .normal)
    }
    
    func get(name: String) {
        petName = name
        if name.isEmpty {
            delegate?.emptyNameFieldError(isHidden: false)
            saveButton.redAndGrayStyle(active: false)
//            saveButton.setImage(R.image.createUnselectedButton(), for: .normal)
        }
//
    }
    
    func get(petBreed: String) {
        breedPet = petBreed
    }
    
    func get(image: UIImage) {
        petPhoto = image
    }
}

// Validation

extension AddSmallPetView {
    func checkState() {
        
        if !petName.isEmpty && !genderType.isEmpty && !vetName!.isEmpty && !vetPhone!.isEmpty {
            
            if petName.isValidName, vetName!.isValidName, vetPhone!.count > 8 {
                saveButton.isUserInteractionEnabled = true
                saveButton.titleLabel?.font = R.font.aileronBold(size: 18)
                saveButton.redAndGrayStyle(active: true)
            }
        }
        else {
            saveButton.redAndGrayStyle(active: false)
        }
    }
}


//MARK: - Network
 extension AddSmallPetView {
    
    func addNewSmallAnimal() {
        if let name = vetName, let phone = vetPhone {
            veterianArr = [["name": name, "phoneNumber": phone]]
        }

        let smallPet = SmallPet(name: petName, speciesType: "small-animal", gender: genderType, breed: breedPet, medicalNotes: medicalNotes, veterinarians: veterianArr)
                print("Small Pet",smallPet)
        PetService().addSmallAnimal(body: smallPet) { result in
            print("Result",result)
            switch result {
            case .success(let allPets):
                self.attachAvatar(petId: allPets.id)
            case .failure(let error):
                self.hideActivityIndicator()
                self.petDelegate?.setupError(error: error)
                self.saveButton.isUserInteractionEnabled = true
//                self.saveButton.setImage(R.image.createSelectedButton(), for: .normal)
                
            }
            
        }
    }
    
    func attachAvatar(petId: String) {
        
        PetService().attachAvatar(id: petId, image: petPhoto!) { result in
            switch result {
            case .success(_):
                self.hideActivityIndicator()
                self.petDelegate?.closingScreen()
            case .failure(let error):
                self.hideActivityIndicator()
                self.petDelegate?.setupError(error: error)
            }
        }
    }
    
    func editSmallAnimal(petId: String) {
        
        if let id = vetId , let name = vetName, let phone = vetPhone {
            veterianArr = [["id": id ,"name": name, "phoneNumber": phone]]
        }

        let smallPet = SmallPetEdit(name: petName, gender: genderType, breed: breedPet, medicalNotes: medicalNotes, veterinarians: veterianArr)
        print("Small Pet",smallPet)
        PetService().editSmallAnimal(id: petId, body: smallPet) { result in
            print("Result is \(result)")
            switch result {
            case .success(_):
                if self.petPhoto == nil {
                    
                    self.hideActivityIndicator()
                    self.petDelegate?.closingScreen()
                } else {
                    self.attachEditAvatar(petId: petId)

                }
//                self.hideActivityIndicator()
//                self.attachAvatar(petId: petId)
//                self.petDelegate?.closingScreen()
            case .failure(let error):
                self.hideActivityIndicator()
                self.petDelegate?.setupError(error: error)
                self.saveButton.isUserInteractionEnabled = true
//                self.saveButton.setImage(R.image.saveButton(), for: .normal)
            }
        }
    }
     
     func attachEditAvatar(petId: String) {
       
         guard let photo = petPhoto else { return }
         
         PetService().attachAvatar(id: petId, image: photo) { result in
             switch result {
             case .success(_):
                 self.hideActivityIndicator()
                 self.petDelegate?.closingScreen()
             case .failure(let error):
                 self.hideActivityIndicator()
                 self.petDelegate?.setupError(error: error)
             }
         }
     }
}

//MARK: - Actions

extension AddSmallPetView {
    @objc func breedTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if let answerBreed = breedTextField.text {
            if containsOnlyLetters(input: answerBreed) {
               checkState()
//                errorveterinarianPhoneNumberLabel.isHidden = true
//                errorveterinarianPhoneNumberLabel.text = ""
                breedPet = answerBreed
            } else {
//                errorveterinarianPhoneNumberLabel.isHidden = false
//                errorveterinarianPhoneNumberLabel.text = "Phone is invalid"
//                saveButton.setImage(R.image.createUnselectedButton(), for: .normal)
            }
            breedPet = answerBreed
        }
    }
    
    @objc func notesTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if let answerNotes = medicationNotesTextField.text {
            if containsOnlyLetters(input: answerNotes) {
                if !petName.isEmpty && !genderType.isEmpty && !vetName!.isEmpty && !vetPhone!.isEmpty {
                    checkState()
                }
////
            } else {
               checkState()
//
            }
            medicalNotes = answerNotes
        }
    }
    
    @objc func veterinarianNameTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if veterinarianNameTextField.text?.isEmpty == true {
            veterinarianNameErrorLabel.setup(isHidden: false, text: "Veterinarian Name should not be empty")
            saveButton.redAndGrayStyle(active: false)
        } else if let answerName = veterinarianNameTextField.text {
//            print(saveButton.currentImage)
          
            if answerName.isValidName {
                    veterinarianNameErrorLabel.setup(isHidden: true, text: "Veterinarian Name should not be empty")
                    
                    checkState()
            } else {
                veterinarianNameErrorLabel.setup(isHidden: false, text: "Invalid Veterinarian Name")
//                if saveButton.titleLabel?.text == "Save" {
//                    print(true)
                    saveButton.redAndGrayStyle(active: false)
//                        saveButton.setImage(R.image.saveButton(), for: .normal)
////                }
////                else {
//                    saveButton.redAndGrayStyle(active: false)
////                    saveButton.setImage(R.image.createUnselectedButton(), for: .normal)
//                }
//                checkState()
               
//                errorveterinarianPhoneNumberLabel.isHidden = false
//                errorveterinarianPhoneNumberLabel.text = "Phone is invalid"
//                saveButton.setImage(R.image.createUnselectedButton(), for: .normal)
            }
            vetName = answerName
        }
    }
     
    
    @objc func veterianPhoneTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if let answerPhone = veterinarianPhoneNumberTextField.text {
            
            if veterinarianPhoneNumberTextField.text?.isEmpty == true {
                veterinarianPhoneNumberErrorLabel.setup(isHidden: false, text: "Veterinarian Number should not be empty")
//                    checkState()
                saveButton.redAndGrayStyle(active: false)
//
            } else if phoneValidation(phone: answerPhone) {
                
                    veterinarianPhoneNumberErrorLabel.setup(isHidden: true, text: "Veterinarian Number should not be empty")
                    vetPhone = answerPhone
                    checkState()
//                if answerPhone.count >= 9 {
//
//
//                }
            } else {
                veterinarianPhoneNumberErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                saveButton.redAndGrayStyle(active: false)
//
            }
            vetPhone = answerPhone
        }
        vetPhone = vetPhone?.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
        if vetPhone!.isValidPhone {
            veterinarianPhoneNumberErrorLabel.setup(isHidden: true, text: "Invalid Phone Number")
            checkState()
        }
    }
    
    @objc func saveButtonAction(sender: UIButton) {
//        if sender.currentImage == UIImage(named: "createSelectedButton") {
//            showActivityIndicator()
//            sender.isUserInteractionEnabled = false
//            addNewSmallAnimal()
////            saveButton.setImage(R.image.createUnselectedButton(), for: .normal)
//
//
//        } else if sender.currentImage == UIImage(named: "SaveButton") {
//            showActivityIndicator()
//            editSmallAnimal(petId: petId)
//        }
        if petId != "" {
            showActivityIndicator()
            editSmallAnimal(petId: petId)
        } else {
            showActivityIndicator()
            sender.isUserInteractionEnabled = false
            addNewSmallAnimal()
        }
        
    }
    
    func highlightedTextField(field: SkyFloatingLabelTextFieldWithIcon) {
        if field.text?.isEmpty ?? true {
            field.style(active: false)
        } else {
            field.style(active: true)
        }
    }
    
    func GetImageData(image:UIImage) {
        print(image)
    }
}

//MARK: - Activity indicator setup

extension AddSmallPetView {
    private func showActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        }
        activityView?.center = self.center
        self.addSubview(activityView!)
        
        activityView?.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        activityView?.startAnimating()
//        self.view.isUserInteractionEnabled = false
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }

    private func hideActivityIndicator(){
        activityView?.stopAnimating()
//        self.view.isUserInteractionEnabled = true
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
}

