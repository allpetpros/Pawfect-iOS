//
//  MeetNGreetDetailViewController.swift
//  p103-customer
//
//  Created by Foram Mehta on 10/05/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit


class MeetNGreetDetailViewController: BaseViewController {
    
    private let backButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.backButtonImage(), for: .normal)
        b.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let appointmentsTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Meet & Greet Details"
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    } ()
    
    private let statusLabel: UILabel = {
        let l = UILabel()
        l.text = "Status: "
        l.font = R.font.aileronHeavy(size: 16)
        l.textColor = .black
        return l
    } ()
    
    private let statusResultLabel: UILabel = {
        let l = UILabel()
        l.textColor = R.color.waitingColor()
        l.font = R.font.aileronHeavy(size: 16)
        return l
    } ()
    
    private let backgroundView: UIView = {
        let v = UIView()
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 5
        v.layer.cornerRadius = 10
        v.backgroundColor = .white
        v.layer.zPosition = 9998
        return v
    } ()
    
    private let topSeparaterView: UIView = {
        let v = UIView()
//        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.layer.zPosition = 9999
        return stackView
    } ()
    
    private let customerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    } ()
    
    private let meetNGreetStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    } ()
    
    private let timeDateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    } ()
    
    private let footerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    } ()

    private let customerImageView: UIImageView = {
        let iv = UIImageView()
       
        return iv
    } ()
    private let customerNameLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = .color293147
        l.numberOfLines = 0
        return l
    } ()
    
    private let customerAddressLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color293147
        l.numberOfLines = 0
        return l
    } ()
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    private let meetNGreetViewView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    } ()
    private let dogWalkingImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    } ()
    
    private let dogWalkingLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        l.text = "Meet & Greet"
        return l
    } ()
    
    private let separatorSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color293147
        return l
    } ()
    
    private let timeLabel: UILabel = {
        let l = UILabel()
        l.text = "12:00 - 12:30 PM"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .color860000
        return l
    } ()
    
    
    
    private let separatorVerticalView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let phoneNumberLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color293147
//        l.text = "97797979797979"
        l.textAlignment = .center
        return l
    } ()
    
//    private let footerButtonStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.alignment = .fill
//        stackView.layer.zPosition = 9999
//        return stackView
//    } ()
    
    
    private let acceptOrderButton: UIButton = {
        let b = UIButton()
        b.setTitle("Accept Order", for: .normal)
        b.titleLabel?.font = R.font.aileronBold(size: 18)
        b.redAndGrayStyle(active: true)
        b.cornerRadius = 15
        b.addTarget(self, action: #selector(acceptOrderButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let cancelOrderButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.cancelOrderImage(), for: .normal)
        b.addTarget(self, action: #selector(cancelOrderButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let scrollView = UIScrollView()
    private let mainView = UIView()
    
    //MARK: - Properties
    
    var id = String()
    private var height = 150
    
    private var customerId = String()
    private var petId = String()
    var meetNGreetDetail: MeetNGreetItem?
    weak var delegate: EmployeeOrderDetailsDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupScrollViewLayouts()
        setupLayout()
        getOrderDetails()
        if meetNGreetDetail?.status == "confirmed" {
            cancelOrderButton.isHidden = true
            acceptOrderButton.setTitle("Complete Order", for: .normal)
            acceptOrderButton.titleLabel?.font = R.font.aileronBold(size: 18)
            acceptOrderButton.redAndGrayStyle(active: true)
            
        }
    }
    
}

//MARK: - Setup Layout

private extension MeetNGreetDetailViewController {
    func setupScrollViewLayouts() {
        view.addSubview(mainView)
        mainView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupLayout() {
        mainView.addSubviews([backButton, appointmentsTitleLabel, statusLabel, statusResultLabel,stackView])
        
        appointmentsTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(60)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(appointmentsTitleLabel)
            $0.width.equalTo(21)
            $0.height.equalTo(15)
            $0.left.equalTo(mainView.snp.left).offset(25)
            
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(48)
            $0.left.equalToSuperview().offset(25)
        }
        
        statusResultLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(48)
            $0.left.equalTo(statusLabel.snp.right).offset(5)
        }
      
        customerStackView.addArrangedSubviews(views: customerImageView,customerNameLabel,customerAddressLabel)
        customerImageView.snp.makeConstraints {
            $0.left.equalTo(5)
            $0.width.equalTo(40)
            $0.height.equalTo(30)
            
        }

        customerNameLabel.snp.makeConstraints {
            $0.left.equalTo(customerImageView.snp.right).offset(10)
            $0.width.equalTo(100)
        }
    
        meetNGreetStackView.addArrangedSubviews(views:dogWalkingImageView,dogWalkingLabel)
    
        dogWalkingImageView.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(40)
        }
        timeDateStackView.addArrangedSubviews(views: dateLabel,timeLabel)
        dateLabel.snp.makeConstraints {
            $0.left.equalTo(5)
            $0.width.equalTo(50)
        }
        footerStackView.addArrangedSubviews(views: timeDateStackView,separatorVerticalView,phoneNumberLabel)
        timeDateStackView.snp.makeConstraints {
            $0.width.equalTo(160)
            $0.height.equalTo(60)
        }
        separatorVerticalView.snp.makeConstraints {
            $0.width.equalTo(2)
            $0.left.equalTo(timeDateStackView.snp.right)
            $0.bottom.equalTo(timeDateStackView.snp.bottom)
        }
        stackView.addArrangedSubviews(views: topSeparaterView,customerStackView,separatorView,meetNGreetStackView,separatorSecondView,footerStackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        topSeparaterView.snp.makeConstraints {
            $0.width.equalTo(10)
        }
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(customerStackView.snp.bottom)
            $0.right.equalTo(stackView.snp.right)
            $0.left.equalTo(stackView.snp.left)
        }
        
        separatorSecondView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(meetNGreetStackView.snp.bottom)
            $0.right.equalTo(stackView.snp.right)
            $0.left.equalTo(stackView.snp.left)
        }
        
        mainView.addSubviews([backgroundView])
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.top).offset(-5)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(stackView.snp.bottom)
        }
        
        mainView.addSubviews([acceptOrderButton,cancelOrderButton])
        cancelOrderButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(60)
        }
        acceptOrderButton.snp.makeConstraints {
            $0.top.equalTo(cancelOrderButton.snp.top).offset(-50)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(42)
            $0.width.equalTo(275)
        }
    }

}

