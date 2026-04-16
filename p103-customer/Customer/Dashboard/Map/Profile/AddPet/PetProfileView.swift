//
//  PetProfileView.swift
//  p103-customer
//
//  Created by Daria Pr on 13.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

@objc protocol DogProfileDelegate: class {
    func closeScreen()
}

@objc protocol EditingPetDelegate: class {
    func toEdit()
}

class PetProfileView: UIView {
    
    //MARK: - UIProperties
    
    private let scrollView = UIScrollView()
    
    private let mainView = UIView()
    private var activityView: UIActivityIndicatorView?
    
    private let petPhotoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill

//        iv.contentMode = .scaleAspectFit
//        iv.backgroundColor = .lightGray
        iv.clipsToBounds = true
        return iv
    } ()
    
//    private let closeButton: UIButton = {
//        let button = UIButton()
//        button.setImage(R.image.closeTest(), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFit
//        button.contentVerticalAlignment = .fill
//        button.contentHorizontalAlignment = .fill
//        button.imageView?.clipsToBounds = true
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(DogProfileDelegate.closeScreen), for: .allTouchEvents)
//        return button
//    }()
    
    private let petTypeImageView: UIImageView = {
        let iv = UIImageView()
//        iv.image = R.image.snallAnimalSelected()
        return iv
    } ()
    
    private let petNameLabel: UILabel = {
        let l = UILabel()
      
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color070F24
        return l
    } ()
    
    private let petBreedLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color606572
        return l
    } ()
    
    private let genderLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 12)
        l.textColor = .color606572
        return l
    } ()
    
    private let genderImageView: UIImageView = {
        let iv = UIImageView()
//        iv.image = R.image.boySelected()
        return iv
    } ()
    
    private lazy var addSmallPetView: ProfileSmallPetView = {
        let v = ProfileSmallPetView()
        v.delegate = self
        return v
    } ()
    
    private lazy var addCatView: ProfileCatView = {
        let v = ProfileCatView()
        v.delegate = self
        return v
    } ()
    
    private lazy var addDogView: ProfileDogView = {
        let v = ProfileDogView()
        v.delegate = self
        return v
    } ()
    
    private var petId = String()
    
    weak var delegate: DogProfileDelegate?
    weak var editDelegate: EditingPetDelegate?
    var ai = UIActivityIndicatorView(style: .large)
 
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
            backgroundColor = .white
       
            setupScrollViewLayouts()
            setupHeaderLayout()
            setupProfile()
//
//        setupScrollViewLayouts()
//        setupHeaderLayout()
//        setupProfile()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    //MARK: - Setup Layout
 
private extension PetProfileView {
    func setupHeaderLayout() {
        mainView.addSubviews([petPhotoImageView])
        
        petPhotoImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
//            $0.top.equalToSuperview().offset(5)
//            $0.left.equalToSuperview().inset(25)
//            $0.right.equalToSuperview().inset(25)
            
            $0.height.equalTo(300)
        }
        
//        closeButton.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(35)
//            $0.right.equalToSuperview().offset(-25)
//            $0.size.equalTo(15)
//        }
    }
    
    func setupProfile() {
        mainView.addSubviews([petTypeImageView, petNameLabel, petBreedLabel, genderImageView, genderLabel])
        
        petTypeImageView.snp.makeConstraints {
            $0.width.equalTo(102)
            $0.height.equalTo(111)
            $0.top.equalTo(petPhotoImageView.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(25)
        }
        
        petNameLabel.snp.makeConstraints {
            $0.top.equalTo(petPhotoImageView.snp.bottom).offset(30)
            $0.left.equalTo(petTypeImageView.snp.right).offset(22)
            $0.right.equalToSuperview().offset(-5)
        }
        
        petBreedLabel.snp.makeConstraints {
            $0.top.equalTo(petNameLabel.snp.bottom).offset(10)
            $0.left.equalTo(petTypeImageView.snp.right).offset(22)
        }
        
        genderImageView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalTo(petBreedLabel.snp.bottom).offset(15)
            $0.left.equalTo(petTypeImageView.snp.right).offset(22)
        }
        
        genderLabel.snp.makeConstraints {
            $0.left.equalTo(genderImageView.snp.right).offset(3)
            $0.centerY.equalTo(genderImageView)
        }
    }
    
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
}

