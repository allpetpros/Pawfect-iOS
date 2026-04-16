//
//  CalendarViewModel.swift
//  VonderApp
//
//  Created by Anton Boss on 21.01.2021.
//  Copyright © 2021 Anton Yanko. All rights reserved.
//

import UIKit
import FSCalendar

// MARK: - CalendarDay
struct CalendarDay {
    let date: Date
    let isSelected: Bool
    let isDayActive: Bool
    let isCheckIn: Bool
    let isCheckOut: Bool
    let isStartDateOfMonth: Bool
    let isEndOfMonth: Bool
    let isRange: Bool
    let isRecoveryRange: Bool
    let isClick: Bool
}

// MARK: - CalendarViewModel

class CalendarViewModel: NSObject {
    
    private let cellHeight: CGFloat = 28
    private let headerHeight: CGFloat = 40
    private let lineSpacing: CGFloat = 3
    private let totalDaysCount = 42
    private let date = Date()
    let currentDay = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
//    private let currentDay = Date() + TimeInterval(TimeZone.current.secondsFromGMT())
    private let headerData = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    
    private var isRange = false
    private var isRecoveryRange = false
    private var isClick = false
    private var isDestroyed = false
    private var isAbilityToCreateRange = true
    
    private var destroyedDate = Date()
    
    private var selectedDatesArr = [Date]()
    
    private var calendarDatesDictionary = [Date: Bool]()
    
    private var calendarData = [CalendarDay]()
//    var calendarView : FSCalendar!
    var format = "MMMM yyyy"
//    var arrData : [(title:String,data:[MyCalendarFields])] = []
    
    var copyCheckInDate: Date?
    var copyCheckOutDate: Date?
    
    var arraySeparated = [Date]()
    
    var tapOnCalendarDay: (() -> ())?
    var minimalStateMonths = 0
    var checkInDate: Date?
    var checkOutDate: Date?
    
    // MARK: - Inits
    
    override init() {
        super.init()

//        rebuildCalendarData()
//
//        initCalendarDictionary()
    }
    
    // MARK: - Private Methods
    
//    private func updateCheckInOutDatesIfNeeded(_ date: Date) {
//
//        if checkOutDate != nil && checkInDate != nil {
//            setupRange(date: date)
//        } else if checkOutDate != nil {
//            if !date.isDayEquals(to: checkOutDate) {
//                checkInDate = nil
//            }
//            checkOutDate = nil
//        } else if checkInDate != nil {
//            if date.isDayEquals(to: checkInDate) {
//                checkInDate = nil
//                clearRange()
//            } else {
//                checkOutDate = date
//                isAbilityToCreateRange = false
//            }
//        } else if date == destroyedDate {
//            if copyCheckInDate == nil {
//                checkInDate = OrderManager.shared.copySeparatedDates.min()
//                checkOutDate = OrderManager.shared.copySeparatedDates.max()
//            } else {
//                checkOutDate = copyCheckOutDate
//                checkInDate = copyCheckInDate
//            }
//            isDestroyed = true
//        } else {
//            if isAbilityToCreateRange {
//                for i in calendarData {
//                    if date == i.date {
//                            if (!i.isRange && i.isRecoveryRange) || (i.isRange && !i.isRecoveryRange) {
//                            refillCalendarDictionary(date: date)
//                        } else {
//                            checkInDate = date
//                            monthShiftFromCurrentDayToSelectedMonth += minimalStateMonths
//                        }
//                    }
//                }
//            } else {
//                for i in calendarData {
//                    if date == i.date {
//                        if (!i.isRange && i.isRecoveryRange) || (i.isRange && !i.isRecoveryRange) {
//                            refillCalendarDictionary(date: date)
//                        }
//                    }
//                }
//            }
//        }
//        rebuildCalendarData()
//    }
    
//    func setupRange(date: Date) {
//
//        copyCheckInDate = checkInDate
//        copyCheckOutDate = checkOutDate
//        if date.isDayEquals(to: checkInDate) || date.isDayEquals(to: checkOutDate) {
//            clearRange()
//        } else {
//            if date == destroyedDate {
//                selectedDatesArr = []
//                if date.isDayEqualsOrLess(to: checkOutDate) {
//                    for i in calendarData {
//                        if date == i.date {
//                            if !i.isRange {
//                                OrderManager.shared.startedDate = copyCheckInDate
//                                OrderManager.shared.endedDate = copyCheckOutDate
//                                refillRangeCalendarArr(date: date)
//                                checkOutDate = nil
//                                checkInDate = nil
//                                destroyedDate = date
//                                isDestroyed = true
//                                isAbilityToCreateRange = false
//                                rebuildCalendarData()
//                            }
//                        }
//                    }
//                }
//            }
//
//            if date.isDayEqualsOrLess(to: checkInDate) {
//                checkInDate = date
//            } else if date.isDayEqualsOrGreater(to: checkOutDate) {
//                checkOutDate = date
//            } else if date.isDayEqualsOrLess(to: checkOutDate) {
//                if selectedDatesArr.count == 0 {
//                    for i in calendarData {
//                        if date == i.date {
//                            if !i.isRange {
//                                refillRangeCalendarArr(date: date)
//                                checkOutDate = nil
//                                checkInDate = nil
//                                destroyedDate = date
//                                rebuildCalendarData()
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
//    func clearRange() {
//        checkInDate = nil
//        copyCheckInDate = nil
//        checkOutDate = nil
//        copyCheckOutDate = nil
//        selectedDatesArr = []
//        isDestroyed = false
//        isAbilityToCreateRange = true
//        OrderManager.shared.copySeparatedDates = []
//        calendarDatesDictionary.removeAll()
//        for i in calendarData {
//            calendarDatesDictionary[i.date] = false
//        }
//    }
    