//MARK: - Actions

extension MeetNGreetDetailViewController {
    
    @objc func backButtonAction() {
        
        self.navigationController?.popViewController(animated: true)
    }

}

//MARK: - Network

private extension MeetNGreetDetailViewController {
    func getOrderDetails() {

        self.statusResultLabel.text = meetNGreetDetail?.status
        self.setupStatusColor(status: meetNGreetDetail?.status ?? "pending")
        self.phoneNumberLabel.text = meetNGreetDetail?.customer.phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        self.dateLabel.text = self.toDateFrom(millis: Int64(meetNGreetDetail?.timeFrom ?? 0))
        self.timeLabel.text = self.toTimeFrom(millis: Int64(meetNGreetDetail?.timeFrom ?? 0))
        self.customerNameLabel.text = meetNGreetDetail?.customer.name
        self.customerAddressLabel.text = meetNGreetDetail?.customer.address
        if let customerImg = meetNGreetDetail?.customer.imageURL {
            self.customerImageView.sd_setImage(with: URL(string: customerImg))
        }
    }
    
    func acceptNewMeetNGreetOrder() {
        showActivityIndicator()
        EmployeeService().acceptNewMeetNGreetOrder(id: meetNGreetDetail?.id ?? "") { result in
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true, completion: {
                    self.hideActivityIndicator()
                    self.delegate?.reloadOrders()
                })
            case .failure(let error):
                self.hideActivityIndicator()
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func cancelMeetNGreetOrder() {
        showActivityIndicator()
        
        EmployeeService().cancelMeetNGreetOrder(id: meetNGreetDetail?.id ?? "") { result in
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true, completion: {
                    self.hideActivityIndicator()
                    self.delegate?.reloadOrders()
                })
            case .failure(let error):
                self.hideActivityIndicator()
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    
    func completeMeetNGreetOrder() {
        showActivityIndicator()
        
        EmployeeService().completeMeetNGreetOrder(id: meetNGreetDetail?.id ?? "") { result in
            switch result {
            case .success(_):
                self.navigationController?.popViewController(animated: true, completion: {
                    self.hideActivityIndicator()
                    self.delegate?.reloadOrders()
                })
            case .failure(let error):
                self.hideActivityIndicator()
                self.setupErrorAlert(error: error)
            }
        }
    }
    
}

//MARK: - Actions

extension MeetNGreetDetailViewController {
    @objc func acceptOrderButtonAction() {
        if acceptOrderButton.currentTitle == "Accept Order" {
            acceptNewMeetNGreetOrder()
        } else {
            completeMeetNGreetOrder()
        }
    }
    
    @objc func cancelOrderButtonAction() {
        cancelMeetNGreetOrder()
    }
}

//MARK: - Setup data

private extension MeetNGreetDetailViewController {
      
    func setupStatusColor(status: String) {
        switch status {
        case "pending":
            statusResultLabel.textColor = R.color.pendingColor()
        case "partially confirmed":
            statusResultLabel.textColor = R.color.partiallyConfirmedColor()
        case "confirmed":
            statusResultLabel.textColor = R.color.statusConfirmedColor()
        case "canceled":
            statusResultLabel.textColor = R.color.canceledColor()
        case "completed":
            statusLabel.textColor = R.color.statusConfirmedColor()
        default:
            statusResultLabel.textColor = R.color.pendingColor()
        }
    }

    func toTimeFrom(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: date)
    }
    
    func toDateFrom(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }
}


