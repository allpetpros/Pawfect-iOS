//
//  PetSittingNewRequestsTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 27.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class PetSittingNewRequestsTableViewCell: UITableViewCell {
    
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
    
    private let calendarLabel: UILabel = {
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
    
    private let dayLabel: UILabel = {
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

//MARK: - Setup Layout

private extension PetSittingNewRequestsTableViewCell {
    func setupLayout() {
        addSubviews([stackView, separatorView, statusLabel, calendarImageView, calendarLabel, separatorSecondView])
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
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
        
        calendarLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(10)
            $0.left.equalTo(calendarImageView.snp.right).offset(10)
        }
        
        separatorSecondView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(calendarLabel.snp.bottom).offset(10)
        }
        
        setupFooterOfCell()
    }
    
    func setupFooterOfCell() {
        addSubviews([timeLabel, separatorBetweenTimeAndRateView, dayLabel])
        
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
        
        dayLabel.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel)
            $0.left.equalTo(separatorBetweenTimeAndRateView.snp.right).offset(13)
        }
    }
}

//MARK: - Setup

private extension PetSittingNewRequestsTableViewCell {
    func setupStatusColor(status: String) {
        switch status {
        case "pending":
            statusLabel.textColor = R.color.pendingColor()
        case "partially confirmed":
            statusLabel.textColor = R.color.partiallyConfirmedColor()
        case "confirmed":
            statusLabel.textColor = R.color.statusConfirmedColor()
        case "canceled":
            statusLabel.textColor = R.color.canceledColor()
        case "completed":
            statusLabel.textColor = R.color.statusConfirmedColor()
        default:
            statusLabel.textColor = R.color.pendingColor()
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

//MARK: - Public method

extension PetSittingNewRequestsTableViewCell {
    func orderSetup(order: EmployeeOrderItems) {
        
        statusLabel.text = order.status
        setupStatusColor(status: order.status)
        
        timeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: toTimeFrom(millis: Int64(order.timeFrom)))) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: toTimeFrom(millis: Int64(order.timeTo))))"
        if let img = order.service.imageUrl {
            calendarImageView.sd_setImage(with: URL(string: img))
        }
        
        calendarLabel.text = order.service.title
        dayLabel.text = "\(toDateFrom(millis: Int64(order.timeTo)))"
                
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0);$0.removeFromSuperview() }
        
        var i = 0
        
        while i != order.pets.count {

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
            label.minimumScaleFactor = 0.5
            label.numberOfLines = 0
            label.text = order.pets[i].name

            if order.pets[i].name.count > 6 {
                label.font = R.font.aileronBold(size: 15)
            }

            let label2 = UILabel()
            label2.textColor = .color070F24
            label2.minimumScaleFactor = 0.5
            label2.numberOfLines = 0
            label2.font = R.font.aileronBold(size: 18)

            let img = UIImageView()
            img.layer.cornerRadius = 10
            img.clipsToBounds = true

            let img2 = UIImageView()
            img2.layer.cornerRadius = 10
            img2.clipsToBounds = true

            if let image = order.pets[i].imageUrl {
                img.sd_setImage(with: URL(string: image), placeholderImage: R.image.alertBox())
            } else {
                img.image = R.image.alertBox()
            }

            i+=1

            if i != order.pets.count {
                label2.text = order.pets[i].name
                if order.pets[i].name.count > 6 {
                    label2.font = R.font.aileronBold(size: 15)
                }
                if let image = order.pets[i].imageUrl {
                    img2.sd_setImage(with: URL(string: image), placeholderImage: R.image.alertBox())
                } else {
                    img2.image = R.image.alertBox()
                }
                i+=1
            }

            firstSV.addArrangedSubviews(views: img, label)

            img.snp.makeConstraints {
                $0.size.equalTo(30)
            }

            img2.snp.makeConstraints {
                $0.size.equalTo(30)
            }
            
            if label2.text != nil {
                secondSV.addArrangedSubviews(views: img2, label2)
                stack.addArrangedSubviews(views: firstSV, secondSV)
            } else {
                stack.addArrangedSubview(firstSV)
            }

            stackView.addArrangedSubview(stack)
        }
    }
}
