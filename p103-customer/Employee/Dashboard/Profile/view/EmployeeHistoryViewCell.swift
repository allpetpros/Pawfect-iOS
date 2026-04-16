//
//  EmployeeHistoryViewCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 29/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit

class EmployeeHistoryViewCell: UITableViewCell {
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let orderDateLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronSemiBold(size: 16)
        l.textColor = .color606572
        return l
    } ()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
//        stackView.backgroundColor = .blue
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private let meetAndGreetImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    } ()
    
    private let meetAndGreetLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color293147
        return l
    } ()
    
    private let statusLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    let bgView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    } ()
    
    private let separatorSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let timeLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 12)
        l.textColor = .color860000
        return l
    } ()
    
    private let separatorVerticalView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let petOwnerImageView: UIImageView = {
        let v = UIImageView()
        v.layer.cornerRadius = 5
        v.clipsToBounds = true
        return v
    } ()
    
    private let nameOwnerLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = .color293147
        return l
    } ()
    
    private let petOwnerLabel: UILabel = {
        let l = UILabel()
        l.text = "pet owner"
        l.font = R.font.aileronLight(size: 12)
        l.textColor = .color606572
        return l
    } ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        setDateLabel()
        setupLayout()
    }
    
    func setDateLabel() {
        addSubviews([orderDateLabel])
        orderDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        setupBackgroundView()
    }
    
    func setupBackgroundView() {
        addSubviews([bgView])
        bgView.snp.makeConstraints {
            $0.top.equalTo(orderDateLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setupLayout() {
        addSubviews([stackView, separatorView, statusLabel, meetAndGreetImageView, meetAndGreetLabel, timeLabel, separatorSecondView, separatorVerticalView, petOwnerImageView, nameOwnerLabel, petOwnerLabel])
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(orderDateLabel.snp.bottom).offset(35)
            $0.left.equalToSuperview().offset(20)
//            $0.right.equalTo(statusOrderLabel.snp.width).offset(-20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(orderDateLabel.snp.bottom).offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(stackView.snp.bottom).offset(20)
        }
        
        meetAndGreetImageView.snp.makeConstraints {
            $0.width.equalTo(14)
            $0.height.equalTo(19)
            $0.top.equalTo(separatorView.snp.bottom).offset(7)
            $0.left.equalToSuperview().offset(25)
        }
        
        meetAndGreetLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(10)
            $0.left.equalTo(meetAndGreetImageView.snp.right).offset(7)
        }

        separatorSecondView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(meetAndGreetLabel.snp.bottom).offset(8)
        }
        
        timeLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(15)
        }
        
        separatorVerticalView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(62)
            $0.top.equalTo(separatorSecondView.snp.bottom)
            $0.left.equalTo(timeLabel.snp.right).offset(7)
        }
        
        petOwnerImageView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(10)
            $0.left.equalTo(separatorVerticalView.snp.right).offset(15)
        }
        
        nameOwnerLabel.snp.makeConstraints {
            $0.left.equalTo(petOwnerImageView.snp.right).offset(13)
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(10)
        }
        
        petOwnerLabel.snp.makeConstraints {
            $0.top.equalTo(nameOwnerLabel.snp.bottom)
            $0.left.equalTo(nameOwnerLabel)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    
    func historyOrdersSetup(orders: EmployeeHistoryDetails) {
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0);$0.removeFromSuperview() }

        var i = 0

        if orders.pets.count == 1 {
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronBold(size: 18)
            label.minimumScaleFactor = 0.5
            label.numberOfLines = 0
            label.text = orders.pets[0].name

            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.spacing = 8
            stack.translatesAutoresizingMaskIntoConstraints = false

            let img = UIImageView()
            img.layer.cornerRadius = 10
            img.contentMode = .scaleAspectFill
            img.clipsToBounds = true

            if let image = orders.pets[i].imageUrl {
                img.sd_setImage(with: URL(string: image))
            } else {
                img.image = R.image.alertBox()
            }

            img.snp.makeConstraints {
                $0.size.equalTo(30)
            }

            stack.addArrangedSubviews(views: img, label)

            stackView.addArrangedSubview(stack)

        } else {
            while i != orders.pets.count {

                let stack = UIStackView()
                stack.axis = .horizontal
                stack.distribution = .fillProportionally
                stack.alignment = .fill
                stack.spacing = 8

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
                label.text = orders.pets[i].name

                if orders.pets[i].name.count > 6 {
                    label.font = R.font.aileronBold(size: 15)
                }

                let label2 = UILabel()
                label2.textColor = .color070F24
                label2.minimumScaleFactor = 0.5
                label2.numberOfLines = 0
                label2.font = R.font.aileronBold(size: 18)

                let img = UIImageView()
                img.layer.cornerRadius = 10
                img.contentMode = .scaleAspectFill
                img.clipsToBounds = true

                let img2 = UIImageView()
                img2.layer.cornerRadius = 10
                img2.contentMode = .scaleAspectFill
                img2.clipsToBounds = true

                if let image = orders.pets[i].imageUrl {
                    img.sd_setImage(with: URL(string: image), placeholderImage: R.image.alertBox())
                } else {
                    img.image = R.image.alertBox()
                }

                i+=1

                if i != orders.pets.count {
                    label2.text = orders.pets[i].name
                    if orders.pets[i].name.count > 6 {
                        label2.font = R.font.aileronBold(size: 15)
                    }
                    if let image = orders.pets[i].imageUrl {
                        img2.sd_setImage(with: URL(string: image), placeholderImage: R.image.alertBox())
                    } else {
                        img2.image = R.image.alertBox()
                    }
                    i+=1
                }
                
                img.snp.makeConstraints {
                    $0.size.equalTo(30)
                }

                img2.snp.makeConstraints {
                    $0.size.equalTo(30)
                }
                
                firstSV.addArrangedSubviews(views: img, label)
                
                if label2.text != nil {
                    secondSV.addArrangedSubviews(views: img2, label2)
                    stack.addArrangedSubviews(views: firstSV, secondSV)
                } else {
                    stack.addArrangedSubviews(views: firstSV)
                }
                stackView.addArrangedSubview(stack)
            }
        }
        orderDateLabel.text = getDate(date: orders.timeFrom)
        print("History Order Date",getDate(date: orders.timeFrom))
        statusLabel.text = orders.status
        setupStatusColor(status: orders.status)
        meetAndGreetLabel.text = orders.service.title
        if let img = orders.service.imageUrl {
            meetAndGreetImageView.sd_setImage(with: URL(string: img))
        }
        if let name = orders.customer?.name, let surname = orders.customer?.surname {
            nameOwnerLabel.text = "\(name) \(surname)"
        }
        if let avatar = orders.customer?.imageUrl {
            petOwnerImageView.sd_setImage(with: URL(string: avatar))
        }
        print("History Order",orders)
        let timeFrom = CommonFunction.shared.toDate(millis: Int64(orders.timeFrom))
        let timeTo = CommonFunction.shared.toDate(millis: Int64(orders.timeTo))
        
        timeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) : \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
      
    }
    
    //MARK: - Color setup
    
    private func setupStatusColor(status: String) {
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
    
    
    func getDate(date: Int) -> String {
        let date = CommonFunction.shared.fromMillisToDate(millis: Double(date))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"

        let historyDate = dateFormatter.string(from: date)
        return historyDate
    }
}
