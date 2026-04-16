//
//  AccountEmployeeTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 26.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class AccountEmployeeTableViewCell: UITableViewCell {

    //MARK: - UIProperties
    
    private let hoursWorkedLabel: UILabel = {
        let l = UILabel()
        l.text = "Hours worked"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorAAABAE
        return l
    } ()
    
    private let hoursImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.clock()
        iv.tintColor = .colorC6222F
        return iv
    } ()
    
    private let hoursDescriptionLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color070F24
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let emailLabel: UILabel = {
        let l = UILabel()
        l.text = "Email"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorAAABAE
        return l
    } ()
    
    private let emailImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.email()
        iv.tintColor = .colorC6222F
        return iv
    } ()
    
    private let emailDescriptionLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color070F24
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let phoneNumberLabel: UILabel = {
        let l = UILabel()
        l.text = "Phone Number"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorAAABAE
        return l
    } ()
    
    private let phoneNumberImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.phone()
        iv.tintColor = .colorC6222F
        return iv
    } ()
    
    private let phoneNumberDescriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "09281327271"
        l.textColor = .color070F24
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let emergencyContactLabel: UILabel = {
        let l = UILabel()
        l.text = "Emergency Contact"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorAAABAE
        return l
    } ()
    
    private let emergencyContactImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.emergencyContactIcon()
        iv.tintColor = .colorC6222F
        return iv
    } ()
    
    private let emergencyContactDescriptionLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color070F24
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let emergencyContactNameLabel: UILabel = {
        let l = UILabel()
        l.text = "Emergency Contact Name"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorAAABAE
        return l
    } ()
    
    private let emergencyContactNameImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.phone()
        iv.tintColor = .colorC6222F
        return iv
    } ()
    
    private let emergencyContactNameDescriptionLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color070F24
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = R.color.borderColor()
        return v
    } ()
    
    private let addressLabel: UILabel = {
        let l = UILabel()
        l.text = "Street Address"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorAAABAE
        return l
    } ()
    
    private let addressImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.locationIcon()
        return iv
    } ()

    private let addressDescriptionLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color070F24
        l.numberOfLines = 0
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    //MARK: - Lifecycle

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
        setupLayout()
    }
}

//MARK: - Converting date

private extension AccountEmployeeTableViewCell {
    func fromMillisToHours(millis: Int) -> Double {
        let seconds = Double(millis) / 1000.0
        let minutes = Double(seconds) / 60
        return minutes / 60
    }
}

//MARK: - Public methods

extension AccountEmployeeTableViewCell {
    func setupCell(email: String, phoneNumber: String, emergencyPhone: String, emergencyName: String, street: String, hoursWork: [Int]) {
        emailDescriptionLabel.text = email
        phoneNumberDescriptionLabel.text = phoneNumber
        emergencyContactDescriptionLabel.text = emergencyName
        emergencyContactNameDescriptionLabel.text = emergencyPhone
        addressDescriptionLabel.text = street
        
        let timeFrom = self.toDate(millis: Int64(hoursWork[0]))
        let timeTo = self.toDate(millis: Int64(hoursWork[1]))
        hoursDescriptionLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"

    }
}

//MARK: - Converting to time

private extension AccountEmployeeTableViewCell {
    
    
    func toDate(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func toTime(time: Int) -> String {
        let doubleVar = fromMillisToHours(millis: time)
        let new = doubleVar.truncatingRemainder(dividingBy: 1.0)
        let rounded = Double(round(1000*new)/1000)
        if rounded == 0.5 {
            return ":30"
        } else {
            return ":00"
        }
    }
}

//MARK: - Setup Layout

private extension AccountEmployeeTableViewCell {

    func setupLayout() {
        addSubviews([hoursWorkedLabel, hoursImageView, hoursDescriptionLabel, emailLabel, emailImageView, emailDescriptionLabel, phoneNumberLabel, phoneNumberImageView, phoneNumberDescriptionLabel])
        
        hoursWorkedLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
        }
        
        hoursImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(hoursWorkedLabel.snp.bottom).offset(6)
        }
        
        hoursDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(hoursWorkedLabel.snp.bottom).offset(6)
            $0.left.equalTo(hoursImageView.snp.right).offset(10)
        }
        
        emailLabel.snp.makeConstraints {
            $0.top.equalTo(hoursImageView.snp.bottom).offset(29)
            $0.left.equalToSuperview().offset(25)
        }
        
        emailImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.top.equalTo(emailLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(25)
        }
        
        emailDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emailLabel.snp.bottom).offset(6)
            $0.left.equalTo(emailImageView.snp.right).offset(10)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(emailImageView.snp.bottom).offset(29)
            $0.left.equalToSuperview().offset(25)
        }
        
        phoneNumberImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.top.equalTo(phoneNumberLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(25)
        }
        
        phoneNumberDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(phoneNumberLabel.snp.bottom).offset(6)
            $0.left.equalTo(phoneNumberImageView.snp.right).offset(10)
        }
        
        setupSecondPartLayout()
    }
    
    func setupSecondPartLayout() {
        addSubviews([emergencyContactLabel, emergencyContactImageView, emergencyContactDescriptionLabel, emergencyContactNameLabel, emergencyContactNameImageView, emergencyContactNameDescriptionLabel, separatorView, addressLabel, addressImageView, addressDescriptionLabel])
        
        emergencyContactLabel.snp.makeConstraints {
            $0.top.equalTo(phoneNumberImageView.snp.bottom).offset(29)
            $0.left.equalToSuperview().offset(25)
        }
        
        emergencyContactImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.top.equalTo(emergencyContactLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(25)
        }
        
        emergencyContactDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emergencyContactLabel.snp.bottom).offset(6)
            $0.left.equalTo(emergencyContactImageView.snp.right).offset(10)
        }
        
        emergencyContactNameLabel.snp.makeConstraints {
            $0.top.equalTo(emergencyContactImageView.snp.bottom).offset(29)
            $0.left.equalToSuperview().offset(25)
        }
        
        emergencyContactNameImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.top.equalTo(emergencyContactNameLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(25)
        }
        
        emergencyContactNameDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(emergencyContactNameLabel.snp.bottom).offset(6)
            $0.left.equalTo(emergencyContactNameImageView.snp.right).offset(10)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(27)
            $0.right.equalToSuperview()
            $0.top.equalTo(emergencyContactNameImageView.snp.bottom).offset(29)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(25)
        }
        
        addressImageView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(16)
            $0.top.equalTo(addressLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview().offset(25)
        }
        
        addressDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(6)
            $0.left.equalTo(addressImageView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-30)
        }
    }
}
