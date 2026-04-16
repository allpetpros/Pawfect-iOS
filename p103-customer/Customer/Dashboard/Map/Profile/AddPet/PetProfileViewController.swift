//
//  PetProfileViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 13.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

@objc protocol ReloadPetDelegate: class {
    func reloadAllPetsList()
}

class PetProfileViewController: BaseViewController {
    
    //MARK: - Properties
    
    private let viewProfile = PetProfileView()
    
    var id = String()
    var imageString = String()
    var avatar = UIImage()
    var breed = String()
    var name = String()
    var gender = String()
    
    var isEmployee = false
    var employeeId = String()
    var activityIndicator  = UIActivityIndicatorView()
    private var walksArr = [String]()
    private var homeArr = [String]()
    private var sizePet = ""
    
    weak var delegate: ReloadPetDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        view = viewProfile
        
        viewProfile.delegate = self
        viewProfile.editDelegate = self
       
        if !isEmployee {
            getFull()
        } else {
//            ai.stopAnimating()
            getCustomerPet()
        }
        setupNavbar()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
}

//MARK: - Network

private extension PetProfileViewController {
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
        self.navigationItem.title = "Pet Information"
        

    }
    
    @objc func didTappedBack() {
        _ = navigationController?.popViewController(animated: true)

    }
    func getCustomerPet() {
        EmployeeService().getPetProfile(id: employeeId) { result in
            
            switch result {
            case .success(let s):
                self.viewProfile.setupEmployee(animal: s)
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func getFull() {
        PetService().getFullProfilePet(id: id) { [self] result in
            print("Result",result)
           
            switch result {
               
            case .success(let allPets):
                if allPets.speciesType == "cat" {
                    
//                    if avatar == nil {
//                        let ai = UIActivityIndicatorView(style: .large)
//                        ai.center = self.view.center
//                        self.view.addSubview(ai)
//                    }
                    self.viewProfile.setup(name: self.name, gender: self.gender, petType: "cat", breed: self.breed, avatar: imageString, id: self.id)
                    self.getCatProfile()
                } else if allPets.speciesType == "dog" {
                    self.viewProfile.setup(name: self.name, gender: self.gender, petType: "dog", breed: self.breed, avatar: imageString, id: self.id)
                    self.getDogProfile()
                } else if allPets.speciesType == "small-animal" {
                    self.viewProfile.setup(name: self.name, gender: self.gender, petType: "small-animal", breed: self.breed, avatar: imageString, id: self.id)
                    self.getSmallAnimalProfile()
                }
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func getDogProfile() {
        
        PetService().getDogProfile(id: id) { result in
            switch result {
            
            case .success(let allPets):
                let dog = allPets
                self.viewProfile.setupDog(profile: dog)
                self.activityIndicator.startAnimating()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func getCatProfile() {
        PetService().getCatProfile(id: id) { result in
            switch result {
            case .success(let allPets):
                let cat = allPets
                self.viewProfile.setupCat(profile: cat)
                self.activityIndicator.startAnimating()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func getSmallAnimalProfile() {
        PetService().getSmallAnimalProfile(id: id) { result in
            print("result",result)
            switch result {
            case .success(let allPets):
                let smallAnimal = allPets
                self.viewProfile.setupSmallPet(profile: smallAnimal)
                self.activityIndicator.startAnimating()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
}

//MARK: - DogProfileDelegate

extension PetProfileViewController: DogProfileDelegate {
    func closeScreen() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - EditingPetDelegate

extension PetProfileViewController: EditingPetDelegate {
    
    func toEdit() {
        
        let vc = EditPetViewController()
        vc.id = id
        vc.breed = breed
        vc.name = name
        vc.gender = gender
//        vc.avatar = avatar
        vc.imageString = imageString
        vc.delegate = self
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - PetsDelegate

extension PetProfileViewController: PetsDelegate {
    func reloadPets() {
        dismiss(animated: true) {
            self.delegate?.reloadAllPetsList()
        }
    }
}