    func refillRangeCalendarArr(date: Date) {

    }
    
    func refillCalendarDictionary(date: Date) {
    }
    

    
    private func setupDictionaryForRebuildCalendarData(day: Date) {
        
        for (value, key) in calendarDatesDictionary {
            print("Value",value)
            print("Key",key)
            
            if value == day {
                if key == true {
                    isClick = true
                    break
                } else {
                    isClick = false
                    break
                }
            }
        }
    }
    
    private func setupSeparatedView(date: Date) {
        
        for i in OrderManager.shared.dates {
            let dateConvert = Date(timeIntervalSince1970: Double(i))
            if dateConvert == date {
                isRange = true
                isRecoveryRange = false
                isClick = false
            }
        }
    }
    
    private func setupArrForRebuildCalendarData(day: Date) {
        
        for j in selectedDatesArr {
            if day == j {
                if isDestroyed {
                    isRecoveryRange = true
                } else {
                    isRange = true
                }
                break
            }
        }
    }
    
    // MARK: - Public Methods
    
//    func rebuildCalendarData() {
//
//        guard let startDateOfMonth = startDateOfSelectedMonth else { return }
//        guard let endDateOfMonth = startDateOfMonth.endDateOfMonth else { return }
//        let daysCountOfPreviousMonth = startDateOfMonth.weekdayNumberOfDay() - 1
//        let xorForCheckInOutDates = (checkInDate == nil && checkOutDate == nil || checkInDate != nil && checkOutDate != nil)
//
//        calendarData = []
//        OrderManager.shared.separatedDates = []
//
//        for i in 0..<totalDaysCount {
//            guard let day = startDateOfMonth.date(byAdding: .day, i - daysCountOfPreviousMonth) else { continue }
//
//            setupDictionaryForRebuildCalendarData(day: day)
//            setupArrForRebuildCalendarData(day: day)
//
//            let isSelected = day.isDayEqualsOrGreater(to: checkInDate) && day.isDayEqualsOrLess(to: checkOutDate)
//            let isCheckIn = day.isDayEquals(to: checkInDate)
//            let isCheckOut = day.isDayEquals(to: checkOutDate)
//            let isDayActive = startDateOfMonth.isMonthEquals(to: day) && (currentDay.isDayEqualsOrLess(to: day) && xorForCheckInOutDates || day.isDayEqualsOrGreater(to: minimalCheckOutDate) || isCheckIn || isCheckOut)
//
//            let calendarDay = CalendarDay(date: day, isSelected: isSelected, isDayActive: isDayActive, isCheckIn: isCheckIn, isCheckOut: isCheckOut, isStartDateOfMonth: day.isDayEquals(to: startDateOfMonth), isEndOfMonth: day.isDayEquals(to: endDateOfMonth), isRange: isRange, isRecoveryRange: isRecoveryRange, isClick: isClick)
//
//            if calendarDay.isSelected == false && calendarDay.isRange && calendarDay.isRecoveryRange == false && calendarDay.isClick == false {
//                OrderManager.shared.separatedDates.insert(calendarDay.date)
//            }
//
//            calendarData.append(calendarDay)
//            isRange = false
//            isRecoveryRange = false
//            isClick = false
//        }
//
//        if OrderManager.shared.separatedDates.isEmpty {
//            copyCheckInDate = OrderManager.shared.copySeparatedDates.min()
//            copyCheckOutDate = OrderManager.shared.copySeparatedDates.max()
//        } else {
//            OrderManager.shared.copySeparatedDates = OrderManager.shared.separatedDates
//            copyCheckInDate = OrderManager.shared.copySeparatedDates.min()
//            copyCheckOutDate = OrderManager.shared.copySeparatedDates.max()
//        }
//    }
    
//    func rebuildSeparatedCalendarData() {
//        guard let startDateOfMonth = startDateOfSelectedMonth else { return }
//        guard let endDateOfMonth = startDateOfMonth.endDateOfMonth else { return }
//        let daysCountOfPreviousMonth = startDateOfMonth.weekdayNumberOfDay() - 1
//        let xorForCheckInOutDates = (checkInDate == nil && checkOutDate == nil || checkInDate != nil && checkOutDate != nil)
//
//        calendarData = []
//        OrderManager.shared.separatedDates = []
//
//        for i in 0..<totalDaysCount {
//            guard let day = startDateOfMonth.date(byAdding: .day, i - daysCountOfPreviousMonth) else { continue }
//
//            setupSeparatedView(date: day)
//
//            let isSelected = day.isDayEqualsOrGreater(to: checkInDate) && day.isDayEqualsOrLess(to: checkOutDate)
//            let isCheckIn = day.isDayEquals(to: checkInDate)
//            let isCheckOut = day.isDayEquals(to: checkOutDate)
//            let isDayActive = startDateOfMonth.isMonthEquals(to: day) && (currentDay.isDayEqualsOrLess(to: day) && xorForCheckInOutDates || day.isDayEqualsOrGreater(to: minimalCheckOutDate) || isCheckIn || isCheckOut)
//
//            let calendarDay = CalendarDay(date: day, isSelected: isSelected, isDayActive: isDayActive, isCheckIn: isCheckIn, isCheckOut: isCheckOut, isStartDateOfMonth: day.isDayEquals(to: startDateOfMonth), isEndOfMonth: day.isDayEquals(to: endDateOfMonth), isRange: isRange, isRecoveryRange: isRecoveryRange, isClick: isClick)
//
//            if calendarDay.isSelected == false && calendarDay.isDayActive && calendarDay.isRange && calendarDay.isRecoveryRange == false && calendarDay.isClick == false {
//                OrderManager.shared.separatedDates.insert(calendarDay.date)
//            }
//
//            calendarData.append(calendarDay)
//            isRange = false
//            isRecoveryRange = false
//            isClick = false
//        }
//    }
    
//    func setCalendar(){
//        
//        
//        self.calendarView = FSCalendar(frame: .zero)
////        self.bgCal.addSubview(self.calendarView)
////        self.calendarView.fillSuperView()
//        
////        self.calendarView.delegate = self
////        self.calendarView.dataSource = self
//        self.calendarView.appearance.titlePlaceholderColor = .clear
//        self.calendarView.headerHeight = 0
//        self.calendarView.appearance.weekdayTextColor = .blue
//        self.calendarView.allowsMultipleSelection = true
////        self.calendarView.appearance.weekdayFont = systemFont(ofSize: 18)
////        self.calendarView.appearance.titleFont = ystemFont(ofSize: 16)
//        self.calendarView.appearance.todaySelectionColor = .black
//        self.calendarView.appearance.todayColor = .clear
//        self.calendarView.appearance.titleTodayColor = .black
//        self.calendarView.appearance.titleSelectionColor = .brown
//        self.calendarView.appearance.selectionColor = .orange
//        self.calendarView.appearance.eventDefaultColor = .red
//        self.calendarView.appearance.eventSelectionColor = .blue
//        
//        self.calendarView.select(Date(), scrollToDate: true)
//    }
}

