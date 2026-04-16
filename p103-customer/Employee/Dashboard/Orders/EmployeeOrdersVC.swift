//
//  EmployeeOrdersVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 04.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

@objc protocol DayConfirmedDelegate: class {
    func get(date: Date)
}



enum EmployeeOrdersState {
    case appointments
    case upcoming
    case history
}

class EmployeeOrdersVC: BaseViewController {
    // MARK: - UIProperties
    private let enableColor:UIColor = .colorC6222F
    private var isMeetGreetSelected = false
    private let dissableColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
    private let topView: UIView = {
        let view = UIView()
        return view
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        label.text = "Pet Sitting Requests"
        return label
    }()
    private lazy var navigationView: NavigationView = {
        let view = NavigationView()
        
        view.setup(state: .employeeOrders)
        view.employeeOrdersDelegate = self
        return view
    }()
    
    private lazy var categoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var newOrderBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(enableColor, for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button.setTitle("New Orders", for: .normal)
        button.tag = 1
        return button
    } ()
    
    private lazy var meetNGreetBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(dissableColor, for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
       
        button.setTitle("Meet & Greet", for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        button.tintColor = .black
        return button
    } ()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.register(MeetNGreetCell.self)
        tableView.register(PetSittingNewRequestsTableViewCell.self)
        tableView.register(ConfirmOrderCellTableViewCell.self)
        tableView.register(EmployeeHistoryViewCell.self)
        return tableView
    }()
    
    private let headerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color606572
        label.text = ""
        return label
    }()
    
    private lazy var calendarDaysView: CalendarDayView = {
        let view = CalendarDayView()
        view.delegate = self
        return view
    }()
           
    // MARK: - Properties
    
    var tableViewState: EmployeeOrdersState = .appointments
    
    private var orders = [EmployeeOrderItems]()
    private var meetNGreetArr = [MeetNGreetItem]()
    private var confirmedOrders = [EmployeeConfirmedItems]()
    private var historyOrders = [EmployeeHistoryDetails]()

    private var page = 1
    private var meetNGreetPage = 1
    private var totalItems = 0
    private var confirmedTotalItems = 0
    private var pageConfirmed = 1
    private var historiesTotalItems = 0
    private var pageHistories = 1
    
    private var dateConfirmed = Int()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        isMeetGreetSelected = false
        tableView.delegate = self
        tableView.dataSource = self

        calendarDaysView.setDefaultSelection()
        setupLayouts()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if !isMeetGreetSelected {
            page = 1
            getNewOrders()
        } else  {
            page = 1
            getMeetNGreet()
        }
        calendarDaysView.setDefaultSelection()
        pageHistories = 1
        getHistories()
    }

}

// MARK: - Extensions
extension EmployeeOrdersVC {
       private func setupLayouts() {
        setupTopView()
        setupTableView()
    }
    private func setupTopView() {
        view.backgroundColor = .white
        view.addSubviews([topView])
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(170)
        }
        topView.addSubviews([descriptionLabel, navigationView, categoryView])
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(25)
        }
        navigationView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(35)
        }
        categoryView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(35)
        }
        categoryView.addSubviews([newOrderBtn,meetNGreetBtn])
        newOrderBtn.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.top)
            $0.leading.equalTo(categoryView.snp.leading).inset(25)
            $0.height.equalTo(35)
        }
        
        meetNGreetBtn.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.top)
            $0.trailing.equalTo(categoryView.snp.trailing).inset(25)
            $0.height.equalTo(35)
        }
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
    }
    
    @objc func buttonTapped(sender: UIButton!) {
        if sender.tag == 1 {
            newOrderBtn.setTitleColor(enableColor, for: .normal)
            meetNGreetBtn.setTitleColor(dissableColor, for: .normal)
            isMeetGreetSelected = false
            tableView.reloadData()
        } else if sender.tag == 2 {
            meetNGreetBtn.setTitleColor(enableColor, for: .normal)
            newOrderBtn.setTitleColor(dissableColor, for: .normal)
            isMeetGreetSelected = true
            getMeetNGreet()
            tableView.reloadData()
        }
    }

}

// MARK: - UITableViewDataSource

