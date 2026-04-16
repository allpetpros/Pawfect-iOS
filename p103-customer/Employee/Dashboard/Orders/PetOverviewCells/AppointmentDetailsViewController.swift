//
//  AppointmentDetailsViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 27.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

@objc protocol EmployeeOrderDetailsDelegate: class {
    func reloadOrders()
}

class AppointmentDetailsViewController: BaseViewController {
    
    //MARK: - UIProperties
    
    private let backButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.backButtonImage(), for: .normal)
        b.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let appointmentsTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Appointment Details"
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
    
    private let viewProfileButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.viewCustomerProfileImage(), for: .normal)
        b.addTarget(self, action: #selector(viewProfileAction), for: .touchUpInside)
        return b
    } ()
    
    private let animalView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 5
        v.layer.cornerRadius = 10
        return v
    } ()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
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
        l.text = "12:00 - 12:30"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .color860000
        return l
    } ()
    
    private let customerImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    } ()
    
    private let customerNameLabel: UILabel = {
        let l = UILabel()
        l.textColor = .black
        l.font = R.font.aileronHeavy(size: 16)
        return l
    } ()
    
    private let separatorVerticalView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let petOwnerLabel: UILabel = {
        let l = UILabel()
        l.text = "pet owner"
        l.font = R.font.aileronLight(size: 12)
        l.textColor = .color606572
        return l
    } ()
    
    private let streetAddressLabel: UILabel = {
        let l = UILabel()
        l.text = "Street Address"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorAAABAE
        return l
    } ()
    
    private let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.locationIcon()
        return iv
    } ()
    
    private let addressInfoLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color070F24
        l.numberOfLines = 0
        return l
    } ()
    
    private let acceptOrderButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.acceptOrderImage(), for: .normal)
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
    
    weak var delegate: EmployeeOrderDetailsDelegate?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupScrollViewLayouts()
        setupLayout()
        getOrderDetails()
    }
    
}

//MARK: - Setup Layout

private extension AppointmentDetailsViewController {
    func setupScrollViewLayouts() {
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
    
    func setupLayout() {
        mainView.addSubviews([backButton, appointmentsTitleLabel, statusLabel, statusResultLabel, viewProfileButton, animalView])
        
        appointmentsTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(60)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(appointmentsTitleLabel)
            $0.width.equalTo(21)
            $0.height.equalTo(15)
            $0.left.equalToSuperview().offset(25)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(48)
            $0.left.equalToSuperview().offset(25)
        }
        
        statusResultLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(48)
            $0.left.equalTo(statusLabel.snp.right).offset(5)
        }
        
        viewProfileButton.snp.makeConstraints {
            $0.top.equalTo(appointmentsTitleLabel.snp.bottom).offset(34)
            $0.right.equalToSuperview().offset(-25)
        }
        
        animalView.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(30)
            $0.height.equalTo(150)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        setupOrderCard()
    }
    
    func setupOrderCard() {
        mainView.addSubviews([stackView, separatorView, dogWalkingImageView, dogWalkingLabel, separatorSecondView, dateLabel, timeLabel, separatorVerticalView, petOwnerLabel, customerImageView, customerNameLabel])
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(animalView).offset(25)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-20)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalTo(animalView)
            $0.right.equalTo(animalView)
            $0.top.equalTo(stackView.snp.bottom).offset(14)
        }
        
        dogWalkingImageView.tintColor = .black
        
        dogWalkingImageView.snp.makeConstraints {
            $0.width.equalTo(19)
            $0.height.equalTo(14)
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(25)
        }
        
        dogWalkingLabel.snp.makeConstraints {
            $0.left.equalTo(dogWalkingImageView.snp.right).offset(5)
            $0.top.equalTo(separatorView.snp.bottom).offset(15)
        }
        
        separatorSecondView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalTo(animalView)
            $0.right.equalTo(animalView)
            $0.top.equalTo(dogWalkingImageView.snp.bottom).offset(14)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(25)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(17)
            $0.left.equalTo(dateLabel.snp.right).offset(10)
        }
        
        separatorVerticalView.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom)
            $0.width.equalTo(1)
            $0.height.equalTo(49)
            $0.left.equalTo(timeLabel.snp.right).offset(15)
        }
        
        customerImageView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(10)
            $0.left.equalTo(separatorVerticalView.snp.right).offset(15)
        }
        
        customerNameLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(8)
            $0.left.equalTo(customerImageView.snp.right).offset(13)
        }
        
        petOwnerLabel.snp.makeConstraints {
            $0.top.equalTo(customerNameLabel.snp.bottom)
            $0.left.equalTo(customerImageView.snp.right).offset(13)
        }
        setupFooter()
    }
    
    func setupFooter() {
        mainView.addSubviews([streetAddressLabel, locationImageView, addressInfoLabel, acceptOrderButton, cancelOrderButton])
        
        streetAddressLabel.snp.makeConstraints {
            $0.top.equalTo(animalView.snp.bottom).offset(33)
            $0.left.equalToSuperview().offset(25)
        }
        
        locationImageView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(16)
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(streetAddressLabel.snp.bottom).offset(8)
        }
        
        addressInfoLabel.snp.makeConstraints {
            $0.top.equalTo(streetAddressLabel.snp.bottom).offset(8)
            $0.left.equalTo(locationImageView.snp.right).offset(14)
            $0.right.equalToSuperview().inset(20)
            
        }
        
        acceptOrderButton.snp.makeConstraints {
            $0.height.equalTo(80)
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-50)
            $0.top.equalTo(addressInfoLabel.snp.bottom).offset(50)
        }
        
        cancelOrderButton.snp.makeConstraints {
            $0.top.equalTo(acceptOrderButton.snp.bottom)
            $0.height.equalTo(80)
            $0.left.equalToSuperview().offset(50)
            $0.right.equalToSuperview().offset(-50)
            $0.bottom.equalToSuperview()
        }
    }
}