//extension CalendarViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    // MARK: - UICollectionViewDataSource
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return calendarData.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeue(CalendarDayCollectionViewCell.self, for: indexPath) else { return UICollectionViewCell() }
//        cell.configure(calendarData[indexPath.row])
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//
//        view.addSubview(stackView)
//
//        stackView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//
//        for i in 0..<headerData.count {
//            let label = UILabel()
//            label.text = headerData[i]
//            label.textAlignment = .center
//            label.textColor = .colorAAABAE
//            label.font = R.font.aileronBold(size: 12)
//            stackView.addArrangedSubview(label)
//        }
//
//        return view
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarDayCollectionViewCell else { return }
//        if !cell.calendarDay.isDayActive {
//            return
//        }
//        updateCheckInOutDatesIfNeeded(cell.calendarDay.date)
//        tapOnCalendarDay?()
//    }
//
//    // MARK: - UICollectionViewDelegateFlowLayout
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: collectionView.frame.width, height: headerHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let daysInWeek: CGFloat = 7
//        return CGSize(width: collectionView.frame.width / daysInWeek, height: cellHeight)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return lineSpacing
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return -1
//    }
//}

//MARK: - Additional func for dates and dictionary

extension CalendarViewModel {
//    func datesRange(from: Date, to: Date) -> [Date] {
//        if from > to { return [Date]() }
//        
//        var tempDate = from
//        var array = [tempDate]
//        
//        while tempDate < to {
//            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
//            array.append(tempDate)
//        }
//        
//        return array
//    }
//    
//    func changeValueDict(dict:[Date:Bool], value: Date, key: Bool)->[Date:Bool] {
//        var mutatedDict = dict
//        mutatedDict[value] = key
//        return mutatedDict
//    }
}