extension EmployeeOrdersVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableViewState {
        case .appointments:
            return 1
        case .upcoming:
            return 1
        case .history:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableViewState {
        case .appointments:
            if !isMeetGreetSelected {
                if orders.count == 0 {
                    let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                    noDataLabel.text          = "No new order found"
                    noDataLabel.textColor     = UIColor.colorC6222F
                    noDataLabel.textAlignment = .center
                    tableView.backgroundView  = noDataLabel
                    tableView.separatorStyle  = .none
                    return 0
                } else  {
                    tableView.backgroundView = nil
                    return orders.count
                }
            } else {
                if meetNGreetArr.count == 0 {
                    let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                    noDataLabel.text          = "No new Meet and Greet found"
                    noDataLabel.textColor     = UIColor.colorC6222F
                    noDataLabel.textAlignment = .center
                    tableView.backgroundView  = noDataLabel
                    tableView.separatorStyle  = .none
                    return 0
                } else  {
                    tableView.backgroundView = nil
                    return meetNGreetArr.count
                }
           
            }
           
        case .upcoming:
            if confirmedOrders.count == 0 {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "No confirmed order found"
                noDataLabel.textColor     = UIColor.colorC6222F
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
                return 0
            } else {
                tableView.backgroundView = nil
                return confirmedOrders.count
            }
            
            
        case .history:
            if historyOrders.count == 0 {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text = "No History found"
                noDataLabel.textColor     = UIColor.colorC6222F
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
                return 0
            } else {
                tableView.backgroundView = nil
                return historyOrders.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewState {
            
        case .appointments:
            
            if !isMeetGreetSelected {
                guard let cell = tableView.dequeue(PetSittingNewRequestsTableViewCell.self, for: indexPath) else { return PetSittingNewRequestsTableViewCell() }
                cell.orderSetup(order: orders[indexPath.row])
                return cell
            } else {
                
                guard let cell = tableView.dequeue(MeetNGreetCell.self, for: indexPath) else { return MeetNGreetCell() }
                cell.orderSetup(timeFrom: meetNGreetArr[indexPath.row].timeFrom, customerDetails: meetNGreetArr[indexPath.row].customer)
                return cell
            }
           
          
        case .upcoming:
            guard let cell = tableView.dequeue(ConfirmOrderCellTableViewCell.self, for: indexPath) else { return ConfirmOrderCellTableViewCell() }
            cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
            cell.confirmedOrdersSetup(orders: confirmedOrders[indexPath.row])

            return cell
        case .history:

            guard let cell = tableView.dequeue(EmployeeHistoryViewCell.self, for: indexPath) else { return EmployeeHistoryViewCell() }
            cell.bgView.addGrayShadowView(offset: CGSize(width: 0, height: 2), radius: 10)
            cell.historyOrdersSetup(orders: historyOrders[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch tableViewState {

        case .appointments:
            if !isMeetGreetSelected {
                if indexPath.row == orders.count - 1 {
                    if totalItems > orders.count {
                        if totalItems == orders.count {
                            break
                        } else {
                            page+=1
                            getNewOrders()
                        }
                    }
                }
            }
        case .upcoming:
            if indexPath.row == confirmedOrders.count - 1 {
                if confirmedTotalItems > confirmedOrders.count {
                    if confirmedTotalItems == confirmedOrders.count {
                        break
                    } else {
                        pageConfirmed+=1
                        getConfirmedOrders(date: dateConfirmed)
                    }

                }
            }
           
        case .history:
            if indexPath.row == historyOrders.count - 1 {
                if historiesTotalItems > historyOrders.count {
                    if historiesTotalItems == historyOrders.count {
                        break
                    } else {
                        pageHistories += 1
                        getHistories()
                    }

                }
            }
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableViewState {
            
        case .appointments, .upcoming:
            if section == 0 {
                return createHeader()
            }
            return UIView()
        case .history:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func createHeader() -> UIView {
        switch tableViewState {
        case .appointments:
            let headerView = UIView()
            headerView.backgroundColor = .clear
            headerView.addSubviews([headerDescriptionLabel])
            headerDescriptionLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(5)
                $0.leading.equalToSuperview().inset(25)
                $0.bottom.equalToSuperview().inset(20)
            }
            return headerView
        case .upcoming:
            let headerView = UIView()
            headerView.backgroundColor = .clear
            headerView.addSubview(calendarDaysView)
            calendarDaysView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(100)
            }
            return headerView
        case .history:
            return UIView()
        }
    }
    
    private func toDate(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch tableViewState {
        case .appointments, .upcoming:
            return 20
        case .history:
            return 30
        }
    }
}

//MARK: - UITableViewDelegate

extension EmployeeOrdersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewState {

        case .appointments:
            if !isMeetGreetSelected{
                let vc = AppointmentDetailsViewController()
                vc.id = orders[indexPath.row].id
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = MeetNGreetDetailViewController()
                vc.delegate = self
                vc.meetNGreetDetail = meetNGreetArr[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        case .upcoming:
            let vc = ConfirmedAppointmentDetailsViewController()
            vc.date = dateConfirmed
            vc.id = confirmedOrders[indexPath.row].id
            vc.customerImageUrl = confirmedOrders[indexPath.row].customer.imageUrl
            vc.customerName = "\(confirmedOrders[indexPath.row].customer.name) \(confirmedOrders[indexPath.row].customer.surname)"
            self.navigationController?.pushViewController(vc, animated: true)
        case .history:
            if historyOrders[indexPath.row].status == "completed" {
                let vc = HistoryVisitSummaryViewController()
                vc.id = historyOrders[indexPath.row].id
                vc.typeOfHistory = "employee"
                vc.service = historyOrders[indexPath.row].service.title
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
            }
        }
    }
}

// MARK: - ProfileNavigationViewOrdersDelegate

extension EmployeeOrdersVC: ProfileNavigationViewEmployeeOrdersDelegate {
    func stateChanged(state: EmployeeOrdersState) {
        self.tableViewState = state
        switch tableViewState {
        case .appointments:
            print("upcoming or orders")
            categoryView.isHidden = false
            isMeetGreetSelected = false
            newOrderBtn.setTitleColor(enableColor, for: .normal)
            meetNGreetBtn.setTitleColor(dissableColor, for: .normal)
            page = 1
            getNewOrders()
            buttonTapped(sender: newOrderBtn)
            tableView.reloadData()
        case .upcoming:
            calendarDaysView.setDefaultSelection()
            categoryView.isHidden = true
        case .history:
            categoryView.isHidden = true
            pageHistories = 1
            getHistories()
            tableView.reloadData()
        }
        tableView.reloadData()
    }
}

//MARK: - Network

private extension EmployeeOrdersVC {
    func getNewOrders() {
        if page == 1 {
            orders = []
        }
        
        EmployeeService().getNewOrders(limit: 10, page: page) { result in
            
            switch result {
            case .success(let success):
                self.orders = success.items
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    
    func getMeetNGreet() {
        if meetNGreetPage == 1 {
            meetNGreetArr = []
        }
        EmployeeService().getListOfMeetNGreetRequest { result in
            switch result {
            case .success(let success):
                for i in success.items {
                    self.meetNGreetArr.append(i)
                }
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
            self.tableView.reloadData()
        }
    }
    
    func getConfirmedOrders(date: Int) {
        
        showActivityIndicator()
        if pageConfirmed == 1 {
            confirmedOrders = []
        }
        
        EmployeeService().getConfirmed(date: date, limit: 10, page: pageConfirmed) { result in
            switch result {
            case .success(let s):
                self.confirmedOrders = s.items
                self.confirmedTotalItems = s.meta.totalItems
                self.tableView.reloadData()
                self.hideActivityIndicator()
            case .failure(let error):
                self.setupErrorAlert(error: error)
                self.hideActivityIndicator()
            }
        }
        self.hideActivityIndicator()
    }
    
    func getHistories() {
        showActivityIndicator()
        if pageHistories == 1 {
            historyOrders = []
        }
        
        EmployeeService().getHistories(limit: 10, page: pageHistories) { result in
            switch result {
            case .success(let s):
                self.historiesTotalItems = s.meta.totalItems
                for i in s.items {
                    self.historyOrders.append(i)
                }
                self.hideActivityIndicator()
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
                self.hideActivityIndicator()
            }
        }
        
    }
}

//MARK: - EmployeeOrderDetailsDelegate

extension EmployeeOrdersVC: EmployeeOrderDetailsDelegate {
    func reloadOrders() {
        getNewOrders()
        getMeetNGreet()
    }
}

//MARK: - DayConfirmedDelegate

extension EmployeeOrdersVC: DayConfirmedDelegate {
    func get(date: Date) {
        dateConfirmed = Int(date.millisecondsSince1970)
        getConfirmedOrders(date: Int(date.millisecondsSince1970))
    }
}

