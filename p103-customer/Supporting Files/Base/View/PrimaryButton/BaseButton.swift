//
//  BaseButton.swift
//  p103-customer
//
//  Created by Yaroslav on 9/3/19.
//  Copyright © 2019 PULS Software. All rights reserved.
//

import UIKit

enum BaseButtonType {
    case next
    case done
    case none
}

class BaseButton: UIView {
    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabelOutlet: UILabel!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    // MARK: - Properties
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
    Bundle.main.loadNibNamed("BaseButton", owner: self, options: nil)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        self.shadowColor = self.contentView.backgroundColor!
        self.shadowOpacity = 0.3
        self.shadowRadius = 15
        self.shadowOffset = CGSize(width: 0, height: 5)
    }
    func setupButton(with title: String, type: BaseButtonType) {
        self.titleLabelOutlet.text = title
        switch type {
        case .done:
            imageViewOutlet.image = UIImage(named: "ok")
            imageViewOutlet.tintColor = .white
        case .next:
            imageViewOutlet.image = UIImage(named: "arrow_right")
            imageViewOutlet.tintColor = .white
        case .none:
            imageViewOutlet.isHidden = true
        }
    }
    func setStatus (isActive: Bool) {
        if isActive == false {
            self.contentView.backgroundColor = .lightGray
            self.shadowColor = self.contentView.backgroundColor!
            self.isUserInteractionEnabled = false
        } else {
            self.contentView.backgroundColor = #colorLiteral(red: 0.9348044991, green: 0.2929496169, blue: 0.08026026934, alpha: 1)
            self.shadowColor = self.contentView.backgroundColor!
            self.isUserInteractionEnabled = true
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isUserInteractionEnabled {
        UIView.animate(withDuration: 0.1) {
            self.contentView.alpha = 0.7
        }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isUserInteractionEnabled {
            UIView.animate(withDuration: 0.1) {
                self.contentView.alpha = 1
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isUserInteractionEnabled {
            UIView.animate(withDuration: 0.1) {
                self.contentView.alpha = 1
            }
        }
    }
}
