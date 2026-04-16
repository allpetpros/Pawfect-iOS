
//
//  PetActionTableViewCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 25/05/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import Alamofire
import GoogleMaps
import SDWebImage


var currentPetActionImageArr = [UIImage]()
class PetActionTableViewCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var serviceDurationLabel: UILabel!
    @IBOutlet weak var attachPhotoButton: UIButton!
    @IBOutlet weak var petCollectionView: UICollectionView!
    @IBOutlet weak var petActionTableView: UITableView!
    
    //MARK: - Properties
    private let bsImagePicker = ImagePickerController()
    private var photoAssets = [PHAsset]()
    var imageArr = [Any]()
    var parent: MapBottomSheetViewController?
    var isInitializingTimer = true
    var id: String?
    var mapPosition: MapPosition = MapPosition(positions: [])
    var orderCheckId = String()
    var petActionName = String()
    var currentDateTime = Int64()
    var duration = Int()
    var time = Int()
    var currentActionTag = Int()
 
   
    var dispatchObj = DispatchGroup()
    //MARK: - Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - SetUp CollectionView & TableView
    func setUpData() {

        petCollectionView.register(UINib(nibName: "PetActionImagesColwCell", bundle: nil), forCellWithReuseIdentifier: "PetActionImagesColwCell")
        petActionTableView.register(UINib(nibName: "PetActionListCell", bundle: nil), forCellReuseIdentifier: "PetActionListCell")
        petActionTableView.delegate = self
        petActionTableView.dataSource = self
        petCollectionView.delegate = self
        petCollectionView.dataSource = self
        petActionTableView.isScrollEnabled = false
        
    }
    
    func collectionViewSetUp() {
        if imageDataArr.count > 0 {
            petCollectionView.isHidden = false
        } else {
            petCollectionView.isHidden = true
        }
    }
    //MARK: - SetUp UI
    func setupUI() {
        secondLabel.font = R.font.aileronBold(size: 12)
        secondLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        secondLabel.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        secondLabel.layer.cornerRadius = secondLabel.frame.width/2
        secondLabel.layer.masksToBounds = true
        secondLineView.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        attachPhotoButton.setTitle("Attach Photo +", for: .normal)
        attachPhotoButton.tintColor = .colorC6222F
        attachPhotoButton.borderColor = .colorC6222F
        attachPhotoButton.titleLabel?.font = R.font.aileronRegular(size: 14)
        attachPhotoButton.borderWidth = 1
        attachPhotoButton.cornerRadius = 8
        attachPhotoButton.addTarget(self, action: #selector(attachPhotoButtonClick), for: .touchUpInside)
        attachPhotoButton.clipsToBounds = true
    }

}
//MARK: - TableView Datasource & Delegate
extension PetActionTableViewCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = petActionTableView.dequeueReusableCell(withIdentifier: "PetActionListCell", for: indexPath) as! PetActionListCell

            if checkListArray[indexPath.row].status == "waiting" {
                cell.actionButton.isHidden = false
                cell.actionButton.borderWidth = 1
                cell.actionButton.layer.cornerRadius = 0.5 * cell.actionButton.bounds.size.width
                cell.actionButton.borderColor = UIColor(hexString: "C6222F")
                let image = UIImage(named: "plus.png")
                cell.actionButton.setImage(image, for: .normal)
                cell.actionButton.clipsToBounds = true
            } else if checkListArray[indexPath.row].status == "completed" {
                cell.actionButton.isHidden = false
                cell.actionButton.borderColor = .clear
                let image = UIImage(named: "actionDone.png")
                cell.actionButton.setImage(image, for: .normal)
            } else if checkListArray[indexPath.row].status == "working" {
                cell.actionButton.isHidden = false
                cell.actionButton.borderColor = .clear
                if !(parent?.timer.isValid)! {
                    let image = UIImage(named: "play.png")
                    cell.actionButton.setImage(image, for: .normal)
                } else {
                    let image = UIImage(named: "pause.png")
                    cell.actionButton.setImage(image, for: .normal)
                }

            }else {
                cell.actionButton.isHidden = true
            }
        cell.actionName.text = checkListArray[indexPath.row].name
        cell.actionButton.tag = indexPath.row
        cell.actionButton.addTarget(self, action: #selector(timerAction(sender:)), for: .touchUpInside)
        return cell
    }
}
//MARK: - UICollectionView Datasource & Delegate
extension PetActionTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = petCollectionView.dequeueReusableCell(withReuseIdentifier: "PetActionImagesColwCell", for: indexPath) as! PetActionImagesColwCell
        
        if imageDataArr[indexPath.row] is String {
            let imgURL = URL(string: imageDataArr[indexPath.row] as! String) ?? URL(fileURLWithPath: "")
            cell.petActionImages.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
                cell.petActionImages.sd_setImage(with: imgURL)
        } else {
            cell.petActionImages.image = imageDataArr[indexPath.row] as? UIImage
        }
       
                
        return cell
    }
}
//MARK: - Action
extension PetActionTableViewCell {
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
                imageDataArr.append(self.getAssetThumbnail(asset: i))
               currentPetActionImageArr.append(self.getAssetThumbnail(asset: i))
            }
            
            print(self.imageArr.count)
            self.petCollectionView.isHidden = false
            self.parent?.stepTblView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
            self.petCollectionView.reloadData()
            self.parent?.showClearView()
            self.parent?.IgnoreInteractionEvents()
            for photo in currentPetActionImageArr {
                self.dispatchObj.enter()
                self.attachPetImages(photo: photo)
            }
            
            self.dispatchObj.notify(queue: .main) {
                currentPetActionImageArr.removeAll()
                self.parent?.hideClearView()
                self.parent?.endIgnoringEvents()
            }
            self.layoutSubviews()
           
        })
    }
    
    @objc func timerAction(sender:UIButton) {
        let currentDate = Date()
        // convert Date to TimeInterval (typealias for Double)
        let timeInterval = currentDate.timeIntervalSince1970
        // convert to Integer
        currentDateTime = Int64(timeInterval * 1000)
        currentActionTag = sender.tag
        petActionName = checkListArray[sender.tag].name
        orderCheckId = checkListArray[sender.tag].id
        duration = checkListArray[sender.tag].duration
        
        if checkListArray[sender.tag].status == "waiting" || checkListArray[sender.tag].status == "working" {
            sender.borderWidth = 0
            checkListArray[sender.tag].status = "working"
            if isInitializingTimer == true {
                
                LocationManager.sharedInstance.startUpdatingLocation()
                print(LocationManager.sharedInstance.longitude)
                print(LocationManager.sharedInstance.latitude)
                let image = UIImage(named: "pause.png")
                sender.setImage(image, for: .normal)
                isInitializingTimer = false
                if checkListArray[sender.tag].dateStart == nil {
                    nextStepApi()
                } else {
                    parent?.stopTimer()
                    self.parent?.startTimer()
                    self.parent?.isPetActionAdded = true
                }
            } else {
                sender.borderWidth = 0
                if sender.currentImage == UIImage(named: "pause.png") {
                    let image = UIImage(named: "play.png")
                    sender.setImage(image, for: .normal)
                    parent?.stopTimer()
                    time = currentTime / 60
                    print(time)
                    if time >= duration {
                        let image = UIImage(named: "actionDone.png")
                        sender.setImage(image, for: .normal)
                        savePetAction()
                    }
                } else if sender.currentImage == UIImage(named: "play.png") {
                    let image = UIImage(named: "pause.png")
                    sender.setImage(image, for: .normal)
                    parent?.startTimer()
                }
            }
        }
        else {
            
        }
        
    }
}
//MARK: - Network
extension PetActionTableViewCell {
    func nextStepApi() {
       
        EmployeeService().nextStepMap(id: id ?? "") { [self] result in
            switch result {
            case .success(_):
                print(result)
                self.saveMapPosition()
            case .failure(let error):
                print(error)
            }
        }
    }

