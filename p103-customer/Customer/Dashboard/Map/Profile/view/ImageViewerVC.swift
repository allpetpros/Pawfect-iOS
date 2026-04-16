//
//  ImageViewerVC.swift
//  p103-customer
//
//  Created by Daria Pr on 21.03.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

@objc protocol EditingVaccineDelegate: class {
    func removePhoto(numberOfElement: Int)
}

@objc protocol YesOrNoGroupCellDelegate: class {
    func reloadData()
}

@objc protocol EditPhotoDelegate: class {
    func editPhoto(numberOfElement: Int)
}

@objc protocol MultipleImagePickerDelegate {
    func getVaccinePhoto(firstButton: UIButton, secondButton: UIButton, thirdButton: UIButton, fourthButton: UIButton, fifthButton: UIButton, sixthButton: UIButton, seventhButton: UIButton, eightButton: UIButton)
    func addNewPhotoVaccine(currentButton: UIButton)
}

@objc protocol NeuteredDelegate: class {
    func getNeutered(answer: Bool)
    func getMedications(answer: Bool)
    func getRequiremets(answer: String)
    func getNotes(answer: String)
}

class ImageViewerVC: BaseViewController {

    //MARK: - UIProperties

    private let scrollView = UIScrollView()
    private let mainView = UIView()
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    } ()
    
    private let arrowBackButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.arrowBackImageView(), for: .normal)
        b.addTarget(self, action: #selector(backArrowAction), for: .touchUpInside)
        return b
    }()
    
    private let trashButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.trashImageView(), for: .normal)
        b.addTarget(self, action: #selector(deleteImageAction), for: .touchUpInside)
        return b
    }()
    
    // MARK: - Properties
    weak var delegateEdit: EditPhotoDelegate?
    weak var delegateRemove: EditingVaccineDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = ImageManager.shared.imageView
        
        view.backgroundColor = R.color.vaccineColor()
        
        scrollView.delegate = self
        updateMinZoomScaleForSize(view.bounds.size)
        setupLayout()
    }
    
    //MARK: - Zoom setup
    
    private func updateMinZoomScaleForSize(_ size: CGSize) {
        let widthScale = size.width / imageView.bounds.width
        let heightScale = size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    //MARK: - Setup Layout
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.left.right.equalTo(self.scrollView.contentLayoutGuide)
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        
        view.addSubviews([imageView, arrowBackButton, trashButton])

        imageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        arrowBackButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.width.equalTo(18)
            $0.height.equalTo(22)
            $0.left.equalToSuperview().offset(28)
        }
        
        trashButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.width.equalTo(18)
            $0.height.equalTo(22)
            $0.right.equalToSuperview().offset(-28)
        }
    }
    
    //MARK: - Actions
    
    @objc func backArrowAction() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteImageAction() {        
        if ImageManager.shared.isEdit == false {
            var i: Int = 0
            
            dismiss(animated: true) {
                
                while i != ImageManager.shared.photoArray.count {
                    if ImageManager.shared.photoArray[i] == ImageManager.shared.imageView.image {
                        self.delegateEdit?.editPhoto(numberOfElement: i)
                        break
                    }
                    i+=1
                }
            }
        } else {
            if ImageManager.shared.vaccineStruct[ImageManager.shared.indexVaccination].id == "local" {
                self.dismiss(animated: true) {
                    ImageManager.shared.vaccineStruct[ImageManager.shared.indexVaccination].img = UIImageView(image: R.image.vaccinePhotoButton())
                    ImageManager.shared.vaccineStruct[ImageManager.shared.indexVaccination].id = "empty"
                    self.delegateRemove?.removePhoto(numberOfElement: ImageManager.shared.indexVaccination)
                }
            } else if ImageManager.shared.vaccineStruct[ImageManager.shared.indexVaccination].id != "local" && ImageManager.shared.vaccineStruct[ImageManager.shared.indexVaccination].id != "empty" {
                ImageManager.shared.vaccinationId = ImageManager.shared.vaccineStruct[ImageManager.shared.indexVaccination].id
                PetService().deleteVaccination(petId: ImageManager.shared.petId, vaccinationId: ImageManager.shared.vaccinationId) { result in
                    switch result {
                    case .success(_):
                        self.dismiss(animated: true) {
                            ImageManager.shared.vaccineStruct[ImageManager.shared.indexVaccination].img = UIImageView(image: R.image.vaccinePhotoButton())
                            ImageManager.shared.vaccineStruct[ImageManager.shared.indexVaccination].id = "empty"
                            self.delegateRemove?.removePhoto(numberOfElement: ImageManager.shared.indexVaccination)
                        }
                        break
                    case .failure(let error):
                        self.setupErrorAlert(error: error)
                        break
                    }
                }
            }
        }
    }
}

//MARK: - UIScrollViewDelegate

extension ImageViewerVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

final class ImageManager {
    static let shared = ImageManager()

    var imageView = UIImageView()
    var vaccinationId = String()
    var petId = String()
    var photoArray = [UIImage]()
    var photoDictionary = [UIImage: Bool]()
    var petType = ""
    var isEdit = false
    var editPhotoArray = [UIImageView]()
    var indexVaccination = Int()
    
    var vaccineStruct = [ImageVaccine]()
    
    var testEditingArr = [UIImageView]()
    var testId = [String]()
    var testDict = [String: UIImageView]()
}

struct ImageVaccine {
    var img = UIImageView()
    var id = String()
}
