//
//  PetSittingRequestTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 12.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class PetSittingRequestTableViewCell: UITableViewCell {

    //MARK: - UIProperties
    private let orderLabel: UILabel = {
        let l = UILabel()
        l.textColor = R.color.statusOrderColor()
        l.numberOfLines = 0
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    private let statusOrderLabel: UILabel = {
        let l = UILabel()
        l.textColor = R.color.statusOrderColor()
        l.numberOfLines = 0
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
        iv.tintColor = .black
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
    
    private let separatorSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
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

    private let timeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 5
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
    
    let moreInfoButton: UIButton = {
        let b = UIButton()
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
        l.isHidden = true
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let statusLabel: UILabel = {
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
    
    private let hideInfoButton: UIButton = {
        let b = UIButton()
        return b
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 10
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
    
    //MARK: - Properties
    
    weak var delegateTable: PetSittingRequestDelegate?
    
    private var visit = [OrdersId]()
    
    private var visitTimeArr = [VisitsId]()
    var orders: Order?
    var id = 0
    private var activityView: UIActivityIndicatorView?
   
    var indexPathofCell: IndexPath?
    //MARK: - Lifecycle
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
       
      
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

        ordersStackView.isUserInteractionEnabled = true
        infoLabel.isUserInteractionEnabled = true
        ordersStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ordersAction)))
        infoLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ordersAction)))
        selectionStyle = .none
        self.moreInfoButton.addTarget(self, action: #selector(moreInfoButtonAction), for: .touchUpInside)
        self.hideInfoButton.addTarget(self, action: #selector(hideInfoButtonAction), for: .touchUpInside)
        setupFirstPartOfLayout()
        setupSecondPartOfLayout()
        
    }
    
    @objc func ordersAction() {
        print("tapped action")
    }
}

//MARK: - Setup Layout
extension PetSittingRequestTableViewCell {
    
    func setupFirstPartOfLayout() {
        addSubviews([stackView, statusOrderLabel, separatorView, calendarImageView, dailyCheckinLabel, dateLabel])
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        statusOrderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.right.equalToSuperview().offset(-20)
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
    }
    
    func setupSecondPartOfLayout() {
        addSubviews([separatorSecondView, separatorThirdView, timeStackView, horizontalSeparatorView, horizontalSecondSeparatorView, moreLabel, moreImageView, moreInfoButton])
        
        timeStackView.addArrangedSubviews(views: morningLabel, afternoonLabel, eveningLabel)
        
        separatorSecondView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(15)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }

        timeStackView.snp.makeConstraints {
            $0.left.equalTo(separatorSecondView.snp.left).offset(5)
            $0.right.equalTo(separatorSecondView.snp.right).offset(-5)
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        horizontalSeparatorView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(42)
            $0.top.equalTo(separatorSecondView.snp.bottom)
            $0.left.equalTo(morningLabel.snp.right).offset(24)
        }
        
