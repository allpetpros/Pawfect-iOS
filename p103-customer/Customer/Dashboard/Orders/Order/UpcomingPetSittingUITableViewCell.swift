//
//  UpcomingPetSittingUITableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 15.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import Cosmos

class UpcomingPetSittingUITableViewCell: UITableViewCell {

    //MARK: - UIProperties  
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let statusLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 16)
        return l
    } ()
    
    private let meetAndGreenImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    } ()
    
    private let serviceLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let meetAndGreetLabel: UILabel = {
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
//        l.backgroundColor = .gray
        l.textColor = .color860000
        l.font = R.font.aileronBold(size: 12)
        return l
    } ()
    
    private let separatorBetweenTimeAndRateView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let customerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.profile_test()
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
    
    private let raitingView: CosmosView = {
        let v = CosmosView()
        v.isUserInteractionEnabled = false
        v.settings.starSize = 15
        return v
    } ()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
        
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
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
}

//MARK: - Setup Layout
private extension UpcomingPetSittingUITableViewCell {
    
    func setupLayout() {
                
        addSubviews([stackView, separatorView, statusLabel, meetAndGreenImageView, serviceLabel,meetAndGreetLabel, separatorSecondView, timeLabel, separatorBetweenTimeAndRateView, customerImageView, customerNameLabel, raitingView])
        
//        stackView.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(20)
//            $0.left.equalToSuperview().offset(20)
//            $0.right.equalToSuperview().offset(20)
//        }
//
//        statusLabel.snp.makeConstraints {
//            $0.top.equalToSuperview().offset(25)
//            $0.right.equalToSuperview().offset(-25)
//        }
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalToSuperview().offset(20)
//            $0.right.equalTo(statusOrderLabel.snp.width).offset(-20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
//            $0.left.equalTo(stackView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-20)
//            $0.width.equalTo(100)
        }
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(stackView.snp.bottom).offset(10)
        }

        meetAndGreenImageView.snp.makeConstraints {
            $0.width.equalTo(14)
            $0.height.equalTo(19)
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(separatorView.snp.bottom).offset(7)
        }

        serviceLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(10)
            $0.left.equalTo(meetAndGreenImageView.snp.right).offset(10)
        }
        meetAndGreetLabel.snp.makeConstraints {
            $0.top.equalTo(serviceLabel.snp.bottom).offset(10)
            $0.left.equalTo(serviceLabel.snp.left)
        }

        separatorSecondView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(meetAndGreetLabel.snp.bottom).offset(10)
        }
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(25)
            $0.bottom.equalToSuperview().offset(-30)
        }
        
        separatorBetweenTimeAndRateView.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom)
            $0.width.equalTo(1)
            $0.height.equalTo(50)
            $0.left.equalTo(timeLabel.snp.right).offset(24)
        }
        
        customerImageView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(10)
            $0.left.equalTo(separatorBetweenTimeAndRateView.snp.right).offset(15)
        }
        
        customerNameLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(7)
            $0.left.equalTo(customerImageView.snp.right).offset(13)
        }
        
        raitingView.snp.makeConstraints {
            $0.leading.equalTo(customerNameLabel)
            $0.top.equalTo(customerNameLabel.snp.bottom).offset(1)
            $0.width.equalTo(62)
            $0.height.equalTo(10)
        }
    }
}

//MARK: - Setup orders

private extension UpcomingPetSittingUITableViewCell {
    func setupStatusColor(status: String) {
        switch status {
        case "pending":
            statusLabel.textColor = R.color.pendingColor()
        case "partially confirmed":
            statusLabel.textColor = R.color.partiallyConfirmedColor()
        case "completed":
            statusLabel.textColor = R.color.statusConfirmedColor()
        case "confirmed":
            statusLabel.textColor = R.color.statusConfirmedColor()
        case "canceled":
            statusLabel.textColor = R.color.canceledColor()
        default:
            statusLabel.textColor = R.color.pendingColor()
        }
    }
    
