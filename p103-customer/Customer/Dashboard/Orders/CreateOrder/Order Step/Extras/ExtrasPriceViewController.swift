//
//  ExtrasPriceViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 08.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class ExtrasPriceViewController: BaseViewController {
    
    //MARK: - UIProperties
    
    private let dogWalkingTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Extras"
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    } ()
    
    private let closebutton: UIButton = {
        let button = UIButton()
//        button.setImage(R.image.backArrowCalendar(), for: .normal)
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
        tableView.register(ExtrasPriceTableViewCell.self)
        return tableView
    }()
    
    private let doneButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Done", type: .ok, bordered: true)
        button.redAndGrayStyleMain(active: true)
        let doneAction = UIButton()
        doneAction.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        button.addSubview(doneAction)
        doneAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    //MARK: - Properties
    
    private var isExtrasTapped: Bool = true
    private var extras = [ExtraServices]()
    private var priceArr = [Int]()
    private var titleArr = [String]()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        showView()
        
        let dummyViewHeight = CGFloat(40)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        
        getExtras()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        OrderManager.shared.extraPrice = []
//        OrderManager.shared.extraTitleArr = []
//        OrderManager.shared.extraIds = []
    
    }
    
    //MARK: - Setup Layout
    
    private func setupTableView() {
        view.addSubviews([dogWalkingTitleLabel, closebutton, tableView, doneButton])
        
//        closebutton.snp.makeConstraints {
//            $0.width.equalTo(21)
//            $0.height.equalTo(15)
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
//            $0.left.equalToSuperview().offset(25)
//        }
//
//        dogWalkingTitleLabel.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            $0.left.equalTo(closebutton.snp.right).offset(19)
//        }
//
//        tableView.snp.makeConstraints {
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(doneButton.snp.top)
//            $0.top.equalTo(dogWalkingTitleLabel.snp.bottom).offset(28)
//        }
//
//        doneButton.snp.makeConstraints {
//            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
//            $0.leading.trailing.equalToSuperview().inset(50)
//            $0.height.equalTo(40)
//        }
        
        dogWalkingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
//            $0.left.equalTo(closebutton.snp.right).offset(19)
            $0.leading.trailing.equalToSuperview().offset(10)
        }
        closebutton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(15)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.right.equalToSuperview().offset(-25)
        }
//        descriptionLabel.snp.makeConstraints {
//            $0.leading.equalToSuperview().inset(25)
//            $0.top.equalTo(view.safeAreaLayoutGuide).inset(38)
//        }offse
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
//            $0.trailing.equalTo(closebutton).offset(5)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(dogWalkingTitleLabel.snp.bottom).offset(28 )
        }
        doneButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(6)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
        }
    }
    
}

//MARK: - Actions

extension ExtrasPriceViewController {
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonAction() {
        
        let vc = SelectDateAndTimeVC(state: .services)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension ExtrasPriceViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return extras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeue(ExtrasPriceTableViewCell.self, for: indexPath) else { return ExtrasPriceTableViewCell() }
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
        cell.setup(name: extras[indexPath.row].title, price: extras[indexPath.row].price, description: extras[indexPath.row].description)
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
        if let cell = tableView.cellForRow(at: indexPath) as? ExtrasPriceTableViewCell {
            
            if isExtrasTapped {
                
                if cell.checkboxButton.currentImage == UIImage(named: "checkboxBlack") {
                    cell.cellPicked()
                    OrderManager.shared.extraIds.insert(extras[indexPath.row].id)
                    OrderManager.shared.extraTitleArr.append(titleArr[indexPath.row])
                    OrderManager.shared.extraPrice.append(priceArr[indexPath.row])
                    
                } else {
                    cell.cellUnpicked()
                    OrderManager.shared.extraIds.remove(extras[indexPath.row].id)
                    OrderManager.shared.extraTitle = titleArr[indexPath.row]
                    for i in 0..<OrderManager.shared.extraPrice.count {
                        if OrderManager.shared.extraPrice[i] == extras[indexPath.row].price && OrderManager.shared.extraTitleArr[i] == titleArr[indexPath.row] {
                            OrderManager.shared.extraPrice.remove(at: i)
                            OrderManager.shared.extraTitleArr.remove(at: i)
                            break
                        }
                        
                    }
                    
                }
                
            }
        }
    }
}

//MARK: - Network

private extension ExtrasPriceViewController {
    func getExtras() {
        CustomerService().getExtras { result in
            
            switch result {
            case .success(let userData):
                self.extras = userData.items
                for i in self.extras {
                    self.hideView()
                    self.priceArr.append(i.price)
                    self.titleArr.append(i.title)
                }
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
}
