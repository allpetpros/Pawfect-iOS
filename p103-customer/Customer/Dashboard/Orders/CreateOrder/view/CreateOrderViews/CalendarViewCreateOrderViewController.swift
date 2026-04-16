//
//  CalendarViewCreateOrderViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 12.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewCreateOrderViewController: BaseViewController {

    //MARK: - UIProperties
   
    private lazy var calendarView: FSCalendar = {
        let vwCalander = FSCalendar()
        return vwCalander
    
    } ()
    
    private let alertBoxImageView: UIImageView = {
        let v = UIImageView()
        v.image = R.image.alertBoxImageView()
        return v
    } ()
    
    private let okButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.okButtomImage(), for: .normal)
        b.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        return b
    } ()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    
    var dates = [String]()
//    let dateFormatter = DateFormatter()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
//        configureCalendarView()
        arr()
        setCalendar()
        configureCalendarView()
        
    }
  
    //MARK: - Setup Layout
    
    private func configureCalendarView() {
        
        view.addSubviews([alertBoxImageView, calendarView, okButton])
        
        alertBoxImageView.snp.makeConstraints {
            $0.width.equalTo(335)
            $0.height.equalTo(380)
            $0.center.equalToSuperview()
        }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(alertBoxImageView)
            $0.left.right.equalTo(alertBoxImageView)
            $0.height.equalTo(320)
        }
        
        okButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(60)
            $0.bottom.equalTo(alertBoxImageView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
//        setupCalendar()
    }
    func setCalendar(){
    
        self.calendarView = FSCalendar(frame: .zero)
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.today = nil
        self.calendarView.appearance.titleTodayColor = UIColor.color606572
        self.calendarView.appearance.weekdayTextColor = UIColor.color606572
        self.calendarView.appearance.selectionColor = UIColor.color860000
        
        self.calendarView.appearance.headerTitleColor = UIColor.color606572
    }
    
    func arr() {
        for i in 0..<datesRange.count {
            dates.append(dateFormatter.string(from: datesRange[i]))
        }
    }
  }

//MARK: - Action

extension CalendarViewCreateOrderViewController {
    @objc func okButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

extension CalendarViewCreateOrderViewController : FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
   
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {

        let dateString = self.dateFormatter.string(from: date)

        if self.dates.contains(dateString) {
            calendarView.appearance.titleSelectionColor = .white
            return UIColor.color860000
        } else {
            return UIColor.clear
        }
    
    }
  
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false

    }
    
    
}
