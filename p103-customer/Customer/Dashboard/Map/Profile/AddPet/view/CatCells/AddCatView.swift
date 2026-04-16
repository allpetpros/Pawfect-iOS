//
//  AddCatView.swift
//  p103-customer
//
//  Created by Daria Pr on 12.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON



@objc protocol VaccinationCatDelegate: class {
    func addNewPhotos()
    func viewPhoto()
    func addOneNewPhoto()
    func close()
    func setup(error: Error)
}

class AddCatView: UIView {
    
    //MARK: - UIProperties
    private let birthDateIconBtn: UIButton = {
        let b = UIButton()
        let image = UIImage(named: "calendar-1")
        
        b.setImage(image, for: .normal)
        b.addTarget(self, action: #selector(birthdateIconTapped), for: .touchUpInside)
        return b
    }()
    
    private lazy var birthdateTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Select Birthdate*")
        tf.addTarget(self, action: #selector(birthdateTextFieldAction), for: .allEvents)
        tf.delegate = self
        tf.tag = 3
        return tf
    } ()
    
    private lazy var ageTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Age*")
        tf.keyboardType = .numberPad
        tf.addTarget(self, action: #selector(ageTextFieldAction), for: .editingChanged)
        tf.returnKeyType = UIReturnKeyType.next
        tf.delegate = self
        tf.isUserInteractionEnabled = false
        tf.tag = 4
        return tf
    } ()
    
    private lazy var breedTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Breed")
        tf.keyboardType = .alphabet
        tf.addTarget(self, action: #selector(breedTextFieldAction), for: .editingChanged)
        tf.returnKeyType = UIReturnKeyType.next
        tf.delegate = self
        tf.tag = 5
        return tf
    } ()
    
    private lazy var feedingLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronSemiBold(size: 16)
        l.text = "Feeding"
        l.textColor = .color293147
        return l
    } ()
    
    private lazy var feedingTextView: InstructionsTextView = {
        let tv = InstructionsTextView()
        tv.setup(placeholder: "Feeding Instructions")
        tv.tag = 6
        return tv
    } ()
    
    private lazy var medicationDescriptionTextView: InstructionsTextView = {
        let tv = InstructionsTextView()
        tv.setup(placeholder: "Medication Instructions")
        tv.tag = 7
        return tv
    }()
    
    private lazy var neuteredView: YesOrNoView = {
        let view = YesOrNoView()
        view.setup(type: .neutered)
        view.delegate = self
        return view
    }()
    
    private lazy var vaccinationLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronSemiBold(size: 16)
        l.text = "Vaccinations"
        l.textColor = .color293147
        return l
    } ()
    
    private lazy var uploadImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.direction1()
        iv.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        return iv
    } ()
    
    private let uploadButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(uploadButtonAction), for: .touchUpInside)
        return b
    }()
    
    private lazy var vaccinationView: VaccinationView = {
        let v = VaccinationView()
        v.isHidden = true
        v.delegate = self
        return v
    } ()
    
    private lazy var medicalView: YesOrNoView = {
        let view = YesOrNoView()
        view.setup(type: .medications)
        view.delegate = self
        return view
    }()
    
    private lazy var medicationRequirementsTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Medical requirements")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.addTarget(self, action: #selector(requirementsTextFieldAction), for: .editingChanged)
        tv.delegate = self
        tv.tag = 8
        tv.returnKeyType = UIReturnKeyType.next
        return tv
    } ()
    
    private lazy var medicationNotesTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Medical notes/concerns")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.addTarget(self, action: #selector(notesTextFieldAction), for: .editingChanged)
        tv.delegate = self
        tv.tag = 9
        tv.returnKeyType = UIReturnKeyType.next
        return tv
    } ()
    
    private lazy var veterinarianNameTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Veterinarian Name*")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.addTarget(self, action: #selector(veterinarianNameTextFieldAction), for: .editingChanged)
        tv.delegate = self
        tv.tag = 10
        tv.returnKeyType = UIReturnKeyType.next
        return tv
    } ()
    
    private let veterinarianNameErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Name field should not be empty")
        return l
    } ()
    
    private lazy var veterinarianPhoneNumberTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Veterinarian Phone Number*")
        tv.keyboardType = .phonePad
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.delegate = self
        tv.addTarget(self, action: #selector(veterianPhoneTextFieldAction), for: .editingChanged)
        tv.delegate = self
        tv.tag = 11
        tv.returnKeyType = UIReturnKeyType.next
        return tv
    } ()
    
    private let veterinarianPhoneNumberErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Phone Number should not be empty")
        return l
    } ()
    
    private lazy var litterBoxLocationTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Location of litter box")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.addTarget(self, action: #selector(litterBoxTextFieldAction), for: .editingChanged)
        tv.delegate = self
        tv.tag = 12
        tv.returnKeyType = UIReturnKeyType.done
        return tv
    } ()
    