        horizontalSecondSeparatorView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(42)
            $0.top.equalTo(separatorSecondView.snp.bottom)
            $0.left.equalTo(afternoonLabel.snp.right).offset(24)
        }
        
        separatorThirdView.snp.makeConstraints {
            $0.top.equalTo(horizontalSecondSeparatorView.snp.bottom)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        moreLabel.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-25)
        }
        
        moreImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(7)
            $0.left.equalTo(moreLabel.snp.right).offset(5)
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(20)
        }
        
        moreInfoButton.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func moreInfoLayoutSetup() {
        moreLabel.snp.remakeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        moreLabel.isHidden = true
        moreImageView.isHidden = true
        moreInfoButton.isUserInteractionEnabled = false
        
        addSubviews([infoLabel, ordersStackView, hideLabel, hideImageView, hideInfoButton])
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
        }
        
        ordersStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        hideLabel.snp.makeConstraints {
            $0.top.equalTo(ordersStackView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        hideImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(7)
            $0.left.equalTo(hideLabel.snp.right).offset(5)
            $0.top.equalTo(ordersStackView.snp.bottom).offset(35)
        }

        hideInfoButton.snp.makeConstraints {
            $0.top.equalTo(ordersStackView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-30)
        }
        
        var i = 0
        
        ordersStackView.arrangedSubviews.forEach { ordersStackView.removeArrangedSubview($0);$0.removeFromSuperview() }
            
        while i != visit.count {
            
            let status = visit[i].status
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            
            stack.spacing = 1
            
            let button = UIButton()
            button.setImage(R.image.orderArrowImage(), for: .normal)
            
            let line = UIView()
            line.backgroundColor = .colorE8E9EB
            
            let stackStatus = UIStackView()
            stackStatus.axis = .horizontal
            stackStatus.distribution = .fillProportionally
            stackStatus.alignment = .fill
            stackStatus.spacing = 1
            
            let stackFinal = UIStackView()
            stackFinal.axis = .horizontal
            stackFinal.distribution = .fillProportionally
            stackFinal.alignment = .fill
            stackFinal.spacing = 1
            
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronRegular(size: 14)
            
            let statusLabel = UILabel()
            statusLabel.textColor = .color070F24
            statusLabel.font = R.font.aileronRegular(size: 16)
            
            let timeLabel = UILabel()
            timeLabel.textColor = .color860000
            timeLabel.font = R.font.aileronRegular(size: 14)
            
            statusLabel.text = status
            
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
            
            let dateFrom = Date(timeIntervalSince1970: (Double(visit[i].dateFrom) / 1000.0))
            
            let dateTo = Date(timeIntervalSince1970: (Double(visit[i].dateTo) / 1000.0))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd"
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            label.text = dateFormatter.string(from: dateFrom)
            let timeFrom = timeFormatter.string(from: dateFrom)
            let timeTo = timeFormatter.string(from: dateTo)
            print(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom))
            print(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))

            timeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"

            i+=1
            
            stack.addArrangedSubviews(views: label, timeLabel)
            
            stackStatus.addArrangedSubviews(views: statusLabel, button)
            
            stackFinal.addArrangedSubviews(views: stack, stackStatus)
            
            ordersStackView.addArrangedSubviews(views: stackFinal, line)
            
            line.snp.makeConstraints {
                $0.height.equalTo(1)
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
            }
        }
    }
   
    
    func setupStatusColor(status: String) {
        switch status {
        case "pending":
            statusOrderLabel.textColor = R.color.pendingColor()
        case "partially confirmed":
            statusOrderLabel.textColor = R.color.partiallyConfirmedColor()
        case "confirmed":
            statusOrderLabel.textColor = R.color.statusConfirmedColor()
        case "completed":
            statusLabel.textColor = R.color.statusConfirmedColor()
        case "canceled":
            statusOrderLabel.textColor = R.color.canceledColor()
        default:
            statusOrderLabel.textColor = R.color.pendingColor()
        }
    }
    
    func getDate(dates: [Int]) {
        let first = dates.min()
        let second = dates.max()
        
        let firstDate = CommonFunction.shared.fromMillisToDate(millis: Double(first!))
        let secondDate = CommonFunction.shared.fromMillisToDate(millis: Double(second!))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let checkMonthFormatter = DateFormatter()
        checkMonthFormatter.dateFormat = "MMM"
        
        let dateFirst = dateFormatter.string(from: firstDate)
        let dateSecond = dateFormatter.string(from: secondDate)
        
        let monthFirst = checkMonthFormatter.string(from: firstDate)
        let monthSecond = checkMonthFormatter.string(from: secondDate)
        
        if first == second {
            dateLabel.text = dateFirst
        } else {
            if monthFirst == monthSecond {
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "MMM d"
                let day = dayFormatter.string(from: firstDate)
                dateLabel.text = "\(day) - \(dateSecond)"
            } else {
                dateLabel.text = "\(dateFirst) - \(dateSecond)"
            }
        }
    }
}

//MARK: - Setup cells: public method

