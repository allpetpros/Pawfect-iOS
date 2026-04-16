//
//  MeetNGreetCell.swift
//  p103-customer
//
//  Created by Foram Mehta on 04/05/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit


class MeetNGreetCell: UITableViewCell {
    
    //MARK: - UIProperties
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    private let customerDetailView: UIView = {
        let v = UIView()
        return v
    } ()
    
    private let customerImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .orange
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
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = .color293147
        l.numberOfLines = 0
        return l
    } ()
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let statusLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = R.color.statusOrderColor()
        return l
    } ()
    
    private let calendarImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    } ()
    
    private let meetNGreetLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        l.text = "Meet And Greet"
        return l
    } ()

    private let separatorSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let dateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let timeLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronBold(size: 12)
        return l
    } ()
    
    private let separatorBetweenTimeAndRateView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let phoneNumberLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color293147
        
        return l
    } ()
    
    //MARK: - Properties
    
    private var imageArr: [UIImageView] = []
        
    //MARK: - Lifecycle

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor

        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10

        selectionStyle = .none
        setupLayout()
    }

    override func layoutSubviews() {
         super.layoutSubviews()
        
         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}

private extension MeetNGreetCell {
    func setupLayout() {
        addSubviews([stackView, customerDetailView,customerImageView,customerNameLabel,customerAddressLabel,separatorView, calendarImageView, meetNGreetLabel, separatorSecondView])
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.height.equalTo(70)
            
        }
        customerDetailView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.top)
            $0.left.equalTo(stackView.snp.left)
            $0.right.equalTo(stackView.snp.right)
            $0.bottom.equalTo(stackView.snp.bottom)
        }
        customerImageView.snp.makeConstraints {
            $0.centerY.equalTo(customerDetailView)
            
            $0.width.equalTo(50)
            $0.height.equalTo(40)
            $0.left.equalTo(customerDetailView.snp.left).offset(5)

        }
        
        customerNameLabel.snp.makeConstraints {
            $0.left.equalTo(customerImageView.snp.right).offset(5)
            $0.top.equalTo(customerDetailView.snp.top)
            $0.bottom.equalTo(customerDetailView.snp.bottom)
            $0.width.equalTo(100)
        }
        customerAddressLabel.snp.makeConstraints {
            $0.left.equalTo(customerNameLabel.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(customerDetailView.snp.top)
            $0.bottom.equalTo(customerDetailView.snp.bottom)
            $0.width.equalTo(100)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(stackView.snp.bottom).offset(10)
        }
                
        calendarImageView.snp.makeConstraints {
            $0.width.equalTo(19)
            $0.height.equalTo(19)
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(separatorView.snp.bottom).offset(9)
        }
        
        meetNGreetLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(10)
            $0.left.equalTo(calendarImageView.snp.right).offset(10)
        }
        
        separatorSecondView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(meetNGreetLabel.snp.bottom).offset(10)
        }
        
        setupFooterOfCell()
    }
    
    func setupFooterOfCell() {
        addSubviews([dateLabel,timeLabel,separatorBetweenTimeAndRateView, phoneNumberLabel])
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(35)
            
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(35)
        }
        
        separatorBetweenTimeAndRateView.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom)
            $0.width.equalTo(1)
            $0.height.equalTo(45)
            $0.left.equalTo(timeLabel.snp.right).offset(24)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        phoneNumberLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel)
            $0.left.equalTo(separatorBetweenTimeAndRateView.snp.right).offset(13)
        }
    }
}

//MARK: - Setup

private extension MeetNGreetCell {

    
    func toTimeFrom(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: date)
    }
    
    func toDateFrom(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd   HH:mm a"
        return dateFormatter.string(from: date)
    }
}

//MARK: - Public method

extension MeetNGreetCell {
    func orderSetup(timeFrom: Int, customerDetails: CustomerDetail?) {
        timeLabel.text = "\(toDateFrom(millis: Int64(timeFrom)))"
        let phone = customerDetails?.phoneNumber
        phoneNumberLabel.text = phone?.applyPatternOnNumbers(pattern: "(###) ###-####",replacementCharacter: "#")
        customerNameLabel.text = customerDetails?.name
        customerAddressLabel.text = customerDetails?.address
        customerImageView.sd_setImage(with: URL(string: customerDetails?.imageURL ?? ""), placeholderImage: R.image.alertBox())
    }
}