//MARK: - Public func: setup header

extension PetProfileView {
    
    func setupEmployee(animal: PetStruct) {
        
        petNameLabel.text = animal.name
//        let ai = UIActivityIndicatorView(style: .large)
//        ai.center = self.petPhotoImageView.center
//        self.petPhotoImageView.addSubview(ai)
        
        if let img = animal.imageUrl {
            self.petPhotoImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.petPhotoImageView.sd_setImage(with: URL(string: img), placeholderImage: nil, options: .lowPriority, context: nil)
        }
//        if let img = animal.imageUrl {
//
//            petPhotoImageView.sd_setImage(with: URL(string: img), placeholderImage: R.image.alertBox())
//        }
        petBreedLabel.text = animal.breed
        
        switch animal.gender {
        case "male":
            genderLabel.text = "Boy"
            genderImageView.image = R.image.boySelected()
        case "female":
            genderLabel.text = "Girl"
            genderImageView.image = R.image.girlSelected()
            genderImageView.snp.makeConstraints {
                $0.width.equalTo(14)
                $0.height.equalTo(30)
                $0.top.equalTo(petBreedLabel.snp.bottom).offset(15)
                $0.left.equalTo(petTypeImageView.snp.right).offset(22)
            }
        default:
            break
        }
        
        switch animal.speciesType {
        case "dog":
            petTypeImageView.image = R.image.dogSelected()
            setupAnimalView(view: addDogView)
            addDogView.setupEmployee(profile: animal)
        case "cat":
            petTypeImageView.image = R.image.catSelected()
            setupAnimalView(view: addCatView)
            addCatView.setupEmployee(profile: animal)
        case "small-animal":
            petTypeImageView.image = R.image.smallAnimalSelected()
            setupAnimalView(view: addSmallPetView)
            addSmallPetView.setupSmall(profile: animal)
        default:
            break
        }
    }
    
    func setupCat(profile: CatStructGet) {
        addCatView.setupView(catProfile: profile, id: petId)
    }
    
    func setupSmallPet(profile: SmallPetGet) {
        
        addSmallPetView.setupView(profile: profile)
    }
    
    func setupDog(profile: DogStructGet) {
        
        addDogView.setupView(dogProfile: profile, id: petId)
    }
    
    func setup(name: String, gender: String, petType: String, breed: String, avatar: String, id: String) {
        
        petId = id
        
//        if avatar == "" {
            self.petPhotoImageView.sd_imageIndicator = SDWebImageActivityIndicator.large
            self.petPhotoImageView.sd_setImage(with: URL(string: avatar), placeholderImage: nil, options: SDWebImageOptions.lowPriority, context: nil)
    
//        } else {
////        petPhotoImageView.image = avatar
//            petPhotoImageView.sd_setImage(with: URL(string: avatar),placeholderImage: <#T##UIImage?#>)
//        }
//
        petNameLabel.text = name
        if breed != "-" {
            petBreedLabel.text = breed
        } 
                
        switch gender {
        case "male":
            genderLabel.text = "Boy"
            genderImageView.image = R.image.boySelected()
        case "female":
            genderLabel.text = "Girl"
            genderImageView.image = R.image.girlSelected()
            genderImageView.snp.makeConstraints {
                $0.width.equalTo(14)
                $0.height.equalTo(30)
                $0.top.equalTo(petBreedLabel.snp.bottom).offset(15)
                $0.left.equalTo(petTypeImageView.snp.right).offset(22)
            }
        default:
            break
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
}

//MARK: - Setup AnimalView

private extension PetProfileView {
    
    func setupAnimalView(view: UIView) {
        mainView.addSubview(view)
        
        view.snp.makeConstraints {
            $0.top.equalTo(petTypeImageView.snp.bottom).offset(26)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

//MARK: - EditPetDelegate

extension PetProfileView: EditPetDelegate {
    func toEdit() {
        editDelegate?.toEdit()
    }
}


extension PetProfileView {
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
        UIApplication.shared.beginIgnoringInteractionEvents()
        
    }

    private func hideActivityIndicator(){
        activityView?.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
}
