//
//  EmployeeProfileVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 04.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import Cosmos

enum EmployeeProfileStates {
    case timeOff
    case payout
    case account
    case review
}
enum TimeOffSections: CaseIterable {
    case request
    case weekends

    var headerText: String {
        switch self {

        case .request:
            return "none"
        case .weekends:
            return "I’m taking"
        }
    }
}
enum PayoutSections: CaseIterable {
    case amount
    case history
    
    var headerText: String {
        switch self {
            
        case .history:
            return "Appointments History"
        case .amount:
            return "Amount Earned"
        }
    }
}

@objc protocol EmployeeTimeOffDelegate: AnyObject {
    func reloadTimeOffs()
}

class EmployeeProfileVC: UIViewController {
    
    // MARK: - UIProperties
    //TopView
    
    
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.employee_test(), for: .normal)
        button.imageView?.layer.cornerRadius = 7
        return button
    }()
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 18)
        label.textColor = .color293147
        label.numberOfLines = 2
        return label
    }()
    
    private let nameBtnPressed: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(nameButtonPressed), for: .touchUpInside)
        return b
    } ()
    
    private lazy var navigationView: NavigationView = {
        let view = NavigationView()
        view.setup(state: .employeeProfile)
        view.employeeProfileDelegate = self
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        
        tableView.register(UINib(nibName: TimeOffCell.className, bundle: nil), forCellReuseIdentifier: TimeOffCell.className)
        tableView.register(UINib(nibName: TransactionCell.className, bundle: nil), forCellReuseIdentifier: TransactionCell.className)
        tableView.register(AccountEmployeeTableViewCell.self)
        tableView.register(ReviewEmployeeTableViewCell.self)
        return tableView
    }()
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .color293147
        label.font = R.font.aileronBold(size: 18)
        label.text = "Amount Earned"
        return label
    }()
    private let amountValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.525, green: 0, blue: 0, alpha: 1)
        label.font = R.font.aileronBold(size: 18)
        label.text = "$4232"
        return label
    }()
    private let percentageDescriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "Your percentage of the order 20%"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .color606572
        return l
    }()
    private let headerDescriptionLabel: UILabel = {
         let label = UILabel()
         label.font = R.font.aileronSemiBold(size: 16)
         label.textColor = .color606572
         return label
     }()
    private let timeOffLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 18)
        label.textColor = .color293147
        label.text = "Time off Request"
        return label
    }()
    private let addTimeOffButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.borderColor = .colorC6222F
        button.borderWidth = 1
        button.setTitle("Add time off", for: .normal)
        button.setTitleColor(.colorC6222F, for: .normal)
        button.titleLabel?.font = R.font.aileronRegular(size: 14)
        button.addTarget(self, action: #selector(addTimeOffButtonTouched), for: .touchUpInside)
        return button
    }()
    private lazy var alertView: CustomAlertView = {
        let view = CustomAlertView()
        view.delegate = self
        return view
    }()
    
    private let ratingTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "My Rating"
        l.font = R.font.aileronBold(size: 18)
        l.textColor = .color293147
        return l
    }()
    
    private let cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.starSize = 25
        view.settings.starMargin = 5
        view.isUserInteractionEnabled = false
        view.settings.fillMode = .precise
        return view
    }()
    
    private let averageRateLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    }()
    
    private let reviewsTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Reviews"
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = .color293147
        return l
    }()
    
    private let logOutButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.logOutCustomerAccount(), for: .normal)
        b.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
        return b
    } ()
    
    // MARK: - Properties
    
    private let enableColor:UIColor = .colorC6222F
    private let dissableColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
    private var tableViewState: EmployeeProfileStates = .timeOff
    
    private var items = [TimeOffsItems]()
    private var isWaiting = false
    
    private var dates = [Int]()
    private var email = String()
    private var phoneNumber = String()
    private var emergName = String()
    private var emergPhone = String()
    private var street = String()
    private var hoursWorked = [Int]()
    private var totalCredits: Double?
    private var ratings = [RatingItems]()
    private var assessments = [Int]()
    private var appointHistoryArr = [OrderHistoryItem]()
    var totalAmountEarned = Double()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Access Token", DBManager.shared.getAccessToken() as Any)
        setupLayouts()

        self.tabBarController?.tabBar.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getTimeOffs()
        getProfile()
        getRating()
        getTotalCredits()
        getAppointmentHistory()
        tableView.reloadData()
        tableView.setNeedsLayout()
        tableView.layoutSubviews()
        
    }
    
    // MARK: - Selectors
    
    @objc func addTimeOffButtonTouched() {
        if isWaiting {
            let alertVC = AlertViewController()
            alertVC.setupAlertMessage(message: "Unfortunately, you cannot book more than one time-off request")
            alertVC.modalPresentationStyle = .overCurrentContext
            self.present(alertVC, animated: true, completion: nil)
        } else {
            let vc = TimeOffVC(state: .add)
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}

// MARK: - Setup Layout

extension EmployeeProfileVC {
    private func setupLayouts() {
        view.backgroundColor = .white
        setupTopView()
        setupTableView()
    }
    private func setupTopView() {
        view.addSubviews([topView])

        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(146)
        }
       
        topView.addSubviews([profileButton, profileNameLabel, nameBtnPressed,navigationView,logOutButton])
        
        profileButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().inset(25)
        }
        profileNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileButton)
            $0.leading.equalTo(profileButton.snp.trailing).offset(15)
        }
        
        nameBtnPressed.snp.makeConstraints {
            $0.centerY.equalTo(profileButton)
            $0.leading.equalTo(profileButton.snp.leading)
            $0.trailing.equalTo(profileNameLabel.snp.trailing)
        }
        
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(profileButton.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(35)
        }
        logOutButton.snp.makeConstraints {
            $0.width.equalTo(67)
            $0.height.equalTo(30)
            $0.center.equalTo(profileNameLabel)
            $0.right.equalToSuperview().offset(-25)
        }
        topView.setNeedsLayout()
        topView.layoutSubviews()
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? -20)
        }
    }
}

