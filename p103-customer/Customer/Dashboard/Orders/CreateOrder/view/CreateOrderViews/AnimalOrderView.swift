//
//  AnimalOrderView.swift
//  p103-customer
//
//  Created by Daria Pr on 17.06.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class AnimalOrderView: UIView {
    
    //MARK: - UIProperties
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let dogImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.tintColor = UIColor.black
        return iv
    } ()
    
    private let typeWalksLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let dateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        l.minimumScaleFactor = 0.5
        l.adjustsFontSizeToFitWidth = true
        l.numberOfLines = 2
        return l
    } ()
    
    private let separatorSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let calendarLabel: UILabel = {
        let l = UILabel()
        l.text = "View calendar"
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.totalOrderArrowImage()
        return iv
    } ()
    
    private let separatorThirdView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let viewCalendarButton: UIButton = {
        let b = UIButton()
        return b
    } ()
    
    private let timeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 85
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
    
    private let horizontalSeparatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let horizontalSecondSeparatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    weak var calendarViewDelegate: CalendarViewDelegate?
    
    private var x = 15
    private var y = 10
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupFirstPartOfLayout()
        viewCalendarButton.addTarget(self, action: #selector(viewCalendarButtonAction), for: .touchUpInside)
        
        typeWalksLabel.text = OrderManager.shared.service
        if OrderManager.shared.serviceImage != "-" {
            dogImageView.sd_setImage(with: URL(string: OrderManager.shared.serviceImage))
        }
        
        dateSetup()
        timeSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Layout
    
    private func setupFirstPartOfLayout() {
        
        addSubviews([mainStackView, separatorView, dogImageView, typeWalksLabel, dateLabel])
        
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.equalToSuperview().offset(15)
            $0.right.equalToSuperview()
        }
        
        var i = 0
                
        while i != OrderManager.shared.nameOfPet.count {

            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.spacing = 40
            stack.translatesAutoresizingMaskIntoConstraints = false

            let firstSV = UIStackView()
            firstSV.axis = .horizontal
            firstSV.spacing = 10

            let secondSV = UIStackView()
            secondSV.axis = .horizontal
            secondSV.spacing = 10

            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronBold(size: 18)
            label.minimumScaleFactor = 0.5
            label.numberOfLines = 0
            label.text = OrderManager.shared.nameOfPet[i]

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

            img.sd_setImage(with: URL(string:  OrderManager.shared.imageOfPet[i]), placeholderImage: R.image.alertBox())

            i+=1

            if i != OrderManager.shared.nameOfPet.count {
                label2.text = OrderManager.shared.nameOfPet[i]
                img2.sd_setImage(with: URL(string: OrderManager.shared.imageOfPet[i]), placeholderImage: R.image.alertBox())
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

            mainStackView.addArrangedSubview(stack)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(mainStackView.snp.bottom).offset(14)
        }

        dogImageView.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(14)
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.left.equalToSuperview().offset(25)
        }

        typeWalksLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.left.equalTo(dogImageView.snp.right).offset(5)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.right.equalToSuperview().offset(-20)
        }
        
        setupSecondPartOfLayout()
    }
    
    private func setupSecondPartOfLayout() {
        addSubviews([separatorSecondView, calendarLabel, arrowImageView, separatorThirdView, viewCalendarButton, timeStackView, horizontalSeparatorView, horizontalSecondSeparatorView])

        timeStackView.addArrangedSubviews(views: morningLabel, afternoonLabel, eveningLabel)

        separatorSecondView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(15)
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        calendarLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(15)
        }

        arrowImageView.snp.makeConstraints {
            $0.width.equalTo(7)
            $0.height.equalTo(12)
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(15)
        }

        separatorThirdView.snp.makeConstraints {
            $0.top.equalTo(arrowImageView.snp.bottom).offset(15)
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }

        viewCalendarButton.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom)
            $0.bottom.equalTo(separatorThirdView.snp.bottom)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }

        timeStackView.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }

        horizontalSeparatorView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(42)
            $0.top.equalTo(separatorThirdView.snp.bottom)
            $0.left.equalTo(morningLabel.snp.right).offset(50)
        }

        horizontalSecondSeparatorView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(42)
            $0.top.equalTo(separatorThirdView.snp.bottom)
            $0.left.equalTo(afternoonLabel.snp.right).offset(50)
            $0.bottom.equalToSuperview()
        }

        horizontalSeparatorView.isHidden = true
        horizontalSecondSeparatorView.isHidden = true
    }
}

