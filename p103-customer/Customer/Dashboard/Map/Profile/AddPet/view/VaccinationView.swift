//
//  VaccinationView.swift
//  p103-customer
//
//  Created by Daria Pr on 12.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SDWebImage

@objc protocol VaccineDelegate: class {
    func newPhoto()
    func photoViewer()
}

class VaccinationView: UIView {
        
    //MARK: - UIProperties
    
    private let vaccinePhotoHorizontalStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    } ()
    
    private let vaccinePhotoHorizontalSecondStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    } ()
    
    private let firstButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.vaccinePhotoButton(), for: .normal)
        return b
    } ()
    
    private let secondButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.vaccinePhotoButton(), for: .normal)
        return b
    } ()

    private let thirdButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.vaccinePhotoButton(), for: .normal)
        return b
    } ()

    private let fourthButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.vaccinePhotoButton(), for: .normal)
        return b
    } ()
    
    private let fifthButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.vaccinePhotoButton(), for: .normal)
        return b
    } ()
    
    private let sixthButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.vaccinePhotoButton(), for: .normal)
        return b
    } ()
    
    private let seventhButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.vaccinePhotoButton(), for: .normal)
        return b
    } ()
    
    private let eighthButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.vaccinePhotoButton(), for: .normal)
        return b
    } ()
    
    var vaccineButtonsArr = [UIButton]()
    
    private var imageArr = [UIImageView(image: R.image.vaccinePhotoButton()), UIImageView(image: R.image.vaccinePhotoButton()), UIImageView(image: R.image.vaccinePhotoButton()), UIImageView(image: R.image.vaccinePhotoButton()), UIImageView(image: R.image.vaccinePhotoButton()), UIImageView(image: R.image.vaccinePhotoButton()), UIImageView(image: R.image.vaccinePhotoButton()), UIImageView(image: R.image.vaccinePhotoButton())]
    
    weak var delegate: VaccineDelegate?
    
    private var width = Int()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        addTargetsToFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Layout
    
    private func setupLayout() {
        addSubviews([vaccinePhotoHorizontalStackView, vaccinePhotoHorizontalSecondStackView])
        
        vaccinePhotoHorizontalStackView.addArrangedSubviews(views: firstButton, secondButton, thirdButton, fourthButton)
        vaccinePhotoHorizontalSecondStackView.addArrangedSubviews(views: fifthButton, sixthButton, seventhButton, eighthButton)
        
        vaccinePhotoHorizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        vaccinePhotoHorizontalSecondStackView.snp.makeConstraints {
            $0.top.equalTo(vaccinePhotoHorizontalStackView.snp.bottom).offset(9)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func addTargetsToFields() {
        let massOfField = [firstButton, secondButton, thirdButton, fourthButton, fifthButton, sixthButton, seventhButton, eighthButton]

        vaccineButtonsArr = massOfField
        
        for field in massOfField {
            field.addTarget(self, action: #selector(changePhotoVaccineAction), for: .touchUpInside)
        }

        for i in massOfField {
            i.snp.makeConstraints {
                $0.size.equalTo(75)
            }
        }
    }
}

//MARK: - Set photo to buttons

extension VaccinationView {
    func setPhoto(imageUrls: [String]) {
        vaccineButtonsArr = [firstButton, secondButton, thirdButton, fourthButton, fifthButton, sixthButton, seventhButton, eighthButton]
        var i = 0
        
        while i != imageUrls.count {
            
            vaccineButtonsArr[i].sd_setImage(with: URL(string: imageUrls[i]), for: .normal, placeholderImage: R.image.pet_photo_placeholder())
            
//            vaccineButtonsArr[i].sd_setImage(with: URL(string: imageUrls[i]), placeholder: R.image.pet_photo_placeholder(), for: .normal, completed: nil)
            imageArr[i].sd_setImage(with: URL(string: imageUrls[i]))
            i+=1
        }

        for i in imageArr {
            ImageManager.shared.editPhotoArray.append(i)
        }
    }
    
    func setVaccinePhoto() {
        vaccineButtonsArr = [firstButton, secondButton, thirdButton, fourthButton, fifthButton, sixthButton, seventhButton, eighthButton]

        if ImageManager.shared.isEdit {
            for i in 0..<vaccineButtonsArr.count {
                let img = ImageManager.shared.vaccineStruct[i].img
                vaccineButtonsArr[i].setImage(img.image, for: .normal)//
            }
        } else {
            var i = 0
            while i != ImageManager.shared.photoArray.count {
                
                self.vaccineButtonsArr[i].setImage(ImageManager.shared.photoArray[i], for: .normal)
                i+=1
            }
        }
    }
}

//MARK: - Actions

extension VaccinationView {
    @objc func changePhotoVaccineAction(sender: UIButton) {
        vaccineButtonsArr = [firstButton, secondButton, thirdButton, fourthButton, fifthButton, sixthButton, seventhButton, eighthButton]
        
        var i = 0
        
        while i != vaccineButtonsArr.count - 1 {
            if vaccineButtonsArr[i] == sender {
                break
            }
            i+=1
        }
        
        if sender.currentImage == UIImage(named: "vaccinePhotoButton") {
            delegate?.newPhoto()
        } else {
            if let image = sender.currentImage {
                let iv = UIImageView(image: image)
                ImageManager.shared.imageView = iv
                ImageManager.shared.indexVaccination = i
            }
            delegate?.photoViewer()
        }
    }
}
