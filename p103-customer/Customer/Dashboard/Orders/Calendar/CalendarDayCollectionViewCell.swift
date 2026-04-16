//
//  CalendarDayCollectionViewCell.swift
//  VonderApp
//
//  Created by Anton Boss on 21.01.2021.
//  Copyright © 2021 Anton Yanko. All rights reserved.
//

import UIKit

class CalendarDayCollectionViewCell: UICollectionViewCell {
    
    private(set) var calendarDay: CalendarDay!
    
    // MARK: UI Properties
    
    private let roseView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.calendarRangeColor()
        view.cornerRadius = 5
        return view
    }()
    
    private let selectedDayView: UIView = {
        let view = UIView()
        view.cornerRadius = 14
        view.backgroundColor = R.color.calendarSelectDayColor()
        return view
    }()
    
    private let dayNumberLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 12)
        return label
    }()
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Setup Methods
    
    private func setupLayout() {
        contentView.clipsToBounds = true
        contentView.addSubviews([roseView, selectedDayView, dayNumberLabel])

        selectedDayView.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.center.equalTo(dayNumberLabel)
        }
        
        dayNumberLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    // MARK: - Private Methods
    
    private func updateRoseView() {
        let isNeedToRemoveRoseViewOnLeftSide = calendarDay.isStartDateOfMonth || calendarDay.date.weekdayNumberOfDay() == 1
        
        let isNeedToRemoveRoseViewOnRightSide = calendarDay.isEndOfMonth || calendarDay.date.weekdayNumberOfDay() == 7
        
        roseView.isHidden = !(calendarDay.isSelected && calendarDay.isDayActive) || calendarDay.isCheckIn && isNeedToRemoveRoseViewOnRightSide || calendarDay.isCheckOut && isNeedToRemoveRoseViewOnLeftSide
        
        if roseView.isHidden { return }
        
        if !calendarDay.isRange {

        roseView.snp.remakeConstraints {
            $0.height.equalTo(24)
            $0.centerY.equalToSuperview()
                if calendarDay.isCheckIn {
                    $0.left.equalTo(contentView.snp.centerX)
                    $0.right.equalToSuperview().inset(-5)
                } else if calendarDay.isCheckOut {
                    $0.left.equalToSuperview().inset(-5)
                    $0.right.equalTo(contentView.snp.centerX)
                } else if isNeedToRemoveRoseViewOnLeftSide && isNeedToRemoveRoseViewOnRightSide {
                    $0.left.equalTo(selectedDayView)
                    $0.right.equalTo(selectedDayView)
                } else if isNeedToRemoveRoseViewOnLeftSide {
                    $0.left.equalTo(selectedDayView)
                    $0.right.equalToSuperview().inset(-5)
                } else if isNeedToRemoveRoseViewOnRightSide {
                    $0.left.equalToSuperview().inset(-5)
                    $0.right.equalTo(selectedDayView)
                } else {
                    $0.left.right.equalToSuperview().inset(-5)
                }
            }
        }
    }
    
    // MARK: - Public Methods
    
    func configure(_ calendarDay: CalendarDay) {
        self.calendarDay = calendarDay
        dayNumberLabel.text = calendarDay.date.toString(format: "d")
        selectedDayView.isHidden = !((calendarDay.isCheckIn || calendarDay.isCheckOut) && calendarDay.isDayActive)

        if (calendarDay.isCheckIn || calendarDay.isCheckOut) && calendarDay.isDayActive {
            dayNumberLabel.textColor = .white
        } else if (calendarDay.isRange || calendarDay.isRecoveryRange) && calendarDay.isSelected == false {
            if calendarDay.isClick {
                selectedDayView.isHidden = true
                dayNumberLabel.textColor = .color293147
            } else {
                selectedDayView.isHidden = false
                dayNumberLabel.textColor = .white
            }
        } else if calendarDay.isRecoveryRange && calendarDay.isSelected {
            selectedDayView.isHidden = true
            dayNumberLabel.textColor = .color293147
        } else {
            dayNumberLabel.textColor = calendarDay.isDayActive ? .color293147 : .colorAAABAE
        }
        updateRoseView()
    }
}
