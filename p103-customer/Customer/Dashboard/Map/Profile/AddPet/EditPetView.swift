//
//  EditPetView.swift
//  p103-customer
//
//  Created by Daria Pr on 16.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SDWebImage

@objc protocol EditViewDelegate: AnyObject {
    func change(name: String)
    

}

@objc protocol EditPetProfileDelegate: AnyObject {
    func closeScreen()
    func choosePhoto()
    func openPhotoViewer()
    func setup(error: Error)
    func chooseSinglePhoto()

}

class EditPetView: UIView {
    
    //MARK: - UIProperties
    private let scrollView = UIScrollView()
    
    private let mainView = UIView()
    
    var petAvatar = UIImage()
    
    private let petPhotoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
//        iv.contentMode = .scaleAspectFit
//        iv.addTarget(self, action: #selector(petImage), for: .)
//        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    } ()
    var activityIndicator = UIActivityIndicatorView()
//    private let closeButton: UIButton = {
//        let button = UIButton()
//        button.setImage(R.image.closeTest(), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.contentVerticalAlignment = .fill
//        button.contentHorizontalAlignment = .fill
//        button.imageView?.clipsToBounds = true
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(EditPetProfileDelegate.closeScreen), for: .allTouchEvents)
//        return button
//    }()
    
    private let petTypeImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    } ()
    
    private lazy var petsNameTextField: SkyFloatingLabelTextField = {
        let l = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Pet's Name")
        l.addTarget(self, action: #selector(petsNameAction), for: .allEvents)
        l.delegate = self
        l.returnKeyType = UIReturnKeyType.next
        l.tag = 1
        return l
    } ()
    
    private lazy var breedTextField: SkyFloatingLabelTextField = {
        let l = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Breed")
        l.addTarget(self, action: #selector(petsBreedAction), for: .allEvents)
        l.delegate = self
        l.returnKeyType = UIReturnKeyType.next
        l.tag = 2
        return l
    } ()
    
    private let errorNameLabel: UILabel = {
        let l = UILabel()
        l.text = "This field is required*"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorC6222F
        l.isHidden = true
        return l
    } ()
    
//    private let errorBreedLabel: UILabel = {
//        let l = UILabel()
//        l.text = "This field is required*"
//        l.font = R.font.aileronRegular(size: 12)
//        l.textColor = .colorC6222F
//        l.isHidden = true
//        return l
//    } ()
//
    private lazy var addCatView: AddCatView = {
        let v = AddCatView()
        v.delegateError = self
        v.delegate = self
        return v
    } ()
    
    private lazy var addDogView: AddDogView = {
        let v = AddDogView()
        v.delegateError = self
        v.delegate = self
        v.dogDelegate = self
        return v
    } ()
    
    private lazy var addSmallPetView: AddSmallPetView = {
        let v = AddSmallPetView()
        v.delegate = self
        v.petDelegate = self
        return v
    } ()
    
    weak var delegate: EditPetProfileDelegate?
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        petPhotoImageView.isUserInteractionEnabled = true
        petPhotoImageView.addGestureRecognizer(tapGestureRecognizer)
        setupScrollViewLayouts()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as? UIImageView
        delegate?.chooseSinglePhoto()
//        ImageManager.shared.isEdit = true
//        if let image = petPhotoImageView.image{
//            addCatView.get(image:image)
//            addSmallPetView.get(image: image)
////                addDogView.get(name: name)
//        }
        print("True")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EditPetView: UITextFieldDelegate {
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


//MARK: - Setup Layout

private extension EditPetView {
    
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
        setupHeaderLayout()
    }
    
    func setupHeaderLayout() {
        mainView.addSubviews([petPhotoImageView])
        
        petPhotoImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(300)
        }
        
//        closeButton.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(35)
//            $0.right.equalToSuperview().offset(-25)
//            
//            $0.size.equalTo(15)
//        }
        setupProfile()
    }
    
    func setupProfile() {
        mainView.addSubviews([petTypeImageView, petsNameTextField, breedTextField, errorNameLabel])
        
        petTypeImageView.snp.makeConstraints {
            $0.width.equalTo(102)
            $0.height.equalTo(111)
            $0.top.equalTo(petPhotoImageView.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(25)
        }
        
        petsNameTextField.snp.makeConstraints {
            $0.top.equalTo(petPhotoImageView.snp.bottom).offset(25)
            $0.left.equalTo(petTypeImageView.snp.right).offset(20)
            $0.right.equalToSuperview().offset(-30)
        }
        
        errorNameLabel.snp.makeConstraints {
            $0.top.equalTo(petsNameTextField.snp.bottom).offset(3)
            $0.left.equalTo(petTypeImageView.snp.right).offset(20)
        }
        
        breedTextField.snp.makeConstraints {
            $0.top.equalTo(petsNameTextField.snp.bottom).offset(20)
            $0.left.equalTo(petTypeImageView.snp.right).offset(20)
            $0.right.equalToSuperview().offset(-30)
        }
    }
    
    func setupAnimalView(view: UIView) {
        mainView.addSubview(view)
        
        view.snp.makeConstraints {
            $0.top.equalTo(petTypeImageView.snp.bottom).offset(26)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

//MARK: - Public funcs

extension EditPetView {
    func setup(name: String, gender: String, petType: String, breed: String, avatar: String) {
        self.petPhotoImageView.sd_imageIndicator = SDWebImageActivityIndicator.large
        self.petPhotoImageView.sd_setImage(with: URL(string: avatar), placeholderImage: nil, options: SDWebImageOptions.lowPriority, context: nil)
//        petPhotoImageView.image = avatar
        
        petsNameTextField.text = name
        
        if breed != "-" {
            breedTextField.text = breed
        }
        
        switch petType {
        case "dog":
            petTypeImageView.image = R.image.dogSelected()
            setupAnimalView(view: addDogView)
        case "cat":
            petTypeImageView.image = R.image.catSelected()
            setupAnimalView(view: addCatView)
        case "small-animal":
            petTypeImageView.image = R.image.smallAnimalSelected()
            setupAnimalView(view: addSmallPetView)
        default:
            break
        }
    }
    
    func setupCat(profile: CatStructGet, id: String, name: String, breed: String, gender: String) {
        activityIndicator.startAnimating()
        addCatView.setupView(catProfile: profile, id: id, name: name, breed: breed, gender: gender)
    }
    
    func setupSmallPet(profile: SmallPetGet, id: String, name: String, breed: String, gender: String) {
        addSmallPetView.setupView(profile: profile, id: id, name: name, breed: breed, gender: gender)
    }
    
    func setupDog(profile: DogStructGet, id: String, name: String, breed: String, gender: String) {
        addDogView.setupView(dogProfile: profile, id: id, name: name, breed: breed, gender: gender, typeView: "edit")
    }
    
}

//MARK: - Actions

extension EditPetView {
    @objc func petsNameAction() {
        if let name = petsNameTextField.text {
            addCatView.get(name: name)
            addSmallPetView.get(name: name)
            addDogView.get(name: name)
        }
        
    }
    
    @objc func petsBreedAction() {
        if let breed = breedTextField.text {
            addCatView.get(petBreed: breed)
            addSmallPetView.get(petBreed: breed)
            addDogView.get(petBreed: breed)
        }
    }

}

//MARK: - SmallPetErrorDelegate

extension EditPetView: SmallPetErrorDelegate {
    func closeScreen() {
        delegate?.closeScreen()
    }
    
    func emptyNameFieldError(isHidden: Bool) {
        errorNameLabel.isHidden = isHidden
    }
    
    
}

//MARK: - VaccinationCatDelegate

extension EditPetView: VaccinationCatDelegate {
    func setup(error: Error) {
        delegate?.setup(error: error)
    }
    
    func close() {
        delegate?.closeScreen()
    }
    
    func addOneNewPhoto() {
        ImageManager.shared.isEdit = true
        delegate?.choosePhoto()
    }

    func viewPhoto() {
        ImageManager.shared.isEdit = true

        delegate?.openPhotoViewer()
    }
    
    func addNewPhotos() {
        ImageManager.shared.isEdit = true
        delegate?.choosePhoto()
    }
}

//MARK: - Public func

extension EditPetView {
    func setPhoto() {
        if ImageManager.shared.petType == "cat" {
            addCatView.setupPhotosToButtons()
        } else {
            addDogView.setupPhotosToButtons()
        }
    }
    
    func setDeletePhoto(number: Int) {
        if ImageManager.shared.petType == "cat" {
            addCatView.removePhoto(onIndex: number)
        } else {
            addDogView.removePhoto(onIndex: number)
        }
    }
    
    func deleteEditingPhoto(number: Int) {
        if ImageManager.shared.petType == "cat" {
            addCatView.removePhoto(onIndex: number)
        } else {
            addDogView.removePhoto(onIndex: number)
        }
    }
    
    func setPet(avatar: UIImage) {
        petPhotoImageView.image = avatar
        addCatView.get(image: avatar)
        addDogView.get(image: avatar)
        addSmallPetView.get(image: avatar)
        petAvatar = avatar
        
        
    }
}

//MARK: - SmallPetDelegate

extension EditPetView: SmallPetDelegate {
    func setupError(error: Error) {
        delegate?.setup(error: error)
    }
    
    func closingScreen() {
        delegate?.closeScreen()
    }

    
//    func setPet(avatar: UIImage) {
//        petPhotoImageView.image = avatar
//        petAvatar = avatar
////        sendRequiredData()
//    }
}

//MARK: - DogDelegate

extension EditPetView: DogDelegate {
    func toCloseScreen() {
        delegate?.closeScreen()
    }
    
//    func setPet(avatar: UIImage) {
//        petPhotoImageView.image = avatar
//        petAvatar = avatar
////        sendRequiredData()
//    }
}