// MARK: - UITableViewDataSource

extension EmployeeProfileVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableViewState {
        case .timeOff:
            return TimeOffSections.allCases.count
        case .payout:
            return PayoutSections.allCases.count
        case .account:
            return 1
        case .review:
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableViewState {
            
        case .timeOff:
            switch TimeOffSections.allCases[section] {
            case .request:
                return 0
            case .weekends:
                if items.count > 0 {
                    tableView.backgroundView  = nil
                    return items.count
                    
                } else {
                    return 0
                }
                }
            
        case .payout:
            switch PayoutSections.allCases[section] {
            case .history:
                if appointHistoryArr.count != 0 {
                    tableView.backgroundView  = nil
                    return appointHistoryArr.count
                }
                else {
                    return 0
                }
//
            case .amount:
                return 0
            }
        case .account:
            return 1
        case .review:
            
            if ratings.count != 0 {
                tableView.backgroundView  = nil
                return ratings.count
            }
            else {
               
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewState {
        
        case .timeOff:
            let cell = tableView.dequeueReusableCell(withIdentifier: TimeOffCell.className, for: indexPath) as! TimeOffCell
            cell.setupCell(type: items[indexPath.row].timeOffType, typeCalendar: items[indexPath.row].dateChoiceType, note: items[indexPath.row].notes, status: items[indexPath.row].status, dates: items[indexPath.row].dates, id: items[indexPath.row].id)
            cell.delegate = self
            return cell
            
        case .payout:
            let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.className, for: indexPath) as! TransactionCell
            cell.transactionNameLabel.text = appointHistoryArr[indexPath.row].title
            cell.transactionCostLabel.text = "+$" + String(appointHistoryArr[indexPath.row].amount)
            cell.transactionDateLabel.text = self.fromDateToString(date: CommonFunction.shared.fromMillisToDate(millis: Double(appointHistoryArr[indexPath.row].date)))
            return cell
        case .account:
            guard let cell = tableView.dequeue(AccountEmployeeTableViewCell.self, for: indexPath) else { return AccountEmployeeTableViewCell() }
            cell.setupCell(email: email, phoneNumber: phoneNumber, emergencyPhone: emergName, emergencyName: emergPhone, street: street, hoursWork: hoursWorked)
            return cell
        case .review:
            guard let cell = tableView.dequeue(ReviewEmployeeTableViewCell.self, for: indexPath) else { return ReviewEmployeeTableViewCell() }
            cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
            cell.setupReview(ratings: ratings[indexPath.row])
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDelegate

extension EmployeeProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableViewState {
            
        case .timeOff:
            switch TimeOffSections.allCases[section] {
                
            case .request:
                let headerView = UIView()
                headerView.addSubviews([timeOffLabel, addTimeOffButton])
                timeOffLabel.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(6)
                    $0.leading.equalToSuperview().inset(25)
                    $0.bottom.equalToSuperview().inset(40)
                }
                addTimeOffButton.snp.makeConstraints {
                    $0.trailing.equalToSuperview().inset(25)
                    $0.height.equalTo(30)
                    $0.width.equalTo(146)
                    $0.centerY.equalTo(timeOffLabel)
                }
                return headerView
            case .weekends:
                let headerView = OrderDetailsDateHeader()
                return headerView
            }
            
        case .payout:
            switch PayoutSections.allCases[section] {
                
            case .history:
                let headerView = OrderDetailsDateHeader()
                headerView.setup(date: PayoutSections.allCases[section].headerText)
                return headerView
            case .amount:
                let headerView = UIView()
                headerView.addSubviews([amountLabel, amountValueLabel, percentageDescriptionLabel])
                amountLabel.snp.makeConstraints {
                    $0.top.equalToSuperview()
                    $0.leading.equalToSuperview().inset(25)
                }
                amountValueLabel.snp.makeConstraints {
                    $0.trailing.equalToSuperview().inset(25)
                    $0.centerY.equalTo(amountLabel)
                }
                percentageDescriptionLabel.snp.makeConstraints {
                    $0.left.equalToSuperview().offset(25)
                    $0.top.equalTo(amountLabel.snp.bottom).offset(10)
                    $0.bottom.equalToSuperview().inset(40)
                }
                return headerView
            }
        case .account:
            let headerView = UIView()
            headerView.addSubviews([headerDescriptionLabel])
            headerDescriptionLabel.snp.makeConstraints {
                $0.top.equalToSuperview().inset(5)
                $0.leading.equalToSuperview().inset(25)
                $0.bottom.equalToSuperview().inset(30)
            }
            headerDescriptionLabel.text = "My Account"
            headerDescriptionLabel.font = R.font.aileronBold(size: 18)
            headerDescriptionLabel.textColor = .color293147
            return headerView
        case .review:
            let headerView = UIView()
            headerView.addSubviews([ratingTitleLabel, cosmosView, averageRateLabel, reviewsTitleLabel])
            ratingTitleLabel.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.left.equalToSuperview().offset(25)
            }
            cosmosView.snp.makeConstraints {
                $0.top.equalTo(ratingTitleLabel.snp.bottom).offset(20)
                $0.left.equalToSuperview().offset(27)
            }
            averageRateLabel.snp.makeConstraints {
                $0.top.equalTo(ratingTitleLabel.snp.bottom).offset(15)
                $0.left.equalTo(cosmosView.snp.right).offset(18)
            }
            reviewsTitleLabel.snp.makeConstraints {
                $0.top.equalTo(cosmosView.snp.bottom).offset(35)
                $0.left.equalToSuperview().offset(26)
                $0.bottom.equalToSuperview().inset(30)
            }
            return headerView
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableViewState == .payout, PayoutSections.allCases[section] == .history {
            return 30
        }
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.beginUpdates()
//        tableView.endUpdates()
    }
}

