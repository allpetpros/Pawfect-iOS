//
//  EmployeeDashboardTabBarController.swift
//  p103-customer
//
//  Created by Alex Lebedev on 04.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

class EmployeeDashboardTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.unselectedItemTintColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        self.tabBar.tintColor = .colorC6222F
        self.tabBar.barTintColor = .white
        self.delegate = self
        
        let profileVC = EmployeeProfileVC()
        profileVC.tabBarItem = UITabBarItem(title:"Profile", image: R.image.user(), tag: 0)
        
        let petsVC = EmployeeOrdersVC()
        petsVC.tabBarItem =  UITabBarItem(title: "Orders", image: R.image.pets(), tag: 1)
        
        let mapVC = UINavigationController(rootViewController: MapCurrentOrdersViewController())
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: R.image.map(), tag: 2)
        
        viewControllers = [profileVC, petsVC, mapVC]
    }
    
    

   
}
