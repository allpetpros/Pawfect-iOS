//
//  DBManager.swift
//  p103-customer
//
//  Created by Alex Lebedev on 16.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import RealmSwift

enum UserDefaultsKeys: String {
    case userAccessToken
    case userRole
    case status
    case balance
    case userDeviceToken
    
}
enum CurrentUserType {
    case customer
    case employee
    
    init?(role: String) {
        switch role {
        case "customer":
            self = .customer
        case "employee":
            self = .employee
        default:
            return nil
        }
        
    }
}

class DBManager {
    static let shared = DBManager()
    let realm = try! Realm()
    
    //TOKEN
    private init() {}
    
    func getAccessToken() -> String? {
        let token = UserDefaults.standard.string(forKey: UserDefaultsKeys.userAccessToken.rawValue)
        if let savedToken = token {
            return savedToken
        } else {
            return nil
        }
    }
    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.userAccessToken.rawValue)
    }
    func removeAccessToken() {
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userAccessToken.rawValue)
        
        let deviceToken = getDeviceToken()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.set(deviceToken, forKey: UserDefaultsKeys.userDeviceToken.rawValue)
//        UserDefaults.synchronize(<#T##self: UserDefaults##UserDefaults#>)
    }
    //Role
    func getUserRole() -> CurrentUserType? {
        let key = UserDefaults.standard.string(forKey: UserDefaultsKeys.userRole.rawValue)
        if let key = key {
            if let role = CurrentUserType(role: key) { return role } else { return nil }
        } else {
            return nil
        }
    }
    
    func getStatus() -> Int? {

        let status = UserDefaults.standard.integer(forKey: UserDefaultsKeys.status.rawValue)
        print(status)
        return status
    }
    
    func saveStatus(_ status: Int) {
        UserDefaults.standard.set(status, forKey: UserDefaultsKeys.status.rawValue)
    }
    
    func getBalance() -> Double {
        let balance = UserDefaults.standard.double(forKey: UserDefaultsKeys.balance.rawValue)
        print(balance)
        return balance
    }
    
    func saveBalance(_ balance: Double) {
        UserDefaults.standard.set(balance, forKey: UserDefaultsKeys.balance.rawValue)
    }
    
    func saveUserRole(_ role: String) {
        
        UserDefaults.standard.set(role, forKey: UserDefaultsKeys.userRole.rawValue)
    }
    
    func removeUserRole() {
        
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userRole.rawValue)
    }
    
    func getDeviceToken() -> String? {
        let token = UserDefaults.standard.string(forKey: UserDefaultsKeys.userDeviceToken.rawValue)
        if let savedToken = token {
            return savedToken
        } else {
            return nil
        }
    }
    func saveDeviceToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.userDeviceToken.rawValue)
    }
    
    func removeDeviceToken() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userDeviceToken.rawValue)
}
    func updateCustomerProfile(_ customer: Customer) {
        let userForDelete = realm.objects(CustomerDB.self)
        if let userData = userForDelete.first {
            try! realm.write {
                realm.delete(userData)
            }
        }
        
        let customerDB = CustomerDB(customer: customer)
        
        try! realm.write {
            realm.add(customerDB)
        }
    }
    //Employee
    func getEmployeeProfile() -> Employee? {
        let fetchedUser = realm.objects(EmployeeDB.self)
        
        if let employee = fetchedUser.first {
            return Employee(employeeDB: employee)
        } else {
            return nil
        }
    }
    
    func updateEmployeeProfile(_ employee: Employee) {
        let userForDelete = realm.objects(EmployeeDB.self)
        if let userData = userForDelete.first {
            try! realm.write {
                realm.delete(userData)
            }
        }
        
        let employeeDB = EmployeeDB(employee: employee)
        
        try! realm.write {
            realm.add(employeeDB)
        }
    }
    
    
    

    func updateCustomerPets(_ pets: AllPets) {

    }
    
    
}
