//
//  ProfileDogView.swift
//  p103-customer
//
//  Created by Daria Pr on 13.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ProfileDogView: UIView {
    //MARK: - UIProperties
    private let birthdateLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 12)
        l.text = "Birthdate"
        l.textColor = .colorAAABAE
        return l
    } ()
    
    private let birthdate: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.text = "bdsbfhsdbfhsbfh"
        l.textColor = .color070F24
        return l
    } ()
    
//    private let ageTextField: SkyFloatingLabelTextField = {
//        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Age")
//        tf.isUserInteractionEnabled = false
//        tf.backgroundColor = .yellow
//        tf.lineColor = .white
//        return tf
//    } ()
    private let ageLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 12)
        l.text = "Age"
        l.textColor = .colorAAABAE
        return l
    } ()
    
    private var agetext: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.text = "bdsbfhsdaaaabfhsbfh"
        l.textColor = .color070F24
        return l
    } ()
   
    
    private let sizeLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorAAABAE
        return l
    } ()
    
    private let amountOfSizeLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color070F24
        return l
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
        tv.isUserInteractionEnabled = false
        tv.lineForPetView()
        return tv
    } ()
    
    private let walkQuestionView = WalkQuestionMultipleAnswerView()
    
    private let homeQuestionView = HomeQuestionMultipleAnswerView()
    
    private let medicationDescriptionTextView: InstructionsTextView = {
        let tv = InstructionsTextView()
        tv.setup(placeholder: "Medication Instructions")
        tv.isUserInteractionEnabled = false
        tv.lineForPetView()
        return tv
    }()
    
    private let neuteredTitleLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronSemiBold(size: 16)
        l.text = "Neutered/spayed"
        l.textColor = .color293147
        return l
    } ()
    
    private let neuteredAnswerLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color070F24
        return l
    } ()
    
    private let vaccinationLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronSemiBold(size: 16)
        l.text = "Vaccinations"
        l.textColor = .color293147
        return l
    } ()
    
    private var vaccinationView: VaccinationView = {
        let v = VaccinationView()
        v.isUserInteractionEnabled = false
        return v
    } ()
    
    private let medicationTitleLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronSemiBold(size: 16)
        l.text = "Medications"
        l.textColor = .color293147
        return l
    } ()
    
    private let medicationAnswerLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color070F24
        return l
    } ()
    
    private let medicationRequirementsTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Medical requirements")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.isUserInteractionEnabled = false
        tv.lineColor = .white
        return tv
    } ()
    
    private let medicationNotesTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Medical notes/concerns")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.isUserInteractionEnabled = false
        tv.lineColor = .white
        return tv
    } ()
    
    private let veterinarianNameTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Veterinarian Name")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.isUserInteractionEnabled = false
        tv.lineColor = .white
        return tv
    } ()
    
    private let veterinarianPhoneNumberTextField: SkyFloatingLabelTextField = {
        let tv = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Veterinarian Phone Number")
        tv.font = R.font.aileronRegular(size: 14)
        tv.textColor = .color070F24
        tv.isUserInteractionEnabled = false
        tv.lineColor = .white
        return tv
    } ()
    
    private let doggyDoorTitleLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronSemiBold(size: 16)
        l.text = "Doggy Door"
        l.textColor = .color293147
        return l
    } ()
    
    private let doggyDoorAnswerLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color070F24
        return l
    } ()
    
    private let shyLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color070F24
        return l
    } ()
    
    private let editButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.editButton(), for: .normal)
        b.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        return b
    }()
    
    //MARK: - Properties
    
    private var petId = String()
    private var vaccineArr = [String]()
    weak var delegate: EditPetDelegate?
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Layout