//MARK: - Setup Order Description

private extension AnimalOrderView {
    func dateSetup() {
        if let firstDate = OrderManager.shared.startedDate, let endDate = OrderManager.shared.endedDate {
            
            OrderManager.shared.copyStart = OrderManager.shared.startedDate
            OrderManager.shared.copyEnd = OrderManager.shared.endedDate
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
            
            dateFormatter.dateFormat = "dd"
            
            let secondFormatter = DateFormatter()
            secondFormatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
            secondFormatter.dateFormat = "MMM"
            
            let monthFirst = secondFormatter.string(from: firstDate)
            let monthSecond = secondFormatter.string(from: endDate)
            
            let first = dateFormatter.string(from: firstDate)
            let second = dateFormatter.string(from: endDate)
            
            if monthFirst == monthSecond {
                dateLabel.text = "\(monthFirst) \(first) - \(monthFirst) \(second) "
            } else {
                dateLabel.text = "\(monthSecond) \(first) - \(monthFirst) \(second) "
            }
        }
    }
    
    func timeSetup() {
        if OrderManager.shared.partOfDays.count == 3 {
            setupMorning()
            setupAfternoon()
            setupEvening()
            horizontalSeparatorView.isHidden = false
            horizontalSecondSeparatorView.isHidden = false
        } else if OrderManager.shared.partOfDays.count == 2 {
            horizontalSeparatorView.snp.remakeConstraints {
                $0.width.equalTo(1)
                $0.height.equalTo(42)
                $0.top.equalTo(separatorThirdView.snp.bottom)
                $0.centerX.equalToSuperview()
            }
            if OrderManager.shared.partOfDays.contains("morning") && OrderManager.shared.partOfDays.contains("afternoon") {
                setupMorning()
                setupAfternoon()
                eveningLabel.isHidden = true
            } else if OrderManager.shared.partOfDays.contains("afternoon") && OrderManager.shared.partOfDays.contains("evening") {
                setupAfternoon()
                setupEvening()
                morningLabel.isHidden = true
            } else if OrderManager.shared.partOfDays.contains("evening") && OrderManager.shared.partOfDays.contains("morning") {
                setupMorning()
                setupEvening()
                afternoonLabel.isHidden = true
            }
        } else {
            if OrderManager.shared.partOfDays.contains("morning") {
                afternoonLabel.isHidden = true
                eveningLabel.isHidden = true
                setupMorning()
            } else if OrderManager.shared.partOfDays.contains("afternoon") {
                eveningLabel.isHidden = true
                morningLabel.isHidden = true
                setupAfternoon()
            } else if OrderManager.shared.partOfDays.contains("evening") {
                afternoonLabel.isHidden = true
                morningLabel.isHidden = true
                setupEvening()
            }
        }
    }
    
    func setupMorning() {
        print("Morning Hours are",OrderManager.shared.morningHours)
        if OrderManager.shared.morningHours.isEmpty {
            morningLabel.text = "07:00AM"
        } else {
            morningLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: OrderManager.shared.morningHours))"
        }
    }
    
    func setupAfternoon() {
        print("Afternoon Hours are",OrderManager.shared.afternoonHours)
        if OrderManager.shared.afternoonHours.isEmpty {
            afternoonLabel.text = "12:00PM"
        } else {
            afternoonLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time:OrderManager.shared.afternoonHours))"
        }
    }
    
    func setupEvening() {
        print("Evening Hours are",OrderManager.shared.eveningHours)
        if OrderManager.shared.eveningHours.isEmpty {
            eveningLabel.text = "05:00PM"
        } else {
            eveningLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time:OrderManager.shared.eveningHours))"
        }
    }
}

//MARK: - Action

extension AnimalOrderView {
    @objc func viewCalendarButtonAction() {
        calendarViewDelegate?.tapOnCalendarCell()
    }
}

//MARK: - Public func: setup cells

extension AnimalOrderView {
    func setupCell(date: String, time: [String]) {
        dateLabel.text = date
        if !time[0].isEmpty {
            morningLabel.text = time[0]
        }
        
        if !time[1].isEmpty {
            afternoonLabel.text = time[1]
        }
        
        if !time[2].isEmpty {
            eveningLabel.text = time[2]
        }
    }
    
    
}