//MARK: - ProfileNavigationViewEmployeeProfileDelegate

extension EmployeeProfileVC: ProfileNavigationViewEmployeeProfileDelegate {
    func stateChanged(state: EmployeeProfileStates) {
        self.tableViewState = state
        
        tableView.reloadData()
    }
}

//MARK: - TimeOffCellDelegate

extension EmployeeProfileVC: TimeOffCellDelegate {
    func editButtonTapped(id: String, notes: String,dates: [Int]) {
        let vc = TimeOffVC(state: .edit)
        vc.id = id
        vc.delegate = self
        vc.getDates = dates
        vc.notesGet = notes
        print("notes",notes)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func startReloadSizes() {
        tableView.beginUpdates()
    }
    
    func finishReloadSizes() {
        tableView.endUpdates()
    }
}

//MARK: - CustomAlertViewDelegate

extension EmployeeProfileVC: CustomAlertViewDelegate {
    func okButtonTouched(alertType: AlertType) {
        self.removeCustomBlur()
        self.alertView.removeFromSuperview()
    }
    
   
}

//MARK: - Log Out

extension EmployeeProfileVC {
    
    @objc func nameButtonPressed() {
        stateChanged(state: .account)
        
        navigationView.thirdButton.setTitleColor(enableColor, for: .normal)
        navigationView.thirdPoint.backgroundColor = enableColor
        navigationView.thirdPoint.isHidden = false
        
        navigationView.firstButton.setTitleColor(dissableColor, for: .normal)
        navigationView.firstPoint.isHidden = true
        
        navigationView.secondButton.setTitleColor(dissableColor, for: .normal)
        navigationView.secondPoint.isHidden = true
    
        navigationView.fourthButton.setTitleColor(dissableColor, for: .normal)
        navigationView.fourthPoint.isHidden = true
    }
    
