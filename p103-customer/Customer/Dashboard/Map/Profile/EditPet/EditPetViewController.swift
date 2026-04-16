//
//  EditPetViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 16.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

class EditPetViewController: BaseViewController {
    
    //MARK: - Properties

    let editViewPet = EditPetView()
    private var imagePicker = UIImagePickerController()
    var id = String()
    var breed = String()
    var name = String()
    var gender = String()
    var avatar = UIImage()
    var imageString = String()
    
    private let bsImagePicker = ImagePickerController()
    
    private var photoAssets = [PHAsset]()
    
    weak var delegate: PetsDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        view = editViewPet
        
        editViewPet.delegate = self
        setupNavbar()
        
        getFull()
    }
    
}

//MARK: - Network

private extension EditPetViewController {
    func setupNavbar() {
        self.navigationController?.navigationBar.isHidden = false
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let backButtonImg : UIButton = UIButton.init(type: .custom)
        backButtonImg.setImage(R.image.leftArrow(), for: .normal)
        backButtonImg.addTarget(self, action: #selector(didTappedBack), for: .touchUpInside)
        backButtonImg.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let addButton = UIBarButtonItem(customView: backButtonImg)
        self.navigationItem.setLeftBarButtonItems([addButton], animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.title = "Edit Pet"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Aileron-Bold", size: 18)!]
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func didTappedBack() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is CustomerProfileVC {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    func getFull() {
        
        PetService().getFullProfilePet(id: id) { result in
            
            switch result {
            
            case .success(let allPets):
                if allPets.speciesType == "cat" {
                    self.editViewPet.setup(name: self.name, gender: self.gender, petType: "cat", breed: self.breed, avatar: self.imageString)
                    self.getCatProfile()

                } else if allPets.speciesType == "dog" {
                    self.editViewPet.setup(name: self.name, gender: self.gender, petType: "dog", breed: self.breed, avatar: self.imageString)
                    self.getDogProfile()
                } else if allPets.speciesType == "small-animal" {
                    self.editViewPet.setup(name: self.name, gender: self.gender, petType: "small-animal", breed: self.breed, avatar : self.imageString)
                    self.getSmallAnimalProfile()
                }
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
            self.activityView?.stopAnimating()
        }
        
    }
    
    func getDogProfile() {
        PetService().getDogProfile(id: id) { result in
            
            switch result {
            
            case .success(let allPets):
                let dog = allPets
                self.editViewPet.setupDog(profile: dog, id: self.id, name: self.name, breed: self.breed, gender: self.gender)
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func getCatProfile() {
        PetService().getCatProfile(id: id) { result in
            
            switch result {

            case .success(let allPets):
//                self.activityView?.stopAnimating()
                let cat = allPets
                self.editViewPet.setupCat(profile: cat, id: self.id, name: self.name, breed: self.breed, gender: self.gender)
               
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func getSmallAnimalProfile() {
        
        PetService().getSmallAnimalProfile(id: id) { result in
            print("Result",result)
            switch result {
            
            case .success(let allPets):
                let smallAnimal = allPets
                
                self.editViewPet.setupSmallPet(profile: smallAnimal, id: self.id, name: self.name, breed: self.breed, gender: self.gender)
                print(self.editViewPet.setupSmallPet(profile: smallAnimal, id: self.id, name: self.name, breed: self.breed, gender: self.gender))
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
}

//MARK: - EditPetProfileDelegate

extension EditPetViewController: EditPetProfileDelegate {
    
    
    
    func setup(error: Error) {
        self.setupErrorAlert(error: error)
    }
    
    func openPhotoViewer() {
        let vc = ImageViewerVC()
        vc.delegateEdit = self
        vc.delegateRemove = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
//    func choosePhoto() {
//
//        presentImagePicker(bsImagePicker, select: { (asset) in
//        }, deselect: { (asset) in
//        }, cancel: { (assets) in
//        }, finish: { (assets) in
//            if ImageManager.shared.isEdit {
//                for i in 0..<ImageManager.shared.vaccineStruct.count {
//                    if ImageManager.shared.vaccineStruct[i].id == "local" {
//                        ImageManager.shared.vaccineStruct[i].id = "empty"
//                        ImageManager.shared.vaccineStruct[i].img = UIImageView(image: R.image.vaccinePhotoButton())
//                    }
//                }
//
//                for i in assets {
//                    for j in 0..<ImageManager.shared.vaccineStruct.count {
//                        if ImageManager.shared.vaccineStruct[j].id == "empty" {
//                            let img = self.getAssetThumbnail(asset: i)
//                            ImageManager.shared.vaccineStruct[j].img = UIImageView(image: img)
//                            ImageManager.shared.vaccineStruct[j].id = "local"
//                            break
//                        }
//                    }
//                }
//            } else {
//                for i in assets {
//                    ImageManager.shared.photoArray.append(self.getAssetThumbnail(asset: i))
//                }
//            }
//            self.editViewPet.setPhoto()
//        })
//    }
    
    func choosePhoto() {
        bsImagePicker.settings.selection.max = 8

        presentImagePicker(bsImagePicker, select: { (asset) in
        }, deselect: { (asset) in
        }, cancel: { (assets) in
        }, finish: { (assets) in
            if ImageManager.shared.isEdit {
                for i in 0..<ImageManager.shared.vaccineStruct.count {
                    if ImageManager.shared.vaccineStruct[i].id == "local" {
                        ImageManager.shared.vaccineStruct[i].id = "empty"
                        ImageManager.shared.vaccineStruct[i].img = UIImageView(image: R.image.vaccinePhotoButton())
                    }
                }
                for i in assets {
                    for j in 0..<ImageManager.shared.vaccineStruct.count {
                        if ImageManager.shared.vaccineStruct[j].id == "empty" {
                            let img = self.getAssetThumbnail(asset: i)
                            ImageManager.shared.vaccineStruct[j].img = UIImageView(image: img)
                            ImageManager.shared.vaccineStruct[j].id = "local"
                            break
                        }
                    }
                }
            } else {
                for i in assets {
                    ImageManager.shared.photoArray.append(self.getAssetThumbnail(asset: i))
                }
            }
            self.editViewPet.setPhoto()
//            self.viewPet.setPhoto()
//            self.addPetView?.sendRequiredData()
            
        })
        
        
        
    }
    
    func chooseSinglePhoto() {
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func closeScreen() {
//        dismiss(animated: true) {
//            self.delegate?.reloadPets()
//        }
//        _ = navigationController?.popViewController(animated: true)
        for controller in (self.navigationController?.viewControllers ?? []) as Array {
        print("Controller are",controller)
        if controller.isKind(of: CustomerProfileVC.self) {
            self.delegate?.reloadPets()
            self.navigationController?.popToViewController(controller, animated: true)
            break
        }
    }

    }
}

//MARK: - Setup assets

extension EditPetViewController {
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
}

//MARK: - EditPhotoDelegate

extension EditPetViewController: EditPhotoDelegate {
    func editPhoto(numberOfElement: Int) {
        editViewPet.setDeletePhoto(number: numberOfElement)
    }
}

extension EditPetViewController: EditingVaccineDelegate {
    func removePhoto(numberOfElement: Int) {
        editViewPet.deleteEditingPhoto(number: numberOfElement)
    }
}

extension EditPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        editViewPet.setPet(avatar: image)
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
