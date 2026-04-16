//
//  AddPetView.swift
//  p103-customer
//
//  Created by Daria Pr on 07.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import BSImagePicker
import Photos

@objc protocol AddPetDelegate: AnyObject {
    func closeScreen()
    func profileImageTouched()
    func openPhotoViewer()
    func choosePhoto()
    func setup(error: Error)
}

class AddPetView: UIView {
    
    //MARK: - UIProperties
    
    let scrollView = UIScrollView()
    
    let mainView = UIView()

    let petPhotoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.pet_photo_placeholder()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        return iv
    } ()
    
     var profileImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(AddPetDelegate.profileImageTouched), for: .touchUpInside)
        return button
    }()
    
    private let requirementsLabel: UILabel = {
        let l = UILabel()
        l.text = "Photo of pet *required"
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color606572
        return l
    } ()
    
    private lazy var petNameTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Pet's Name*")
        tf.keyboardType = .alphabet
        tf.delegate = self
        tf.tag = 1
        tf.returnKeyType = UIReturnKeyType.done
        tf.addTarget(self, action: #selector(petNameAction), for: .editingChanged)
        return tf
    } ()
    
    private let typePetLabel: UILabel = {
        let l = UILabel()
        l.text = "My Pet is*"
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = .color293147
        return l
    } ()
    
    private let petNameErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Name field should not be empty")
        return l
    } ()
    
    private let petButtonsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 27
        sv.distribution = .fillEqually
        return sv
    } ()
    
    private let dogButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.dogUnselected(), for: .normal)
        b.addTarget(self, action: #selector(dogButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let catButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.catSelected(), for: .normal)
        b.addTarget(self, action: #selector(catButtonAction), for: .touchUpInside)
        
        return b
    } ()
    
     let smallAnimalsButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.smallAnimalUnselected(), for: .normal)
        b.addTarget(self, action: #selector(smallButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let typePetGenderLabel: UILabel = {
        let l = UILabel()
        l.text = "Girl or Boy?*"
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = .color293147
        return l
    } ()
    
    let girlSignImage: UIImageView = {
        let b = UIImageView()
        
        b.image = R.image.girlSelected()
        
//        b.backgroundColor = .orange
//        b.setImage(R.image.girlUnselected(), for: .normal)
//        b.addTarget(self, action: #selector(girlSignTouched), for: .touchUpInside)
        return b
    } ()

    
    let girlButton: UIButton = {
        let b = UIButton()
//        b.backgroundColor = .gray
//        b.setImage(R.image.girlUnselected(), for: .normal)
        b.addTarget(self, action: #selector(girlSignTouched), for: .touchUpInside)
        return b
    } ()
    
    let boyButton: UIButton = {
        let b = UIButton()
//        b.backgroundColor = .gray
//        b.setImage(R.image.girlUnselected(), for: .normal)
        b.addTarget(self, action: #selector(boySignTouched), for: .touchUpInside)
        return b
    } ()
    
    private let girlLabel: UILabel = {
        let l = UILabel()
        l.text = "Girl"
        l.font = R.font.aileronBold(size: 12)
        l.textColor = .color860000
        return l
    } ()
    
    private let boyLabel: UILabel = {
        let l = UILabel()
        l.text = "Boy"
        l.font = R.font.aileronBold(size: 12)
        l.textColor = .color606572
        return l
    } ()
    
    private let boySignImage: UIImageView = {
        let b = UIImageView()
        
        b.image = R.image.boyUnselected()
        //        b.addTarget(self, action: #selector(boySignTouched), for: .touchUpInside)
        return b
    } ()
    
    private lazy var dogView: AddDogView = {
        let v = AddDogView()
        v.delegate = self
        return v
    } ()

    private lazy var catView: AddCatView = {
        let v = AddCatView()
        v.delegate = self
        return v
    } ()
    
    private lazy var smallPetView: AddSmallPetView = {
        let v = AddSmallPetView()
        v.petDelegate = self
        v.delegateHandle = self
        return v
    } ()
    
    var vaccineButtonsArr = [UIButton]()
    
    //MARK: - Properties
    
    weak var delegate: AddPetDelegate?
    
     var petAvatar: UIImage?
    
    private let bsImagePicker = ImagePickerController()
    private var photoAssets = [PHAsset]()
    
    var typeOfPet = String()
    var petName = String()
    var gender = String()
        
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        typeOfPet = "cat"
        gender = "female"
        petNameTextField.delegate = self
        setupScrollViewLayouts()
        setupHeaderLayout()
        setupPetChoosing()
        setupGenderType()
        setupPetView(view: catView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Setup Layout

private extension AddPetView {
    
    func setupScrollViewLayouts() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.left.right.equalTo(self.scrollView.contentLayoutGuide)
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
    }
    
    func setupHeaderLayout() {
//        mainView.addSubviews([instructionsLabel, petPhotoImageView, requirementsLabel, petNameTextField, typePetLabel, profileImageButton])
        mainView.addSubviews([ petPhotoImageView, requirementsLabel, petNameTextField,petNameErrorLabel ,typePetLabel, profileImageButton])

//        closeButton.snp.makeConstraints {
//            $0.size.equalTo(17)
//            $0.left.equalToSuperview().offset(25)
//            $0.top.equalToSuperview().inset(38)
//        }
//
//        addPetTitleLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().inset(25)
//            $0.left.equalTo(closeButton.snp.right).offset(25)
//        }
//
//        instructionsLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(0)
//            $0.left.equalToSuperview().offset(25)
//        }
        
        petPhotoImageView.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.top.equalToSuperview().offset(20)
//            $0.top.equalTo(instructionsLabel.snp.bottom).offset(28)
            $0.left.equalToSuperview().offset(25)
        }
        
        profileImageButton.snp.makeConstraints {
            $0.edges.equalTo(petPhotoImageView)
        }
        
        requirementsLabel.snp.makeConstraints {
            $0.centerY.equalTo(petPhotoImageView)
            $0.left.equalTo(petPhotoImageView.snp.right).offset(15)
        }
        
        petNameTextField.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(petPhotoImageView.snp.bottom).offset(44)
            $0.right.equalToSuperview().offset(-25)
        }
        
        petNameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(petNameTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        typePetLabel.snp.makeConstraints {
            $0.top.equalTo(petNameTextField.snp.bottom).offset(25)
            $0.left.equalToSuperview().offset(25)
        }
    }
    
    func setupPetChoosing() {
        petButtonsStackView.addArrangedSubviews(views: catButton, dogButton, smallAnimalsButton)
        mainView.addSubviews([petButtonsStackView, typePetGenderLabel])

        dogButton.snp.makeConstraints {
            $0.top.equalTo(typePetLabel.snp.bottom).offset(9)
            $0.width.equalTo(90)
            $0.height.equalTo(116)
        }

        catButton.snp.makeConstraints {
            $0.top.equalTo(typePetLabel.snp.bottom).offset(19)
            $0.width.equalTo(102)
            $0.height.equalTo(106)
        }

        smallAnimalsButton.snp.makeConstraints {
            $0.top.equalTo(typePetLabel.snp.bottom).offset(20)
            $0.width.equalTo(97)
            $0.height.equalTo(105)
        }
        
        petButtonsStackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        typePetGenderLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(catButton.snp.bottom).offset(30)
        }
    }
    
    func setupGenderType() {
        mainView.addSubviews([girlSignImage,girlButton, boySignImage, girlLabel, boyLabel, boyButton])
        
        girlButton.snp.makeConstraints {
           
            $0.top.equalTo(typePetGenderLabel.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
            $0.trailing.equalTo(girlLabel).offset(5)
        }
        girlSignImage.snp.makeConstraints {
            $0.width.equalTo(17)
            $0.height.equalTo(30)
            
            $0.top.equalTo(typePetGenderLabel.snp.bottom).offset(23)
            $0.left.equalTo(girlButton).inset(2)
        }
        
        girlLabel.snp.makeConstraints {
            $0.left.equalTo(girlSignImage.snp.right).offset(17)
            $0.top.equalTo(typePetGenderLabel.snp.bottom).offset(25)
        }
        
        boyButton.snp.makeConstraints {
            $0.top.equalTo(typePetGenderLabel.snp.bottom).offset(23)
            $0.left.equalTo(girlLabel.snp.right).offset(63)
            $0.trailing.equalTo(boyLabel).offset(5)
        }
        
        boySignImage.snp.makeConstraints {
            $0.size.equalTo(33)
            $0.top.equalTo(typePetGenderLabel.snp.bottom).offset(10)
            $0.left.equalTo(boyButton)
        }
        
        boyLabel.snp.makeConstraints {
            $0.left.equalTo(boySignImage.snp.right).offset(10)
            $0.top.equalTo(typePetGenderLabel.snp.bottom).offset(25)
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupPetView(view: UIView) {
        mainView.addSubview(view)
        
        boyLabel.snp.remakeConstraints {
            $0.left.equalTo(boySignImage.snp.right).offset(10)
            $0.top.equalTo(typePetGenderLabel.snp.bottom).offset(25)
        }
        
        view.snp.makeConstraints {
            $0.top.equalTo(girlLabel.snp.bottom).offset(30)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

//MARK: - Pet Type Actions

extension AddPetView {
    @objc func dogButtonAction() {
        typeOfPet = "dog"
        ImageManager.shared.petType = "dog"
        typePetGenderLabel.text = "Girl or Boy?*"
        
        dogButton.setImage(R.image.dogSelected(), for: .normal)
        catButton.setImage(R.image.catUnselected(), for: .normal)
        smallAnimalsButton.setImage(R.image.smallAnimalUnselected(), for: .normal)
                
        catView.removeFromSuperview()
        smallPetView.removeFromSuperview()
        setupPetView(view: dogView)
        sendRequiredData()
    }
    
    @objc func catButtonAction() {
        typeOfPet = "cat"
        ImageManager.shared.petType = "cat"
        typePetGenderLabel.text = "Girl or Boy?*"
        
        dogButton.setImage(R.image.dogUnselected(), for: .normal)
        catButton.setImage(R.image.catSelected(), for: .normal)
        smallAnimalsButton.setImage(R.image.smallAnimalUnselected(), for: .normal)
        
        dogView.removeFromSuperview()
        smallPetView.removeFromSuperview()
        setupPetView(view: catView)
        sendRequiredData()
    }
    
    @objc func smallButtonAction() {
        typeOfPet = "small-animal"
        typePetGenderLabel.text = "Girl or Boy?*"
        
        dogButton.setImage(R.image.dogUnselected(), for: .normal)
        catButton.setImage(R.image.catUnselected(), for: .normal)
        smallAnimalsButton.setImage(R.image.smallAnimalSelected(), for: .normal)
        
        catView.removeFromSuperview()
        dogView.removeFromSuperview()
        setupPetView(view: smallPetView)
        sendRequiredData()
    }
}

//MARK: - gender Actions

extension AddPetView {
    @objc func girlSignTouched() {
        gender = "female"
    //        girlSignButton.setImage(R.image.girlSelected(), for: .normal)
        girlSignImage.image = R.image.girlSelected()
        girlLabel.textColor = .color860000
        
//        boySignButton.setImage(R.image.boyUnselected(), for: .normal)
        boySignImage.image = R.image.boyUnselected()
        boyLabel.textColor = .color606572
        sendRequiredData()
    }
    
    @objc func boySignTouched() {
        gender = "male"
//        girlSignButton.setImage(R.image.girlUnselected(), for: .normal)
        girlSignImage.image = R.image.girlUnselected()
        girlLabel.textColor = .color606572
        
//        boySignButton.setImage(R.image.boySelected(), for: .normal)
        boySignImage.image = R.image.boySelected()
        boyLabel.textColor = .color860000
        sendRequiredData()
    }
    
    func sendRequiredData() {
        if !typeOfPet.isEmpty {
            if let avatar = petAvatar {
                if !petName.isEmpty {
                    switch typeOfPet {
                    case "cat":
                        catView.sendRequiredInfo(name: petName, speciesType: typeOfPet, gender: gender, avatar: avatar,veterianName: catView.vetName ?? "",veterianPhoneNumber: catView.vetPhone ?? "")
                    case "small-animal":
//                        smallPetView.sendRequiredInfo(name: petName, speciesType: typeOfPet, gender: gender, avatar: avatar)
                        smallPetView.sendRequiredInfo(name: petName, speciesType: typeOfPet, gender: gender, avatar: avatar, veterianName: smallPetView.vetName ?? "", veterianPhone: smallPetView.vetPhone ?? "")
                    case "dog":
//                        dogView.sendRequiredInfo(name: petName, speciesType: typeOfPet, gender: gender, avatar: avatar, typeView: "add")
                        dogView.sendRequiredInfo(name: petName, speciesType: typeOfPet, gender: gender, avatar: avatar, typeView: "add", veterianName: dogView.vetName ?? "", Vetnmber: dogView.vetPhone ?? "")
                    default:
                        break
                    }
                }
                
            }
        }
    }
}

//MARK: - UITextFieldDelegate

extension AddPetView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            petName = text
            sendRequiredData()
        }
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
    
    @objc func petNameAction(field: SkyFloatingLabelTextFieldWithIcon) {
        if field.text?.isEmpty ?? true {
            petNameErrorLabel.setup(isHidden: false, text: "Pet Name should not be empty")
            field.style(active: false)
            dogView.saveButton.redAndGrayStyle(active: false)
            smallPetView.saveButton.redAndGrayStyle(active: false)
            catView.saveButton.redAndGrayStyle(active: false)
            petName = ""
            
            sendRequiredData()
            
        } else {
            let nameField = petNameTextField.text!
            if nameField.isValidName {
                petNameErrorLabel.setup(isHidden: true, text: "Invalid Pet Name")
                sendRequiredData()
                petName = field.text!
            } else {
                petNameErrorLabel.setup(isHidden: false, text: "Invalid Pet Name")
                field.style(active: false)
                dogView.saveButton.redAndGrayStyle(active: false)
                smallPetView.saveButton.redAndGrayStyle(active: false)
                catView.saveButton.redAndGrayStyle(active: false)
                sendRequiredData()
            }
        }
    }
}

//MARK: - VaccinationCatDelegate

extension AddPetView: VaccinationCatDelegate {
    func setup(error: Error) {
        delegate?.setup(error: error)
    }
    
    func close() {
        delegate?.closeScreen()
    }
    
    func addOneNewPhoto() {
        delegate?.choosePhoto()
    }
    
    func viewPhoto() {
        delegate?.openPhotoViewer()
    }
    
    func addNewPhotos() {
        delegate?.choosePhoto()
    }
}

//MARK: - Public funcs

extension AddPetView {
    func setPhoto() {
        if ImageManager.shared.petType == "cat" {
            catView.setupPhotosToButtons()
        } else {
            dogView.setupPhotosToButtons()
        }
    }
    
    func setDeletePhoto(number: Int) {
        if ImageManager.shared.petType == "cat" {
            catView.removePhoto(onIndex: number)    
        } else {
            dogView.removePhoto(onIndex: number)
        }
    }
    
    func setPet(avatar: UIImage) {
        
        petPhotoImageView.image = avatar
        petAvatar = avatar
        sendRequiredData()
    }
}

//MARK: - SmallPetDelegate

extension AddPetView: SmallPetDelegate {
    func setupError(error: Error) {
        delegate?.setup(error: error)
    }
    
    func closingScreen() {
        delegate?.closeScreen()
    }
}
