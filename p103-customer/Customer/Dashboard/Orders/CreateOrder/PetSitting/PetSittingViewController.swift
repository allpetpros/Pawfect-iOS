//
//  PetSittingViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 08.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class PetSittingViewController: BaseViewController {

    //MARK: - UIProperties
    
    private let subCategoryTitleLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    } ()
    
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
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.register(PetSittingTableViewCell.self)
        return tableView
    }()
    
    private let nextButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Next", type: .nextBig, bordered: true)
        
        button.redAndGrayStyleMain(active: false)
        let doneButtonAction = UIButton()
        doneButtonAction.addTarget(self, action: #selector(nextButtonTouched), for: .touchUpInside)
        button.addSubview(doneButtonAction)
        doneButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    //MARK: - Properties
    
    var subCategoryTitle : String? 
    private var titleArr = [String]()
    private var descrArr = [String]()
    private var speciesTypeArr = [String]()
    private var sizeTypeArr = [String]()
    private var priceArr = [Int]()
    private var idArr = [String]()
    private var imageArr = [String]()
    var listOfServicesArr = [ListOfServices]()
    var serviceArr = [ListOfServices]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showView()
        subCategoryTitleLabel.text = subCategoryTitle
        view.backgroundColor = UIColor.white
        let dummyViewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        clearDBData()
        getServices()
        setupTableView()

    }
    
    
    
    //MARK: - Setup Layout
    
    func clearDBData() {
        OrderManager.shared.morningHours = ""
        OrderManager.shared.afternoonHours = ""
        OrderManager.shared.eveningHours = ""
        OrderManager.shared.extraPrice = []
        OrderManager.shared.extraTitleArr = []
        OrderManager.shared.totalExtraPrice = 0
    }
    
    private func setupTableView() {
        
        view.addSubviews([subCategoryTitleLabel, closebutton, tableView, nextButton])
        
        subCategoryTitleLabel.snp.makeConstraints {
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
            $0.top.equalTo(subCategoryTitleLabel.snp.bottom).offset(28 )
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
    }
    
    func getServices() {
        for i in listOfServicesArr {
            if subCategoryTitle == i.subcategory!["title"] {
                serviceArr.append(i)
                self.speciesTypeArr.append(i.speciesType.joined(separator: ", "))
            }
        }
        hideView()
    }
}

//MARK: - Actions

extension PetSittingViewController {
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextButtonTouched() {
        getExtras()
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension PetSittingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(PetSittingTableViewCell.self, for: indexPath) else { return PetSittingTableViewCell() }
        
        cell.setup(title: serviceArr[indexPath.row].title, description: serviceArr[indexPath.row].description, price: serviceArr[indexPath.row].price, typeOfAnimal: speciesTypeArr[indexPath.row], imageUrl: serviceArr[indexPath.row].imageUrl ?? "")
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setupCheckboxes(indexPath: indexPath)
    }
}

//MARK: - Setup Checkboxes

private extension PetSittingViewController {
    func setupCheckboxes(indexPath: IndexPath) {
        for cell in tableView.visibleCells {
            let c = cell as! PetSittingTableViewCell
            c.cellUnpicked()
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? PetSittingTableViewCell {
            cell.cellPicked()
            OrderManager.shared.serviceId = serviceArr[indexPath.row].id
            OrderManager.shared.service = serviceArr[indexPath.row].title
            OrderManager.shared.price = serviceArr[indexPath.row].price
            nextButton.redAndGrayStyleMain(active: true)
        }
    }
}

//MARK: - Network

private extension PetSittingViewController {

    func getExtras() {
        CustomerService().getExtras { result in
            switch result {
            case .success(let userData):
                if userData.items.isEmpty {
                    let vc = SelectDateAndTimeVC(state: .services)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                } else {
                    let vc = ExtrasPriceViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
}