extension PetSittingRequestTableViewCell {
    func petsSetup(pets: [PetsId], order: Orders, dates: [String], time: [String]) {
        var dates = [Int]()
        
        for i in order.orders {
            dates.append(i.dateTo)
        }
        
        getDate(dates: dates)
        
        statusOrderLabel.text = order.status
        setupStatusColor(status: order.status)
        
        infoTimeLabel.text = time.joined(separator: " - ")
        
        dailyCheckinLabel.text = order.service.title
        if let img = order.service.imageUrl {
            calendarImageView.sd_setImage(with: URL(string: img))
        }

        for j in 0..<order.visits.count {

            let timeFrom = String(CommonFunction.shared.toDate(millis: Int64(order.visits[j].timeFrom)))
            let timeTo = String(CommonFunction.shared.toDate(millis: Int64(order.visits[j].timeTo)))
            
            if order.visits[j].type == "morning" {
                morningLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
            } else if order.visits[j].type == "afternoon" {
                afternoonLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
            } else if order.visits[j].type == "evening" {
                eveningLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
            }
        }
        
        horizontalSeparatorView.isHidden = true
        horizontalSecondSeparatorView.isHidden = true
        
        visit = order.orders
        visitTimeArr = order.visits
        
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
            img.contentMode = .scaleAspectFill
            img.layer.cornerRadius = 10
            img.clipsToBounds = true
            
            if let image = pets[i].imageUrl {
                img.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
            } else {
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
                stack.distribution = .fillProportionally
                stack.alignment = .fill
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
                label.text = pets[i].name
                
                if pets[i].name.count > 6 {
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
                img.contentMode = .scaleAspectFill
                img2.clipsToBounds = true
                
                if let image = pets[i].imageUrl {
                    img.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
                } else {
                    img.sd_setImage(with: URL(string: ""), placeholderImage: R.image.pet_photo_placeholder())
                }
                
                i+=1
                
                if i != pets.count {
                    label2.text = pets[i].name
                    if pets[i].name.count > 6 {
                        label2.font = R.font.aileronBold(size: 15)
                    }
                    if let image = pets[i].imageUrl {
                        img2.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
                    } else {
                        img2.sd_setImage(with: URL(string: ""), placeholderImage: R.image.pet_photo_placeholder())
                    }
                    i+=1
                }
                firstSV.addArrangedSubviews(views: img, label)
                if label2.text != nil {
                    secondSV.addArrangedSubviews(views: img2, label2)
                    stack.addArrangedSubviews(views: firstSV, secondSV)
                } else {
                    stack.addArrangedSubview(firstSV)
                }
                img.snp.makeConstraints {
                    $0.size.equalTo(30)
                }
                img2.snp.makeConstraints {
                    $0.size.equalTo(30)
                }
                stackView.addArrangedSubview(stack)
            }
        }
    }
    
    func setup(time: [String]) {
        if time.count == 1 {
            afternoonLabel.text = time[0]
        }
    }
}

//MARK: - Actions

extension PetSittingRequestTableViewCell {
    @objc func moreInfoButtonAction() {

        infoLabel.isHidden = false
        if let indexPath = indexPathofCell {
            delegateTable?.onClickExpandCollapse(isMoreExpanded: true, indexPath: indexPath.row)
        }
        moreInfoLayoutSetup()
        delegateTable?.reloadTable()

    }
    
    @objc func hideInfoButtonAction() {
        infoLabel.isHidden = true
        dateDescriptionLabel.isHidden = true
        infoTimeLabel.isHidden = true
        statusLabel.isHidden = true
        arrowToOrderImageView.isHidden = true
        arrowSecondToOrderImageView.isHidden = true
        separatorSixthView.isHidden = true
        separatorSeventhView.isHidden = true
        hideInfoButton.removeFromSuperview()
        hideLabel.removeFromSuperview()
        hideImageView.removeFromSuperview()
        
        ordersStackView.removeFromSuperview()
        
        moreInfoButton.snp.remakeConstraints {
            $0.top.equalTo(separatorThirdView)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        moreLabel.isHidden = false
        moreImageView.isHidden = false
        moreInfoButton.isUserInteractionEnabled = true
        if let indexPath = indexPathofCell {
            delegateTable?.onClickExpandCollapse(isMoreExpanded: false, indexPath: indexPath.row)
        }
        delegateTable?.reloadTable()
    }
}

//MARK: - Activity

extension PetSittingRequestTableViewCell {
    private func showActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        }
        activityView?.center = self.center
        self.addSubview(activityView!)
        activityView?.startAnimating()
    }

    private func hideActivityIndicator() {
        activityView?.stopAnimating()
    }
}
