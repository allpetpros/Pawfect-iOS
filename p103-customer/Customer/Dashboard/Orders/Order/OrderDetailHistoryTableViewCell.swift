//
//  OrderDetailHistoryTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 16.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import Cosmos

class OrderDetailHistoryTableViewCell: UITableViewCell {
    
    //MARK: - UIProperties
    private let orderDateLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronSemiBold(size: 16)
        l.textColor = .color606572
        return l
    } ()
    
    private let meetAndGreetImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    } ()
 
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    let bgView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    } ()
    
    private let petImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    } ()
    
    private let petNameLabel: UILabel = {
        let l = UILabel()
        l.text = "Fluffy"
        l.textColor = .color070F24
        l.font = R.font.aileronBold(size: 18)
        return l
    } ()
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let statusLabel: UILabel = {
        let l = UILabel()
        l.text = "completed"
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = R.color.statusConfirmedColor()
        return l
    } ()
    
    private let dogWalksLabel: UILabel = {
        let l = UILabel()
        l.text = "Dog Walks"
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let dogWalksImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.belt()
        return iv
    } ()
    
    private let viewSummaryButton: UIButton = {
        let b = UIButton()
        b.setTitle("View Summary Details", for: .normal)
        b.setTitleColor(.color860000, for: .normal)
        b.titleLabel?.font = R.font.aileronBold(size: 12)
        return b
    } ()
    private let middleStatckView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private let rejectionReasonLabel: UILabel = {
        let l = UILabel()
        l.text = "No Data"
        l.textColor = .color860000
        l.font = R.font.aileronBold(size: 12)
        return l
    } ()
    
    private let separatorSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let horizontalSeparatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let infoTimeLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.text = "17:00 - 17:30"
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let customerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.profile_test()
        return iv
    } ()
    
    private let employeeNameLabel: UILabel = {
        let l = UILabel()
        l.text = "James"
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    let rateEmployeeButton: UIButton = {
        let b = UIButton()
        b.setTitle("Rate Employee", for: .normal)
        b.setTitleColor(R.color.statusConfirmedColor(), for: .normal)
        b.titleLabel?.font = R.font.aileronRegular(size: 16)
        return b
    } ()
    
//MARK: - UIProperties
    private let raitingView = CosmosView()
    var rowIndex: Int?
    weak var delegateRate: HistoryRateDelegate?
    var currentHistoryId: String?
    var employeeId: String?
    
    var historyData: Histories?
    
//MARK: - Lifecycle

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectionStyle = .none
        setDateLabel()
        setupLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.rateEmployeeButton.isUserInteractionEnabled = true
    }
    
//MARK: - Setup Layout
    
    override func layoutSubviews() {
         super.layoutSubviews()
        self.setupLayout()
        
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
    func setupLayout() {
        addSubviews([stackView, separatorView, statusLabel, dogWalksLabel, dogWalksImageView, separatorSecondView])
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(orderDateLabel.snp.bottom).offset(35)
            $0.left.equalToSuperview().offset(20)
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
            $0.top.equalTo(stackView.snp.bottom).offset(10)
        }
        
        dogWalksImageView.tintColor = UIColor.black
        
        dogWalksImageView.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(14)
            $0.left.equalToSuperview().offset(25)
            $0.top.equalTo(separatorView.snp.bottom).offset(7)
        }
        
        dogWalksLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(7)
            $0.left.equalTo(dogWalksImageView.snp.right).offset(10)
        }
        
        separatorSecondView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(dogWalksLabel.snp.bottom).offset(10)
        }
       
        setupFooterOfCell()
    }
    
    func setupFooterOfCell() {
        middleStatckView.addArrangedSubviews(views: viewSummaryButton,rejectionReasonLabel)
        addSubviews([middleStatckView, horizontalSeparatorView, infoTimeLabel, customerImageView, employeeNameLabel, raitingView, rateEmployeeButton])
        rateEmployeeButton.addTarget(self, action: #selector(rateEmployeeAction), for: .touchUpInside)
        viewSummaryButton.addTarget(self, action: #selector(viewSummaryAction), for: .touchUpInside)
        viewSummaryButton.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(3)
            $0.left.equalTo(dogWalksLabel.snp.right).offset(29)
        }
        
        infoTimeLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(18)
            $0.left.equalToSuperview().offset(16)
        }
        
        horizontalSeparatorView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(42)
            $0.top.equalTo(separatorSecondView.snp.bottom)
            $0.left.equalTo(infoTimeLabel.snp.right).offset(7)
        }
        
        customerImageView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(10)
            $0.left.equalTo(horizontalSeparatorView.snp.right).offset(15)
        }
        
        
        
        rateEmployeeButton.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-15)

        }
        
        employeeNameLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(7)
            $0.width.equalTo(60)
            $0.right.equalTo(rateEmployeeButton.snp.left)
            $0.left.equalTo(customerImageView.snp.right).offset(13)
        }
        
        raitingView.settings.starSize = 8
        raitingView.snp.makeConstraints {
            $0.leading.equalTo(employeeNameLabel)
            $0.top.equalTo(employeeNameLabel.snp.bottom).offset(1)
            $0.width.equalTo(20)
            $0.height.equalTo(15)
            $0.bottom.equalToSuperview().offset(-20)
        }
        
        
        
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
}

//MARK: - Actions

extension OrderDetailHistoryTableViewCell {
    
    @objc func rateEmployeeAction() {
        
        delegateRate?.toRateScreen(rowIndex: rowIndex ?? 0)
    }
    
    @objc func viewSummaryAction() {
        delegateRate?.toSummaryDetailsScreen(rowIndex: self.rowIndex ?? 0)
    }
}

//MARK: - Public method: setup cell

extension OrderDetailHistoryTableViewCell {
    func historySetUp(pets: [PetsId], history: Histories) {
        orderDateLabel.text = getDate(date: history.timeFrom)
        statusLabel.text = history.status
        let timeFrom = CommonFunction.shared.toDate(millis: Int64(history.timeFrom))
        let timeTo = CommonFunction.shared.toDate(millis: Int64(history.timeTo))
        infoTimeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) : \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
        dogWalksLabel.text = history.service.title
        raitingView.rating = history.employee?.rating ?? 0.0 
        currentHistoryId = history.id
        employeeId = history.employee?.id
        if let name = history.employee?.name {
            employeeNameLabel.text = "\(name)"
        }
        if let avatar = history.employee?.imageUrl {
            customerImageView.sd_setImage(with: URL(string: avatar))
        }
        
        if history.reason == nil {
            rejectionReasonLabel.isHidden = true
            
        } else {
            rejectionReasonLabel.isHidden = false
            rejectionReasonLabel.text = history.reason
        }
        
        if history.employee == nil {
            rateEmployeeButton.isHidden = true
            viewSummaryButton.isHidden = true
            
            customerImageView.isHidden = true
            employeeNameLabel.isHidden = true
            raitingView.isHidden = true
        } else  {
            rateEmployeeButton.isHidden = false
            viewSummaryButton.isHidden = false
            customerImageView.isHidden = false
            employeeNameLabel.isHidden = false
            raitingView.isHidden = false
        }
        
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0);$0.removeFromSuperview() }
        switch history.status {
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
            }
            if pets[i].imageUrl == nil {
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
                }
                if pets[i].imageUrl == nil {
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
    
    func getDate(date: Int) -> String {
        let date = CommonFunction.shared.fromMillisToDate(millis: Double(date))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"

        let historyDate = dateFormatter.string(from: date)
        return historyDate
    }
}