    @objc func logOutAction() {
        DBManager.shared.removeAccessToken()
        DBManager.shared.saveStatus(0)
        let vc = UINavigationController(rootViewController: AuthorizationVC())
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

private extension EmployeeProfileVC {
    func setAverageRate() {
        var amount = Int()
        for i in assessments {
            amount += i
        }
        let average = Double(amount) / Double(assessments.count)
        let y = Double(round(10*average)/10)
        cosmosView.rating = average
        if assessments.count > 0 {
            averageRateLabel.isHidden = false
            averageRateLabel.text = String(y)
        } else {
            averageRateLabel.isHidden = true
        }
       
    }
}

//MARK: - Network

private extension EmployeeProfileVC {
    func fromDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    func getRating() {
        EmployeeService().getRating { result in
            print("Employee Ratings",result)
            switch result {
            case .success(let success):
                for i in success.items {
                    self.ratings.append(i)
                    self.assessments.append(Int(i.rate ?? 0))
                }
                self.setAverageRate()
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func getTimeOffs() {
        dates = []
        items = []
        EmployeeService().getTimeOff { result in
            print("Employee TimeOff",result)
            switch result {
            case .success(let success):
                
                self.items.append(contentsOf: success.items)
                for i in success.items {
                    
                    if i.status == "waiting" {
                        self.isWaiting = true
                    }
                    self.dates.append(contentsOf: i.dates)
                }
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func getProfile() {
        EmployeeService().getCurrentEmployee { result in
            print("Employee Current Data",result)
            switch result {
                
            case .success(let employee):
                if employee.name.count > 10 {
                    self.profileNameLabel.text = "\(employee.name) \n\(employee.surname)"
                } else {
                    self.profileNameLabel.text = "\(employee.name) \(employee.surname)"
                }
                self.email = employee.email
                self.phoneNumber = employee.phoneNumber
                self.emergName = employee.emergencies[0].name
                self.emergPhone = employee.emergencies[0].phoneNumber
                self.street = employee.address
                self.hoursWorked.append(employee.workTimeFrom)
                self.hoursWorked.append(employee.workTimeTo)
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func getTotalCredits() {
        EmployeeService().getTotalCredit { [self] result in
            print("Total Credits",result)
            switch result {
            case .success(let totalCredit):
                totalAmountEarned = totalCredit.amountEarned
                self.amountValueLabel.text = "$\(totalCredit.amountEarned)"
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
            self.tableView.reloadData()
        }
    }
    
    func getAppointmentHistory() {
        EmployeeService().getAppointmentHistory { result in
            switch result {
            case .success(let result):
                
                self.appointHistoryArr = result.items
                var average = Double()
                for i in result.items {
                    average += i.amount
                }
                if result.items.count > 0 {
                    self.percentageDescriptionLabel.isHidden = false
                    let averageAmountEarned = average / Double(result.items.count)
                    let roundingAmountValue = String(format: "%.2f", averageAmountEarned)
                    self.percentageDescriptionLabel.text = "Your percentage of the order \(roundingAmountValue)%"
                } else {
                    self.percentageDescriptionLabel.isHidden = true
                }
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
            self.tableView.reloadData()
        }
        
    }
    
    func setupErrorAlert(error: Error) {
        if let error = error as? ErrorResponse {
            self.alertView.setupAlert(description: error.localizedDescription, alertType: .error)
        } else {
            self.alertView.setupAlert(description: error.localizedDescription, alertType: .error)
        }
        self.showCustomBlur()
        self.view.addSubview(self.alertView)
        self.alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

//MARK: - EmployeeTimeOffDelegate

extension EmployeeProfileVC: EmployeeTimeOffDelegate {
    func reloadTimeOffs() {
        getTimeOffs()
    }
}

