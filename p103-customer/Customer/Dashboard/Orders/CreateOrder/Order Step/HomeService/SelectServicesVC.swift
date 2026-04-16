//
//  SelectServicesVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 25.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SwiftyJSON

enum Services: CaseIterable {
    case petSitting
    case boardingAndDaycare
    case dogWalking

    var descriptionLabelText: String {
        switch self {

        case .petSitting:
            return "Pet Sitting"
        case .boardingAndDaycare:
            return "Boarding & Daycare"
        case .dogWalking:
            return "Dog Walking"
        }
    }
}

class SelectServicesVC: BaseViewController {
    
    // MARK:  - UI Properties

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        label.text = "Select Services"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.register(ServicesCell.self)
        return tableView
    }()
    
    private lazy var alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.delegate = self
        return view
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
    
    //MARK: - Properties
    
    private var titleArr = [String]()
    private var idArr = [String]()
    private var imageUrl = [String]()
    var delegate: ReloadData?
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        showView()
        OrderManager.shared.morningHours = ""
        OrderManager.shared.afternoonHours = ""
        OrderManager.shared.eveningHours = ""
        OrderManager.shared.partOfDays = []
        OrderManager.shared.extraPrice = []
        OrderManager.shared.extraTitleArr = []
        OrderManager.shared.totalExtraPrice = 0
        OrderManager.shared.serviceId = ""
        OrderManager.shared.petIds = []
        getServices()
        setupLayouts()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
    }
}

// MARK: - Setup Layout
extension SelectServicesVC {
    private func setupLayouts() {
        view.addSubviews([descriptionLabel,closebutton,tableView])
        
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
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
        }
    }
}

// MARK: - UITableViewDataSource

extension SelectServicesVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(ServicesCell.self, for: indexPath) else { return ServicesCell() }
        cell.setupAvailableServices(title: titleArr[indexPath.row], numberOfServices: indexPath.row, imageUrl: imageUrl[indexPath.row])
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UITableViewDelegate

extension SelectServicesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SelectSubcategoryServicesVC()
        vc.id = idArr[indexPath.row]
        vc.categoryTitle = titleArr[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true
    }
}

//MARK: - Network

private extension SelectServicesVC {
    func getServices() {
        
        CustomerService().getServices { result in
            print(JSON(result))
            switch result {
                
            case .success(let userData):
                for i in userData.items {
                    self.hideView()
                    self.titleArr.append(i.title)
                    self.idArr.append(i.id)
                    if let img = i.imageUrl {
                        self.imageUrl.append(img)
                    } else {
                        self.imageUrl.append("-")
                    }
                }
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
}

//MARK: - Actions

extension SelectServicesVC {
    @objc func closeButtonTouched() {
        dismiss(animated: true) { [self] in
            showActivityIndicator()
            delegate?.reloadOrder()
        }
    }
}


