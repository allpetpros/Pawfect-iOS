//
//  ConfirmedAppointmentDetailsViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 28.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class ConfirmedAppointmentDetailsViewController: BaseViewController {

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
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = .color293147
        return l
    } ()

    private let statusResultLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 16)
        return l
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

    private let customerImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    } ()
    
    private let customerNameLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    private let petOwnerLabel: UILabel = {
        let l = UILabel()
        l.text = "pet owner"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .color606572
        return l
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
//        l.text = "1 Feb"
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color293147
        return l
    } ()
    
    private let timeLabel: UILabel = {
        let l = UILabel()
//        l.text = "12:00 - 12:30"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .color860000
        return l
    } ()
    
    private let commentForSitterLabel: UILabel = {
        let l = UILabel()
//        l.text = "Comment for sitter"
        l.textColor = .colorAAABAE
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let commentFromCustomerLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color070F24
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let separatorThirdView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let totalLabel: UILabel = {
        let l = UILabel()
        l.text = "Total"
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    } ()
    
    private let forOneSittingCommentLabel: UILabel = {
        let l = UILabel()
        l.text = "*for one sitting"
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color606572
        return l
    } ()
    
    private let fullPriceLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 30)
        l.textColor = R.color.approvedColor()
        return l
    } ()
    
    private let separatorFourthView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
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
    
    //MARK: - Properties
    
    var id = String()
    var date = Int()
    var customerImageUrl: String?
    var customerName = String()
    
    private var height = 130
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupLayout()
        getConfirmedDetails()
        
        customerNameLabel.text = customerName
      
        if let img = customerImageUrl {
            customerImageView.sd_setImage(with: URL(string: img))
        }
    }
    
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Setup Layout

private extension ConfirmedAppointmentDetailsViewController {

    func setupLayout() {
        view.addSubviews([backButton, appointmentsTitleLabel, statusLabel, statusResultLabel, customerImageView, customerNameLabel, petOwnerLabel, animalView])
        
        appointmentsTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(70)
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
        
        customerImageView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(statusLabel.snp.bottom).offset(30)
        }
        
        customerNameLabel.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(28)
            $0.left.equalTo(customerImageView.snp.right).offset(13)
        }
        
        petOwnerLabel.snp.makeConstraints {
            $0.top.equalTo(customerNameLabel.snp.bottom)
            $0.left.equalTo(customerImageView.snp.right).offset(13)
        }
        
        animalView.snp.makeConstraints {
            $0.top.equalTo(petOwnerLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        setupOrderCard()
    }
    
    func setupOrderCard() {
        view.addSubviews([stackView, separatorView, dogWalkingLabel, dogWalkingImageView, separatorSecondView, dateLabel, timeLabel])
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(animalView).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalTo(animalView)
            $0.right.equalTo(animalView)
            $0.top.equalTo(stackView.snp.bottom).offset(14)
        }
                
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
            $0.left.equalTo(dateLabel.snp.right).offset(13)
            $0.bottom.equalTo(animalView).offset(-20)
        }
        setupFooter()
    }
    
    func setupFooter() {
        view.addSubviews([commentForSitterLabel, commentFromCustomerLabel, separatorThirdView, totalLabel, forOneSittingCommentLabel, fullPriceLabel, separatorFourthView])
        
        commentForSitterLabel.snp.makeConstraints {
            $0.top.equalTo(animalView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
        }
        
        commentFromCustomerLabel.snp.makeConstraints {
            $0.top.equalTo(commentForSitterLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(25)
        }
        
        separatorThirdView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(commentFromCustomerLabel.snp.bottom).offset(28)
        }
        
        totalLabel.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(25)
        }
        
        forOneSittingCommentLabel.snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(25)
        }
        
        fullPriceLabel.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-25)
        }
        
        separatorFourthView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(forOneSittingCommentLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview()
        }
    }
}

//MARK: - Setup

private extension ConfirmedAppointmentDetailsViewController {
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

    private func toDate(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func toDay(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: Double(millis))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        return dateFormatter.string(from: date)
    }
    
    func petsSetup(pets: [PetsEmployee]) {
        var i = 0
        
        while i != pets.count {
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.spacing = 40
            stack.translatesAutoresizingMaskIntoConstraints = false
            
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
            
            let img2 = UIImageView()
            img2.layer.cornerRadius = 10
            img2.clipsToBounds = true
            
            if let image = pets[i].imageUrl {
                img.sd_setImage(with: URL(string: image))
            } else {
                img.image = R.image.alertBox()
            }
            
            i+=1
            
            if i != pets.count {
                label2.text = pets[i].name
                if let image = pets[i].imageUrl {
                    img2.sd_setImage(with: URL(string: image))
                } else {
                    img2.image = R.image.alertBox()
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
            
            height += 30
            animalView.snp.remakeConstraints {
                $0.top.equalTo(petOwnerLabel.snp.bottom).offset(20)
                $0.height.equalTo(height)
                $0.left.equalToSuperview().offset(10)
                $0.right.equalToSuperview().offset(-10)
            }
        }
    }
    
    
    func fromMillisToDate(millis: Double) -> Date {
        
        return Date(timeIntervalSince1970: TimeInterval(millis) / 1000)
    }
    
    func fromDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }
}

//MARK: - Network

private extension ConfirmedAppointmentDetailsViewController {
    func getConfirmedDetails() {
        showActivityIndicator()
        EmployeeService().getConfirmedDetails(id: id) { [self] result in
            
            switch result {
            case .success(let s):
                self.statusResultLabel.text = s.status
                self.setupStatusColor(status: s.status)
                self.dogWalkingLabel.text = s.service.title
                if let img = s.service.imageUrl {
                    self.dogWalkingImageView.sd_setImage(with: URL(string: img))
                }
                self.fullPriceLabel.text = "$\(s.totalAmount)"
                if let comment = s.comment {
                    self.commentFromCustomerLabel.text = comment
                }
                let timeFrom = String(self.toDate(millis: Int64(s.dateFrom)))
                let timeTo = String(self.toDate(millis: Int64(s.dateTo)))
                self.timeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
                
                
                self.dateLabel.text = self.fromDateToString(date: fromMillisToDate(millis: Double(date)))
                self.petsSetup(pets: s.pets)
                
                self.hideActivityIndicator()
            case .failure(let error):
                self.setupErrorAlert(error: error)
                self.hideActivityIndicator()
            }
        }
    }
    
}
