//
//  MapCurrentOrderTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 20.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class MapCurrentOrderTableViewCell: UITableViewCell {
    
    //MARK: - UIProperties
    
    private let statusOrderLabel: UILabel = {
        let l = UILabel()
        l.textColor = R.color.statusConfirmedColor()
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let dailyCheckinLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let calendarImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    } ()
    
    private let dateLabel: UILabel = {
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
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let horizontalSeparatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let dateDescriptionLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
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
        contentView.layer.cornerRadius = 20
        
        selectionStyle = .none
        
        setupLayout()
    }
    
    //MARK: - Setup Layout
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5))
    }
    
    private func setupLayout() {
        addSubviews([statusOrderLabel, separatorView, calendarImageView, dailyCheckinLabel, dateLabel, separatorSecondView, timeLabel, horizontalSeparatorView, dateDescriptionLabel, stackView])
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        statusOrderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.right.equalToSuperview().offset(-25)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(stackView.snp.bottom).offset(14)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(16)
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.left.equalToSuperview().offset(25)
        }
        
        dailyCheckinLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.left.equalTo(calendarImageView.snp.right).offset(5)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.right.equalToSuperview().offset(-25)
        }
        
        separatorSecondView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(15)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(18)
            $0.left.equalToSuperview().offset(35)
        }
        
        horizontalSeparatorView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(54)
            $0.top.equalTo(separatorSecondView.snp.bottom)
            $0.left.equalTo(timeLabel.snp.right).offset(24)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        dateDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(17)
            $0.left.equalTo(horizontalSeparatorView.snp.right).offset(16)
        }
    }
}

//MARK: - Additional setup for cell

private extension MapCurrentOrderTableViewCell {
    func getDate(firstDate: Int, lastDate: Int) -> [String] {
        let fromDate = CommonFunction.shared.fromMillisToDate(millis: Double(firstDate))
        let toDate = CommonFunction.shared.fromMillisToDate(millis: Double(lastDate))
        
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
    
//    func fromMillisToDate(millis: Double) -> Date {
//        return Date(timeIntervalSince1970: (millis) / 1000)
//    }
    
    func setupStatusColor(status: String) {
        switch status {
        case "pending":
            statusOrderLabel.textColor = R.color.pendingColor()
        case "partially confirmed":
            statusOrderLabel.textColor = R.color.partiallyConfirmedColor()
        case "confirmed":
            statusOrderLabel.textColor = R.color.statusConfirmedColor()
        case "canceled":
            statusOrderLabel.textColor = R.color.canceledColor()
        case "completed":
            statusOrderLabel.textColor = R.color.statusConfirmedColor()
        default:
            statusOrderLabel.textColor = R.color.pendingColor()
        }
    }
    

    func toTimeFrom(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func petsSetup(pets: [PetsId]) {
        for (_,vv) in stackView.subviews.enumerated() {
            vv.removeFromSuperview()
            print(stackView.subviews.count)
        }
        var i = 0
        
        while i != pets.count {
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.spacing = 20
            
            let firstSV = UIStackView()
            firstSV.axis = .horizontal
            firstSV.alignment = .fill
            firstSV.spacing = 10
            
            let secondSV = UIStackView()
            secondSV.axis = .horizontal
            secondSV.alignment = .fill
            secondSV.spacing = 10
            
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronBold(size: 18)
            label.text = pets[i].name
            label.numberOfLines = 2
            
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
                img.sd_setImage(with: URL(string: image), placeholderImage: R.image.alertBox())
            } else {
                img.image = R.image.alertBox()
            }
            
            i+=1
            
            if i != pets.count {
                label2.text = pets[i].name
                if let image = pets[i].imageUrl {
                    img2.sd_setImage(with: URL(string: image), placeholderImage: R.image.alertBox())
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
        }
    }
    
    
    func customerPetSetup(pets: [Pets]) {
        for (_,vv) in stackView.subviews.enumerated() {
            vv.removeFromSuperview()
            print(stackView.subviews.count)
        }
        var i = 0
        
        while i != pets.count {
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.spacing = 20
            
            let firstSV = UIStackView()
            firstSV.axis = .horizontal
            firstSV.alignment = .fill
            firstSV.spacing = 10
            
            let secondSV = UIStackView()
            secondSV.axis = .horizontal
            secondSV.alignment = .fill
            secondSV.spacing = 10
            
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronBold(size: 18)
            label.text = pets[i].name
            label.numberOfLines = 2
            
            let label2 = UILabel()
            label2.textColor = .color070F24
            label2.font = R.font.aileronBold(size: 18)
            
            let img = UIImageView()
            img.layer.cornerRadius = 10
            img.clipsToBounds = true
            
            let img2 = UIImageView()
            img2.layer.cornerRadius = 10
            img2.clipsToBounds = true
            
            if let image = pets[i].imageURL {
                img.sd_setImage(with: URL(string: image), placeholderImage: R.image.alertBox())
            } else {
                img.image = R.image.alertBox()
            }
            
            i+=1
            
            if i != pets.count {
                label2.text = pets[i].name
                if let image = pets[i].imageURL {
                    img2.sd_setImage(with: URL(string: image), placeholderImage: R.image.alertBox())
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
        }
    }
}

//MARK: - Setup orders: public methods

extension MapCurrentOrderTableViewCell {
    func setupEmployeeOrder(orders: MapOrders) {
        statusOrderLabel.text = orders.status
        setupStatusColor(status: orders.status)
        dailyCheckinLabel.text = orders.service.title
        if let url = orders.service.imageUrl {
            calendarImageView.sd_setImage(with: URL(string: url))
        }
        let descrArr = getDate(firstDate: orders.dateFrom, lastDate: orders.dateTo)
        dateDescriptionLabel.text = descrArr.joined(separator: "-")
        timeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: toTimeFrom(millis: Int64(orders.dateFrom)))) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: toTimeFrom(millis: Int64(orders.dateTo))))"
        let dateArr = getDate(firstDate: orders.mainOrderFirstDate, lastDate: orders.mainOrderLastDate)
        dateLabel.text = dateArr.joined(separator: "-")
        petsSetup(pets: orders.pets)
    }
    
    func setUpCustomer() {
        
    }
    
    func setUpCustomer(orders: Items) {
        statusOrderLabel.text = orders.status
        setupStatusColor(status: orders.status ?? "")
        dailyCheckinLabel.text = orders.service?.title
        if let url = orders.service?.imageURL {
            calendarImageView.sd_setImage(with: URL(string: url))
        }
     
        let descrArr = getDate(firstDate: orders.dateFrom ?? 0, lastDate: orders.dateTo ?? 0)
        dateDescriptionLabel.text = descrArr.joined(separator: "-")
        timeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: toTimeFrom(millis: Int64(orders.dateFrom ?? 0)))) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: toTimeFrom(millis: Int64(orders.dateTo ?? 0))))"
        let dateArr = getDate(firstDate: orders.dateFrom ?? 0,lastDate: orders.dateTo ?? 0)
        dateLabel.text = dateArr.joined(separator: "-")
    
        customerPetSetup(pets: orders.pets)
     
    }
}
