//
//  VisitHistoryActionCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 15/07/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import SDWebImage
class VisitHistoryActionCell: UITableViewCell {

    @IBOutlet weak var numberOfActionLabel: UILabel!
    
    @IBOutlet weak var actionImageCollectionView: UICollectionView!
    @IBOutlet weak var actionNameLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    @IBOutlet weak var attachmentLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    
    @IBOutlet weak var actionDurationLabel: UILabel!
    //MARK: Properties
    
    var actionImageArr = [String]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpData()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpData() {
        actionImageCollectionView.register(UINib(nibName: "ActionAttachmentsCell", bundle: nil), forCellWithReuseIdentifier: "ActionAttachmentsCell")
        actionImageCollectionView.delegate = self
        actionImageCollectionView.dataSource = self
    }
    
    func setupUI() {
        numberOfActionLabel.font = R.font.aileronBold(size: 12)
        numberOfActionLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        numberOfActionLabel.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        numberOfActionLabel.layer.cornerRadius = numberOfActionLabel.frame.width/2
        numberOfActionLabel.layer.masksToBounds = true
        lineView.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
       
    }
    
}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension VisitHistoryActionCell: UICollectionViewDelegate ,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actionImageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = actionImageCollectionView.dequeueReusableCell(withReuseIdentifier: "ActionAttachmentsCell", for: indexPath) as! ActionAttachmentsCell
        let imgURL = URL(string: actionImageArr[indexPath.row] as! String) ?? URL(fileURLWithPath: "")
        cell.attachmentImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        
        cell.attachmentImageView.sd_setImage(with: imgURL)
        return cell
    }
}

