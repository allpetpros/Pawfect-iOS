//
//  ProfileNavigationView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 08.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

protocol ProfileNavigationViewCustomerProfileDelegate: AnyObject {
    func stateChanged(state: CustomerProfileStates)
}
protocol ProfileNavigationViewOrdersDelegate: AnyObject {
    func stateChanged(state: CustomerOrdersStates)
}
protocol ProfileNavigationViewEmployeeProfileDelegate: AnyObject {
    func stateChanged(state: EmployeeProfileStates)
}
protocol ProfileNavigationViewEmployeeOrdersDelegate: AnyObject {
    func stateChanged(state: EmployeeOrdersState)
}

enum NavigationViewStates {
    case customerProfile
    case customerOrders
    
    case employeeProfile
    case employeeOrders
}
class NavigationView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    
    @IBOutlet weak var firstPoint: UIView!
    @IBOutlet weak var secondPoint: UIView!
    @IBOutlet weak var thirdPoint: UIView!
    @IBOutlet weak var fourthPoint: UIView!
    
    var numberOfButton = 0
    
    // MARK: - Property
    private let enableColor:UIColor = .colorC6222F
    private let dissableColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
    
    var stateOfScreen: NavigationViewStates?
    
    weak var customerProfileDelegate: ProfileNavigationViewCustomerProfileDelegate?
    weak var customerOrdersDelegate: ProfileNavigationViewOrdersDelegate?
    weak var employeeProfileDelegate: ProfileNavigationViewEmployeeProfileDelegate?
    weak var employeeOrdersDelegate: ProfileNavigationViewEmployeeOrdersDelegate?
       
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ProfileNavigationView", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.bounds
        self.isUserInteractionEnabled = true
    }
    
    // MARK: - Setup
    func setup(state: NavigationViewStates) {
        self.stateOfScreen = state
        firstButton.setTitleColor(enableColor, for: .normal)
        firstButton.titleLabel?.font = R.font.aileronBold(size: 18)
        
        secondButton.setTitleColor(dissableColor, for: .normal)
        secondButton.titleLabel?.font = R.font.aileronBold(size: 18)
        
        thirdButton.setTitleColor(dissableColor, for: .normal)
        thirdButton.titleLabel?.font = R.font.aileronBold(size: 18)
        
        firstPoint.backgroundColor = enableColor
        firstPoint.layer.cornerRadius = firstPoint.frame.size.width/2
        
        secondPoint.backgroundColor = enableColor
        secondPoint.isHidden = true
        secondPoint.layer.cornerRadius = secondPoint.frame.size.width/2
        
        thirdPoint.backgroundColor = enableColor
        thirdPoint.isHidden = true
        thirdPoint.layer.cornerRadius = thirdPoint.frame.size.width/2
        
        fourthPoint.backgroundColor = enableColor
        fourthPoint.isHidden = true
        fourthPoint.layer.cornerRadius = fourthPoint.frame.size.width/2
        
        fourthButton.setTitleColor(dissableColor, for: .normal)
        fourthButton.titleLabel?.font = R.font.aileronBold(size: 18)
        
        switch state {
            
        case .customerProfile:
            firstButton.setTitle("Pets", for: .normal)
            secondButton.setTitle("Payment", for: .normal)
            thirdButton.setTitle("Account", for: .normal)
            fourthButton.isHidden = true
        case .customerOrders:
            firstButton.setTitle("Current", for: .normal)
            secondButton.setTitle("Upcoming", for: .normal)
            thirdButton.setTitle("History", for: .normal)
            fourthButton.isHidden = true
        case .employeeProfile:
            firstButton.setTitle("Time off", for: .normal)
            secondButton.setTitle("Payout", for: .normal)
            thirdButton.setTitle("Account", for: .normal)
        case .employeeOrders:
            firstButton.setTitle("New", for: .normal)
            secondButton.setTitle("Confirmed", for: .normal)
            thirdButton.setTitle("History", for: .normal)
            fourthButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    @IBAction func firstButtonAction(_ sender: UIButton) {
        guard let stateOfScreen = stateOfScreen else { return }
        secondButton.setTitleColor(dissableColor, for: .normal)
        thirdButton.setTitleColor(dissableColor, for: .normal)
        firstButton.setTitleColor(enableColor, for: .normal)
        fourthButton.setTitleColor(dissableColor, for: .normal)
        
        secondPoint.isHidden = true
        thirdPoint.isHidden = true
        firstPoint.isHidden = false
        fourthPoint.isHidden = true
        
        switch stateOfScreen {
            
        case .customerProfile:
            customerProfileDelegate?.stateChanged(state: .pets)
        case .customerOrders:
            customerOrdersDelegate?.stateChanged(state: .orders)
        case .employeeProfile:
            employeeProfileDelegate?.stateChanged(state: .timeOff)
        case .employeeOrders:
            employeeOrdersDelegate?.stateChanged(state: .appointments)
        }
    }
    
    @IBAction func secondButtonAction(_ sender: UIButton) {
        guard let stateOfScreen = stateOfScreen else { return }
        firstButton.setTitleColor(dissableColor, for: .normal)
        thirdButton.setTitleColor(dissableColor, for: .normal)
        secondButton.setTitleColor(enableColor, for: .normal)
        fourthButton.setTitleColor(dissableColor, for: .normal)
        
        firstPoint.isHidden = true
        thirdPoint.isHidden = true
        secondPoint.isHidden = false
        fourthPoint.isHidden = true
        
        switch stateOfScreen {
            
        case .customerProfile:
            customerProfileDelegate?.stateChanged(state: .payment)
        case .customerOrders:
            customerOrdersDelegate?.stateChanged(state: .upcoming)
        case .employeeProfile:
            employeeProfileDelegate?.stateChanged(state: .payout)
        case .employeeOrders:
            employeeOrdersDelegate?.stateChanged(state: .upcoming)
        }
    }
    
    @IBAction func thirdButtonAction(_ sender: UIButton) {
        guard let stateOfScreen = stateOfScreen else { return }
        secondButton.setTitleColor(dissableColor, for: .normal)
        firstButton.setTitleColor(dissableColor, for: .normal)
        thirdButton.setTitleColor(enableColor, for: .normal)
        fourthButton.setTitleColor(dissableColor, for: .normal)

        secondPoint.isHidden = true
        firstPoint.isHidden = true
        thirdPoint.isHidden = false
        fourthPoint.isHidden = true
        
        switch stateOfScreen {
            
        case .customerProfile:
            customerProfileDelegate?.stateChanged(state: .account)
        case .customerOrders:
            customerOrdersDelegate?.stateChanged(state: .history)
        case .employeeProfile:
            employeeProfileDelegate?.stateChanged(state: .account)
        case .employeeOrders:
             employeeOrdersDelegate?.stateChanged(state: .history)
        }
    }
    
    @IBAction func fourthButtonAction(_ sender: UIButton) {
        guard let stateOfScreen = stateOfScreen else { return }
        secondButton.setTitleColor(dissableColor, for: .normal)
        thirdButton.setTitleColor(dissableColor, for: .normal)
        firstButton.setTitleColor(dissableColor, for: .normal)
        fourthButton.setTitleColor(enableColor, for: .normal)
        
        secondPoint.isHidden = true
        thirdPoint.isHidden = true
        firstPoint.isHidden = true
        fourthPoint.isHidden = false
        
        switch stateOfScreen {

        case .customerProfile:
            customerProfileDelegate?.stateChanged(state: .pets)
        case .customerOrders:
            customerOrdersDelegate?.stateChanged(state: .orders)
        case .employeeProfile:
            employeeProfileDelegate?.stateChanged(state: .review)
        case .employeeOrders:
            employeeOrdersDelegate?.stateChanged(state: .appointments)
        }
    }
}
