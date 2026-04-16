//
//  CreateOrderTotalVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 29.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

@objc protocol CalendarViewDelegate: AnyObject {
    func tapOnCalendarCell()
}

class CreateOrderTotalVC: BaseViewController {
    
    // MARK: - UI Property
    private let scrollView = UIScrollView()
    private let mainView = UIView()
    
    private let closebutton: UIButton = {
        let button = UIButton()
//        button.setImage(R.image.backButtonImage(), for: .normal)
        button.setImage(R.image.closeTest(), for: .normal)

        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.clipsToBounds = true
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    }()
    private let registerLabel: UILabel = {
        let label = UILabel()
//        label.text = "Create Order"
        label.text = "Schedule Service"
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        return label
    }()
    private let leftArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .color070F24
        imageView.image = R.image.leftArrow()
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Step 4. Confirm Order"
        label.font = R.font.aileronBold(size: 18)
        return label
    }()
    
    private let commentTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Comment for sitter")
        textField.addTarget(self, action: #selector(commentAction), for: .editingChanged)
        return textField
    }()
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.909, green: 0.913, blue: 0.921, alpha: 1)
        view.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        return view
    }()
    private let secondSeparatorView: UIView = {
        let view = UIView()
//
        view.snp.makeConstraints {
            $0.height.equalTo(2)
        }
        return view
    }()
    private let totalView = CreateOrderTotalView()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color606572
        
        label.text = "Total for visits"
        return label
    }()
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color606572
        return label
    }()
    private let holidayFeeLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    private let holidaylLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let holidayPriceLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let bookButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Confirm Booking Request", type: .ok, bordered: true)
        button.redAndGrayStyleMain(active: false)
        let doneButtonAction = UIButton()
        doneButtonAction.addTarget(self, action: #selector(sendButtonTouched), for: .touchUpInside)
        button.addSubview(doneButtonAction)
        doneButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    private let cancelOrderButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Cancel Booking", type: .cross, bordered: true)
        
        button.redAndGrayStyleMain(active: true)
        let doneButtonAction = UIButton()
        doneButtonAction.addTarget(self, action: #selector(cancelButtonTouched), for: .touchUpInside)
        button.addSubview(doneButtonAction)
        doneButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    private let plantCareLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let plantPriceLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let totalLbl: UILabel = {
        let l = UILabel()
        
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    private let totalPriceLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color606572
        l.font = R.font.aileronSemiBold(size: 16)
        return l
    } ()
    
    private let checkboxButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.checkboxBlack(), for: .normal)
        b.addTarget(self, action: #selector(checkboxButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let privacyLabel: UILabel = {
        let l = UILabel()
        l.text = "confirming the service I agree to the cancellation policy"
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
//    private let privacyButton: UIButton = {
//        let b = UIButton()
//        b.setTitle("cancellation policy", for: .normal)
//        b.setTitleColor(UIColor.blue, for: .normal)
//        b.titleLabel?.font = R.font.aileronRegular(size: 12)
//        return b
//    }()
    
    private lazy var animalCardView: AnimalOrderView = {
        let v = AnimalOrderView()
        v.calendarViewDelegate = self
        v.backgroundColor = UIColor.white
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 5
        v.layer.cornerRadius = 15
        return v
    } ()
    
    //MARK: - Properties
    
    private var isPrivacy: Bool = false
    private var visits = [Visit]()
    private var commentForOrders: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let noOfDays = OrderManager.shared.dates.count
        let noofVisit = OrderManager.shared.partOfDays.count * noOfDays
        totalLabel.text = "Total for \(noofVisit) visits in \(noOfDays) days"
        let guestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:)))
        privacyLabel.addGestureRecognizer(guestureRecognizer)
        setupLayouts()
        getHolidays()
    }
    
    // MARK: - Selectors
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendButtonTouched() {
        createOrder()
        bookButton.redAndGrayStyleMain(active: false)
    }
    
    @objc func cancelButtonTouched() {
        let vc = CustomerDashboardTabBarController()
        vc.selectedIndex = 1
        vc.modalPresentationStyle = .currentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func labelClicked(_ sender: Any) {
        print("UILabel clicked")
        showSimpleAlert()
    }
    
    func showSimpleAlert() {
        let alert = UIAlertController(title: "", message: "You have Clicked Privacy Policy ",preferredStyle:UIAlertController.Style.alert)


        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
            //Sign out action
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: - Network

private extension CreateOrderTotalVC {
    
    func getHolidays() {
        plantPriceLabel.text = ""
        OrderManager.shared.totalExtraPrice = 0
        if !OrderManager.shared.extraIds.isEmpty {
            for i in OrderManager.shared.extraPrice {
                OrderManager.shared.totalExtraPrice = OrderManager.shared.totalExtraPrice + i
            }
        }
        
        if !OrderManager.shared.extraIds.isEmpty {
            
            let formattedArray = (OrderManager.shared.extraTitleArr.map{String($0)}).joined(separator: ",")
            plantCareLabel.text = "Extras Services include: " + "[\(formattedArray)]"
            
            plantPriceLabel.text = "$\(OrderManager.shared.totalExtraPrice * OrderManager.shared.dates.count)"
        } else {
            self.plantCareLabel.isHidden = true
            self.plantPriceLabel.isHidden = true
        }
        
        CustomerService().getHoliday(dateFrom: String(OrderManager.shared.dates[0]), dateTo: String(OrderManager.shared.dates[OrderManager.shared.dates.count - 1])) { result in
            switch result {
            case .success(let s):
                if s.pets.isEmpty {
                    self.totalAmountLabel.text = ""
                    self.totalView.setAmount(newAmount: OrderManager.shared.price)
                    if OrderManager.shared.extraIds.isEmpty {
                        self.plantCareLabel.isHidden = true
                        self.plantPriceLabel.isHidden = true
                        self.totalAmountLabel.text = "$\(String(OrderManager.shared.dates.count * OrderManager.shared.partOfDays.count * OrderManager.shared.price))"
                        self.totalLbl.text = "Total Payable Amount"
                        self.totalPriceLabel.text = "$\(String(OrderManager.shared.dates.count * OrderManager.shared.partOfDays.count * OrderManager.shared.price))"
                    } else {
                        self.totalPriceLabel.isHidden = false
                        self.plantPriceLabel.isHidden = false
                        self.totalAmountLabel.text = "$\(String(OrderManager.shared.dates.count * OrderManager.shared.partOfDays.count * OrderManager.shared.price))"
                        self.totalLbl.text = "Total Payable Amount"
                        self.totalPriceLabel.text = "$\(String(OrderManager.shared.dates.count * OrderManager.shared.partOfDays.count * OrderManager.shared.price + OrderManager.shared.totalExtraPrice * OrderManager.shared.dates.count))"
                    }
                }
            case .failure(let error):
                self.setupErrorAlert(error: error)
                
            }
        }
    }
    
    func createOrder() {
        
        var firstTest = [String: Any]()
        var secondTest = [String: Any]()
        var thirdTest = [String: Any]()
        
        var visiting = [[String: Any]]()
                
        if !OrderManager.shared.morningHours.isEmpty {
            firstTest = ["type": "morning", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.morningHours)] as [String : Any]
            visiting.append(firstTest)
        } else if OrderManager.shared.partOfDays.contains("morning") {
            OrderManager.shared.morningHours = "7:00"
            firstTest = ["type": "morning", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.morningHours)] as [String : Any]
            visiting.append(firstTest)
        }
        
        if !OrderManager.shared.afternoonHours.isEmpty {
            secondTest = ["type": "afternoon", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.afternoonHours)] as [String : Any]
            visiting.append(secondTest)
        } else if OrderManager.shared.partOfDays.contains("afternoon") {
            OrderManager.shared.afternoonHours = "12:00pm"
            secondTest = ["type": "afternoon", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.afternoonHours)] as [String : Any]
            visiting.append(secondTest)
        }
        
        if !OrderManager.shared.eveningHours.isEmpty {
            thirdTest = ["type": "evening", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.eveningHours)] as [String : Any]
            visiting.append(thirdTest)
        } else if OrderManager.shared.partOfDays.contains("evening") {
            OrderManager.shared.eveningHours = "05:00pm"
            thirdTest = ["type": "evening", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.eveningHours)] as [String : Any]
            visiting.append(thirdTest)
        }
        
        let parameters: [String: Any] = [
            "petIds": Array(OrderManager.shared.petIds),
            "visits": visiting,
            "serviceId": OrderManager.shared.serviceId,
            "dates": OrderManager.shared.dates,
            "comment": commentForOrders,
            "extraIds": Array(OrderManager.shared.extraIds),
            "amount": OrderManager.shared.partOfDays.count * OrderManager.shared.price
        ]
        print("Parameters are:",parameters)
        
        let baseURL = "\(Constant.baseURL)/customer/orders/"

        if let token = DBManager.shared.getAccessToken() {
            let Auth_header: HTTPHeaders = ["Authorization": "Bearer \(token)"]

            AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { (response) in
                print("Create Order Response:",response)
                switch response.result {
                case .success(let success):
                    let json = JSON(success)
                    if json["message"] == "Customer balance less then need for order!" {
                        self.setupWarning(alert: json["message"].string!, isOrders: true)
                    } else {
                        let vc = FinalPetRequestViewController()
                            vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                case .failure(let error):
                    self.setupErrorAlert(error: error)
                    self.bookButton.redAndGrayStyleMain(active: true)
                }
            }
        }
    }
}

