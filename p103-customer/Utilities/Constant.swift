//
//  Constant.swift
//  p103-customer
//
//  Created by SOTSYS371 on 27/07/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit
import FittedSheets

class Constant: NSObject {
    static let baseURL = "http://dev1.spaceo.in/pawfect_web_qa" // Development URL
    
    static let MobileNumberMaxLimit = 14
    static let EmergencyContactMaxLimit = 13
    static let USMobileNumberLimit = 10
    static var sheet: SheetViewController?
    static var option: SheetOptions?
    static var height = 200
}
