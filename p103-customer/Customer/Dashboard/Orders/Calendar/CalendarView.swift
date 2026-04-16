//
//  CalendarView.swift
//  VonderApp
//
//  Created by Anton Boss on 21.01.2021.
//  Copyright © 2021 Anton Yanko. All rights reserved.
//

import UIKit
import FSCalendar

@objc protocol CalendarDelegate: AnyObject {
    func dateChanged()
}

class CalendarView: UIView {
    // MARK: - Properties
    
    private let viewModel = CalendarViewModel()
//    var calendarView : FSCalendar!
    var tapOnCalendarDay: ((_ checkInDate: Date?, _ checkOutDate: Date?) -> ())?
    
    // MARK: - UI Properties

    private let mainView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.cornerRadius = 8
        view.borderColor = UIColor.white
        view.borderWidth = 1
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubviews([previousMonthButton, titleLabel, nextMonthButton])
        
        previousMonthButton.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        nextMonthButton.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(10)
        }
                
        return view
    }()
    
    private let previousMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.arrowBackCalendarButton(), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(previousMonthButtonAction), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .color606572
        label.font = R.font.aileronBold(size: 18)
        return label
    }()
    
    private let nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.calendarArrowButton(), for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(nextMonthButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear

        collectionView.register(CalendarDayCollectionViewCell.self)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView")
        
        return collectionView
    }()
    
    //MARK: - Properties
    
    weak var delegate: CalendarDelegate?
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupActions()
        updateData()
//        setCalendar()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup Layout
    
    private func setupLayout() {
        addSubview(mainView)
        mainView.addSubviews([headerView, calendarCollectionView])
        
        mainView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(5)
        }
        
        headerView.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.left.top.right.equalToSuperview()
        }
        
        calendarCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(15)
        }
    }
    
    private func setupActions() {
        viewModel.tapOnCalendarDay = { [weak self] in
            self?.tapOnCalendarDay?(self?.viewModel.checkInDate, self?.viewModel.checkOutDate)
            self?.updateData()
        }
    }
    
    @objc func previousMonthButtonAction() {

        self.updateData()
    }
    
    @objc func nextMonthButtonAction() {

        self.updateData()
    }
    
    // MARK: - Private Methods
    
    private func updateData() {
//        titleLabel.text = viewModel.startDateOfSelectedMonth?.toString(format: "MMM, yyyy")
        
        if viewModel.checkInDate != nil {
            OrderManager.shared.startedDate = viewModel.checkInDate
            OrderManager.shared.endedDate = viewModel.checkOutDate
            OrderManager.shared.typeOfCalendar = "range"
        } else {
            OrderManager.shared.startedDate = viewModel.copyCheckInDate
            OrderManager.shared.endedDate = viewModel.copyCheckOutDate
            OrderManager.shared.typeOfCalendar = "separated"
        }

        delegate?.dateChanged()
        calendarCollectionView.reloadData()
    }
    
    // MARK: - Public Methods
    
    func updateMinimalStateMonths(_ minimalState: Int) {
        viewModel.minimalStateMonths = minimalState
    }
    
    func updateDates(_ checkInDate: Date?, _ checkOutDate: Date?) {
        viewModel.checkInDate = checkInDate
        viewModel.checkOutDate = checkOutDate
//        viewModel.rebuildCalendarData()
        viewModel.tapOnCalendarDay?()
    }
    
    func updateSeparatedDates() {
//        viewModel.rebuildSeparatedCalendarData()
        viewModel.tapOnCalendarDay?()
    }
    
    func scrollCalendar() {
        previousMonthButton.isUserInteractionEnabled = true
        nextMonthButton.isUserInteractionEnabled = true
        calendarCollectionView.isUserInteractionEnabled = false
    }
}