//    private lazy var catFriendlyButton: ButtonWithTrailingCheckbox = {
//        let b = ButtonWithTrailingCheckbox()
//        b.setup(component: .catFriendly, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
//        b.vkl()
//        shy = "friendly"
//        b.delegate = self
//        return b
//    } ()
//
//    private lazy var shyButton: ButtonWithTrailingCheckbox = {
//        let b = ButtonWithTrailingCheckbox()
//        b.setup(component: .shy, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
//        b.delegate = self
//        return b
//    } ()
    
    let saveButton: UIButton = {
        let b = UIButton()

        b.cornerRadius = 15
        b.setTitle("Create", for: .normal)
        b.titleLabel?.font = R.font.aileronBold(size: 18)
        b.redAndGrayStyle(active: false)
        b.isUserInteractionEnabled = false
        b.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private var activityView: UIActivityIndicatorView?

    //MARK: - Properties
    var editPetPhoto: UIImage?
    private var petId = String()
    private var typeOfPet = String()
    private var petName = String()
    private var genderType = String()
    private var petBreedType = "-"
    private var medication: Bool?
    var petPhoto = UIImage()
    private var petAge: Int?
    private var birthdateText: Int?
    private var medicalRequirements: String?
    private var medicalNotes: String?
    var vetName: String?
    var vetPhone: String?
    var vetId: String?
    private var litterBox: String?
    private var medicationDescription = "-"
    private var feedingDescription = "-"
    private var neutered: Bool?
    private var shy: String?
    private var vetArr: [[String: String]]?
    private var imageArr = [UIImage]()
    
    weak var delegate: VaccinationCatDelegate?
    weak var delegateError: SmallPetErrorDelegate?
    
    private var vaccineArr = [String]()
    private var vaccineIdArr = [String]()
    private var arrayOfVaccination = [UIImageView]()
    let birthdateDatePicker = UIDatePicker()
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        ImageManager.shared.isEdit = false
        
        setupAgeAndBreed()
        setupFeedingAndVaccination()
        setupVeterian()
        birthdateDatePicker.datePickerMode = .date
        birthdateDatePicker.contentHorizontalAlignment = .center
        birthdateDatePicker.maximumDate = Date()
        birthdateDatePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())
        birthdateDatePicker.contentMode = .center
        if #available(iOS 13.4, *) {
            birthdateDatePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        birthdateTextField.inputView = birthdateDatePicker
        birthdateDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        birthdateTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(handleDatePicker))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Layout

