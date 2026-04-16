//
//  UILabel + Ext.swift
//  p103-customer
//
//  Created by Alex Lebedev on 22.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func addImageToLeading(image: UIImage?, title: String, imageOffsetY: CGFloat, imageColor: UIColor? = nil) {

        // Create Attachment
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        
        // Set bound to reposition
        let imageOffsetY: CGFloat = imageOffsetY
       imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height + 3)
        // Create string with attachment
        let attachmentString = NSAttributedString(attachment: imageAttachment)
        // Initialize mutable string
        let completeText = NSMutableAttributedString(string: "")
        // Add image to mutable string
        completeText.append(attachmentString)
        // Add your text to mutable string
        let textAfterIcon = NSAttributedString(string: title)
        completeText.append(textAfterIcon)
        self.textAlignment = .center
        self.attributedText = completeText
    }
}
