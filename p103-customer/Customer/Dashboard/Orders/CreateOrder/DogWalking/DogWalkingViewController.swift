//
//  DogWalkingViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 08.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class DogWalkingViewController: BaseViewController {

    //MARK: - UIProperties
    
    private let dogWalkingTitleLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    } ()
    
    private let closebutton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.backArrowCalendar(), for: .normal)
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
        tableView.register(DogWalkingTableViewCell.self)
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
    
    private var isFirstTimeDogWalking: Bool = true
    var id = String()
    
    private var titleArr = [String]()
    private var descrArr = [String]()
    private var speciesTypeArr = [String]()
    private var sizeTypeArr = [String]()
    private var priceArr = [Int]()
    private var idArr = [String]()
    private var imageArr = [String]()
    
    private var test = [["J", "Q", "P"], ["K", "A", "Y"]]
    
    private var titleT = [[String]]()
    private var descriptionT = [[String]]()
    private var speciesT = [[String]]()
    private var sizeT = [[String]]()
    private var priceT = [[Int]]()
    private var idT = [[String]]()
    private var imageT = [[String]]()
    
    private var items = [SelectionServices]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setupTableView()
        let dummyViewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        getServices()
    }
    
    //MARK: - Setup Layout
    
    private func setupTableView() {
        view.addSubviews([dogWalkingTitleLabel, closebutton, tableView, nextButton])
        
        closebutton.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(25)
        }
        
        dogWalkingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(31)
            $0.left.equalTo(closebutton.snp.right).offset(19)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top)
            $0.top.equalTo(dogWalkingTitleLabel.snp.bottom).offset(28)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension DogWalkingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleT.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleT[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(DogWalkingTableViewCell.self, for: indexPath) else { return DogWalkingTableViewCell() }
        cell.setup(title: titleT[indexPath.section][indexPath.row], description: descriptionT[indexPath.section][indexPath.row], price: priceT[indexPath.section][indexPath.row], speciesType: speciesT[indexPath.section][indexPath.row], size: sizeT[indexPath.section][indexPath.row], imageUrl: imageT[indexPath.section][indexPath.row])
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setupCheckboxes(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 10, y: 5, width: headerView.frame.width-10, height: headerView.frame.height)
        label.font = R.font.aileronBold(size: 18)
        label.textColor = .color293147
        
        if section == 0 {
            label.text = "Dog Boarding"
        } else {
            label.text = "Dog Daycare"
        }
        
        headerView.addSubview(label)
        
        return headerView
    }

}

//MARK: - Setup Checkboxes state

private extension DogWalkingViewController {
    func setupCheckboxes(indexPath: IndexPath) {
        for cell in tableView.visibleCells {
            let c = cell as! DogWalkingTableViewCell
            c.cellUnpicked()
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? DogWalkingTableViewCell {
            cell.cellPicked()
            OrderManager.shared.serviceId = idT[indexPath.section][indexPath.row]
            OrderManager.shared.service = titleT[indexPath.section][indexPath.row]
            OrderManager.shared.price = priceT[indexPath.section][indexPath.row]
            nextButton.redAndGrayStyleMain(active: true)
        }
    }
}

//MARK: - Actions

extension DogWalkingViewController {
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextButtonTouched() {
        getExtras()
    }
}

//MARK: - Network

private extension DogWalkingViewController {
    func getServices() {
        
        CustomerService().getServices { result in
            switch result {
            case .success(let userData):
                self.dogWalkingTitleLabel.text = userData.items[2].title
                self.items = userData.items
                for i in userData.items[2].services {
                    self.titleArr.append(i.title)
                    self.descrArr.append(i.description)
                    self.priceArr.append(i.price)
                    self.idArr.append(i.id)
                    self.speciesTypeArr.append(i.speciesType.joined(separator: ", "))
                    if let size = i.sizeType {
                        self.sizeTypeArr.append(size)
                    } else {
                        self.sizeTypeArr.append("-")
                    }
                    if let img = i.imageUrl {
                        self.imageArr.append(img)
                    } else {
                        self.imageArr.append("-")
                    }
                }
                self.titleT = self.titleArr.split()
                self.descriptionT = self.descrArr.split()
                self.speciesT = self.speciesTypeArr.split()
                self.sizeT = self.sizeTypeArr.split()
                self.priceT = self.priceArr.split()
                self.idT = self.idArr.split()
                self.imageT = self.imageArr.split()
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
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
                    vc.modalPresentationStyle = .popover
                    self.present(vc, animated: true, completion: nil)
                }
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
}



extension Array {
    func split() -> [[Element]] {
        let ct = self.count
        let half = ct / 2
        let leftSplit = self[0 ..< half]
        let rightSplit = self[half ..< ct]
        return [Array(leftSplit), Array(rightSplit)]
    }
}
