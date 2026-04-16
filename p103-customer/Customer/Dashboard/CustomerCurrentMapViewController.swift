//
//  CustomerCurrentMapViewController.swift
//  p103-customer
//
//  Created by SOTSYS371 on 24/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit

protocol CustomerMapOrderDelegate {
    func reloadCustomerMapData()
}


class CustomerCurrentMapViewController: BaseViewController {
    
    //MARK: - UIProperties
    
    private let currentOrders: UILabel = {
        let l = UILabel()
        l.text = "Current Orders"
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    } ()
    
    private lazy var listOfOrdersTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MapCurrentOrderTableViewCell.self)
        return tableView
    }()
    
    private var noCurrentOrdersLabel: UILabel = {
        let l = UILabel()
        l.text = "No active orders found!!"
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color606572
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    }()
    
    //MARK: - Properties
    
    private var orders = [MapOrders]()
    private var service: ServiceId?
    private var customerOrder = [Items]()
    private var customerService: Service?
   
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pullToRefresh(sender:)), for: .valueChanged)
        listOfOrdersTableView.refreshControl = refreshControl
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
            getCustomerMapOrder()
    }
    
    @objc func pullToRefresh(sender: UIRefreshControl) {
        sender.endRefreshing()
        getCustomerMapOrder()
    }
    
    
    
    //MARK: - Setup Layout
    
    private func setupLayout() {
        view.addSubviews([currentOrders])
        
        currentOrders.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview().offset(25)
        }
       
    }
    
    func setUpTableView() {
        view.addSubviews([listOfOrdersTableView])
        listOfOrdersTableView.snp.makeConstraints {
            $0.top.equalTo(currentOrders.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }

    private func setupNoCurrentOrdersLabel() {
        listOfOrdersTableView.removeFromSuperview()
        view.addSubview(noCurrentOrdersLabel)
        
        noCurrentOrdersLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
    }
    
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension CustomerCurrentMapViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MapCurrentOrderTableViewCell.self, for: indexPath)!
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
        cell.setUpCustomer(orders: customerOrder[indexPath.row])
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = CustomerMapViewController()
            selectedOrderId = customerOrder[indexPath.row].id
            vc.service = customerService
            vc.delegate = self
            vc.modalPresentationStyle = .currentContext
            self.present(vc, animated: true, completion: nil)
        }
    }



//MARK: - Network

private extension CustomerCurrentMapViewController {
    
    
    func reloadTblView() {
        if self.customerOrder.count > 0 {
            if !self.listOfOrdersTableView.isDescendant(of: self.view) {
                self.setUpTableView()
            }
            self.listOfOrdersTableView.reloadData()
        } else {
            self.setupNoCurrentOrdersLabel()
            
        }
        
    }
    
    func getCustomerMapOrder() {
        CustomerService().getMapOrders { result in
            print(result)
            switch result {
            case .success(let ord):
                if ord.items.count > 0  {
                    self.customerOrder = ord.items
                    self.customerService = ord.items[0].service
                } else if ord.items.count == 0 {
                    self.customerOrder.removeAll()
                }
                self.reloadTblView()
                
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
            self.hideActivityIndicator()
        }
        
    }
}
// MARK: - Customer Map Delegate
extension CustomerCurrentMapViewController: CustomerMapOrderDelegate {
    func reloadCustomerMapData() {
        getCustomerMapOrder()
    }
}

