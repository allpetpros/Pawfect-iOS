//
//  PetChoosingViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 09.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PetChoosingViewController: BaseViewController {

    //MARK: - UIProperties
    
    private let backbutton: UIButton = {
        let button = UIButton()
         button.setImage(R.image.closeTest(), for: .normal)
         button.imageView?.contentMode = .scaleAspectFit
         button.contentVerticalAlignment = .fill
         button.contentHorizontalAlignment = .fill
         button.imageView?.clipsToBounds = true
         button.tintColor = .black
         button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
         return button
     }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        label.text = "Schedule Service"
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 18)
        l.textColor = .color293147
        l.text = "Step 3. Select Pets"
        return l
    } ()
    
     private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.register(ChoosingPetOrderTableViewCell.self)
        return tableView
    }()
    
    private let addPetsButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 15
        button.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        button.setTitle("Add Pets", for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
        button.addTarget(self, action: #selector(addPetsButtonTouched), for: .touchUpInside)
        button.redAndGrayStyle(active: false)
        return button
    }()
    
    //MARK: - Properties
    
    private var idArr = [String]()
    private var namePetArr = [String]()
    private var imageArr = [String]()
    private var breedArr = [String]()
    
    private var animalDictId = [String: Bool]()
    private var animalDictName = [String: Bool]()
    private var isChoosen = false
    
    private var page = 1
    private var totalItems = 0
    
    private var breed = String()
    private var url = String()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showView()
        getPets()
        setupLayouts()
    }
    
    // MARK: - Selectors
    @objc func closeButtonTouched() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func addPetsButtonTouched() {
        if isChoosen {
            let vc = CreateOrderTotalVC()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - Setup Layout

private extension PetChoosingViewController {
    func setupLayouts() {
        view.backgroundColor = .white
        view.addSubviews([backbutton, titleLabel, descriptionLabel, tableView, addPetsButton])
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().offset(10)
        }
        backbutton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(15)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.right.equalToSuperview().offset(-25)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(34)
            $0.left.equalTo(titleLabel)

        }
        
        addPetsButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addPetsButton.snp.top)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(15)
        }
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate

extension PetChoosingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return namePetArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(ChoosingPetOrderTableViewCell.self, for: indexPath) else { return ChoosingPetOrderTableViewCell() }
        
        cell.setupPets(name: namePetArr[indexPath.section], breed: breedArr[indexPath.section], imageUrl: imageArr[indexPath.section], checked: animalDictId[idArr[indexPath.section]]!)
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ChoosingPetOrderTableViewCell {
            if cell.picked {
                cell.cellPicked()
                animalDictId[idArr[indexPath.section]] = false
                animalDictName[namePetArr[indexPath.section]] = false
            } else {
                animalDictId[idArr[indexPath.section]] = true
                animalDictName[namePetArr[indexPath.section]] = true
                cell.cellUnpicked()
            }
            addPetsButton.redAndGrayStyle(active: true)
        }
        isChoosen = false
        checkState()
    }
}

//MARK: - Check state of cell

private extension PetChoosingViewController {
    func checkState() {
        addPetsButton.redAndGrayStyle(active: false)
        for (key, value) in animalDictId {
            if value == true {
                isChoosen = true
                OrderManager.shared.petIds.insert(key)
                addPetsButton.redAndGrayStyle(active: true)
            } else {
                OrderManager.shared.petIds.remove(key)
            }
        }
        
        OrderManager.shared.nameOfPet = []
        OrderManager.shared.imageOfPet = []
        
        for i in 0..<namePetArr.count {
            for j in OrderManager.shared.petIds {
                if idArr[i] == j {
                    OrderManager.shared.nameOfPet.append(namePetArr[i])
                    OrderManager.shared.imageOfPet.append(imageArr[i])
                }
            }
        }
    }
}

//MARK: - Network

private extension PetChoosingViewController {
    func getPets() {
        var firstTest = [String: Any]()
        var secondTest = [String: Any]()
        var thirdTest = [String: Any]()
        
        var visiting = [[String: Any]]()
        
        if !OrderManager.shared.morningHours.isEmpty {
            firstTest = ["type": "morning", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.morningHours)] as [String : Any]
            visiting.append(firstTest)
        } else if OrderManager.shared.partOfDays.contains("morning") {
            OrderManager.shared.morningHours = "7:00"
            firstTest = ["type": "morning", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.morningHours)] as [String : Any]
            visiting.append(firstTest)
        }
        
        if !OrderManager.shared.afternoonHours.isEmpty {
            secondTest = ["type": "afternoon", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.afternoonHours)] as [String : Any]
            visiting.append(secondTest)
        } else if OrderManager.shared.partOfDays.contains("afternoon") {
            OrderManager.shared.afternoonHours = "12:00"
            secondTest = ["type": "afternoon", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.afternoonHours)] as [String : Any]
            visiting.append(secondTest)
        }
        
        if !OrderManager.shared.eveningHours.isEmpty {
            thirdTest = ["type": "evening", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.eveningHours)] as [String : Any]
            visiting.append(thirdTest)
        } else if OrderManager.shared.partOfDays.contains("evening") {
            OrderManager.shared.eveningHours = "19:00"
            thirdTest = ["type": "evening", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.eveningHours)] as [String : Any]
            visiting.append(thirdTest)
        }
        
        let parameters: [String: Any] = [
            "visits": visiting,
            "serviceId": OrderManager.shared.serviceId,
            "onDates": OrderManager.shared.dates,
        ]
        let baseURL = "\(Constant.baseURL)/customer/pets/for-order"
        if let token = DBManager.shared.getAccessToken() {
            let Auth_header: HTTPHeaders = ["Authorization": "Bearer \(token)"]

            AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { (response) in
                print("pets for-order", response)
                switch response.result {
                case .success(let success):
                    self.hideView()
                    let json = JSON(success)
                    if json["items"].array?.count != 0 {
                        
                        for i in 0..<json["items"].array!.count {
                            self.namePetArr.append(json["items"][i]["name"].string!)
                            if let breed = json["items"][i]["breed"].string {
                                self.breedArr.append(breed)
                            } else {
                                self.breedArr.append("-")
                            }
                            if let imgUrl = json["items"][i]["imageUrl"].string {
                                self.imageArr.append(imgUrl)
                            } else {
                                self.imageArr.append("-")
                            }
                            self.idArr.append(json["items"][i]["id"].string!)
                        }
                        
                        for i in self.namePetArr {
                            self.animalDictName[i] = false
                        }
                        
                        for i in self.idArr {
                            self.animalDictId[i] = false
                        }
                    }
                    self.tableView.reloadData()
                    self.hideActivityIndicator()
                case .failure(let error):
                    self.hideActivityIndicator()
                    self.setupErrorAlert(error: error)
                }
            }
        }
    }

}
