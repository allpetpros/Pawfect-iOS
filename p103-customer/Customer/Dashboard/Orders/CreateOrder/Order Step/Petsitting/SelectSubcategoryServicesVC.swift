//
//  SelectSubcategoryServicesVC.swift
//  p103-customer
//
//  Created by Foram Mehta on 22/02/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import SwiftyJSON
class SelectSubcategoryServicesVC: BaseViewController {
    
    // MARK:  - UI Properties
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        return label
    }()
    private let closebutton: UIButton = {
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.register(SubCategoryServiceCell.self)
        return tableView
    }()
    
    private lazy var alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.delegate = self
        return view
    }()
    
    //MARK: - Properties
    
    private var titleArr = [String]()
    private var idArr = [String]()
    private var imageUrl = [String]()
    var id: String?
    var categoryTitle: String?
    var subCategoryArr = [[String:String]]()
    var listOfServicesArr = [ListOfServices]()
    var uniqueSubCategoryArr = [[String:String]]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showView()
        descriptionLabel.text = categoryTitle
        view.backgroundColor = .white
        clearDBData()
        getServices(id: id!)
        setupLayouts()
    }
}


// MARK: - Setup Layout
extension SelectSubcategoryServicesVC {
    
    func clearDBData() {
        OrderManager.shared.morningHours = ""
        OrderManager.shared.afternoonHours = ""
        OrderManager.shared.eveningHours = ""
        OrderManager.shared.extraPrice = []
        OrderManager.shared.extraTitleArr = []
        OrderManager.shared.totalExtraPrice = 0
    }
    
    private func setupLayouts() {
        view.addSubviews([closebutton,descriptionLabel, tableView])

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.leading.trailing.equalToSuperview().offset(10)
        }
        closebutton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(15)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.right.equalToSuperview().offset(-25)
        }
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(descriptionLabel.snp.bottom)
        }
    }
}
//MARK: - Actions
extension SelectSubcategoryServicesVC {
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension SelectSubcategoryServicesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return uniqueSubCategoryArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(SubCategoryServiceCell.self, for: indexPath) else { return SubCategoryServiceCell() }
        print(indexPath.row)
        cell.setupAvailableServices(title: uniqueSubCategoryArr[indexPath.row]["title"] ?? "", numberOfServices: indexPath.row, imageUrl: imageUrl[indexPath.row])
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITableViewDelegate

extension SelectSubcategoryServicesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = PetSittingViewController()      
        vc.subCategoryTitle = uniqueSubCategoryArr[indexPath.row]["title"]
        
        vc.listOfServicesArr = listOfServicesArr
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
}

//MARK: - Network

private extension SelectSubcategoryServicesVC {
    func getServices(id: String) {
        
        CustomerService().getServices { result in
        print("Subcategpry:", result)
        switch result {
            case .success(let userData):
                for i in userData.items {
                    if i.id == id {
                        for j in i.services {
                            self.hideView()
                            self.listOfServicesArr.append(j)
                            self.subCategoryArr.append(j.subcategory ?? [:])
                            self.imageUrl.append("-")
                        }
                        self.uniqueSubCategoryArr = self.subCategoryArr.unique()
                    }
                }
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
}
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
