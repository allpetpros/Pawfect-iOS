//
//  SittingWithPetView.swift
//  p103-customer
//
//  Created by Daria Pr on 21.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class SittingWithPetView: UIView {
    
    //MARK: - UIProperties
    
    private let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    } ()
    
    private let sittingLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color606572
        l.text = "Sitting with"
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()

    private let addressImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.address()
        return iv
    } ()
    
    private let addressLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color070F24
        return l
    } ()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    //MARK: - Properties
    
    var state = String()
    private var height = 85
    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        addressImageView.tintColor = .colorC6222F

        if state == "customer" {
            setupLayout()
        } else if state == "employee" {
            setupEmployeeLayout()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: - Setup Layout

extension SittingWithPetView {
    
    func setupLayout() {
        addSubviews([containerView, sittingLabel, stackView])
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(85)
        }
        
        sittingLabel.snp.makeConstraints {
            $0.top.equalTo(containerView).offset(20)
            $0.left.equalToSuperview().offset(25)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(sittingLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview()
        }
    }
    
    func setupEmployeeLayout() {
        addSubviews([containerView, sittingLabel, stackView, addressImageView, addressLabel])
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(height)
        }
        
        sittingLabel.snp.makeConstraints {
            $0.top.equalTo(containerView).offset(20)
            $0.left.equalToSuperview().offset(25)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(sittingLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview()
        }
        
        addressImageView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(16)
            $0.top.equalTo(stackView.snp.bottom).offset(17)
            $0.left.equalToSuperview().offset(25)
        }
        
        addressLabel.snp.makeConstraints {
            $0.centerY.equalTo(addressImageView)
            $0.top.equalTo(stackView.snp.bottom).offset(5)
            $0.left.equalTo(addressImageView.snp.right).offset(14)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(containerView.snp.bottom).offset(-5)
        }
    }
}

//MARK: - Public method: setup

extension SittingWithPetView {
    func setupTopMapView(pets: [PetsBreedId], address: String) {
        addressImageView.isHidden = false
        var i = 0
        
//        petNameLabel.text = pets[0].name
//        if let img = pets[0].imageUrl {
//            petPhotoImageView.sd_setImage(with: URL(string: img))
//        }
        addressLabel.text = address
        
        while i != pets.count {
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.alignment = .fill
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            let firstSV = UIStackView()
            firstSV.axis = .horizontal
            firstSV.distribution = .fillProportionally
            firstSV.alignment = .fill
            
            firstSV.spacing = 10
            
            let secondSV = UIStackView()
            secondSV.axis = .horizontal
            secondSV.distribution = .fillProportionally
           
            secondSV.alignment = .fill
            secondSV.spacing = 10
            
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronBold(size: 18)
            label.minimumScaleFactor = 0.5
//            label.backgroundColor = .orange
            label.numberOfLines = 0
            label.text = pets[i].name
            
            if pets[i].name.count > 6 {
                label.font = R.font.aileronBold(size: 15)
            }
            
            let label2 = UILabel()
            label2.textColor = .color070F24
            label2.minimumScaleFactor = 0.5
//            label.backgroundColor = .orange
            label2.numberOfLines = 0
            label2.font = R.font.aileronBold(size: 18)
            
            let img = UIImageView()
            img.layer.cornerRadius = 10
            img.clipsToBounds = true
                        
            let img2 = UIImageView()
            img2.layer.cornerRadius = 10
            img2.clipsToBounds = true
            
            if let image = pets[i].imageUrl {
                img.sd_setImage(with: URL(string: image))
            } else {
                img.image = R.image.alertBox()
            }
            
            i+=1
            
            if i != pets.count {
                label2.text = pets[i].name
                if pets[i].name.count > 6 {
                    label2.font = R.font.aileronBold(size: 15)
                }
                if let image = pets[i].imageUrl {
                    img2.sd_setImage(with: URL(string: image))
                } else {
                    img2.image = R.image.alertBox()
                }
                i+=1
            }
            
            firstSV.addArrangedSubviews(views: img, label)
            
            secondSV.addArrangedSubviews(views: img2, label2)
            
            img.snp.makeConstraints {
                $0.size.equalTo(30)
            }

            img2.snp.makeConstraints {
                $0.size.equalTo(30)
            }
            
            stack.addArrangedSubviews(views: firstSV, secondSV)

            stackView.addArrangedSubview(stack)
            
            height += 45
            containerView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(height)
            }
        }
    }
    
    func setupCustomerTopMapView(pets: [PetDetail], address: String) {
        addressImageView.isHidden = true
        var i = 0
        
//        petNameLabel.text = pets[0].name
//        if let img = pets[0].imageUrl {
//            petPhotoImageView.sd_setImage(with: URL(string: img))
//        }
        addressLabel.text = address
        
        while i != pets.count {
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.alignment = .fill
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            let firstSV = UIStackView()
            firstSV.axis = .horizontal
            firstSV.distribution = .fillProportionally
            firstSV.alignment = .fill
            
            firstSV.spacing = 10
            
            let secondSV = UIStackView()
            secondSV.axis = .horizontal
            secondSV.distribution = .fillProportionally
           
            secondSV.alignment = .fill
            secondSV.spacing = 10
            
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronBold(size: 18)
            label.minimumScaleFactor = 0.5
//            label.backgroundColor = .orange
            label.numberOfLines = 0
            label.text = pets[i].name
            
            if pets[i].name.count ?? 0 > 6 {
                label.font = R.font.aileronBold(size: 15)
            }
            
            let label2 = UILabel()
            label2.textColor = .color070F24
            label2.minimumScaleFactor = 0.5
//            label.backgroundColor = .orang
            label2.numberOfLines = 0
            label2.font = R.font.aileronBold(size: 18)
            
            let img = UIImageView()
            img.layer.cornerRadius = 10
            img.clipsToBounds = true
                        
            let img2 = UIImageView()
            img2.layer.cornerRadius = 10
            img2.clipsToBounds = true
            
            if let image = pets[i].imageURL {
                img.sd_setImage(with: URL(string: image))
            } else {
                img.image = R.image.alertBox()
            }
            
            i+=1
            
            if i != pets.count {
                label2.text = pets[i].name
                if pets[i].name.count > 0 {
                    label2.font = R.font.aileronBold(size: 15)
                }
                if let image = pets[i].imageURL {
                    img2.sd_setImage(with: URL(string: image))
                } else {
                    img2.image = R.image.alertBox()
                }
                i+=1
            }
            
            firstSV.addArrangedSubviews(views: img, label)
            
            secondSV.addArrangedSubviews(views: img2, label2)
            
            img.snp.makeConstraints {
                $0.size.equalTo(30)
            }

            img2.snp.makeConstraints {
                $0.size.equalTo(30)
            }
            
            stack.addArrangedSubviews(views: firstSV, secondSV)

            stackView.addArrangedSubview(stack)
            
            height += 45
            containerView.snp.remakeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(height)
            }
        }
    }
}
