//
//  BoardingAndDaycareViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 07.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class BoardingAndDaycareViewController: BaseViewController {
    
    //MARK: - UIProperties
    
    private let boardingTitleLabel: UILabel = {
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
        tableView.register(BoardingAndDaycareTableViewCell.self)
        return tableView
    }()
    
    private  let nextButton: SecondaryButton = {
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
    
    var id = String()
    private var titleArr = [String]()
    private var descrArr = [String]()
    private var speciesTypeArr = [String]()
    private var sizeTypeArr = [String]()
    private var priceArr = [Int]()
    private var idArr = [String]()
    private var imageArr = [String]()
    
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
        view.addSubviews([boardingTitleLabel, closebutton, tableView, nextButton])
        
        closebutton.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(25)
        }
        
        boardingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(31)
            $0.left.equalTo(closebutton.snp.right).offset(19)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top)
            $0.top.equalTo(boardingTitleLabel.snp.bottom).offset(28)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate

extension BoardingAndDaycareViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(BoardingAndDaycareTableViewCell.self, for: indexPath) else { return BoardingAndDaycareTableViewCell() }
        cell.setup(section: indexPath, title: titleArr[indexPath.row], price: priceArr[indexPath.row], description: descrArr[indexPath.row], size: speciesTypeArr[indexPath.row], imageUrl: imageArr[indexPath.row])
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        setupCheckboxesSecondSection(indexPath: indexPath)
    }
    
    func setupCheckboxesSecondSection(indexPath: IndexPath) {
        for cell in tableView.visibleCells {
            let c = cell as! BoardingAndDaycareTableViewCell
            c.cellUnpicked()
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? BoardingAndDaycareTableViewCell {
            cell.cellPicked()
            OrderManager.shared.serviceId = idArr[indexPath.row]
            OrderManager.shared.serviceImage = imageArr[indexPath.row]
            OrderManager.shared.service = titleArr[indexPath.row]
            OrderManager.shared.price = priceArr[indexPath.row]
            nextButton.redAndGrayStyleMain(active: true)
        }
    }
}

//MARK: - Actions

extension BoardingAndDaycareViewController {
    @objc func nextButtonTouched() {
        getExtras()
    }
    
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - Network

private extension BoardingAndDaycareViewController {
    func getServices() {
        
        CustomerService().getServices { result in
            switch result {
            case .success(let userData):
                self.boardingTitleLabel.text = userData.items[1].title
                for i in userData.items[1].services {
                    self.titleArr.append(i.title)
                    self.descrArr.append(i.description)
                    self.priceArr.append(i.price)
                    self.idArr.append(i.id)
                    self.speciesTypeArr.append(i.speciesType.joined(separator: ", "))
                    if let img = i.imageUrl {
                        self.imageArr.append(img)
                    } else {
                        self.imageArr.append("-")
                    }
                }
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
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
}