private extension ProfileDogView {
    func setupLayout() {
        addSubviews([birthdateLabel,birthdate,ageLabel,agetext,sizeLabel, amountOfSizeLabel, feedingLabel, feedingTextView, walkQuestionView, medicationDescriptionTextView, homeQuestionView])
        
        birthdateLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        birthdate.snp.makeConstraints {
            $0.top.equalTo(birthdateLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(25)
        }
        
        ageLabel.snp.makeConstraints {
            $0.top.equalTo(birthdate.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
        }
        
        agetext.snp.makeConstraints {
            $0.top.equalTo(ageLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(25)
        }
        
        sizeLabel.snp.makeConstraints {
            $0.top.equalTo(agetext.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
        }
       
        amountOfSizeLabel.snp.makeConstraints {
            $0.top.equalTo(sizeLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(25)
        }
        
        feedingLabel.snp.makeConstraints {
            $0.top.equalTo(amountOfSizeLabel.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
        }
        
        feedingTextView.snp.makeConstraints {
            $0.top.equalTo(feedingLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        walkQuestionView.snp.makeConstraints {
            $0.top.equalTo(feedingTextView.snp.bottom).offset(40)
        }
        
        homeQuestionView.snp.makeConstraints {
            $0.top.equalTo(walkQuestionView.snp.bottom).offset(40)
        }
        
        medicationDescriptionTextView.snp.makeConstraints {
            $0.top.equalTo(homeQuestionView.snp.bottom).offset(45)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
        setupVaccinationLayout()
    }
    
    func setupVaccinationLayout() {
        addSubviews([neuteredTitleLabel, neuteredAnswerLabel, vaccinationLabel, vaccinationView, medicationTitleLabel, medicationAnswerLabel, medicationRequirementsTextField, medicationNotesTextField, veterinarianNameTextField, veterinarianPhoneNumberTextField, doggyDoorTitleLabel, doggyDoorAnswerLabel, shyLabel, editButton])
        
        neuteredTitleLabel.snp.makeConstraints {
            $0.top.equalTo(medicationDescriptionTextView.snp.bottom).offset(25)
            $0.left.equalToSuperview().offset(25)
        }
        
        neuteredAnswerLabel.snp.makeConstraints {
            $0.top.equalTo(neuteredTitleLabel.snp.bottom).offset(21)
            $0.left.equalToSuperview().offset(25)
        }
        
        vaccinationLabel.snp.makeConstraints {
            $0.top.equalTo(neuteredAnswerLabel.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
        }
        
        vaccinationView.snp.makeConstraints {
            $0.top.equalTo(vaccinationLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().offset(-34)
            $0.height.equalTo(159)
        }
        
        medicationTitleLabel.snp.makeConstraints {
            $0.top.equalTo(vaccinationView.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
        }
        
        medicationAnswerLabel.snp.makeConstraints {
            $0.top.equalTo(medicationTitleLabel.snp.bottom).offset(21)
            $0.left.equalToSuperview().offset(25)
        }
        
        medicationRequirementsTextField.snp.makeConstraints {
            $0.top.equalTo(medicationAnswerLabel.snp.bottom).offset(40)
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
        
        veterinarianPhoneNumberTextField.snp.makeConstraints {
            $0.top.equalTo(veterinarianNameTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        doggyDoorTitleLabel.snp.makeConstraints {
            $0.top.equalTo(veterinarianPhoneNumberTextField.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
        }
        
        doggyDoorAnswerLabel.snp.makeConstraints {
            $0.top.equalTo(doggyDoorTitleLabel.snp.bottom).offset(21)
            $0.left.equalToSuperview().offset(25)
        }
        
        shyLabel.snp.makeConstraints {
            $0.top.equalTo(doggyDoorAnswerLabel.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(shyLabel.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}

//MARK: - Actions

extension ProfileDogView {
    @objc func editButtonAction() {
        delegate?.toEdit()
    }
}

extension ProfileDogView {
    func getVaccination() {
        PetService().getVaccinePhoto(id: petId) { [self] result in
            switch result {
            case .success(let allPets):
                for i in allPets.items {
                    
                    vaccineArr.append(i.imageUrl)
                }
                self.vaccinationView.setPhoto(imageUrls: vaccineArr)
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Public func

extension ProfileDogView {
    func setupEmployee(profile: PetStruct) {
//        if let age = profile.age {
////            ageTextField.text = String(age)
//        }
        if let s = profile.size {
            sizeLabel.text = String(s)
        }
        amountOfSizeLabel.text = profile.sizeType
        if let feed = profile.feedingInstructions {
            if feed != "-" {
                feedingTextView.setup(text: feed, placeholder: "Feeding Instructions")
            }
        }
        if let med = profile.medicationInstructions {
            if med != "-" {
                medicationDescriptionTextView.setup(text: med, placeholder: "Medication Description")
            }
        }
        
        if let wArr = profile.onWalks {
            walkQuestionView.setupProfileView(answersArr: wArr)
        }
        if let entryArr = profile.onSomeoneEntry {
            homeQuestionView.setupProfileView(answersArr: entryArr)
        }
        
        if profile.isSprayed == true {
            neuteredAnswerLabel.text = "Yes"
        } else {
            neuteredAnswerLabel.text = "No"
        }

        if profile.hasMedication == true {
            medicationAnswerLabel.text = "Yes"
        } else {
            medicationAnswerLabel.text = "No"
        }

        medicationRequirementsTextField.text = profile.medicalRequirements
        medicationNotesTextField.text = profile.medicalNotes
        if let name = profile.veterinarian?.name {
            veterinarianNameTextField.text = name
        }
        
        if let phone = profile.veterinarian?.phoneNumber {
            veterinarianPhoneNumberTextField.text = phone
        }
        if profile.isDoggyDoorExists == true {
            doggyDoorAnswerLabel.text = "Yes"
        } else {
            doggyDoorAnswerLabel.text = "No"
        }

        if profile.character == "friendly" {
            shyLabel.text = "Dog friendly"
        } else if profile.character == "shy" {
            shyLabel.text = "Shy"
        }
    }
    
    func setupView(dogProfile: DogStructGet, id: String) {
        
        petId = id
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy"
        let date = dateFormatter.string(from: CommonFunction.shared.fromMillisToDate(millis: Double(dogProfile.dob!)))
        birthdate.text = "\(date)"
        getAge(date: CommonFunction.shared.fromMillisToDate(millis: Double(dogProfile.dob!)))
        sizeLabel.text = String(dogProfile.sizeType)
        amountOfSizeLabel.text = String(dogProfile.size)
        if let feed = dogProfile.feedingInstructions {
            if feed != "-" {
                feedingTextView.setup(text: feed, placeholder: "Feeding Instructions")
            }
        }
        if let med = dogProfile.medicationInstructions {
            if med != "-" {
                medicationDescriptionTextView.setup(text: med, placeholder: "Medication Description")
            }
        }
        
        if let wArr = dogProfile.onWalks {
            walkQuestionView.setupProfileView(answersArr: wArr)
        }
        if let entryArr = dogProfile.onSomeoneEntry {
            homeQuestionView.setupProfileView(answersArr: entryArr)
        }
        
        if dogProfile.isSprayed == true {
            neuteredAnswerLabel.text = "Yes"
        } else {
            neuteredAnswerLabel.text = "No"
        }

        if dogProfile.hasMedication == true {
            medicationAnswerLabel.text = "Yes"
        } else {
            medicationAnswerLabel.text = "No"
        }

        medicationRequirementsTextField.text = dogProfile.medicalRequirements
        medicationNotesTextField.text = dogProfile.medicalNotes
        if let name = dogProfile.veterinarian?.name {
            veterinarianNameTextField.text = name
        }
        
        if let phone = dogProfile.veterinarian?.phoneNumber {
            veterinarianPhoneNumberTextField.text = phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        }
        if dogProfile.isDoggyDoorExists == true {
            doggyDoorAnswerLabel.text = "Yes"
        } else {
            doggyDoorAnswerLabel.text = "No"
        }

        if dogProfile.character == "friendly" {
            shyLabel.text = "Dog friendly"
        } else if dogProfile.character == "shy" {
            shyLabel.text = "Shy"
        }
        getVaccination()
    }
    func getAge(date: Date) {
        
        let now = Date()
        print("Date\(date)")
        let diffComponents = Calendar.current.dateComponents([.year ,.month,.day], from: date, to: now)
        print(diffComponents)
       
        if diffComponents.month == 0 && diffComponents.year == 0{
            agetext.text = "\(diffComponents.day!) Days"
        } else if diffComponents.year == 0 {
            if diffComponents.month == 1 {
                agetext.text = "\(diffComponents.month!) " + "Month"
            } else {
                agetext.text = "\(diffComponents.month!) " + "Months"
            }
        } else if diffComponents.year! != 0 && diffComponents.month != 0 {
            if diffComponents.year == 1 && diffComponents.month == 1 {
                agetext.text = "\(diffComponents.year!) " + "Year, " + "\(diffComponents.month!)" + "Month"
            } else if diffComponents.year == 1 && diffComponents.month != 1 {
                agetext.text = "\(diffComponents.year!) " + "Year, " + "\(diffComponents.month!)" + "Months"

            } else if diffComponents.year != 1 && diffComponents.month == 1{
                agetext.text = "\(diffComponents.year!) " + "Years, " + "\(diffComponents.month!)" + "Month"
            } else if diffComponents.year! > 1 && diffComponents.month! > 1 {
                agetext.text = "\(diffComponents.year!) " + "Years, " + "\(diffComponents.month!)" + "Months"
            }

        } else if diffComponents.year! != 0 && diffComponents.month == 0{
            if diffComponents.year == 1 {
                agetext.text = "\(diffComponents.year!) " + "Year"
            } else {
                agetext.text = "\(diffComponents.year!) " + "Years"
            }
        }

    }
}