//MARK: - Actions

extension AppointmentDetailsViewController {
    @objc func viewProfileAction() {
        let vc = ShowCustomerProfileViewController()
        vc.id = customerId
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func petAction() {
        let vc = PetProfileViewController()
        vc.isEmployee = true
        vc.employeeId = petId
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - Network

private extension AppointmentDetailsViewController {
    func getOrderDetails() {
        showActivityIndicator()
        EmployeeService().getNewOrderDetail(id: id) { [self] result in
            
            switch result {
            case .success(let success):
                self.customerId = success.customer.id
                self.setup(pets: success.pets)
                self.petId = success.pets[0].id
                self.statusResultLabel.text = success.status
                self.setupStatusColor(status: success.status)
                self.dogWalkingLabel.text = success.service.title
                if let img = success.service.imageUrl {
                    self.dogWalkingImageView.sd_setImage(with: URL(string: img))
                }
                self.dateLabel.text = self.toDateFrom(millis: Int64(success.timeTo))
                self.timeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: self.toTimeFrom(millis: Int64(success.timeFrom)))) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: self.toTimeFrom(millis: Int64(success.timeTo))))"
                self.customerNameLabel.text = "\(success.customer.name) \(success.customer.surname)"
                if let customerImg = success.customer.imageUrl {
                    self.customerImageView.sd_setImage(with: URL(string: customerImg))
                }
                self.addressInfoLabel.text = success.customer.homeAddress
                self.hideActivityIndicator()
            case .failure(let error):
                self.hideActivityIndicator()
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func acceptOrder() {
        showActivityIndicator()

        EmployeeService().acceptNewOrder(id: id) { result in
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
    
    func cancelOrder() {
        showActivityIndicator()
        
        EmployeeService().cancelOrder(id: id) { result in
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

extension AppointmentDetailsViewController {
    @objc func acceptOrderButtonAction() {
        acceptOrder()
    }
    
    @objc func cancelOrderButtonAction() {
        cancelOrder()
    }
}

//MARK: - Setup data

private extension AppointmentDetailsViewController {
    
    func setup(pets: [PetsId]) {
        var i = 0
        
        while i != pets.count {
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.spacing = 20
            
            let firstSV = UIStackView()
            firstSV.axis = .horizontal
            firstSV.distribution = .fillProportionally
            firstSV.alignment = .fill
            firstSV.spacing = 10
            
            let secondSV = UIStackView()
            secondSV.axis = .horizontal
            secondSV.distribution = .fillProportionally
            secondSV.alignment = .fill
            secondSV.spacing = 10
            
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronBold(size: 18)
            label.text = pets[i].name
            
            let label2 = UILabel()
            label2.textColor = .color070F24
            label2.font = R.font.aileronBold(size: 18)
            
            let img = UIImageView()
            img.layer.cornerRadius = 10
            img.clipsToBounds = true
            img.image = R.image.alertBox()
            
            let img2 = UIImageView()
            img2.layer.cornerRadius = 10
            img2.clipsToBounds = true
            img2.image = R.image.alertBox()
            
            let button = UIButton()
            button.addTarget(self, action: #selector(petAction), for: .touchUpInside)
            
            view.addSubview(button)
            
            if pets[i].name.count > 6 {
                label.font = R.font.aileronBold(size: 15)
            }
            
            if let image = pets[i].imageUrl {
                img.sd_setImage(with: URL(string: image))
            }
            
            i+=1
            
            if i != pets.count {
                label2.text = pets[i].name
                if pets[i].name.count > 6 {
                    label2.font = R.font.aileronBold(size: 15)
                }
                if let image = pets[i].imageUrl {
                    img2.sd_setImage(with: URL(string: image))
                }
                i+=1
            }
            
            firstSV.addArrangedSubviews(views: img, label)
            
            secondSV.addArrangedSubviews(views: img2, label2)
            
            img.snp.makeConstraints {
                $0.size.equalTo(30)
            }

            img2.snp.makeConstraints {
                $0.size.equalTo(30)
            }
            
            stack.addArrangedSubviews(views: firstSV, secondSV)

            stackView.addArrangedSubview(stack)
            
            button.snp.makeConstraints {
                $0.edges.equalTo(firstSV)
            }
            
            height += 30
            animalView.snp.remakeConstraints {
                $0.top.equalTo(statusLabel.snp.bottom).offset(30)
                $0.height.equalTo(height)
                $0.left.equalToSuperview().offset(10)
                $0.right.equalToSuperview().offset(-10)
            }
        }
    }
    
}
//MARK: - Custom Functions

extension AppointmentDetailsViewController {
    
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
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func toDateFrom(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
    }
}
