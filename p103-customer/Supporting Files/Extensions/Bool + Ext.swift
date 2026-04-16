//
//  Bool + Ext.swift
//  p103-customer
//
//  Created by Alex Lebedev on 10.08.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
extension Bool {
var data:Data {
    var _self = self
    return Data(bytes: &_self, count: MemoryLayout.size(ofValue: self))
}


}
