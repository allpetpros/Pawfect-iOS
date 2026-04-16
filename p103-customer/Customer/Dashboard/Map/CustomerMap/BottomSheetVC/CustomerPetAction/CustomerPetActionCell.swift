//
//  CustomerPetActionCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 17/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import SDWebImage

class CustomerPetActionCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDurationLabel: UILabel!
    @IBOutlet weak var petCollectionView: UICollectionView!
    @IBOutlet weak var petActionTableView: UITableView!
    
    //MARK: - Properties
    var imageArr = [Any]()
    
    //MARK: - Cell Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpData()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
//MARK: UITableview Delegate & Datasource
extension CustomerPetActionCell: UITableViewDelegate,UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return checkListStartArr.count
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = petActionTableView.dequeueReusableCell(withIdentifier: "CustomerPetActionTableViewCell", for: indexPath) as! CustomerPetActionTableViewCell
            cell.petNameLabel.text = checkListStartArr[indexPath.row].name
            cell.petDurationLabel.text = CommonFunction.shared.toDate(millis: Int64(checkListStartArr[indexPath.row].dateStart ?? 0))
            return cell
        }
}

//MARK: - Custom Methods
extension CustomerPetActionCell {
    func setUpData() {

        petCollectionView.register(UINib(nibName: "PetImageCell", bundle: nil), forCellWithReuseIdentifier: "PetImageCell")
        petActionTableView.register(UINib(nibName: "CustomerPetActionTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomerPetActionTableViewCell")
        petActionTableView.delegate = self
        petActionTableView.dataSource = self
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        petActionTableView.isScrollEnabled = false
        
    }
    
    func setUI() {
        secondLabel.font = R.font.aileronBold(size: 12)
        secondLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        secondLabel.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        secondLabel.layer.cornerRadius = secondLabel.frame.width/2
        secondLabel.layer.masksToBounds = true
        
        secondLineView.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        secondLineView.layer.masksToBounds = true
    }
}

//MARK: UICollectionview Delegate & Datasource

extension CustomerPetActionCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = petCollectionView.dequeueReusableCell(withReuseIdentifier: "PetImageCell", for: indexPath) as! PetImageCell
        
       
        if imageArr[indexPath.row] is String {
            let imgURL = URL(string: imageArr[indexPath.row] as! String) ?? URL(fileURLWithPath: "")
                cell.petActionImages.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.petActionImages.sd_setImage(with: imgURL)
              
        } else {
                cell.petActionImages.image = imageArr[indexPath.row] as? UIImage
        }
        
                
        return cell
    }
}

