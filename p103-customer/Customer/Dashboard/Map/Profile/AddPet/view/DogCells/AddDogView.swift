//
//  AddDogView.swift
//  p103-customer
//
//  Created by Daria Pr on 12.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import FSCalendar
import SwiftUI

@objc protocol SlidersDelegate: AnyObject {
    func getPet(size: String)
    func getSize(amount: String)
}

@objc protocol DogDelegate: AnyObject {
    func toCloseScreen()
}
enum MyError: Error {
    case runtimeError(String)
}
class AddDogView: UIView, CustomAlertViewDelegate {
 
    //MARK: - UIProperties
    var tags: Int?
    var addPetView = AddPetView()
    private lazy var alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.delegate = self
        return view
    }()
    
    private lazy var birthdateTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Select Birthdate*")
        tf.addTarget(self, action: #selector(birthdateTextFieldAction), for: .allEvents)
        tf.delegate = self
        tf.tag = 3
        return tf
    } ()
    private let birthDateIconBtn: UIButton = {
        let b = UIButton()
        let image = UIImage(named: "calendar-1")
        b.setImage(image, for: .normal)
        b.addTarget(self, action: #selector(birthdateIconTapped), for: .touchUpInside)
        return b
    }()
    
    private lazy var ageTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Age*")
        tf.keyboardType = .numberPad
        tf.isUserInteractionEnabled = false
        tf.delegate = self
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

    private lazy var slidersView: SlidersView = {
        let sv = SlidersView()
        sv.delegate = self
        return sv
    } ()
    
    private let feedingLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronSemiBold(size: 16)
        l.text = "Feeding"
        l.textColor = .color293147
        return l
    } ()
    
    private let feedingTextView: InstructionsTextView = {
        let tv = InstructionsTextView()
        tv.setup(placeholder: "Feeding Instructions")
        tv.tag = 6
        return tv
    } ()
    
    private let walkView: WalkQuestionMultipleAnswerView = {
        let v = WalkQuestionMultipleAnswerView()
        v.setupLayout()
        return v
    } ()
    
    private let homeView: HomeQuestionMultipleAnswerView = {
       let v = HomeQuestionMultipleAnswerView()
        v.setupLayout()
        return v
    } ()
    
    private let medicationDescriptionTextView: InstructionsTextView = {
        let tv = InstructionsTextView()
        tv.setup(placeholder: "Medication Instructions")
        return tv
    }()

    private lazy var neuteredView: YesOrNoView = {
        let view = YesOrNoView()
        view.setup(type: .neutered)
        view.delegate = self
        return view
    }()
    
    private let vaccinationLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronSemiBold(size: 16)
        l.text = "Vaccinations"
        l.textColor = .color293147
        return l
    } ()
    
    private let uploadImageView: UIImageView = {
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
    
    private let medicalView: YesOrNoView = {
        let view = YesOrNoView()
        view.setup(type: .medications)
        return view
    }()
    
    private lazy var medicationRequirementsTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Medical requirements")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.addTarget(self, action: #selector(requirementsTextFieldAction), for: .editingChanged)
        tv.returnKeyType = UIReturnKeyType.next
        tv.delegate = self
        tv.tag = 7
        return tv
    } ()
    
    private lazy var medicationNotesTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Medical notes/concerns")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.addTarget(self, action: #selector(notesTextFieldAction), for: .editingChanged)
        tv.returnKeyType = UIReturnKeyType.next
        tv.delegate = self
        tv.tag = 8
        return tv
    } ()
    
    private lazy var veterinarianNameTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Veterinarian Name*")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.addTarget(self, action: #selector(veterinarianNameTextFieldAction), for: .editingChanged)
        tv.returnKeyType = UIReturnKeyType.search
        tv.delegate = self
        tv.tag = 9
        return tv
    } ()
    
    private lazy var veterinarianNameErrorLabel: ErrorRequiredFieldsView = {
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
        tv.returnKeyType = UIReturnKeyType.next
        tv.delegate = self
        tv.tag = 10
        return tv
    } ()
    
    private let veterinarianPhoneNumberErrorLabel: ErrorRequiredFieldsView = {
            let l = ErrorRequiredFieldsView()
            l.setup(isHidden: true, text: "Phone Number should not be empty")
            return l
    }()

    
    private lazy var doggyDoorView: YesOrNoView = {
        let view = YesOrNoView()
        view.setup(type: .doggyDoor)
        view.delegate = self
        return view
    }()
   

    
    private lazy var vaccinationView: VaccinationView = {
        let v = VaccinationView()
        v.isHidden = true
        v.delegate = self
        return v
    } ()
    
     let saveButton: UIButton = {
         let b = UIButton(type: .custom)
        b.cornerRadius = 15
        b.setTitle("Create", for: .normal)
        b.titleLabel?.font = R.font.aileronBold(size: 18)
        b.redAndGrayStyle(active: false)
        b.isUserInteractionEnabled = false
        b.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        return b
    }()

    
    private var activityView: UIActivityIndicatorView?
    
    //MARK: - Properties
    
    private var petId = String()
    
    var typeOfPet = String()
    var petName = String()
    var genderType = String()
    var petPhoto: UIImage?
    var editPetPhoto: UIImage?
    var type = String()
    private var breedPet = "-"
    private var medication: Bool?
    private var petBirthdate: Int?
    private var petAge: Int?
    private var medicalRequirements: String?
    private var medicalNotes: String?
    var vetName: String?
    var vetId: String?
    var vetPhone: String?
    private var medicationDescription: String?
    private var feedingDescription: String?
    private var neutered: Bool?
    private var shy: String?
    private var isDoggyDoor: Bool?
    private var sizeOfPet = String()
    private var sizeAmount = Int()
    
    private var walksDict = ["Is leash trained": false, "Doesn't like interacting with other dogs/people": false, "Chases small animals/birds": false, "Pulls on leash ": false]
    
    private var homeDict = ["Protective (barks at strangers) ": false, "Tries to rush out for walk/playtime": false, "Pees from excitement": false, "Shy, but warms up eventually": false]
    
    private var walksArr = [String]()
    private var homeArr = [String]()
    
    private var imageArr = [UIImage]()
    private var vaccineArr = [String]()
    
    private var vetArr: [[String: String]]?
    
    weak var delegate: VaccinationCatDelegate?
    weak var delegateError: SmallPetErrorDelegate?
    weak var dogDelegate: DogDelegate?
    var birthdateDatePicker = UIDatePicker()
    var label = UILabel()
    var isEditDogApiCalled = Bool()
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
                
        medicalView.delegate = self
        neuteredView.delegate = self
        
        ImageManager.shared.isEdit = false

        setupAgeAndBreed()
        setupFeeding()
        setupMedication()
        setupVeterian()
        
        birthdateDatePicker.datePickerMode = .date
        birthdateDatePicker.contentHorizontalAlignment = .center
        if #available(iOS 13.4, *) {
            birthdateDatePicker.preferredDatePickerStyle = .wheels
        } else {
        }
        birthdateDatePicker.maximumDate = Date()
        birthdateDatePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -20, to: Date())
        birthdateDatePicker.contentMode = .center
        birthdateTextField.inputView = birthdateDatePicker
        birthdateDatePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        birthdateTextField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(handleDatePicker))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Layout
    
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
    
    func setupFeeding() {
        addSubviews([feedingLabel, feedingTextView, slidersView])
        slidersView.snp.makeConstraints {
            $0.top.equalTo(breedTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        feedingLabel.snp.makeConstraints {
            $0.top.equalTo(slidersView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(26)
        }
        
        feedingTextView.snp.makeConstraints {
            $0.top.equalTo(feedingLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    func setupMedication() {
        addSubviews([medicationDescriptionTextView, neuteredView, vaccinationLabel, uploadImageView, uploadButton, walkView, homeView, vaccinationView])
        
        let title = NSAttributedString(string: "Upload pet records", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font: R.font.aileronLight(size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.color606572])
        uploadButton.setAttributedTitle(title, for: .normal)
        
        walkView.snp.makeConstraints {
            $0.top.equalTo(feedingTextView.snp.bottom).offset(20)
            $0.height.equalTo(200)
            $0.left.right.equalToSuperview()
        }
        
        homeView.snp.makeConstraints {
            $0.top.equalTo(walkView.snp.bottom).offset(20)
            $0.height.equalTo(230)
            $0.left.right.equalToSuperview()
        }
        
        medicationDescriptionTextView.snp.makeConstraints {
            $0.top.equalTo(homeView.snp.bottom).offset(50)
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
        addSubviews([medicalView, medicationRequirementsTextField, medicationNotesTextField, veterinarianNameTextField, veterinarianPhoneNumberTextField, doggyDoorView,saveButton,veterinarianNameErrorLabel,veterinarianPhoneNumberErrorLabel])
        
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
            $0.leading.equalTo(veterinarianPhoneNumberTextField)
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

        
        doggyDoorView.snp.makeConstraints {
            $0.top.equalTo(veterinarianPhoneNumberTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.height.equalTo(60)
            $0.width.equalTo(150)
        }
        
        
        saveButton.snp.makeConstraints {
            $0.top.equalTo(doggyDoorView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}

//MARK: - Validation

private extension AddDogView {
    func checkState() {
        if !petName.isEmpty && !genderType.isEmpty && !sizeOfPet.isEmpty && !vetName!.isEmpty && !vetPhone!.isEmpty && !birthdateTextField.text!.isEmpty && !ageTextField.text!.isEmpty {
            if petName.isValidName && vetName!.isValidName && vetPhone!.count > 8 {
            saveButton.isUserInteractionEnabled = true
            saveButton.titleLabel?.font = R.font.aileronBold(size: 18)
            saveButton.redAndGrayStyle(active: true)
            }
        } else {
            saveButton.redAndGrayStyle(active: false)
        }
    }
}

//MARK: - Actions

extension AddDogView {
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
}

//MARK: - Public funcs

extension AddDogView {
    func sendRequiredInfo(name: String, speciesType: String, gender: String, avatar: UIImage, typeView: String,veterianName: String, Vetnmber: String) {
        petName = name
        genderType = gender
        petPhoto = avatar
        type = typeView
        vetName = veterianName
        vetPhone = Vetnmber
        
        checkState()
    }
    
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
    
    func setupView(dogProfile: DogStructGet, id: String, name: String, breed: String, gender: String, typeView: String) {
        type = typeView
        ImageManager.shared.isEdit = true
        
        ImageManager.shared.petType = "dog"
        ImageManager.shared.petId = id
        petId = id
        petName = name
        genderType = gender
        breedPet = breed
        breedTextField.isHidden = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date = dateFormatter.string(from: CommonFunction.shared.fromMillisToDate(millis: Double(dogProfile.dob!)))
        birthdateTextField.text = "\(date)"
        petBirthdate = dogProfile.dob
        getAge(date: CommonFunction.shared.fromMillisToDate(millis: Double(dogProfile.dob!)))
        
        slidersView.snp.remakeConstraints {
            $0.top.equalTo(ageTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        slidersView.setSize(size: dogProfile.size, sizeType: dogProfile.sizeType)
        sizeOfPet = dogProfile.sizeType
        sizeAmount = dogProfile.size
        
        if let feed = dogProfile.feedingInstructions {
            if feed != "-" {
                feedingTextView.setup(text: feed, placeholder: "Feeding Instructions")
            }
            feedingDescription = feed
        }
        if let med = dogProfile.medicationInstructions {
            if med != "-" {
                medicationDescriptionTextView.setup(text: med, placeholder: "Medication Description")
            }
            medicationDescription = med
        }
        
        if let wArr = dogProfile.onWalks {
            walksArr = wArr
            
            for i in walksArr {
                for j in walksDict.keys {
                    if i == j {
                        walksDict[j] = true
                    }
                }
            }
            
            walkView.setupEditView(answersDict: walksDict)
        }
        
        if let entryArr = dogProfile.onSomeoneEntry {
            homeArr = entryArr
            
            for i in homeArr {
                for j in homeDict.keys {
                    if i == j {
                        homeDict[j] = true
                    }
                }
            }
            
            homeView.setupEditView(answersDict: homeDict)
        }
    
        if dogProfile.isSprayed == true {
            neutered = true
            neuteredView.setValue(true)
        } else if dogProfile.isSprayed == false {
            neutered = false
            neuteredView.setValue(false)
        }

        if dogProfile.hasMedication == true {
            medication = true
            medicalView.setValue(true)
        } else if dogProfile.hasMedication == false {
            medication = false
            medicalView.setValue(false)
        }

        medicationRequirementsTextField.text = dogProfile.medicalRequirements
        medicalRequirements = dogProfile.medicalRequirements
        medicationNotesTextField.text = dogProfile.medicalNotes
        medicalNotes = dogProfile.medicalNotes
        if let id = dogProfile.veterinarian?.id {
            vetId = id
        }
        if let name = dogProfile.veterinarian?.name {
            veterinarianNameTextField.text = name
            vetName = name
        }
        if let phone = dogProfile.veterinarian?.phoneNumber {
            veterinarianPhoneNumberTextField.text = phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            vetPhone = phone
        }
        if dogProfile.isDoggyDoorExists == true {
            isDoggyDoor = true
            doggyDoorView.setValue(true)
        } else if dogProfile.isDoggyDoorExists == false {
            isDoggyDoor = false
            doggyDoorView.setValue(false)
        }

        if dogProfile.character == "friendly" {
            shy = "friendly"
        } else if dogProfile.character == "shy" {
            shy = "shy"
        }
        
        saveButton.redAndGrayStyle(active: true)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        saveButton.isUserInteractionEnabled = true
        getVaccination()
    }
    
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
                }
                self.vaccinationView.setPhoto(imageUrls: self.vaccineArr)
            case .failure(let error):
                self.delegate?.setup(error: error)
            }
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
        breedPet = petBreed
    }
    
    func get(image: UIImage) {
        editPetPhoto = image
    }
    
}

//MARK: - VaccineDelegate

extension AddDogView: VaccineDelegate {
    func newPhoto() {
        delegate?.addOneNewPhoto()
    }
    
    func photoViewer() {
        delegate?.viewPhoto()
    }
}

//MARK: - Textfield`s Actions

extension AddDogView {
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
    
    @objc func handleDatePicker() {
        petBirthdate = Int(birthdateDatePicker.date.millisecondsSince1970)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        birthdateTextField.text = dateFormatter.string(from: birthdateDatePicker.date)
        getAge(date: birthdateDatePicker.date)
        checkState()
    }
    
    @objc func ageTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        tags = 1
        highlightedTextField(field: field)

    }
    
    @objc func breedTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        if let answerBreed = breedTextField.text {
            breedPet = answerBreed
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
        
            if answerName.isValidName {
                    veterinarianNameErrorLabel.setup(isHidden: true, text: "Veterinarian Name should not be empty")
                    checkState()
                }
           else  {
                veterinarianNameErrorLabel.setup(isHidden: false, text: "Invalid Veterinarian Name")
                saveButton.redAndGrayStyle(active: false)
            }
            vetName = answerName
        }
    }
    
    @objc func veterianPhoneTextFieldAction(field: SkyFloatingLabelTextFieldWithIcon) {
        highlightedTextField(field: field)
        tags = 2
        if let answerPhone = veterinarianPhoneNumberTextField.text {
            if veterinarianPhoneNumberTextField.text?.isEmpty == true {
                veterinarianPhoneNumberErrorLabel.setup(isHidden: false, text: "Veterinarian Number should not be empty")
                saveButton.redAndGrayStyle(active: false)
            } else if phoneValidation(phone: answerPhone) {
                    veterinarianPhoneNumberErrorLabel.setup(isHidden: true, text: "Veterinarian Number should not be empty")
                vetPhone = answerPhone
                    checkState()
            } else {
                veterinarianPhoneNumberErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                saveButton.redAndGrayStyle(active: false)
            }
            vetPhone = answerPhone
        }
        vetPhone = vetPhone?.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
        if vetPhone!.isValidPhone {
            veterinarianPhoneNumberErrorLabel.setup(isHidden: true, text: "Invalid Phone Number")
            checkState()
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

//MARK: - SaveButton Action

extension AddDogView {
    @objc func saveButtonAction(sender: UIButton) {
        if petId != "" {
            if !isEditDogApiCalled {
                editDog(petId: petId)
                isEditDogApiCalled = true
            } else {
                
            }
        } else {
            getSizeOfDog()
            addDog()
        }
    }
}

//MARK: - YesOrNoViewDelegate

extension AddDogView: YesOrNoViewDelegate {
    func tapOnQuestion(question: YesOrNoViewGroups, answer: Bool) {
        if question == .medications {
            medication = answer
        }
        if question == .neutered {
            neutered = answer
        }
        if question == .doggyDoor {
            isDoggyDoor = answer
        }
    }
}

//MARK: - ButtonWithTrailingCheckboxDelegate

extension AddDogView: ButtonWithTrailingCheckboxDelegate {
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool) {
        if questions == .dogFriendly && answer == true {
        } else if questions == .shy && answer == true {
//            dogFriendlyButton.vukl()
//            shyButton.vkl()
//            shy = "shy"
        } else if questions == .catFriendly && answer == false {
//            dogFriendlyButton.vukl()
//            shy = ""
        } else if questions == .shy && answer == false {
//            shyButton.vukl()
//            shy = ""
        }
    }
    
    func getSizeOfDog() {
        if let size = Int(slidersView.getSize()) {
            switch size {
            case 0...35:
                sizeOfPet = "small"
            case 36...45:
                sizeOfPet = "medium"
            case 46...100:
                sizeOfPet = "large"
            default:
                break
            }
        }
    }
}

//MARK: - Network

extension AddDogView {
    func editDog(petId: String) {
        showActivityIndicator()
        if let id = vetId , let name = vetName, let phone = vetPhone {
            vetArr = [["id": id ,"name": name, "phoneNumber": phone]]
        }
        walksArr = walkView.getCheckedWalkQuestion()
        homeArr = homeView.getCheckedHomeQuestion()
        
        feedingDescription = feedingTextView.getText()
        if feedingDescription?.count == 0 {
            feedingDescription = "-"
        }
        
        medicationDescription = medicationDescriptionTextView.getText()
        if medicationDescription?.count == 0 {
            medicationDescription = "-"
        }

        let dog = DogStructEdit(name: petName, gender: genderType, size: sizeAmount, sizeType: sizeOfPet, age: petAge, dob: petBirthdate,breed: breedPet, feedingInstructions: feedingDescription, medicationInstructions: medicationDescription, isSpayed: neutered, onWalksActions: walksArr, onSomeoneEntryActions: homeArr, hasMedication: medication, medicalRequirements: medicalRequirements, medicalNotes: medicalNotes, isDoggyDoorExists: isDoggyDoor, veterinarians: vetArr, character: shy)

        PetService().editDog(id: petId, body: dog) { result in
            switch result {
            case .success(_):
                for i in ImageManager.shared.vaccineStruct {
                    if i.id == "local" {
                        self.imageArr.append(i.img.image!)
                    }
                }
                if self.editPetPhoto != nil {
                    self.attachEditAvatar(petId: petId)
                } else {
                if self.imageArr.count != 0 {
                    self.attachVaccinations(petId: petId)
                } else {
                    self.hideActivityIndicator()
                    self.dogDelegate?.toCloseScreen()
                }
                }
            case .failure(let error):
                self.hideActivityIndicator()
                self.delegate?.setup(error: error)
                self.saveButton.isUserInteractionEnabled = true
                
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
    
    
    func addDog() {
        
        
        showActivityIndicator()
        if !walkView.getCheckedWalkQuestion().isEmpty {
            walksArr = walkView.getCheckedWalkQuestion()
        }
        
        if !homeView.getCheckedHomeQuestion().isEmpty {
            homeArr = homeView.getCheckedHomeQuestion()
        }
        
        getSizeOfDog()
        
        medicationDescription = medicationDescriptionTextView.getText()

        feedingDescription = feedingTextView.getText()
        
        if feedingDescription?.count == 0 {
            feedingDescription = "-"
        }
        
        if medicationDescription?.count == 0 {
            medicationDescription = "-"
        }
        
        if let name = vetName, let phone = vetPhone {
            vetArr = [["name": name, "phoneNumber": phone]]
        }
        
        let dog = DogStruct(name: petName, speciesType: "dog", gender: genderType, size: sizeAmount, sizeType: sizeOfPet, breed: breedPet, dob: petBirthdate, age: petAge, feedingInstructions: feedingDescription, onWalksActions: walksArr, onSomeoneEntryActions: homeArr, medicationInstructions: medicationDescription, isSpayed: neutered, medicalNotes: medicalNotes, medicalRequirements: medicalRequirements, veterinarians: vetArr, hasMedication: medication, isDoggyDoorExists: isDoggyDoor)
        
        PetService().addDog(body: dog) { result in
            switch result {
            case .success(let dog):
                print("Result",result)
                self.attachAvatar(petId: dog.id)
            case .failure(let error):
                self.delegate?.setup(error: error)
                self.hideActivityIndicator()
                self.saveButton.isUserInteractionEnabled = true
//                self.saveButton.setImage(R.image.createSelectedButton(), for: .normal)
            }
        }
    }

    func attachAvatar(petId: String) {
//
        for i in vaccinationView.vaccineButtonsArr {
            if i.currentImage != UIImage(named: "vaccinePhotoButton") {
                imageArr.append(i.currentImage!)
            }
        }

        PetService().attachAvatar(id: petId, image: petPhoto!) { result in
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

//MARK: - SlidersDelegate

extension AddDogView: SlidersDelegate {
    func getSize(amount: String) {
        if let am = Int(amount) {
            sizeAmount = am
            if type == "add" {
                checkState()
            }
        }
    }
    
    func getPet(size: String) {
        sizeOfPet = size
        if type == "add" {
            checkState()
        }
    }
}

//MARK: - UITextFieldDelegate

extension AddDogView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 10 {
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

//MARK: - Activity indicator setup

extension AddDogView {
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
    
    func getDateString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let result = formatter.string(from: date)
        print(result)
        return result
    }
    
    func dateFormatter(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        let result = formatter.string(from: date)
        print(result)
        
        let addedDate = result
        let objformatter = DateFormatter()
        objformatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
        objformatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        let date1 = objformatter.date(from: addedDate)
        print("DATE \(String(describing: date1!))")
        return date1!
    }
    
    func getAge(date: Date) {
        
        let now = Date()
//
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
    
    func okButtonTouched(alertType: AlertType) {
        
    }

}



