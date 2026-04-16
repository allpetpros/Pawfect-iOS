//
//  EmployeeArrivesCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 24/05/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import SDWebImage


class EmployeeArrivesCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var employeeArriveImage: UIImageView!
    
    @IBOutlet weak var employeeLineView: UIView!
    @IBOutlet weak var employeeArrivesLabel: UILabel!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var petCollectionView: UICollectionView!
    
  
    @IBOutlet weak var attachPhotoButton: UIButton!
    
    //MARK: - Properties
    private let bsImagePicker = ImagePickerController()
    private var photoAssets = [PHAsset]()
    var parent: MapBottomSheetViewController?
    var imageArr = [Any]()
    
    //MARK: - Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        petCollectionView.register(UINib(nibName: "PetActionImagesColwCell", bundle: nil), forCellWithReuseIdentifier: "PetActionImagesColwCell")
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    //MARK: - SetupUI
    func setupUI() {
        
        firstLabel.font = R.font.aileronBold(size: 12)
        firstLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        firstLabel.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        firstLabel.layer.cornerRadius = firstLabel.frame.width/2
        firstLabel.layer.masksToBounds = true
        
        employeeLineView.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        
        attachPhotoButton.setTitle("Attach Photo +", for: .normal)
        attachPhotoButton.tintColor = .colorC6222F
        attachPhotoButton.borderColor = .colorC6222F
        attachPhotoButton.titleLabel?.font = R.font.aileronRegular(size: 14)
        attachPhotoButton.borderWidth = 1
        attachPhotoButton.cornerRadius = 8
        attachPhotoButton.addTarget(self, action: #selector(attachPhotoButtonClick), for: .touchUpInside)
        attachPhotoButton.clipsToBounds = true
        
    }
    //MARK: - Setup Collectionview
    func collectionViewSetUp() {
        if imageArr.count > 0 {
            petCollectionView.isHidden = false
        } else {
            petCollectionView.isHidden = true
        }
    }
    
}
//MARK: - Action

extension EmployeeArrivesCell {
    @objc func attachPhotoButtonClick() {
        for i in 0..<photoAssets.count {
            bsImagePicker.deselect(asset: photoAssets[i])
        }
        parent?.presentImagePicker(bsImagePicker, select: { (asset) in
        }, deselect: { (asset) in
        }, cancel: { (assets) in
        }, finish: { (assets) in
            self.photoAssets = []
            self.photoAssets = assets
            self.photoAssets = assets
            
            for i in assets {
                self.imageArr.append(self.getAssetThumbnail(asset: i))
            }
            self.petCollectionView.isHidden = false
            
            self.petCollectionView.reloadData()
            self.parent?.stepTblView.reloadData()
        })
    }
    
    
}
//MARK: -  UICollectionView Delegate & DataSource
extension EmployeeArrivesCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = petCollectionView.dequeueReusableCell(withReuseIdentifier: "PetActionImagesColwCell", for: indexPath) as! PetActionImagesColwCell
        cell.petActionImages.image = imageArr[indexPath.row] as? UIImage
        return cell
    }
}

//MARK: - PHAsset Method
extension EmployeeArrivesCell {
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
