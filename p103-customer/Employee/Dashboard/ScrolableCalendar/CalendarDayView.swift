//
//  CalendarDayView.swift
//  p103-customer
//
//  Created by Daria Pr on 28.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class CalendarDayView: UIView {
  
    //MARK: - UIProperties
    
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
        view.addSubviews([previousMonthButton, monthLabel, nextMonthButton])
        previousMonthButton.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
        }
        
        monthLabel.snp.makeConstraints {
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
        button.isHidden = true
        return button
    }()
    
    private let monthLabel: UILabel = {
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
    
    private lazy var datesСollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        let width = UIScreen.main.bounds.width / 4
        let height = UIScreen.main.bounds.height / 10
        layout.itemSize = CGSize(width: width, height: 20)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = viewModel
        collectionView.dataSource = viewModel
//        collectionView.backgroundColor = .orange
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DateChooserCollectionViewCell.self)
        return collectionView
    } ()
    
    //MARK: - Properties
    
    private var currentMonthInRange = Date()
    private var currentMonth = 0
    private var currentYear = 0
    
    weak var delegate: DayConfirmedDelegate?
    
    private let date = Date()
        
    let calendar = Calendar.current
    private let viewModel = CalendarDayViewModel()
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        viewModel.delegate = self
        
        monthLabel.text = viewModel.currentMonth()
        
//        viewModel.calendarArray = datesRange(from: date, to: date.endOfMonth)
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, yyyy"
        monthLabel.text = dateFormatter.string(from: date)

        let month = calendar.component(.month, from: date)
        currentMonth = month
        
        let year = calendar.component(.year, from: date)
        currentYear = year
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup Layout
    
    private func setupLayout() {
        addSubview(mainView)
        mainView.addSubviews([headerView, datesСollectionView])
        
        mainView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(5)
        }

        headerView.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.left.top.right.equalToSuperview()
        }
        
        datesСollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        self.setDefaultSelection()
    }
    
    func setDefaultSelection() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        for i in viewModel.calendarArray {
            viewModel.calendarDayDict[i] = false
        }
        viewModel.calendarDayDict[viewModel.calendarArray[0]] = true
        viewModel.delegate?.get(day: viewModel.calendarArray[0])
        self.datesСollectionView.reloadData()
        
        viewModel.checkState(date: viewModel.calendarArray[0])
        self.datesСollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
}

//MARK: - Actions

extension CalendarDayView {
    @objc func previousMonthButtonAction() {
        let previousMonth = getPreviousMonth(date: currentMonthInRange)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, yyyy"
        monthLabel.text = dateFormatter.string(from: previousMonth)
        currentMonthInRange = previousMonth
        
        let previousMonthDate = whatMonthIs(date: previousMonth.firstDayOfTheMonth)
        let previousYearDate = whatYearIs(date: previousMonth.firstDayOfTheMonth)
        
        if previousMonthDate == currentMonth && previousYearDate == currentYear {
            previousMonthButton.isHidden = true
            viewModel.calendarArray = datesRange(from: date, to: previousMonth.endOfMonth)
        } else {
            viewModel.calendarArray = datesRange(from: previousMonth.firstDayOfTheMonth, to: previousMonth.endOfMonth)
        }
        datesСollectionView.reloadData()
    }
    
    @objc func nextMonthButtonAction() {
        let nextMonth = getNextMonth(date: currentMonthInRange)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, yyyy"
        monthLabel.text = dateFormatter.string(from: nextMonth)
        currentMonthInRange = nextMonth
        
        let nextMonthDate = whatMonthIs(date: nextMonth.firstDayOfTheMonth)
        let nextYearDate = whatYearIs(date: nextMonth.firstDayOfTheMonth)
        
        if nextMonthDate == currentMonth && nextYearDate == currentYear {
            viewModel.calendarArray = datesRange(from: date, to: nextMonth.endOfMonth)
        } else {
            viewModel.calendarArray = datesRange(from: nextMonth.firstDayOfTheMonth, to: nextMonth.endOfMonth)
        }
        
        previousMonthButton.isHidden = false
        datesСollectionView.reloadData()
    }
    
    func whatMonthIs(date: Date) -> Int {
        let month = calendar.component(.month, from: date)
        
        return month
    }
    
    func whatYearIs(date: Date) -> Int {
        let year = calendar.component(.year, from: date)
        
        return year
    }
    
    func getNextMonth(date:Date)->Date {
        return Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }

    func getPreviousMonth(date:Date)->Date {
        return Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    
    func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        
        var tempDate = from
        var array = [tempDate]
        
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        array.removeLast()
//        print("Array is\(array)")
        return array
    }
}

//MARK: - Additional func for changing month

extension CalendarDayView {
    func setupCalendarForChanging(_ month: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, yyyy"
        monthLabel.text = dateFormatter.string(from: month)
        viewModel.currentMonthInRange = month
        
        let currentMonth = getCurrentMonth()
        let needToSetMonth = dateFormatter.string(from: month)
        
        viewModel.calendarArray = viewModel.datesRange(from: month.firstDayOfTheMonth, to: month.endOfMonth)
        if let cellCurrent = datesСollectionView.cellForItem(at: viewModel.selectedIndex) as? DateChooserCollectionViewCell {
            
            cellCurrent.setupUnhighlighted()
        }
        datesСollectionView.reloadData()
        if currentMonth == needToSetMonth {
            if let day = Int(viewModel.currentDay) {
                let index = IndexPath(row: day - 1, section: 0)
                self.datesСollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            }
        } else {
            datesСollectionView.resetScrollPositionToTop()
        }
       
    }
    
    func getCurrentMonth() -> String {
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, yyyy"
        return dateFormatter.string(from: now)
    }
}

//MARK: - CalendarDayDelegate

extension CalendarDayView: CalendarDayDelegate {
    func reloadDates() {
        datesСollectionView.reloadData()
    }
    
    func get(day: Date) {
        delegate?.get(date: day)
    }
}
