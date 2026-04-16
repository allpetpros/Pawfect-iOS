//
//  CustomMarker.swift
//  p103-customer
//
//  Created by SOTSYS371 on 14/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit

class CustomMarker: UIView {

    //MARK: - IBOutlet
    @IBOutlet weak var customViewImage: UIImageView!
    @IBOutlet weak var petActionName: UILabel!
    
 
    
    public static func showAlert(title: String) -> CustomMarker {
            let vw = UINib(nibName: "CustomMarker", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomMarker
        vw.petActionName.text = title
        vw.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return vw
    }
    

}
