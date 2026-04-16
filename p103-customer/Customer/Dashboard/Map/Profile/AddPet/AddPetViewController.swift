//
//  AddPetViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 07.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos

@objc protocol PetsDelegate: class {
    func reloadPets()
}

class AddPetViewController: UIViewController {
    
    //MARK: - Properties
    
    private let viewPet = AddPetView()
    
    private var imagePicker = UIImagePickerController()
    private let bsImagePicker = ImagePickerController()
    
    private var photoAssets = [PHAsset]()
    var addPetView: AddPetView?
    weak var delegate: PetsDelegate?
    
    private lazy var alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.delegate = self
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = viewPet

        viewPet.delegate = self
        setupNavbar()
    }
}

//MARK: - AddPetDelegate

extension AddPetViewController: AddPetDelegate {
    
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
        self.navigationItem.title = "Step 3:  Add Your Pets"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Aileron-Bold", size: 18)!]
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true

    }
    
    @objc func didTappedBack() {
        _ = navigationController?.popViewController(animated: true)

    }
    func setup(error: Error) {
        errorHandle(error: error)
    }
    
    func choosePhoto() {
       
        bsImagePicker.settings.selection.max = 8

        presentImagePicker(bsImagePicker, select: { (asset) in
        }, deselect: { (asset) in
        }, cancel: { (assets) in
        }, finish: { (assets) in
            self.photoAssets = []
            ImageManager.shared.photoArray = []
            self.photoAssets = assets
            self.photoAssets = assets
            for i in assets {
                ImageManager.shared.photoArray.append(self.getAssetThumbnail(asset: i))
            }
            self.viewPet.setPhoto()
            self.addPetView?.sendRequiredData()
            
        })
        
    }
    
    func profileImageTouched() {
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func closeScreen() {
        _ = navigationController?.popViewController(animated: true, completion: {
            
            self.delegate?.reloadPets()
        })

    }
    
    func openPhotoViewer() {
        let vc = ImageViewerVC()
        vc.delegateEdit = self
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
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

extension AddPetViewController: EditPhotoDelegate {
    func editPhoto(numberOfElement: Int) {
        bsImagePicker.deselect(asset: photoAssets[numberOfElement])
        viewPet.setDeletePhoto(number: numberOfElement)
    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension AddPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        viewPet.setPet(avatar: image)
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

//MARK: - Handle Errors

extension AddPetViewController {
    func errorHandle(error: Error) {
        if let error = error as? ErrorResponse {
            if error.localizedDescription.contains("veterinarians.0.Veterinarian phone number is invalid") {
                self.alertView.setupAlert(description: "Veterinarian number is invalid", alertType: .error)
            } else if error.localizedDescription.contains("Unauthorized") {
                self.alertView.setupAlert(description: "Your session has been expired, Please login again.", alertType: .unAuthroized)
            }  else {
                self.alertView.setupAlert(description: error.localizedDescription, alertType: .error)
            }
        } else {
            self.alertView.setupAlert(description: error.localizedDescription,alertType: .error)
            
        }
        self.showCustomBlur()
        self.view.addSubview(self.alertView)
        self.alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

//MARK: - CustomAlertViewDelegate

extension AddPetViewController: CustomAlertViewDelegate {
    func okButtonTouched(alertType: AlertType) {
        if alertType == .error {
            self.removeCustomBlur()
            self.alertView.removeFromSuperview()
        } else if alertType == .unAuthroized {
            DBManager.shared.removeAccessToken()
            DBManager.shared.saveStatus(0)
            DBManager.shared.removeUserRole()
            let vc = UINavigationController(rootViewController: AuthorizationVC())
            UIApplication.shared.windows.first?.rootViewController = vc
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}
