//
//  SelectDateAndTimeVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 28.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FSCalendar

enum SelectDateAndTimeVCState {
    case meetAndGreet
    case services
}

var datesRange: [Date] = [Date]()

class SelectDateAndTimeVC: BaseViewController {
    enum AdditionalViews {
        case perDay
        case sameForAllday
        case requring
    }
    // MARK: - UI Properties
    private let scrollView = UIScrollView()
    private let mainView = UIView()
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    private var firstDate: Date?
   
    private var lastDate: Date?
   
    
    
    private let closebutton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.closeTest(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.clipsToBounds = true
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    }()
    private let registerLabel: UILabel = {
        let label = UILabel()
        label.text = "Schedule Service"
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        button.snp.makeConstraints {
            $0.size.equalTo(100)
        }
        button.addTarget(self, action: #selector(backButtonTouched), for: .touchUpInside)
        return button
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 18)
        return label
    }()
    private let selectDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Select days interval"
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color293147
        return label
    }()
    
    private lazy var fewDaysCheckboxButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .fewDays, typeOfCheckbox: .blackPoint, typeOfText: .black)
        button.delegate = self
        button.isUserInteractionEnabled = true
        button.setupCalendarFont()
        return button
    }()
    
    private lazy var separatedDaysCheckboxButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .separatedDays, typeOfCheckbox: .blackPoint, typeOfText: .black)
        button.delegate = self
        button.isUserInteractionEnabled = true
        button.setupCalendarFont()
        return button
    }()
    
    private lazy var calendarView: FSCalendar = {
        let vwCalander = FSCalendar()
        setCalendar()
        return vwCalander
    } ()
    
    private lazy var morningCheckboxButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .morning, typeOfCheckbox: .blackPoint, typeOfText: .black)
        button.delegate = self
        return button
    }()
    
    private lazy var afternoonCheckboxButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .afternoon, typeOfCheckbox: .blackPoint, typeOfText: .black)
        button.delegate = self
        return button
    }()
    
    private lazy var eveningCheckboxButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .evening, typeOfCheckbox: .blackPoint, typeOfText: .black)
        button.delegate = self
        return button
    }()
    
    private let dateStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    private let selectTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Time"
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color293147
        return label
    }()
    private lazy var timePickerView: TimePickerView = {
        let view = TimePickerView()
        view.delegate = self
        return view
    }()
    private let nextButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Next", type: .nextBig, bordered: true)
        
        button.redAndGrayStyleMain(active: false)
        let doneButtonAction = UIButton()
        doneButtonAction.addTarget(self, action: #selector(nextButtonTouched), for: .touchUpInside)
        button.addSubview(doneButtonAction)
        doneButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    var tapGesture: UITapGestureRecognizer?
    
    private let blackoutView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.027, green: 0.059, blue: 0.141, alpha: 0.6)
        return view
    }()
    
    private lazy var visitPerDayView: VisitPerDayView = {
        let view = VisitPerDayView()
        view.delegate = self
        return view
    }()
    private lazy var sameForAllDayView: SameForAllDayView = {
        let view = SameForAllDayView()
        view.delegate = self
        return view
    }()
    private lazy var recurringView: RecurringView = {
        let view = RecurringView()
        view.delegate = self
        return view
    }()
    
    private let morningButton: UIButton = {
        let b = UIButton()
        b.setTitle("Morning", for: .normal)
        b.setTitleColor(.color293147, for: .normal)
        b.backgroundColor = R.color.pickerColor()?.withAlphaComponent(0.3)
        b.titleLabel?.font = R.font.aileronRegular(size: 16)
        b.isHidden = true
        b.addTarget(self, action: #selector(morningButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let afternoonButton: UIButton = {
        let b = UIButton()
        b.setTitle("Afternoon", for: .normal)
        b.setTitleColor(.color293147, for: .normal)
        b.backgroundColor = R.color.pickerColor()?.withAlphaComponent(0.3)
        b.titleLabel?.font = R.font.aileronRegular(size: 16)
        b.isHidden = true
        b.addTarget(self, action: #selector(afternoonButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let eveningButton: UIButton = {
        let b = UIButton()
        b.setTitle("Evening", for: .normal)
        b.setTitleColor(.color293147, for: .normal)
        b.backgroundColor = R.color.pickerColor()?.withAlphaComponent(0.3)
        b.titleLabel?.font = R.font.aileronRegular(size: 16)
        b.isHidden = true
        b.addTarget(self, action: #selector(eveningButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let instructionLabel: UILabel = {
        let l = UILabel()
        l.text = "When you are choosing Morning, Afternoon, Evening it means that you want to book three visits in one day"
        l.textColor = .colorAAABAE
        l.numberOfLines = 2
        l.font = R.font.aileronRegular(size: 12)
        l.isHidden = true
        return l
    } ()
    
    private let daysLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 12)
        l.isHidden = true
        return l
    } ()
    
    private let startDateLabel: UILabel = {
        let l = UILabel()
        l.text = "Start Date"
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 12)
        l.isHidden = true
        return l
    } ()
    
    private let endDateLabel: UILabel = {
        let l = UILabel()
        l.text = "End Date"
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 12)
        l.isHidden = true
        return l
    } ()
    
    private let startDateNumberLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronBold(size: 12)
        l.isHidden = true
        return l
    } ()
    
    private let endDateNumberLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronBold(size: 12)
        l.isHidden = true
        return l
    } ()
    
    private let buttonsUnderPickerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        return stack
    }()
    
    // MARK: - Properties
    private var state: SelectDateAndTimeVCState?
    
    private var isTapped: Bool = false
    
    private var daysArr = [Date]()
    private var morning = String()
    private var afternoon = String()
    private var evening = String()
    
    private var isMorning = false
    private var isAfternoon = false
    private var isEvening = false
    private var isCalendarActive = false
    private var morningTime: String?
    private var afternoonTime: String?
    private var eveningTime: String?
    private var isRangeSelected = Bool()
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OrderManager.shared.startedDate = nil
        OrderManager.shared.endedDate = nil
        setCalendar()
        OrderManager.shared.partOfDays = []
        OrderManager.shared.dates = []
        fewDaysCheckboxButton.vkl()
        isRangeSelected = true

        
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(state: SelectDateAndTimeVCState) {
        super.init(nibName: nil, bundle: nil)
        setup(state: state)
    }
    
    // MARK: - Functions
    func setup(state: SelectDateAndTimeVCState) {
        self.state = state
        setupLayouts()
        switch state {
        
        case .meetAndGreet:
            break
        case .services:
            descriptionLabel.text = "Step 2. Select Date and Time"
        }
    }
    
    private func blackout(show: Bool) {
        if show {
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTouched))
            blackoutView.addGestureRecognizer(tapGesture!)
            view.addSubview(blackoutView)
            blackoutView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            blackoutView.removeFromSuperview()
        }
    }
    
    private func showAdditionalView(type: AdditionalViews) {
        blackout(show: true)
        switch type {
        
        case .perDay:
            view.addSubview(visitPerDayView)
            visitPerDayView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        case .sameForAllday:
            view.addSubview(sameForAllDayView)
            sameForAllDayView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        case .requring:
            view.addSubview(recurringView)
            recurringView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
}

// MARK: - Setup layout

private extension SelectDateAndTimeVC {
    func setupLayouts() {
        view.backgroundColor = .white
        setupScrollViewLayouts()
        setupTopPartLayouts()
        setupDateSection()
        setupTimeSection()
    }
    
    func setupScrollViewLayouts() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.left.right.equalTo(self.scrollView.contentLayoutGuide)
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
    }
    
    func setupTopPartLayouts() {
        mainView.addSubviews([closebutton, registerLabel, descriptionLabel])
//        closebutton.snp.makeConstraints {
//            $0.width.equalTo(21)
//            $0.height.equalTo(15)
//            $0.leading.equalToSuperview().inset(25)
//            $0.top.equalToSuperview().inset(38)
//        }
//        registerLabel.snp.makeConstraints {
//            $0.leading.equalTo(closebutton.snp.trailing).offset(20)
//            $0.top.equalToSuperview().inset(26)
//        }
//        descriptionLabel.snp.makeConstraints {
//            $0.top.equalTo(registerLabel.snp.bottom).offset(34)
//            $0.left.equalToSuperview().offset(25)
//        }
        registerLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
//            $0.left.equalTo(closebutton.snp.right).offset(19)
            $0.leading.trailing.equalToSuperview().offset(10)
        }
        closebutton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(35)
            $0.right.equalToSuperview().offset(-25)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(registerLabel.snp.bottom).offset(34)
            $0.left.equalTo(registerLabel)
        }
      
        
    }
    
    func setupDateSection() {
        mainView.addSubviews([selectDateLabel, fewDaysCheckboxButton,separatedDaysCheckboxButton,calendarView, morningCheckboxButton, afternoonCheckboxButton, eveningCheckboxButton, instructionLabel, daysLabel, startDateLabel, endDateLabel, startDateNumberLabel, endDateNumberLabel])
        selectDateLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(25)
        }
        fewDaysCheckboxButton.snp.makeConstraints {
            $0.top.equalTo(selectDateLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(150)
        }

        separatedDaysCheckboxButton.snp.makeConstraints {
            $0.top.equalTo(selectDateLabel.snp.bottom).offset(12)
            $0.right.equalToSuperview().offset(-25)
//            $0.left.equalTo(fewDaysCheckboxButton.snp.right).offset(19)
            $0.width.equalTo(150)
        }
        calendarView.snp.makeConstraints {
            $0.top.equalTo(fewDaysCheckboxButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(310)
        }
        
        morningCheckboxButton.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.width.equalTo(92)
            $0.left.equalToSuperview().offset(25)
        }
        afternoonCheckboxButton.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.width.equalTo(92)
            $0.left.equalTo(morningCheckboxButton.snp.right).offset(25)
        }
        eveningCheckboxButton.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom)
            $0.width.equalTo(92)
            $0.left.equalTo(afternoonCheckboxButton.snp.right).offset(25)
        }
        instructionLabel.snp.makeConstraints {
            $0.top.equalTo(morningCheckboxButton.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        daysLabel.snp.makeConstraints {
            $0.top.equalTo(instructionLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(25)
        }
        
        startDateLabel.snp.makeConstraints {
            $0.top.equalTo(daysLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(25)
        }
        
        endDateLabel.snp.makeConstraints {
            $0.top.equalTo(startDateLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(25)
        }
        
        startDateNumberLabel.snp.makeConstraints {
            $0.top.equalTo(daysLabel.snp.bottom).offset(16)
            $0.right.equalToSuperview().offset(-25)
        }
        
        endDateNumberLabel.snp.makeConstraints {
            $0.top.equalTo(startDateNumberLabel.snp.bottom).offset(16)
            $0.right.equalToSuperview().offset(-25)
        }
        
    }
    
    func setupTimeSection() {
        mainView.addSubviews([selectTimeLabel, timePickerView, nextButton, morningButton, afternoonButton, eveningButton, buttonsUnderPickerStackView])
        
        selectTimeLabel.snp.makeConstraints {
            $0.top.equalTo(eveningCheckboxButton.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(25)
        }
        
        buttonsUnderPickerStackView.addArrangedSubviews(views: morningButton, afternoonButton, eveningButton)
        
        buttonsUnderPickerStackView.snp.makeConstraints {
            $0.top.equalTo(selectTimeLabel.snp.bottom).offset(20)
            $0.left.equalTo(timePickerView)
            $0.right.equalTo(timePickerView)
            $0.bottom.equalTo(timePickerView.snp.top)
        }
        
        timePickerView.snp.makeConstraints {
            $0.top.equalTo(buttonsUnderPickerStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(150)
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(timePickerView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}

// MARK: - ButtonWithTrailingCheckboxDelegate

extension SelectDateAndTimeVC: ButtonWithTrailingCheckboxDelegate {
    
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool) {
       
        if OrderManager.shared.startedDate != nil && OrderManager.shared.endedDate != nil {
            isCalendarActive = true
//            instructionLabel.isHidden = false
//            daysLabel.isHidden = false
//            startDateLabel.isHidden = false
//            endDateLabel.isHidden = false
//            startDateNumberLabel.isHidden = false
//            endDateNumberLabel.isHidden = false
            checkValidation()
            rangeDateChanged()
        } 
        if questions.titleOflabel == "Morning" && answer == true {
            changeColorOfPickerButtons(numberOfButton: 0)
            morningButton.isHidden = false
            
            timePickerView.morningTime[0] = timePickerView.morningHours[0]
            timePickerView.morningTime[0] = timePickerView.morningTime[1]
            timePickerView.resetPicker()
            timePickerView.morningPickerUpdate()
            OrderManager.shared.partOfDays.insert("morning")
            isMorning = true
        } else if questions.titleOflabel == "Morning" && answer == false {
            morningButton.isHidden = true
            OrderManager.shared.partOfDays.remove("morning")
            OrderManager.shared.morningHours = ""
            if OrderManager.shared.partOfDays.contains("afternoon") {
                timePickerView.afternoonTime[0] = timePickerView.afternoonHours[0]
                timePickerView.afternoonTime[0] = timePickerView.afternoonTime[1]
                
                timePickerView.afternoonPickerUpdate()
                changeColorOfPickerButtons(numberOfButton: 1)
//                timePickerView.resetPicker()
            } else if OrderManager.shared.partOfDays.contains("evening") {
                eveningButton.isHidden = false
                timePickerView.eveningTime[0] = timePickerView.eveningHours[0]
                timePickerView.eveningTime[0] = timePickerView.eveningTime[1]
                
                changeColorOfPickerButtons(numberOfButton: 2)
                timePickerView.eveningPickerUpdate()
                timePickerView.resetPicker()
            } else {
                timePickerView.totalTime[0] = timePickerView.hours[0]
                timePickerView.totalTime[0] = timePickerView.minutes[1]
                timePickerView.TotalPickerUpdate()
//                timePickerView.resetPicker()
            }
//            timePickerView.timePickerView.reloadAllComponents()
            isMorning = false
        }
        if questions.titleOflabel == "Afternoon" && answer == true {
            afternoonButton.isHidden = false
            changeColorOfPickerButtons(numberOfButton: 1)
            timePickerView.afternoonTime[0] = timePickerView.afternoonHours[0]
            timePickerView.afternoonTime[0] = timePickerView.afternoonTime[0]
//            timePickerView.resetPicker()
            timePickerView.afternoonPickerUpdate()
            OrderManager.shared.partOfDays.insert("afternoon")
            
            isAfternoon = true
        } else if questions.titleOflabel == "Afternoon" && answer == false {
            afternoonButton.isHidden = true
            OrderManager.shared.partOfDays.remove("afternoon")
            OrderManager.shared.afternoonHours = ""
            if OrderManager.shared.partOfDays.contains("morning") {
                timePickerView.morningTime[0] = timePickerView.morningHours[0]
                timePickerView.morningTime[0] = timePickerView.morningTime[1]
               
                timePickerView.morningPickerUpdate()
                changeColorOfPickerButtons(numberOfButton: 0)
                timePickerView.resetPicker()
            } else if OrderManager.shared.partOfDays.contains("evening") {
                eveningButton.isHidden = false
                timePickerView.eveningTime[0] = timePickerView.eveningHours[0]
                timePickerView.eveningTime[0] = timePickerView.eveningTime[1]
                
                changeColorOfPickerButtons(numberOfButton: 2)
                timePickerView.eveningPickerUpdate()
                timePickerView.resetPicker()
            } else {
                timePickerView.totalTime[0] = timePickerView.hours[0]
                timePickerView.totalTime[0] = timePickerView.minutes[1]
                timePickerView.TotalPickerUpdate()
//                timePickerView.resetPicker()
            }
            
            timePickerView.timePickerView.reloadAllComponents()
            isAfternoon = false
        }
        if questions.titleOflabel == "Evening" && answer == true {
            eveningButton.isHidden = false
            timePickerView.eveningTime[0] = timePickerView.eveningHours[0]
            timePickerView.eveningTime[0] = timePickerView.eveningTime[1]
//            timePickerView.resetPicker()
            changeColorOfPickerButtons(numberOfButton: 2)
            timePickerView.eveningPickerUpdate()
            
            OrderManager.shared.partOfDays.insert("evening")
            isEvening = true
        } else if questions.titleOflabel == "Evening" && answer == false {
            eveningButton.isHidden = true
            OrderManager.shared.partOfDays.remove("evening")
           
            OrderManager.shared.eveningHours = ""
            if OrderManager.shared.partOfDays.contains("morning") {
                timePickerView.morningTime[0] = timePickerView.morningHours[0]
                timePickerView.morningTime[0] = timePickerView.morningTime[1]
                
                timePickerView.morningPickerUpdate()
                changeColorOfPickerButtons(numberOfButton: 0)
                timePickerView.resetPicker()
            } else if OrderManager.shared.partOfDays.contains("afternoon") {
                timePickerView.afternoonTime[0] = timePickerView.afternoonHours[0]
                timePickerView.afternoonTime[0] = timePickerView.afternoonTime[1]
                
                timePickerView.afternoonPickerUpdate()
                changeColorOfPickerButtons(numberOfButton: 1)
                timePickerView.resetPicker()
            } else {
                timePickerView.totalTime[0] = timePickerView.hours[0]
                timePickerView.totalTime[0] = timePickerView.minutes[1]
                timePickerView.TotalPickerUpdate()
//                timePickerView.resetPicker()
            }
            timePickerView.timePickerView.reloadAllComponents()
            isEvening = false
        }
        if questions.titleOflabel == "Multiple Days" && answer == true || questions.titleOflabel == "Single Day" && answer == false {
            separatedDaysCheckboxButton.vukl()
            fewDaysCheckboxButton.vkl()
            nextButton.redAndGrayStyleMain(active: false)
            for i in 0..<datesRange.count {
                calendarView.deselect(datesRange[i])
            }
            OrderManager.shared.startedDate = nil
            OrderManager.shared.endedDate = nil
           
            isCalendarActive = false
            rangeDateChanged()
            datesRange.removeAll()
//            calendarView.reloadData()
            isRangeSelected = true
            firstDate = nil
            lastDate = nil
        } else if questions.titleOflabel == "Single Day" && answer == true || questions.titleOflabel == "Multiple Days" && answer == false {
            separatedDaysCheckboxButton.vkl()
            fewDaysCheckboxButton.vukl()
            nextButton.redAndGrayStyleMain(active: false)
            for i in 0..<datesRange.count {
                calendarView.deselect(datesRange[i])
            }
            OrderManager.shared.startedDate = nil
            OrderManager.shared.endedDate = nil
            isCalendarActive = false
            rangeDateChanged()
            datesRange.removeAll()
            
//            calendarView.reloadData()
            isRangeSelected = false
            firstDate = nil
            lastDate = nil
        }
        
        checkValidation()
        
        selectTimeLabel.snp.remakeConstraints {
            $0.top.equalTo(endDateLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(25)
        }
        instructionLabel.isHidden = false
        daysLabel.isHidden = false
        startDateLabel.isHidden = false
        endDateLabel.isHidden = false
        startDateNumberLabel.isHidden = false
        endDateNumberLabel.isHidden = false
    }
    
  
    func changeColorOfPickerButtons(numberOfButton: Int) {
        if numberOfButton == 0 {
            morningButton.backgroundColor = R.color.pickerChooseColor()
            morningButton.setTitleColor(.color293147, for: .normal)
            
            afternoonButton.backgroundColor = R.color.pickerColor()?.withAlphaComponent(0.3)
            afternoonButton.setTitleColor(R.color.pickerChooseColor(), for: .normal)
            eveningButton.backgroundColor = R.color.pickerColor()?.withAlphaComponent(0.3)
            eveningButton.setTitleColor(R.color.pickerChooseColor(), for: .normal)
        } else if numberOfButton == 1 {
            afternoonButton.backgroundColor = R.color.pickerChooseColor()
            afternoonButton.setTitleColor(.color293147, for: .normal)
            morningButton.backgroundColor = R.color.pickerColor()?.withAlphaComponent(0.3)
            morningButton.setTitleColor(R.color.pickerChooseColor(), for: .normal)
            eveningButton.backgroundColor = R.color.pickerColor()?.withAlphaComponent(0.3)
            eveningButton.setTitleColor(R.color.pickerChooseColor(), for: .normal)
        } else if numberOfButton == 2 {
            eveningButton.backgroundColor = R.color.pickerChooseColor()
            eveningButton.setTitleColor(.color293147, for: .normal)
            
            afternoonButton.backgroundColor = R.color.pickerColor()?.withAlphaComponent(0.3)
            afternoonButton.setTitleColor(R.color.pickerChooseColor(), for: .normal)
            morningButton.backgroundColor = R.color.pickerColor()?.withAlphaComponent(0.3)
            morningButton.setTitleColor(R.color.pickerChooseColor(), for: .normal)
        }
    }
    
    func dateCounts() {
        daysArr = []
        OrderManager.shared.dates = []
        
        
        if var date = OrderManager.shared.startedDate, let endDate = OrderManager.shared.endedDate {
            while date <= endDate {
                daysArr.append(date)
                date = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                
            }
        }
        for i in daysArr {
            //
            var dates = i.millisecondsSince1970
            dates = dates - Int64(TimeZone.current.secondsFromGMT() * 1000)
            print("TimeZone::",TimeZone.current.secondsFromGMT())
            print("Date::",dates)
            OrderManager.shared.dates.append(dates)
            
        }
    }
}

//MARK: - Date setup

private extension SelectDateAndTimeVC {
    func convertDateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
        let month = formatter.string(from: date)
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        
        return "\(month) \(day)"
    }
}

//MARK: - Actions

extension SelectDateAndTimeVC {
    @objc func morningButtonAction() {
        changeColorOfPickerButtons(numberOfButton: 0)
        timePickerView.morningPickerUpdate()
        timePickerView.resetPicker()
    }
    
    @objc func afternoonButtonAction() {
        changeColorOfPickerButtons(numberOfButton: 1)
        timePickerView.afternoonPickerUpdate()
        timePickerView.resetPicker()
    }
    
    @objc func eveningButtonAction() {
        changeColorOfPickerButtons(numberOfButton: 2)
        timePickerView.eveningPickerUpdate()
        timePickerView.resetPicker()
    }
    
    @objc func backButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextButtonTouched() {
        
        dateCounts()
        if !OrderManager.shared.morningHours.isEmpty || OrderManager.shared.partOfDays.contains("morning") {
            if OrderManager.shared.partOfDays.contains("morning") && OrderManager.shared.morningHours.isEmpty {
                OrderManager.shared.morningHours = "07:00"
                
            }
//            morningTime = convertMilitaryTimeToNoneMilitaryTime(time: OrderManager.shared.morningHours)
            getDateTime(date: OrderManager.shared.startedDate!, time: OrderManager.shared.morningHours)
        } else if !OrderManager.shared.afternoonHours.isEmpty || OrderManager.shared.partOfDays.contains("afternoon") {
            if OrderManager.shared.partOfDays.contains("afternoon") && OrderManager.shared.afternoonHours.isEmpty{
                OrderManager.shared.afternoonHours = "12:00"
            }
//            afternoonTime = convertMilitaryTimeToNoneMilitaryTime(time: OrderManager.shared.afternoonHours)
            getDateTime(date: OrderManager.shared.startedDate!, time: OrderManager.shared.afternoonHours)
        } else if !OrderManager.shared.eveningHours.isEmpty || OrderManager.shared.partOfDays.contains("evening") {
            if OrderManager.shared.partOfDays.contains("evening") && OrderManager.shared.eveningHours.isEmpty{
                OrderManager.shared.eveningHours = "17:00"
            }
//            eveningTime = convertMilitaryTimeToNoneMilitaryTime(time: OrderManager.shared.eveningHours)
            getDateTime(date: OrderManager.shared.startedDate!, time: OrderManager.shared.eveningHours)
        }
        
    }
    
    @objc func tapGestureTouched() {
        visitPerDayView.removeFromSuperview()
        blackout(show: false)
    }
}



// MARK: - VisitPerDayViewDelegate

extension SelectDateAndTimeVC: VisitPerDayViewDelegate {
    func numberOfDayChanged(number: Int) {
        print(number)
    }
}

//MARK: - RecurringViewDelegate

extension SelectDateAndTimeVC: RecurringViewDelegate {
    func okButtonTouched(value: DayCountCell.DayCountCellRows) {
        recurringView.removeFromSuperview()
        blackout(show: false)
    }
}

//MARK: - SameForAllDayViewDelegate

extension SelectDateAndTimeVC: SameForAllDayViewDelegate {
    func close(with: Bool) {
        sameForAllDayView.removeFromSuperview()
        blackout(show: false)
    }
}

//MARK: - CalendarDelegate


extension SelectDateAndTimeVC: CalendarDelegate {
    func dateChanged() {
        checkValidation()
    }
}

//MARK: - Validation

private extension SelectDateAndTimeVC {
    func checkValidation() {
        if isMorning == false && isAfternoon == false && isEvening == false {
            nextButton.redAndGrayStyleMain(active: false)
        } else if isMorning || isAfternoon || isEvening && OrderManager.shared.startedDate != nil {
            if OrderManager.shared.endedDate != nil {
//            if isCalendarActive {
                nextButton.redAndGrayStyleMain(active: true)
            } else {
                nextButton.redAndGrayStyleMain(active: false)
            }
        }
    }
}

//MARK: - PickerTimeDelegate

extension SelectDateAndTimeVC: PickerTimeDelegate {
    func totalTime(time: [String]) {
//        var time = time.joined(separator: ":")
//        time = time
////        let morningTime = convertMilitaryTimeToNoneMilitaryTime(time: morning)
////
//        OrderManager.shared.morningHours = morningTime
    }
    
    func timeMorningChoosen(time: [String]) {
       
        morning = time.joined(separator: ":")
        morning = morning + "AM"
        let morningTime = CommonFunction.shared.convertMilitaryTimeToNoneMilitaryTime(time: morning)
        
        OrderManager.shared.morningHours = morningTime
    }
    
    func timeAfternoonChoosen(time: [String]) {
        
        afternoon = time.joined(separator: ":")
        afternoon = afternoon + "PM"
        let afternoonTime = CommonFunction.shared.convertMilitaryTimeToNoneMilitaryTime(time: afternoon)
        
        OrderManager.shared.afternoonHours = afternoonTime
    }
    
    func timeEveningChoosen(time: [String]) {
        
        evening = time.joined(separator: ":")
        evening = evening + "PM"
        let eveningTime = CommonFunction.shared.convertMilitaryTimeToNoneMilitaryTime(time: evening)
        OrderManager.shared.eveningHours = eveningTime
    }
    
    func setCalendar(){
    
        self.calendarView = FSCalendar(frame: .zero)
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.allowsMultipleSelection = true
        self.calendarView.today = nil
        self.calendarView.appearance.titleTodayColor = UIColor.color606572
        self.calendarView.appearance.weekdayTextColor = UIColor.color606572
        self.calendarView.appearance.selectionColor = UIColor.color860000
        self.calendarView.appearance.headerTitleColor = UIColor.color606572
    }
    
    func convertTimeTOHoursFormat(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let date = dateFormatter.date(from: time)
        dateFormatter.dateFormat = "h:mm a"
        let Date12 = dateFormatter.string(from: date!)
        print("12 hour formatted Date:",Date12)
        return Date12
    }
}

//MARK: - Network

private extension SelectDateAndTimeVC {
    func getPets() {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minutes = calendar.component(.minute, from: now)
        
        var firstTest = [String: Any]()
        var secondTest = [String: Any]()
        var thirdTest = [String: Any]()
        
        var visiting = [[String: Any]]()
        
        if !OrderManager.shared.morningHours.isEmpty {
            firstTest = ["type": "morning", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.morningHours)] as [String : Any]
            visiting.append(firstTest)
        }
        else if OrderManager.shared.partOfDays.contains("morning") {
            OrderManager.shared.morningHours = "07:00"
            firstTest = ["type": "morning", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.morningHours)] as [String : Any]
            visiting.append(firstTest)
        }
        
        if !OrderManager.shared.afternoonHours.isEmpty {
            secondTest = ["type": "afternoon", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.afternoonHours)] as [String : Any]
            visiting.append(secondTest)
        }
        else if OrderManager.shared.partOfDays.contains("afternoon") {

            OrderManager.shared.afternoonHours = "12:00"
            secondTest = ["type": "afternoon", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.afternoonHours)] as [String : Any]
            visiting.append(secondTest)
        }
        
        if !OrderManager.shared.eveningHours.isEmpty {
            thirdTest = ["type": "evening", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.eveningHours)] as [String : Any]
            visiting.append(thirdTest)
        }
        else if OrderManager.shared.partOfDays.contains("evening") {
            OrderManager.shared.eveningHours = "17:00"

            thirdTest = ["type": "evening", "time": CommonFunction.shared.getMillisecond(hours: OrderManager.shared.eveningHours)] as [String : Any]
            visiting.append(thirdTest)
        }
        
        let parameters: [String: Any] = [
            "visits": visiting,
            "serviceId": OrderManager.shared.serviceId,
            "onDates": OrderManager.shared.dates,
        ]
    
        print("Parameters for order are :",parameters)
        let baseURL = "\(Constant.baseURL)/customer/pets/for-order"
        
        
        if let token = DBManager.shared.getAccessToken() {
            let Auth_header: HTTPHeaders = ["Authorization": "Bearer \(token)"]

            AF.request(baseURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: Auth_header).responseJSON { (response) in
                print("Response for Order Are",response)
                switch response.result {
                    
                case .success(let success):
                    let json = JSON(success)
                    if json["items"].array?.count == 0 {

                        self.setupWarning(alert: "Oops!  Please add a valid pet type before booking this service:(", isOrders: true)
                    } else {
                        let vc = PetChoosingViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    self.hideActivityIndicator()
                case .failure(let error):
                    self.hideActivityIndicator()
                    self.setupErrorAlert(error: error)
                }
            }
        }
    }
    
    func getDateTime(date: Date , time: String) {
        
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minutes = calendar.component(.minute, from: now)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDate = formatter.string(for: date)
        let current = formatter.string(from: now)
        let dates =  "\(startDate!) \(time):00+0000"
        let currentTime = "\(current) \(String(hour)):\(String(minutes)):00+0000"
        let format = DateFormatter ()
        format.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        let date = format.date(from:dates)
        let currentDateTime = format.date(from: currentTime)!
        print(currentDateTime)
        
        let diffComponents = Calendar.current.dateComponents([.day ,.hour, .minute], from: currentDateTime, to: date!)
        print(diffComponents)
        if diffComponents.day! <= 0 && diffComponents.hour! < 24 {
            self.setupWarning(alert: "We're sorry, we cannot complete your request, as we require at least 24 hours in advance notice.Please contact our office if you need immediate/last minute booking.", isOrders: false)
        } else {
            getPets()
        }
    }
}

extension SelectDateAndTimeVC : FSCalendarDelegate,FSCalendarDelegateAppearance,FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        isCalendarActive = true
        let date = dateFormatter(date: date)
        
        if isRangeSelected  {
            if firstDate == nil {
                firstDate = date
                datesRange = [firstDate!]
                
                print("datesRange contains: \(datesRange)")
                
                return
            }
            
            // only first date is selected:
            if firstDate != nil && lastDate == nil {
                // handle the case of if the last date is less than the first date:
                if lastDate == nil {
                    nextButton.redAndGrayStyleMain(active: false)
                }
                if date <= firstDate! {
                    calendar.deselect(firstDate!)
                    firstDate = date
                    datesRange = [firstDate!]
                    
                    print("datesRange contains: \(datesRange)")
                    
                    return
                }
                
                let range = dateRange(from: firstDate!, to: date)
                
                lastDate = range.last
               
                OrderManager.shared.startedDate = dateFormatter1(date: firstDate ?? Date())
                OrderManager.shared.endedDate = dateFormatter1(date: lastDate ?? Date())
                for d in range {
                    calendar.select(d)
                }
                
                datesRange = range
                
                print("datesRange contains: \(datesRange)")
                rangeDateChanged()
                checkValidation()
                return
                
            }
            
            if firstDate != nil && lastDate != nil {
                for d in calendar.selectedDates {
                    calendar.deselect(d)
                }
                
                lastDate = nil
                firstDate = nil
                
                datesRange = []
                firstDate = date
                datesRange.append(date)
                calendar.select(date)
            }
            
        } else {
            datesRange.append(date)
            OrderManager.shared.startedDate = dateFormatter1(date: datesRange.min() ?? Date())
            OrderManager.shared.endedDate = dateFormatter1(date: datesRange.max() ?? Date())
            firstDate = dateFormatter1(date: datesRange.min() ?? Date())
            lastDate = dateFormatter1(date: datesRange.max() ?? Date())
            rangeDateChanged()
        }
        checkValidation()
        
    }
    
    func dateFormatter(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        let result = formatter.string(from: date)
        print(result)
        
        let addedDate = result
        let objformatter = DateFormatter()
//        objformatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
        objformatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        let date1 = objformatter.date(from: addedDate)
        print("DATE \(String(describing: date1!))")
        return date1!
    }
    
    func dateFormatter1(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        let result = formatter.string(from: date)
        print(result)
        
        let addedDate = result
        let objformatter = DateFormatter()
        objformatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
        objformatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        let date1 = objformatter.date(from: addedDate)
        print("DATE \(String(describing: date1!))")
        return date1!
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let date = dateFormatter(date: date)
        if isRangeSelected {
            isCalendarActive = false
            for d in calendar.selectedDates {
                calendar.deselect(d)
                datesRange.removeAll()
                isCalendarActive = false
                OrderManager.shared.startedDate = nil
                OrderManager.shared.endedDate = nil
                firstDate = nil
                lastDate = nil
            }
            checkValidation()
            rangeDateChanged()
        } else {
           
            calendar.deselect(date)
            for i in 0..<datesRange.count {
                if datesRange[i] == date {
                    datesRange.remove(at: i)
                    isCalendarActive = true
                    break
                }    
            }
            
            OrderManager.shared.startedDate = datesRange.min()
            OrderManager.shared.endedDate = datesRange.max()
            firstDate = datesRange.min()
            lastDate = datesRange.max()
            if datesRange.count == 0 {
                isCalendarActive = false
            }
            checkValidation()
            rangeDateChanged()
            
        }
        print("Date Range:-------",datesRange)
        
    }
    
    func dateRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }

        var tempDate = from
        var array = [tempDate]

        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
//        return Date()
        let currentDay = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return currentDay
    }
    
    func rangeDateChanged() {
        if isCalendarActive  {
            startDateNumberLabel.text = convertDateToString(date: OrderManager.shared.startedDate!)
            endDateNumberLabel.text = convertDateToString(date:OrderManager.shared.endedDate!)
            isCalendarActive = true
        } else {
            startDateNumberLabel.text = ""
            endDateNumberLabel.text = ""
            isCalendarActive = false
        }
    }
}
