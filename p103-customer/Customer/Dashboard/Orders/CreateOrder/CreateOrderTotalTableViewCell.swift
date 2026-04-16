//
//  CreateOrderTotalTableViewCell.swift
//  p103-customer
//
//  Created by Daria Pr on 09.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class CreateOrderTotalTableViewCell: UITableViewCell {

    //MARK: - UIProperties
    
    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let dogImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.belt()
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
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        return stack
    }()
    
    //MARK: - Properties
    
    weak var calendarViewDelegate: CalendarViewDelegate?
    
    private var x = 15
    private var y = 10
    
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
        
        setupFirstPartOfLayout()
        setupSecondPartOfLayout()
        viewCalendarButton.addTarget(self, action: #selector(viewCalendarButtonAction), for: .touchUpInside)
        
        typeWalksLabel.text = OrderManager.shared.service
    }
    
    //MARK: - Setup Layout
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
         self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func setupFirstPartOfLayout() {
        
        addSubviews([mainStackView, separatorView, dogImageView, typeWalksLabel, dateLabel])
        
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
                
        for i in 0..<OrderManager.shared.nameOfPet.count {
            let element = OrderManager.shared.nameOfPet[i]
            let photoElement = OrderManager.shared.imageOfPet[i]
            
            let labelNum = UILabel()
            labelNum.textColor = .color070F24
            labelNum.font = R.font.aileronBold(size: 18)
            labelNum.text = element

            let image = UIImageView()
            image.layer.masksToBounds = true
            image.layer.cornerRadius = 5
            if photoElement != "-" {
                image.sd_setImage(with: URL(string: photoElement))
            }
            
            mainStackView.addSubviews([image, labelNum])

            if i % 3 == 0 && i != 0 {
                y += 50
                x = 10
            }
            
            if i == OrderManager.shared.nameOfPet.count - 1 {
                image.snp.makeConstraints {
                    $0.size.equalTo(30)
                    $0.top.equalToSuperview().offset(y)
                    $0.left.equalToSuperview().offset(x)
                    $0.bottom.equalToSuperview()
                }
                
                labelNum.snp.makeConstraints {
                    $0.top.equalToSuperview().offset(y)
                    $0.left.equalTo(image.snp.right).offset(5)
                }
            } else {
                image.snp.makeConstraints {
                    $0.size.equalTo(30)
                    $0.top.equalToSuperview().offset(y)
                    $0.left.equalToSuperview().offset(x)
                }
                labelNum.snp.makeConstraints {
                    $0.top.equalToSuperview().offset(y)
                    $0.left.equalTo(image.snp.right).offset(5)
                }
            }
            x += 120
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
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
            $0.right.equalToSuperview().offset(-25)
        }
    }
    
    func setupSecondPartOfLayout() {
        addSubviews([separatorSecondView, calendarLabel, arrowImageView, separatorThirdView, viewCalendarButton, timeStackView, horizontalSeparatorView, horizontalSecondSeparatorView])
        
        timeStackView.addArrangedSubviews(views: morningLabel, afternoonLabel, eveningLabel)
        
        separatorSecondView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(15)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
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
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
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
            $0.left.equalTo(morningLabel.snp.right).offset(24)
        }
        
        horizontalSecondSeparatorView.snp.makeConstraints {
            $0.width.equalTo(1)
            $0.height.equalTo(42)
            $0.top.equalTo(separatorThirdView.snp.bottom)
            $0.left.equalTo(afternoonLabel.snp.right).offset(24)
            $0.bottom.equalToSuperview()
        }
        
        horizontalSeparatorView.isHidden = true
        horizontalSecondSeparatorView.isHidden = true
    }
}

//MARK: - Action

extension CreateOrderTotalTableViewCell {
    @objc func viewCalendarButtonAction() {
        calendarViewDelegate?.tapOnCalendarCell()
    }
}

//MARK: - Public func: setup cells

extension CreateOrderTotalTableViewCell {
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
