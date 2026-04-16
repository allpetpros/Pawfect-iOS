//
//  OrderDetailsTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 22.06.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class OrderDetailsTableViewCell: UITableViewCell {

    //MARK: - UIProperties
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private let ordersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private let statusOrderLabel: UILabel = {
        let l = UILabel()
        l.textColor = R.color.statusOrderColor()
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let calendarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = R.image.calendar()
        iv.tintColor = UIColor.black
        return iv
    } ()
    
    private let dailyCheckinLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let dateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    
    private let timeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 50
        sv.distribution = .fillEqually
        return sv
    } ()
    
    private let morningLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let afternoonLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let eveningLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let moreLabel: UILabel = {
        let l = UILabel()
        l.text = "More"
        l.isHidden = false
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorC6222F
        return l
    } ()
    
    private let moreImageView: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = false
        iv.image = R.image.moreArrowImageView()
        return iv
    } ()
    
    private let separatorSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let moreInfoButton: UIButton = {
        let b = UIButton()
//        b.addTarget(self, action: #selector(moreInfoButtonAction), for: .touchUpInside)
        return b
    }()
    
    private let infoLabel: UILabel = {
        let l = UILabel()
        l.text = "Information"
        l.font = R.font.aileronBold(size: 18)
        l.textColor = .colorC6222F
        l.isHidden = true
        return l
    } ()
    
    private let dateDescriptionLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let infoTimeLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.text = "12:00 - 12:30"
        l.isHidden = true
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let statusOrdersLabel: UILabel = {
        let l = UILabel()
        l.text = "confirmed"
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = R.color.statusConfirmedColor()
        l.isHidden = true
        return l
    } ()
    
    private let arrowToOrderImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.orderArrowImage()
        iv.isHidden = true
        return iv
    } ()
    
    private let separatorSixthView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()

    private let arrowSecondToOrderImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.orderArrowImage()
        iv.isHidden = true
        return iv
    } ()
    
    private let separatorSeventhView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let hideLabel: UILabel = {
        let l = UILabel()
        l.text = "Hide details"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorC6222F
        return l
    } ()
    
    private let hideImageView: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = false
        iv.image = R.image.hideMoreImage()
        return iv
    } ()
    
    private let separatorThirdView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let hideInfoButton: UIButton = {
        let b = UIButton()
        return b
    }()
    
    private var visit = [OrdersId]()
    
    //MARK: - Init
    
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
    
    override func layoutSubviews() {
         super.layoutSubviews()

         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    //MARK: - Setup Layout

    private func setupLayout() {
        addSubviews([stackView, statusOrderLabel, separatorView, dailyCheckinLabel, calendarImageView, dateLabel, separatorSecondView, separatorThirdView, timeStackView, ordersStackView, moreLabel, moreImageView, moreInfoButton])
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        statusOrderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.right.equalToSuperview().offset(-10)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(stackView.snp.bottom).offset(14)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(16)
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.left.equalToSuperview().offset(15)
        }
        
        dailyCheckinLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.left.equalTo(calendarImageView.snp.right).offset(5)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.right.equalToSuperview().offset(-15)
        }
        
        timeStackView.addArrangedSubviews(views: morningLabel, afternoonLabel, eveningLabel)
        
        separatorSecondView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(47)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }

        timeStackView.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(18)
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
        }
        
        separatorThirdView.snp.makeConstraints {
            $0.top.equalTo(timeStackView.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        ordersStackView.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        moreLabel.snp.makeConstraints {
            $0.top.equalTo(ordersStackView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        moreImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(7)
            $0.left.equalTo(moreLabel.snp.right).offset(5)
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        moreInfoButton.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
}

extension OrderDetailsTableViewCell {
    func setupCell(orders: [OrderDetails]) {
        dailyCheckinLabel.text = orders[0].service.title
        let date = self.getDate(firstDate: orders[0].firstDate, lastDate: orders[0].lastDate)
        dateLabel.text = date.joined(separator: "-")
        let time = self.getTime(firstDate: orders[0].firstDate, lastDate: orders[0].lastDate)
        self.infoTimeLabel.text = time.joined(separator: " - ")
        self.dateDescriptionLabel.text = date.joined(separator: "-")
        self.afternoonLabel.text = time.joined(separator: " - ")
        self.visit = orders[0].orders
        self.petsSetup(pets: orders[0].pets)
    }
    
    func petsSetup(pets: [PetsId]) {
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
        }
    }
    
    func getDate(firstDate: Int, lastDate: Int) -> [String] {
        let fromDate = CommonFunction.shared.fromMillisToDate(millis: Double(firstDate))
        let toDate = CommonFunction.shared.fromMillisToDate(millis: Double(lastDate))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        
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
    
    func getTime(firstDate: Int, lastDate: Int) -> [String] {
        let fromDate = CommonFunction.shared.fromMillisToDate(millis: Double(firstDate))
        let toDate = CommonFunction.shared.fromMillisToDate(millis: Double(lastDate))

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        let timeFirst = timeFormatter.string(from: fromDate)
        let timeSecond = timeFormatter.string(from: toDate)

        var timeArr = [String]()

        timeArr.append(timeFirst)
        timeArr.append(timeSecond)

        return timeArr
    }
    
    

}
