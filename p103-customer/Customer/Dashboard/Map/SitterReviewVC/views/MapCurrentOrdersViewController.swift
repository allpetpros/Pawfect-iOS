//
//  MapCurrentOrdersViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 20.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

enum MapState {
    case customer
    case employee
}

protocol EmployeeMapDelegate {
    func reloadData()
}



class MapCurrentOrdersViewController: BaseViewController {
    
    //MARK: - UIProperties
    
    private let currentOrders: UILabel = {
        let l = UILabel()
        l.text = "Current Orders"
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    } ()
    
    private lazy var listOfOrdersTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MapCurrentOrderTableViewCell.self)
        return tableView
    }()
    
    private var noCurrentOrdersLabel: UILabel = {
        let l = UILabel()
        l.text = "You haven't got any active orders for today"
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
        

        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showActivityIndicator()
        getMapOrder()
    }
    
    @objc func pullToRefresh(sender: UIRefreshControl) {
        sender.endRefreshing()
        getMapOrder()
    }
    
    
    
    
    //MARK: - Setup Layout
    
    private func setupLayout() {
        view.addSubviews([currentOrders])
        
        currentOrders.snp.makeConstraints {
            $0.top.equalToSuperview().offset(60)
            $0.left.equalToSuperview().offset(25)
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

extension MapCurrentOrdersViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

               return orders.count

    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(MapCurrentOrderTableViewCell.self, for: indexPath)!
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)

        print(orders.count)
            cell.setupEmployeeOrder(orders: orders[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MapViewController()
        vc.id = orders[indexPath.row].id
        vc.service = service
        vc.delegate = self
        vc.modalPresentationStyle = .currentContext
        self.present(vc, animated: true, completion: nil)

    }
}

//MARK: - Network

private extension MapCurrentOrdersViewController {
    
    func setUpTableView() {
        view.addSubviews([listOfOrdersTableView])
        listOfOrdersTableView.snp.makeConstraints {
            $0.top.equalTo(currentOrders.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
    func reloadTblView() {

            if self.orders.count > 0 {
                if !self.listOfOrdersTableView.isDescendant(of: self.view) {
                    self.setUpTableView()
                }
                self.listOfOrdersTableView.reloadData()
            } else {
                self.setupNoCurrentOrdersLabel()
                
            }
    }
    
    func getMapOrder() {
        EmployeeService().getCurrentMapOrders { result in
            print(result)
            switch result {
            case .success(let ord):
                
                if ord.items.count > 0 {

                    self.orders = ord.items
                    self.service = ord.items[0].service
                } else if ord.items.count == 0 {
                    self.orders.removeAll()
                }
                self.reloadTblView()
               self.hideActivityIndicator()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
            self.hideActivityIndicator()
        }
    }
    
}

// MARK: - Employee Map Delegate
extension MapCurrentOrdersViewController: EmployeeMapDelegate {
    func reloadData() {

    }
}