    func saveMapPosition() {
        let position = PositionsStruct(lat:LocationManager.sharedInstance.latitude, long: LocationManager.sharedInstance.longitude, createdAt: currentDateTime)
        mapPosition.positions.append(position)
        EmployeeService().saveMapPosition(id: id ?? "", positions: mapPosition) { result in
            switch result {
            case .success( _):
                print(result)
                self.parent?.startTimer()
                self.parent?.isPetActionAdded = true
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func savePetAction() {
        self.parent?.showClearView()
        self.parent?.IgnoreInteractionEvents()
        EmployeeService().savePetAction(id: id ?? "", orderCheckId: orderCheckId, name: petActionName, lat: LocationManager.sharedInstance.latitude, long: LocationManager.sharedInstance.longitude, createdAt: currentDateTime) { result in
            switch result {
            case .success( _):
                self.saveMapTime()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func saveMapTime() {
        EmployeeService().saveMapTime(id: id ?? "", orderCheckId: orderCheckId, minutes: time) { result in
            switch result {
            case .success( _):
                print(result)
                self.getOrderDetails()
                self.petCollectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }

    func getOrderDetails() {
        pointsArr.removeAll()
        checkListArray.removeAll()
        
        EmployeeService().getCurrentMapOrderDetails(id: id ?? "") { [self] result in
            print("Employee Map Details", result)
            switch result {
            case .success(let details):
                self.parent?.endIgnoringEvents()
                self.parent?.hideClearView()
                DispatchQueue.main.async {
                    self.parent?.delegate?.fetchRoute()
                }
                customerHomeSourcelat = details.customerHomePosition.lat
                customerHomeSourceLong = details.customerHomePosition.long
                pointsArr = details.points
                checkListArray = details.checklist
                for i in 0..<checkListArray.count {
                    if checkListArray[i].trackDuration > 0 {
                        checkListArray[i].status = "completed"
                    } else if checkListArray[i].trackDuration == 0 {
                        checkListArray[i].status = "waiting"
                        break
                    }
                    
                }
                if self.currentActionTag > checkListArray.count - 1 {
                    return
                } else if self.currentActionTag == checkListArray.count - 1 {
                    self.parent?.isPetActionCompleted = true
                } else {
                    LocationManager.sharedInstance.lastKnownLatitude = LocationManager.sharedInstance.latitude
                    LocationManager.sharedInstance.lastKnownLongitude = LocationManager.sharedInstance.longitude
                    checkListArray[self.currentActionTag].status = "completed"
                    checkListArray[self.currentActionTag+1].status = "waiting"
                    self.orderCheckId = checkListArray[self.currentActionTag+1].id
                    currentTime = 0
                    self.isInitializingTimer = true
                    self.petActionTableView.reloadData()
                }
                self.parent?.stepTblView.reloadData()
            case .failure(_):
                break
            }
        }
    }
    
    func attachPetImages(photo:UIImage) {
     
        let baseURL = "\(Constant.baseURL)/employee/map/\(id ?? "")/attachment"
        var params = [String: Any]()
        params["orderCheckId"] = self.orderCheckId
        if let token = DBManager.shared.getAccessToken() {
            
            let Auth_header: HTTPHeaders = ["Authorization": "Bearer \(token)"]
            var j = 0
            AF.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
                }
                    multipartFormData.append(photo.pngData()!, withName: "attachment", fileName: "attachment\(j).png", mimeType: "image/png")
                     j+=1
            }, to: baseURL, method: .post, headers: Auth_header).responseJSON { response in
                self.dispatchObj.leave()
                switch response.result {
                case .success(_):
                    print(response.result)
                    
                case .failure(_):
                    print(response.result)
                }
            }
        }
    }
}

//MARK: - PHAsset Method
extension PetActionTableViewCell {
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