    func toDate(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

//MARK: - Cell setup

extension UpcomingPetSittingUITableViewCell {
    
    func petsSetup(pets: [PetsId], order: UpcomingOrders) {
        
        statusLabel.text = order.status
        
        setupStatusColor(status: order.status)
        
      
            if order.employee == nil {
                customerNameLabel.isHidden = true
                customerImageView.isHidden = true
                raitingView.isHidden = true
            } else {
                if let order = order.employee {
                customerNameLabel.isHidden = false
                customerImageView.isHidden = false
                raitingView.isHidden = false
                customerNameLabel.text = "\(order.name) \(order.surname)"
                if let img = order.imageUrl {
                    customerImageView.sd_setImage(with: URL(string: img))
                }
                raitingView.rating = order.rating ?? 0.0
            }
        }
//            customerNameLabel.text = "\(name.name) \(name.surname)"
//            if let img = name.imageUrl {
//                customerImageView.sd_setImage(with: URL(string: img))
//            }
//            raitingView.rating = Double(name.rating ?? 0.0)
        
        serviceLabel.text = order.service.title
        
        let timeFrom = toDate(millis: order.dateFrom)
        let timeTo = toDate(millis: order.dateTo)
        timeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) : \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
        
        if let img = order.service.imageUrl {
            meetAndGreenImageView.sd_setImage(with: URL(string: img))
        }
        
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0);$0.removeFromSuperview() }
        
        var i = 0
        if pets.count == 1 {
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronBold(size: 18)
            label.minimumScaleFactor = 0.5
            label.numberOfLines = 0
            label.text = pets[0].name
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.spacing = 20
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            let img = UIImageView()
            img.layer.cornerRadius = 10
            img.contentMode = .scaleAspectFill
            img.clipsToBounds = true
            
            if let image = pets[i].imageUrl {
                img.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
            }  else {
                img.sd_setImage(with: URL(string: ""), placeholderImage: R.image.pet_photo_placeholder())
            }
            
            img.snp.makeConstraints {
                $0.size.equalTo(30)
            }
            
            stack.addArrangedSubviews(views: img, label)
            
            stackView.addArrangedSubview(stack)
        } else {
            while i != pets.count {
                let stack = UIStackView()
                stack.axis = .horizontal
                stack.distribution = .fillEqually
                stack.alignment = .fill
//                stack.backgroundColor = .gray
//                stack.spacing = 40
                
                stack.translatesAutoresizingMaskIntoConstraints = false

                let firstSV = UIStackView()
                firstSV.axis = .horizontal
//                firstSV.backgroundColor = .orange
                firstSV.spacing = 10

                let secondSV = UIStackView()
                secondSV.axis = .horizontal
                secondSV.spacing = 10

                let label = UILabel()
                label.textColor = .color070F24
                label.font = R.font.aileronBold(size: 18)
                label.minimumScaleFactor = 0.5
                label.numberOfLines = 0
                label.text = pets[i].name

                let label2 = UILabel()
                label2.textColor = .color070F24
                label2.minimumScaleFactor = 0.5
                label2.numberOfLines = 0
                label2.font = R.font.aileronBold(size: 18)

                let img = UIImageView()
                img.contentMode = .scaleAspectFill
                img.layer.cornerRadius = 10
                img.clipsToBounds = true

                let img2 = UIImageView()
                img2.contentMode = .scaleAspectFill
                img2.layer.cornerRadius = 10
                img2.clipsToBounds = true

                if let image = pets[i].imageUrl {
                    img.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
                }  else {
                    img.sd_setImage(with: URL(string: ""), placeholderImage: R.image.pet_photo_placeholder())
                }

                i+=1

                if i != pets.count {
                    label2.text = pets[i].name
                    if let image = pets[i].imageUrl {
                        img2.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
                    }  else {
                        img2.sd_setImage(with: URL(string: ""), placeholderImage: R.image.pet_photo_placeholder())
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
}