//MARK: - Actions

extension CreateOrderTotalVC {
    @objc func checkboxButtonAction() {
        isPrivacy = !isPrivacy
        if isPrivacy {
            checkboxButton.setImage(R.image.checbox_selected(), for: .normal)
            bookButton.redAndGrayStyleMain(active: true)
        } else {
            checkboxButton.setImage(R.image.checkboxBlack(), for: .normal)
            bookButton.redAndGrayStyleMain(active: false)
        }
    }
    
    @objc func commentAction() {
        if let comm = commentTextField.text {
            commentForOrders = comm
        }
    }
}

//MARK: - CalendarViewDelegate

extension CreateOrderTotalVC: CalendarViewDelegate {
    func tapOnCalendarCell() {
        let vc = CalendarViewCreateOrderViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - Setup Layout

extension CreateOrderTotalVC {
    private func setupLayouts() {
        view.backgroundColor = .white
        setupScrollViewLayouts()
        setupTopPartLayouts()
        setupTableView()
        setupFields()
        setupBottomPart()
    }
    
    private func setupScrollViewLayouts() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.left.right.equalTo(self.scrollView.contentLayoutGuide)
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
    }
    
    private func setupTopPartLayouts() {
        mainView.addSubviews([closebutton, registerLabel, leftArrowImageView, descriptionLabel])
//        closebutton.snp.makeConstraints {
//            $0.width.equalTo(21)
//            $0.height.equalTo(15)
//            $0.leading.equalToSuperview().inset(25)
//            $0.top.equalToSuperview().inset(38)
//        }
//        registerLabel.snp.makeConstraints {
//            $0.leading.equalTo(closebutton.snp.trailing).offset(20)
//            $0.top.equalToSuperview().inset(26)
//        }
//
//        descriptionLabel.snp.makeConstraints {
//            $0.top.equalTo(registerLabel.snp.bottom).offset(34)
//            $0.leading.equalToSuperview().offset(25)
//        }
        registerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().offset(10)
            $0.top.equalToSuperview().inset(26)
        }
        
        closebutton.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(15)
//            $0.trailing.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().inset(38)
            $0.right.equalToSuperview().offset(-25)
        }
        
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(registerLabel.snp.bottom).offset(34)
            $0.leading.equalTo(registerLabel).offset(10)
        }
    }
    private func setupTableView() {
        mainView.addSubviews([animalCardView, commentTextField])
        animalCardView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(38)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-15)
        }
        
        commentTextField.snp.makeConstraints {
            $0.top.equalTo(animalCardView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
    }
    private func setupFields() {
        mainView.addSubviews([commentTextField])
        commentTextField.snp.makeConstraints {
            $0.top.equalTo(animalCardView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
    }
    private func setupBottomPart() {
        mainView.addSubviews([separatorView, totalView, secondSeparatorView, totalLabel, totalAmountLabel, holidaylLabel, holidayPriceLabel, plantCareLabel, plantPriceLabel, totalLbl,totalPriceLabel,checkboxButton, privacyLabel, bookButton,cancelOrderButton])
        separatorView.snp.makeConstraints {
            $0.top.equalTo(commentTextField.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        totalView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(77)
        }
        secondSeparatorView.snp.makeConstraints {
            $0.top.equalTo(totalView.snp.bottom).offset(10)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(25)
        }
        totalLabel.snp.makeConstraints {
            $0.top.equalTo(secondSeparatorView.snp.bottom).offset(10)
            $0.leading.equalTo(secondSeparatorView)
        }
        totalAmountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(25)
            $0.centerY.equalTo(totalLabel)
        }
        
        holidaylLabel.snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(25)
        }
        
        holidayPriceLabel.snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(8)
            $0.right.equalToSuperview().offset(-25)
        }
        
        plantCareLabel.snp.makeConstraints {
            $0.top.equalTo(holidaylLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalTo(plantPriceLabel).offset(-60)
        }
        
        plantPriceLabel.snp.makeConstraints {
            $0.top.equalTo(holidayPriceLabel.snp.bottom).offset(8)
            $0.right.equalToSuperview().offset(-25)
        }
        
        totalLbl.snp.makeConstraints {
            $0.top.equalTo(plantCareLabel.snp.bottom).offset(16)
            $0.left.equalTo(checkboxButton.snp.left)
//            $0.right.equalTo(plantPriceLabel).offset(-40)
//            $0.bottom.equalTo(privacyLabel.snp.top).offset(-20)
        }
        
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(plantCareLabel.snp.bottom).offset(15)
//            $0.left.equalTo(totalLbl).offset(20)
            $0.right.equalToSuperview().offset(-25)
//            $0.bottom.equalTo(privacyLabel.snp.top).offset(-20)
        }
        
        checkboxButton.snp.makeConstraints {
            $0.top.equalTo(totalLbl.snp.bottom).offset(23)
            $0.left.equalToSuperview().offset(25)
        }
        
        privacyLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkboxButton)
            $0.left.equalTo(checkboxButton.snp.right).offset(10)
        }
        
//        privacyButton.snp.makeConstraints {
//            $0.centerY.equalTo(privacyLabel)
//            $0.left.equalTo(privacyLabel.snp.right).offset(2)
//        }
        
        bookButton.snp.makeConstraints {
            $0.top.equalTo(privacyLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(50)
//            $0.bottom.equalToSuperview().inset(20)
        }
        
        cancelOrderButton.snp.makeConstraints {
            $0.top.equalTo(bookButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

//MARK: - Date setup

private extension CreateOrderTotalVC {
//    func fromMillisToDate(millis: Double) -> Date {
//        return Date(timeIntervalSince1970: (millis) / 1000)
//    }
}
