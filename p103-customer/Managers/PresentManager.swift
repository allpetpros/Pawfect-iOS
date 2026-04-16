//
//  PresentManager.swift
//  p103-customer
//
//  Created by Alex Lebedev on 07.08.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import UIKit

class PresentManager {
    static let shared = PresentManager()
    private init(){}
    
    var app = UIApplication.shared
    
    var delegate: AppDelegate {
        return app.delegate as! AppDelegate
    }
    var window: UIWindow? {
        return delegate.window
    }
    
    func presentStartScreen() {
        let navigationController: UINavigationController?
        var status = 0
        if DBManager.shared.getAccessToken() != nil, let role = DBManager.shared.getUserRole() {
            switch role {

            case .customer:
                status = DBManager.shared.getStatus() ?? 0
                print(DBManager.shared.getAccessToken())
                if status == 1 {
                    navigationController = UINavigationController(rootViewController: CustomerDashboardTabBarController())
                } else {
                    navigationController = UINavigationController(rootViewController: AuthorizationVC())
                }
            case .employee:
                print(DBManager.shared.getAccessToken())
                navigationController = UINavigationController(rootViewController: EmployeeDashboardTabBarController())
            }
            navigationController?.navigationBar.isHidden = true
        } else {
            
            navigationController = UINavigationController(rootViewController: AuthorizationVC())
            navigationController?.navigationBar.isHidden = false
        }
       
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    func presentForgotPasswordFlow(code: String) {
        let authVC = AuthorizationVC()
        let vc = NewPasswordVC(state: .forgotPassword)
        vc.code = code
        let navigationController = UINavigationController(rootViewController: authVC)
        navigationController.pushViewController(vc, animated: false)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    func presentCustomerFlow() {
        let dashboard = CustomerDashboardTabBarController()
        let navigationController = UINavigationController(rootViewController: dashboard)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    func presentEmployeeFlow() {
        let dashboard = EmployeeDashboardTabBarController()
        let navigationController = UINavigationController(rootViewController: dashboard)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    func compliteCustomerRegistration() {
        let navigationController = UINavigationController(rootViewController: AuthorizationVC())
        navigationController.pushViewController(RegistrationMainVC(), animated: false)
        navigationController.navigationBar.isHidden = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
