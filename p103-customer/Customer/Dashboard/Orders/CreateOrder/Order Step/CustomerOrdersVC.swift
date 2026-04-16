//
//  PetsVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 08.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

enum CustomerOrdersStates {
    case orders
    case upcoming
    case history
}
 
enum StartOrderStates {
    case orders
    case upcoming
}

@objc protocol PetSittingRequestDelegate: AnyObject {
    func reloadTable()
    func onClickExpandCollapse(isMoreExpanded: Bool,indexPath: Int)
}

@objc protocol HistoryRateDelegate: AnyObject {
    func toRateScreen(rowIndex: Int)
    func toSummaryDetailsScreen(rowIndex: Int)
}

@objc protocol ReloadData: AnyObject {
    func reloadMeetNGreet()
    func reloadOrder()
}


protocol ReloadHistory {
    func getHistory()
}

class CustomerOrdersVC: BaseViewController {
    
    // MARK: - UI Property
    //TopView
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
        view.setup(state: .customerOrders)
        view.customerOrdersDelegate = self
        
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.register(UpcomingPetSittingUITableViewCell.self, forCellReuseIdentifier: "UpcomingPetSittingUITableViewCell")
        tableView.register(OrderDetailHistoryTableViewCell.self, forCellReuseIdentifier: "OrderDetailHistoryTableViewCell")
        tableView.register(PetSittingRequestTableViewCell.self, forCellReuseIdentifier: "PetSittingRequestTableViewCell")
        return tableView
    }()
    private let createOrderButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Schedule", type: .plus, bordered: true)
        button.borderColor = .colorC6222F
        let addPetButtonAction = UIButton()
        addPetButtonAction.addTarget(self, action: #selector(createOrderButtonTouched), for: .touchUpInside)
        button.addSubview(addPetButtonAction)
        addPetButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
        return button
    }()
    
    private let calendarDaysView = CalendarDayView()
    
    private var noOrdersLabel: UILabel = {
        let l = UILabel()
        l.text = "No visits scheduled. \nTap \"Schedule\" button to book your visits."
        l.font = R.font.aileronBold(size: 18)
        l.textColor = .color070F24
        l.textAlignment = .center
        l.numberOfLines = 3
        return l
    } ()

    private let scheduleButton: UIButton = {
        let b = UIButton()
        b.cornerRadius = 15
        b.setTitle("Schedule", for: .normal)
        b.titleLabel?.font = R.font.aileronBold(size: 18)
        b.redAndGrayStyle(active: true)
        b.addTarget(self, action: #selector(createOrderButtonTouched), for: .touchUpInside)
        return b
    } ()

    // MARK: - Properties
    
    private var tableViewState: CustomerOrdersStates = .orders
    private var stateOrder: StartOrderStates = .orders
    private let date = Date()
    private var calendarArray = [Date]()
    private var currentMonthInRange = Date()
    private var orders = [Orders]()
    private var timesArr = [String]()
    private var datesArr = [String]()
    private var startingOrderDate = Int()
    private var endingOrderDate = Int()
    private var upcoming = [UpcomingOrders]()
    private var histories = [Histories]()
    private var upcomingDate = Date()
    private var totalItems = 0
    private var totalItemsUpcoming = 0
    private var totalItemsHistories = 0
    private var page = 1
    private var pageUpcoming = 1
    private var pageHistories = 1
    private var noofPages:Int?
    private var pages: Double?
    private var currentMonth = 0
    private var currentYear = 0
    var indexArrManagingState = [Int]()
    private var imageUrlUpcomingArr = [String]()
    
    private var petsUpcoming = [PetsId]()
    
    private var calendarDayDict = [Date: Bool]()
    var isHideSectionWhileReloadingTable = false
    let calendar = Calendar.current
    var getMeetNGreetStatus: Int = Int()
    var getMeetNGreetTime: Int = Int()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("order"), object: nil)
        calendarDaysView.delegate = self