private extension AddCatView {
    func setupAgeAndBreed() {
        addSubviews([birthdateTextField,birthDateIconBtn,ageTextField, breedTextField])
        
        birthdateTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        birthDateIconBtn.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-35)
            $0.bottom.equalTo(birthdateTextField.snp.bottom).offset(-8)
            $0.height.equalTo(20)
            $0.width.equalTo(20)
            
        }
        
        ageTextField.snp.makeConstraints {
            $0.top.equalTo(birthdateTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        breedTextField.snp.makeConstraints {
            $0.top.equalTo(ageTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
    }
    
    func setupFeedingAndVaccination() {
        addSubviews([feedingLabel, feedingTextView, medicationDescriptionTextView, neuteredView, vaccinationLabel, uploadImageView, uploadButton, vaccinationView])
        
        let title = NSAttributedString(string: "Upload pet records", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: R.font.aileronLight(size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.color606572])
        uploadButton.setAttributedTitle(title, for: .normal)
        
        feedingLabel.snp.makeConstraints {
            $0.top.equalTo(breedTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(26)
        }
        
        feedingTextView.snp.makeConstraints {
            $0.top.equalTo(feedingLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        medicationDescriptionTextView.snp.makeConstraints {
            $0.top.equalTo(feedingTextView.snp.bottom).offset(45)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        neuteredView.snp.makeConstraints {
            $0.top.equalTo(medicationDescriptionTextView.snp.bottom).offset(25)
            $0.left.equalToSuperview().offset(25)
            $0.height.equalTo(60)
        }
        
        vaccinationLabel.snp.makeConstraints {
            $0.top.equalTo(neuteredView.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
        }
        
        vaccinationView.snp.makeConstraints {
            $0.top.equalTo(vaccinationLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview()
            $0.height.equalTo(159)
        }

        uploadImageView.snp.makeConstraints {
            $0.left.equalTo(25)
            $0.top.equalTo(vaccinationLabel).offset(40)
        }
        
        uploadButton.snp.makeConstraints {
            $0.left.equalTo(uploadImageView).offset(20)
            $0.top.equalTo(vaccinationLabel).offset(37)
        }
    }

    func setupVeterian() {
        addSubviews([medicalView, medicationRequirementsTextField, medicationNotesTextField, veterinarianNameTextField, veterinarianPhoneNumberTextField, litterBoxLocationTextField, saveButton, veterinarianNameErrorLabel,veterinarianPhoneNumberErrorLabel])
        
        medicalView.snp.makeConstraints {
            $0.top.equalTo(uploadImageView.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.height.equalTo(60)
            $0.width.equalTo(200)
        }
        
        medicationRequirementsTextField.snp.makeConstraints {
            $0.top.equalTo(medicalView.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        medicationNotesTextField.snp.makeConstraints {
            $0.top.equalTo(medicationRequirementsTextField.snp.bottom).offset(40)
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
            $0.leading.equalTo(veterinarianNameTextField)
        }

        
        litterBoxLocationTextField.snp.makeConstraints {
            $0.top.equalTo(veterinarianPhoneNumberTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        

        
        saveButton.snp.makeConstraints {

            $0.top.equalTo(litterBoxLocationTextField.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
    
    func setupViewForVaccinationEditing() {
        medicalView.snp.remakeConstraints {
            $0.height.equalTo(60)
            $0.left.equalTo(25)
            $0.width.equalTo(200)
            $0.top.equalTo(uploadButton).offset(200)
        }
        uploadImageView.isHidden = true
        uploadButton.isHidden = true
        vaccinationView.isHidden = false
    }
}

//MARK: - TextField`s Actions

extension AddCatView {
    @objc func birthdateTextFieldAction(sender: UITextField) {
    }
    
    @objc func birthdateIconTapped () {

        handleDateFromDatePicker()
    }
    
    func handleDateFromDatePicker() {
        birthdateTextField.inputView = birthdateDatePicker
        birthdateTextField.becomeFirstResponder()
        birthdateDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        birthdateTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(handleDatePicker))
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        birthdateText = Int( birthdateDatePicker.date.millisecondsSince1970)
        birthdateTextField.text = dateFormatter.string(from: birthdateDatePicker.date)
        getAge(date: birthdateDatePicker.date)
        checkState()
    }
    
    func getAge(date: Date) {
        
        let now = Date()
        print("Date\(date)")
        let diffComponents = Calendar.current.dateComponents([.year ,.month,.day], from: date, to: now)
        print(diffComponents)

        if diffComponents.month == 0 && diffComponents.year == 0{
            ageTextField.text = "\(diffComponents.day!) Days"
        } else if diffComponents.year == 0 {
            if diffComponents.month == 1 {
                ageTextField.text = "\(diffComponents.month!) " + "Month"
            } else {
                ageTextField.text = "\(diffComponents.month!) " + "Months"
            }
        } else if diffComponents.year! != 0 && diffComponents.month != 0 {
            if diffComponents.year == 1 && diffComponents.month == 1 {
                ageTextField.text = "\(diffComponents.year!) " + "Year, " + "\(diffComponents.month!)" + "Month"
            } else if diffComponents.year == 1 && diffComponents.month != 1 {
                ageTextField.text = "\(diffComponents.year!) " + "Year, " + "\(diffComponents.month!)" + "Months"

            } else if diffComponents.year != 1 && diffComponents.month == 1{
                ageTextField.text = "\(diffComponents.year!) " + "Years, " + "\(diffComponents.month!)" + "Month"
            } else if diffComponents.year! > 1 && diffComponents.month! > 1 {
                ageTextField.text = "\(diffComponents.year!) " + "Years, " + "\(diffComponents.month!)" + "Months"
            }

        } else if diffComponents.year! != 0 && diffComponents.month == 0{
            if diffComponents.year == 1 {
                ageTextField.text = "\(diffComponents.year!) " + "Year"
            } else {
                ageTextField.text = "\(diffComponents.year!) " + "Years"

            }
        }
        petAge = 0
    }
    
    @objc func ageTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
 
        highlightedTextField(field: field)

    }
    
    @objc func breedTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if let answerBreed = breedTextField.text {
            petBreedType = answerBreed
        }
    }
    
    @objc func requirementsTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if let medicalReq = medicationRequirementsTextField.text {
            medicalRequirements = medicalReq
        }
    }
    
    @objc func notesTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if let answerNotes = medicationNotesTextField.text {
            medicalNotes = answerNotes
        }
    }
    
    @objc func veterinarianNameTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if veterinarianNameTextField.text?.isEmpty == true {
            veterinarianNameErrorLabel.setup(isHidden: false, text: "Veterinarian Name should not be empty")
            saveButton.redAndGrayStyle(active: false)
        } else if let answerName = veterinarianNameTextField.text {
        
//            vetName = answerName
            if answerName.isValidName {
//
                    veterinarianNameErrorLabel.setup(isHidden: true, text: "Veterinarian Name should not be empty")
                    checkState()
                   
                }
//
                else {
                veterinarianNameErrorLabel.setup(isHidden: false, text: "Invalid Veterinarian Name")
                saveButton.redAndGrayStyle(active: false)
//
            }
            vetName = answerName
        }
    }
    
    @objc func veterianPhoneTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if let answerPhone = veterinarianPhoneNumberTextField.text {
            if veterinarianPhoneNumberTextField.text?.isEmpty == true {
                veterinarianPhoneNumberErrorLabel.setup(isHidden: false, text: "Veterinarian Number should not be empty")
                saveButton.redAndGrayStyle(active: false)
//
            } else if phoneValidation(phone: answerPhone) {
                
                    veterinarianPhoneNumberErrorLabel.setup(isHidden: true, text: "Veterinarian Number should not be empty")
                    vetPhone = answerPhone
                    checkState()
               
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

    @objc func litterBoxTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if let answerLitter = litterBoxLocationTextField.text {
            litterBox = answerLitter
        }
    }
    
    func highlightedTextField(field: SkyFloatingLabelTextFieldWithIcon) {
        if field.text?.isEmpty ?? true {
            field.style(active: false)
        } else {
            field.style(active: true)
        }
    }
}


extension AddCatView {
    func checkState() {
        if !petName.isEmpty && !genderType.isEmpty && !vetName!.isEmpty && !vetPhone!.isEmpty && !birthdateTextField.text!.isEmpty && !ageTextField.text!.isEmpty {
            if petName.isValidName && vetName!.isValidName && vetPhone!.count > 8 {

            saveButton.isUserInteractionEnabled = true
            
            saveButton.redAndGrayStyle(active: true)
//
            }
//            saveButton.setImage(R.image.createSelectedButton(), for: .normal)
        }
        else {
            saveButton.redAndGrayStyle(active: false)
//
        }
    }
}
//MARK: - Actions

extension AddCatView {
    @objc func uploadButtonAction() {
        medicalView.snp.remakeConstraints {
            $0.height.equalTo(60)
            $0.left.equalTo(25)
            $0.width.equalTo(200)
            $0.top.equalTo(uploadButton).offset(200)
        }
        uploadImageView.isHidden = true
        uploadButton.isHidden = true
        vaccinationView.isHidden = false
        delegate?.addNewPhotos()
    }
    
    @objc func saveButtonAction(sender: UIButton) {
        if petId != "" {
            editCat(petId: petId)
        } else {
            addCat()
        }
    }
}

//MARK: - Public func

extension AddCatView {
    func sendRequiredInfo(name: String, speciesType: String, gender: String, avatar: UIImage, veterianName: String, veterianPhoneNumber: String) {
        petName = name
        genderType = gender
        petPhoto = avatar
        vetName = veterianName
        vetPhone = veterianPhoneNumber
        checkState()
    }
}

//MARK: - YesOrNoViewDelegate

extension AddCatView: YesOrNoViewDelegate {
    func tapOnQuestion(question: YesOrNoViewGroups, answer: Bool) {
        if question == .medications {
            medication = answer
        }
        if question == .neutered {
            neutered = answer
        }
    }
}

//MARK: - ButtonWithTrailingCheckboxDelegate

extension AddCatView: ButtonWithTrailingCheckboxDelegate {
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool) {
//        if questions == .catFriendly && answer == true {
//            shyButton.vukl()
//            catFriendlyButton.vkl()
//            shy = "friendly"
//        } else if questions == .shy && answer == true {
//            catFriendlyButton.vukl()
//            shyButton.vkl()
//            shy = "shy"
//        }
//        else if questions == .catFriendly && answer == false {
//            catFriendlyButton.vkl()
////            shyButton.vukl()
//            shy = "friendly"
//        } else if questions == .shy && answer == false {
////            catFriendlyButton.vukl()
//            shyButton.vkl()
//            shy = "shy"
//        }
    }
}


//MARK: - Network

private extension AddCatView {
    
    func getVaccination() {
        ImageManager.shared.vaccineStruct = []
        
        for _ in 0..<8 {
            ImageManager.shared.vaccineStruct.append(ImageVaccine(img: UIImageView(image: R.image.vaccinePhotoButton()), id: "empty"))
        }

        PetService().getVaccinePhoto(id: petId) { result in
            switch result {
            case .success(let vaccine):
                self.setupViewForVaccinationEditing()
                for i in 0..<vaccine.items.count {
                    let img = UIImageView()
                    img.sd_setImage(with: URL(string: vaccine.items[i].imageUrl))
                    ImageManager.shared.vaccineStruct[i].id = vaccine.items[i].id
                    ImageManager.shared.vaccineStruct[i].img = img
                    self.vaccineArr.append(vaccine.items[i].imageUrl)
                    self.vaccineIdArr.append(vaccine.items[i].id)
                    ImageManager.shared.testDict[vaccine.items[i].id] = img
                    ImageManager.shared.testId.append(vaccine.items[i].id)
                }
                self.vaccinationView.setPhoto(imageUrls: self.vaccineArr)
            case .failure(let error):
                self.delegate?.setup(error: error)
            }
        }
    }
    
    func editCat(petId: String) {
        showActivityIndicator()
        
        if let id = vetId , let name = vetName, let phone = vetPhone {
            vetArr = [["id": id ,"name": name, "phoneNumber": phone]]
        }
        
        feedingDescription = feedingTextView.getText()
        if feedingDescription.isEmpty {
            feedingDescription = "-"
        }
        
        medicationDescription = medicationDescriptionTextView.getText()
        if medicationDescription.isEmpty {
            medicationDescription = "-"
        }

        let cat = CatStruct(name: petName, gender: genderType, breed: petBreedType, medicalNotes: medicalNotes, medicalRequirements: medicalRequirements, veterinarians: vetArr, age: petAge, dob: birthdateText, feedingInstructions: feedingDescription, medicationInstructions: medicationDescription, isSpayed: neutered, hasMedication: medication, locationOfLitterbox: litterBox)
        
        
        PetService().editCat(id: petId, body: cat) { result in
            switch result {
            case .success(_):
                
                for i in ImageManager.shared.vaccineStruct {
                    if i.id == "local" {
                        self.imageArr.append(i.img.image!)
                    }
                }
                if self.editPetPhoto != nil {

                } else {
                if self.imageArr.count != 0 {
                    self.attachVaccinations(petId: petId)
                } else {
                    self.hideActivityIndicator()
                    self.delegate?.close()
                }
                }

            case .failure(let error):
                self.hideActivityIndicator()
                self.delegate?.setup(error: error)
            }
        }
    }
    func attachEditAvatar(petId: String) {
        
        guard let photo = editPetPhoto else { return }
        
        PetService().attachAvatar(id: petId, image: photo) { result in
            switch result {
            case .success(_):
                if !self.imageArr.isEmpty {
                    self.attachVaccinations(petId: petId)
                } else {
                    self.hideActivityIndicator()
                    self.delegate?.close()
                }
            case .failure(let error):
                self.hideActivityIndicator()
                self.delegate?.setup(error: error)
            }
        }
    }

    
    func addCat() {
        showActivityIndicator()
        feedingDescription = feedingTextView.getText()
        if feedingDescription.isEmpty {
            feedingDescription = "-"
        }
        
        medicationDescription = medicationDescriptionTextView.getText()
        if medicationDescription.isEmpty {
            medicationDescription = "-"
        }
        
        if let name = vetName, let phone = vetPhone {
            vetArr = [["name": name, "phoneNumber": phone]]
        }
        
        let cat = CatStructAdd(name: petName, gender: genderType, speciesType: "cat", breed: petBreedType, medicalNotes: medicalNotes, medicalRequirements: medicalRequirements, veterinarians: vetArr, age: petAge, dob: birthdateText, feedingInstructions: feedingDescription, medicationInstructions: medicationDescription, isSpayed: neutered, hasMedication: medication, locationOfLitterbox: litterBox)

        PetService().addCat(body: cat) { result in
            switch result {
            case .success(let allPets):
                
                self.attachAvatar(petId: allPets.id)
            case .failure(let error):
                self.delegate?.setup(error: error)
                self.hideActivityIndicator()
                self.saveButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func attachAvatar(petId: String) {
        
        for i in vaccinationView.vaccineButtonsArr {
            if i.currentImage != UIImage(named: "vaccinePhotoButton") {
                imageArr.append(i.currentImage!)
            }
        }

        PetService().attachAvatar(id: petId, image: petPhoto) { result in
            switch result {
            case .success(_):
                if !self.imageArr.isEmpty {
                    self.attachVaccinations(petId: petId)
                } else {
                    self.hideActivityIndicator()
                    self.delegate?.close()
                }
            case .failure(let error):
                self.hideActivityIndicator()
                self.delegate?.setup(error: error)
            }
        }
    }

    func attachVaccinations(petId: String) {
        
        let baseURL = "\(Constant.baseURL)/customer/pets/\(petId)/vaccinations"
        if let token = DBManager.shared.getAccessToken() {
            let Auth_header: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            
            var j = 0
            
            AF.upload(multipartFormData: { (multiFormData) in
                for photo in self.imageArr {
                    multiFormData.append(photo.jpegData(compressionQuality: 0.1)!, withName: "vaccinations", fileName: "vaccination\(j).jpeg", mimeType: "image/jpeg")
                    j+=1
                }
            }, to: baseURL, method: .post, headers: Auth_header).responseJSON { response in
                switch response.result {
                case .success(_):
                    self.delegate?.close()
                    self.hideActivityIndicator()
                case .failure(let error):
                    self.hideActivityIndicator()
                    self.delegate?.setup(error: error)
                }
            }
        }
    }
}

extension AddCatView : UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }

        return true
    }
}

// MARK:- UITextField Delegate
extension AddCatView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 11 {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                      return false
                  }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            let text = textField.text
            textField.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            
            return count <= 14
        }
        if textField.tag == 3 {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
               nextField.becomeFirstResponder()
            } else {
               textField.resignFirstResponder()
            }
            return false
    }
   
    
}

//MARK: - Public funcs

extension AddCatView {
    func setupPhotosToButtons() {
        vaccinationView.setVaccinePhoto()
    }
    
    func removePhoto(onIndex: Int) {
        if ImageManager.shared.isEdit {
            vaccinationView.setVaccinePhoto()
        } else {
            ImageManager.shared.photoArray[onIndex] = R.image.vaccinePhotoButton()!
            vaccinationView.setVaccinePhoto()
        }
    }
    
    func setupView(catProfile: CatStructGet, id: String, name: String, breed: String, gender: String) {
        ImageManager.shared.isEdit = true
        ImageManager.shared.petType = "cat"
        petName = name
        ImageManager.shared.petId = id
        petId = id
        petBreedType = breed
        genderType = gender
        breedTextField.isHidden = true
        
        feedingLabel.snp.remakeConstraints {
            $0.top.equalTo(ageTextField.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(26)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date = dateFormatter.string(from: CommonFunction.shared.fromMillisToDate(millis: Double(catProfile.dob!)))
        birthdateTextField.text = "\(date)"
        birthdateText = catProfile.dob
        getAge(date: CommonFunction.shared.fromMillisToDate(millis: Double(catProfile.dob!)))

       
        if let feed = catProfile.feedingInstructions {
            if feed != "-" {
                feedingTextView.setup(text: feed, placeholder: "Feeding Instructions")
            }
            feedingDescription = feed
        }
        
        if let med = catProfile.medicationInstructions {
            if med != "-" {
                medicationDescriptionTextView.setup(text: med, placeholder: "Medication Description")
            }
            medicationDescription = med
        }

        if catProfile.isSprayed == true {
            neuteredView.setValue(true)
            neutered = true
        } else {
            neuteredView.setValue(false)
            neutered = false
        }
        if catProfile.hasMedication == true {
            medication = true
            medicalView.setValue(true)
        } else {
            medication = false
            medicalView.setValue(false)
        }
        
        medicationRequirementsTextField.text = catProfile.medicalRequirements
        medicalRequirements = catProfile.medicalRequirements
        medicationNotesTextField.text = catProfile.medicalNotes
        medicalNotes = catProfile.medicalNotes
        
        if let id = catProfile.veterinarian?.id {
            vetId = id
        }
        
        if let name = catProfile.veterinarian?.name {
            vetName = name
            veterinarianNameTextField.text = name
        }
        
        if let phone = catProfile.veterinarian?.phoneNumber {
            vetPhone = phone
            veterinarianPhoneNumberTextField.text = phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        }
        litterBoxLocationTextField.text = catProfile.locationOfLitterbox
        litterBox = catProfile.locationOfLitterbox
        saveButton.setTitle("Save", for: .normal)
        saveButton.redAndGrayStyle(active: true)
        saveButton.isUserInteractionEnabled = true
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        getVaccination()
        
    }
    
    func get(name: String) {
        petName = name
        if name.isEmpty {
            delegateError?.emptyNameFieldError(isHidden: false)
            saveButton.redAndGrayStyle(active: false)
        } else {
            delegateError?.emptyNameFieldError(isHidden: true)
            saveButton.redAndGrayStyle(active: true)
        }
    }
    
    func get(petBreed: String) {
        petBreedType = petBreed
    }
    
    func get(image: UIImage) {
        editPetPhoto = image
    }
}

//MARK: - VaccineDelegate

extension AddCatView: VaccineDelegate {
    func newPhoto() {
        delegate?.addOneNewPhoto()
    }
    
    func photoViewer() {
        delegate?.viewPhoto()
    }
}

//MARK: - UITextFieldDelegate

//MARK: - Activity

extension AddCatView {
    private func showActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        }
        activityView?.center = self.center
        self.addSubview(activityView!)
        
        activityView?.snp.makeConstraints {
            $0.top.equalTo(veterinarianNameTextField)
            $0.centerX.equalToSuperview()
        }
        activityView?.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    private func hideActivityIndicator(){
        activityView?.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}