//        calendarDaysView.setDefaultSelection()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        setupTopView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.hideActivityIndicator()
        isHideSectionWhileReloadingTable = true
        getMeetNGreetDetails()
        getOrders()
        tableView.reloadData()
    }
       
    // MARK: - Selectors
    
    @objc func methodOfReceivedNotification(notification: NSNotification){
        print("Called")
        orders = []
        page = 1
        noofPages = 1
        getOrders()
        tableView.reloadData()
        
    }
    
    @objc func createOrderButtonTouched() {
        getMeetNGreetDetails()
       
        if getMeetNGreetStatus == 0 {
            let vc = MeetNGreetVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        } else if getMeetNGreetStatus == 1 {
            let date = Date()
            let dateInInt = (date.timeIntervalSince1970)
            let currentDateTime = Int(dateInInt * 1000)
            if currentDateTime > getMeetNGreetTime {
                let vc = SelectServicesVC()
                vc.modalPresentationStyle = .overCurrentContext
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
            } else {
                let vc = MeetNGreetVC()
                vc.delegate = self
                vc.meetNGreetSuccessLabel.text = "Please wait untill your Meet & Greet get procceed"
                vc.hidesBottomBarWhenPushed = true
                vc.modalPresentationStyle = .overCurrentContext
                vc.meetandGreetSchedule = getMeetNGreetTime
                self.present(vc, animated: true, completion: nil)
            }

        } else if getMeetNGreetStatus == 2 || getMeetNGreetStatus == 3 {
            let vc = SelectServicesVC()
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - SetUp Layouts

extension CustomerOrdersVC {
    
    private func setupTopView() {
        view.backgroundColor = .white 
        view.addSubviews([topView])
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(146)
        }
        topView.addSubviews([descriptionLabel])
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(25)
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    private func setupTableView() {
        view.addSubviews([navigationView, tableView])
        navigationView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(35)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? 0)
        }
    }
    
    private func setupNoOrders() {
        noOrdersLabel.isHidden = false
        scheduleButton.isHidden = false
        view.addSubviews([noOrdersLabel, scheduleButton])
        
        noOrdersLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(26)
            $0.right.equalToSuperview().offset(-26)
        }
        scheduleButton.snp.makeConstraints {
            $0.top.equalTo(noOrdersLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }

    }
}

// MARK: - UITableViewDataSource

extension CustomerOrdersVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableViewState {

        case .orders, .upcoming:
            return 1
        case .history:
            tableView.backgroundView = nil
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableViewState {
        case .orders:
            if orders.count != 0 {
                tableView.backgroundView = nil
                createOrderButton.isHidden = false
            } else {
                tableView.backgroundView = nil
                setupNoOrders()
                createOrderButton.isHidden = true
            }
            return orders.count
        case .upcoming:
            noOrdersLabel.isHidden = true
            scheduleButton.isHidden = true
            if upcoming.count == 0 {
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "No Upcoming orders are available"
                noDataLabel.textColor     = UIColor.colorC6222F
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            } else {
                tableView.backgroundView = nil
            }
            return upcoming.count
        case .history:
            noOrdersLabel.isHidden = true
            scheduleButton.isHidden = true
            return histories.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewState {
        
        case .orders:
            print(indexPath.row)
            let identifier = "PetSittingRequestTableViewCell_\(indexPath.row)"
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PetSittingRequestTableViewCell
            cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
            cell.delegateTable = self
            let dates = getDate(indexPath: indexPath.row)
            let time = getTime(indexPath: indexPath.row)
            if isHideSectionWhileReloadingTable && indexArrManagingState.contains(indexPath.row) {
                cell.hideInfoButtonAction()
            }
            cell.indexPathofCell = indexPath
            cell.petsSetup(pets: orders[indexPath.row].pets, order: orders[indexPath.row], dates: dates,time: time)

            return cell
        case .upcoming:
            print(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingPetSittingUITableViewCell", for: indexPath) as! UpcomingPetSittingUITableViewCell
            cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
            cell.petsSetup(pets: upcoming[indexPath.row].pets, order: upcoming[indexPath.row])
            
            return cell
        case .history:
         
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailHistoryTableViewCell", for: indexPath) as! OrderDetailHistoryTableViewCell
            cell.bgView.addGrayShadowView(offset: CGSize(width: 0, height: 2), radius: 10)
            cell.rowIndex = indexPath.row
            print("Currnt History reason of \(indexPath.row)",histories[indexPath.row].reason)
            cell.historySetUp(pets: histories[indexPath.row].pets, history: histories[indexPath.row])
            cell.delegateRate = self
            cell.rateEmployeeButton.isUserInteractionEnabled = true
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch tableViewState {

        case .orders:
            if indexPath.row == orders.count - 1 {
                if totalItems > orders.count {
                    if totalItems == orders.count {
                        break
                    } else {
                        page+=1
                        getOrders()
                    }
                }
            }

        case .upcoming:
            if indexPath.row == upcoming.count - 1 {
                if totalItemsUpcoming > upcoming.count {
                    if totalItems == orders.count {
                        break
                    } else {
                        pageUpcoming+=1
                        getUpcoming(date: Int(upcomingDate.millisecondsSince1970))
                    }
                }
            }
        case .history:
            if indexPath.row == histories.count - 1 {
                if totalItemsHistories > histories.count {
                    if totalItemsHistories == histories.count {
                        break
                    } else {
                        pageHistories += 1
                        getHistories()
                    }
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableViewState {
        case .orders, .upcoming:
            if section == 0 {
                return createHeader()
            }
            return UIView()
        case .history:
            return createHeader()

        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableViewState {
        case .orders:
            return UITableView.automaticDimension
        case .upcoming:
            return 100
        case .history:
            return 0
        }
    }
    func createHeader() -> UIView {
        
        switch tableViewState {

        case .orders:
            let headerView = UIView()
            headerView.backgroundColor = .white
            headerView.addSubview(createOrderButton)
            createOrderButton.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.trailing.equalToSuperview().inset(25)
                $0.width.equalTo(127)
                $0.height.equalTo(30)
                $0.bottom.equalToSuperview().inset(35)
            }
            return headerView
        case .upcoming:
            let headerView = UIView()
            headerView.backgroundColor = .white
            headerView.addSubview(calendarDaysView)
            calendarDaysView.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.bottom.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(40)
            }
            return headerView
        case .history:

            return UIView()
        }

    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch tableViewState {
        
            case .orders, .upcoming:
                return 20
            case .history:
                return 30
        }
    }
}
//MARK: - UITableviewDelegate
extension CustomerOrdersVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableViewState {
        
        case .orders:
            let vc = OrderDetailsViewController()
            vc.delegate = self
            vc.id = orders[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        case .upcoming:
            let vc = OrderDetailUpcomingViewController()
            vc.upcomingDelegate = self
            vc.id = upcoming[indexPath.row].id
            vc.dateUpcoming = upcomingDate
            self.navigationController?.pushViewController(vc, animated: true)
        case .history:
            if histories[indexPath.row].status == "completed" {
                let vc = VisitSummaryHistoryViewController()
                vc.id = histories[indexPath.row].id
                vc.serviceName = histories[indexPath.row].service.title
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                break
            }
        }
        
    }
}

// MARK: - ProfileNavigationViewOrdersDelegate

extension CustomerOrdersVC: ProfileNavigationViewOrdersDelegate {
    func stateChanged(state: CustomerOrdersStates) {
        self.tableViewState = state
        switch tableViewState {
        case .orders:
            page = 1
            getOrders()
        case .upcoming:
            calendarDaysView.setDefaultSelection()
        case .history:
            pageHistories = 1
            getHistories()
        }
        isHideSectionWhileReloadingTable = true
        tableView.reloadData()
    }
}

//MARK: - PetSittingRequestDelegate

extension CustomerOrdersVC: PetSittingRequestDelegate {
    func onClickExpandCollapse(isMoreExpanded: Bool, indexPath: Int) {
        if isMoreExpanded == true {
            indexArrManagingState.append(indexPath)
            isHideSectionWhileReloadingTable = false
        } else {
            indexArrManagingState = indexArrManagingState.filter({
                $0 != indexPath
            })
        }
    }

    func reloadTable() {
        tableView.reloadData()
    }
}
//MARK: - HistoryRateDelegate

extension CustomerOrdersVC: HistoryRateDelegate {
    func toSummaryDetailsScreen(rowIndex: Int) {
        
        let vc = VisitSummaryHistoryViewController()
        vc.typeOfHistory = "customer"
        vc.id = histories[rowIndex].id
        vc.serviceName = histories[rowIndex].service.title
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func toRateScreen(rowIndex: Int) {
        let vc = SitterReviewVC()
        vc.modalPresentationStyle = .fullScreen
        vc.id = histories[rowIndex].id
        vc.historyDetails = histories[rowIndex]
        self.present(vc, animated: true, completion: nil)
    }
    

}

//MARK: - Reload MeetNGreet
extension CustomerOrdersVC: ReloadData{
    func reloadMeetNGreet() {
        self.getMeetNGreetDetails()
    }
    
    func reloadOrder() {
        orders = []
        page = 1
        noofPages = 1
        getOrders()
        tableView.reloadData()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CustomerOrdersVC : UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat((collectionView.frame.size.width / 4) - 5), height: CGFloat(100))
    }
}

//MARK: - Network

private extension CustomerOrdersVC {
    
    func getMeetNGreetDetails() {
        showView()
        CustomerService().getStatusOfMeetNGreet { [self] result in
            print(result)
            switch result {
            case .success(let result):
                getMeetNGreetStatus = result.status
                getMeetNGreetTime = result.time
                if getMeetNGreetStatus == 0 {
                    let vc = MeetNGreetVC()
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.delegate = self
                    vc.hidesBottomBarWhenPushed = true
                    self.present(vc, animated: true, completion: nil)
                }
                hideView()
            case .failure(let error):
                print(error)
                hideView()
            }
            
        }
    }
    
    func getOrders() {
        
        if page == 1 {
            orders = []
        }
        CustomerService().getOrders(limit: 10, page: page) { [self] result in
            
            switch result {
                
            case .success(let allPets):
                self.totalItems = allPets.meta.totalItems
                pages = Double(totalItems) / 10
                print(pages as Any)
                if pages! > 1.0 {
                    noofPages = Int(pages!) + 1
                }
                
                for i in allPets.items {
                    self.orders.append(i)
                }
                
                for i in 0..<allPets.meta.totalItems {
                    let identifier = "PetSittingRequestTableViewCell_\(i)"
                    tableView.register(PetSittingRequestTableViewCell.self, forCellReuseIdentifier: identifier)
                }
                self.setupTableView()
                self.tableView.reloadData()
                self.hideActivityIndicator()
            case .failure(let error):
                self.setupErrorAlert(error: error)
                self.hideActivityIndicator()
            }
        }
    }
    
    func getUpcoming(date: Int) {
        if pageUpcoming == 1 {
            upcoming = []
            petsUpcoming = []
        }
        print("Upcoming Date", date)
        CustomerService().getUpcomingOrder(date: date, limit: 10, page: pageUpcoming) { [self] result in
            print("Upcoming Api Response", result)
            switch result {
            case .success(let success):
                for i in success.items {
                    if success.items.count != 0 {
                        self.upcoming.append(i)
                        self.petsUpcoming.append(contentsOf: i.pets)
                    }
                }
                self.totalItemsUpcoming = success.meta.totalItems
                self.tableView.removeFromSuperview()
                self.setupTableView()
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
                self.hideActivityIndicator()
            }
        }
    }
    
    
    func getHistories() {
        self.showActivityIndicator()
        if pageHistories == 1 {
            histories = []
        }
        CustomerService().getHistories(limit: 10, page: pageHistories) { result in
            print("Histories of Pet are",result)
            switch result {
            case .success(let success):
                for i in success.items {
                    self.histories.append(i)
                }
                self.totalItemsHistories = success.meta.totalItems
                self.hideActivityIndicator()
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
                self.hideActivityIndicator()
            }
        }
    }
}

//MARK: - Date & time setup

private extension CustomerOrdersVC {

    func getDate(indexPath: Int) -> [String] {
        let fromDate = CommonFunction.shared.fromMillisToDate(millis: Double(orders[indexPath].orders[0].dateFrom))
        let toDate = CommonFunction.shared.fromMillisToDate(millis: Double(orders[indexPath].orders[0].dateTo))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let dateFirst = dateFormatter.string(from: fromDate)
        let dateSecond = dateFormatter.string(from: toDate)
        var datesArr = [String]()
        if dateFirst == dateSecond {
            datesArr.append(dateFirst)
        } else {
            datesArr.append(dateFirst)
            datesArr.append(dateSecond)
        }
        return datesArr
    }
    
    func getTime(indexPath: Int) -> [String] {
        let fromDate = CommonFunction.shared.fromMillisToDate(millis: Double(orders[indexPath].orders[0].dateFrom))
        let toDate = CommonFunction.shared.fromMillisToDate(millis: Double(orders[indexPath].orders[0].dateTo))
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeFirst = timeFormatter.string(from: fromDate)
        let timeSecond = timeFormatter.string(from: toDate)
        var timeArr = [String]()
        timeArr.append(timeFirst)
        timeArr.append(timeSecond)
        return timeArr
    }
}

//MARK: - OrderDetailDelegate

extension CustomerOrdersVC: OrderDetailDelegate {
    func reloadOrders() {
        orders = []
        page = 1
        noofPages = 1
        getOrders()
        tableView.reloadData()
    }
}

//MARK: - DayConfirmedDelegate

extension CustomerOrdersVC: DayConfirmedDelegate {
    func get(date: Date) {
      
        upcomingDate = date
        pageUpcoming = 1
        getUpcoming(date: Int(date.millisecondsSince1970))
    }
}

extension CustomerOrdersVC: ReloadHistory {
    func getHistory() {
        pageHistories = 1
        getHistories()
    }
}


