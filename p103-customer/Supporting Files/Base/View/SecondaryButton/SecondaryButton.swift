//
//  SecondaryButton.swift
//  p103-customer
//
//  Created by Yaroslav on 10/2/19.
//  Copyright © 2019 PULS Software. All rights reserved.
//

import UIKit

enum SecondaryButtonType {
    case nextSmall
    case nextBig
    case plus
    case edit
    case none
    case ok
    case close
    case create
    case cross
}

class SecondaryButton: UIView {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var imageTrailingConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit () {
        Bundle.main.loadNibNamed("SecondaryButton", owner: self, options: nil)
            self.addSubview(containerView)
            containerView.frame = self.bounds
            self.isUserInteractionEnabled = true
    }
    
    func setupButton (title: String, type: SecondaryButtonType, bordered: Bool) {
        if bordered {
            containerView.borderWidth = 1
            containerView.layer.cornerRadius = 10
        }
        
        self.titleLabel.font = R.font.aileronRegular(size: 14)
        self.titleLabel.text = title
        self.titleLabel.textColor = .colorC6222F
        self.image.tintColor = .colorC6222F
        
        switch type {
        case .edit:
            self.image.image = R.image.edit()!
            containerView.borderColor = .colorC6222F
        case .nextSmall:
            self.image.image = R.image.small_arrow_right()!
            imageTrailingConstraint.constant = 8
            image.snp.updateConstraints {
                $0.height.equalTo(8)
                $0.width.equalTo(11)
            }
            containerView.borderColor = .colorC6222F
        case .nextBig:
            self.image.image = R.image.arrow_right()!
            image.snp.updateConstraints {
                $0.height.equalTo(9)
                $0.width.equalTo(13)
            }
            containerView.borderColor = .clear
            self.titleLabel.textColor = .white
            self.image.tintColor = .white
            self.titleLabel.font = R.font.aileronBold(size: 18)
        case .plus:
            self.image.image = R.image.plus()!
            containerView.borderColor = .colorC6222F
        case .none:
            self.image.image = nil
            containerView.borderColor = .colorC6222F
        case .ok:
            self.image.image = R.image.ok()
            containerView.borderColor = .clear
            self.titleLabel.textColor = .white
            self.image.tintColor = .white
            self.titleLabel.font = R.font.aileronBold(size: 18)
        case .close:
            self.image.image = R.image.closeEmailIcon()!
           
            containerView.borderColor = .colorC6222F
            
        case .cross:
            self.image.image = R.image.closeTest()
            containerView.borderColor = .clear
            self.titleLabel.textColor = .white
            self.image.tintColor = .white
            self.titleLabel.font = R.font.aileronBold(size: 18)
        case .create:
            containerView.borderColor = .clear
            self.titleLabel.textColor = .white
            self.image.image = nil
            self.titleLabel.font = R.font.aileronBold(size: 18)
            self.titleLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
    }
    
    func redAndGrayStyleMain(active: Bool) {
        if active {
            self.isUserInteractionEnabled = true
            self.containerView.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
//            self.containerView.layer.shadowOpacity = 1
            self.containerView.layer.shadowRadius = 7
            self.containerView.layer.shadowColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1).cgColor
            self.containerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        } else {
             self.isUserInteractionEnabled = false
            self.containerView.backgroundColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
//            self.containerView.shadowColor = .clear
            self.containerView.shadowOpacity = 0
            self.containerView.shadowRadius = 0
        }
    }
    func redAndGrayStyleAdditional(active: Bool) {
         if active {
            containerView.borderColor = .colorC6222F
            self.titleLabel.textColor = .colorC6222F
            self.image.tintColor = .colorC6222F
         } else {
            containerView.borderColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
            self.titleLabel.textColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
            self.image.tintColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
         }
     }
    
    // MARK: - Animation
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isUserInteractionEnabled {
        UIView.animate(withDuration: 0.1) {
             self.containerView.backgroundColor = #colorLiteral(red: 0.7764705882, green: 0.1333333333, blue: 0.1843137255, alpha: 1)
             self.containerView.borderColor = #colorLiteral(red: 0.7764705882, green: 0.1333333333, blue: 0.1843137255, alpha: 1)
        }
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isUserInteractionEnabled {
            UIView.animate(withDuration: 0.1) {
                if #available(iOS 13, *) {
                            self.containerView.backgroundColor = .systemBackground
                    self.containerView.borderColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)

                }
                else {
                    self.containerView.backgroundColor = .white
                    self.containerView.borderColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
                }
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.isUserInteractionEnabled {
            UIView.animate(withDuration: 0.1) {
                         if #available(iOS 13, *) {
                                  self.containerView.backgroundColor = .systemBackground
                            self.containerView.borderColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
                      }
                      else {
                          self.containerView.backgroundColor = .white
                            self.containerView.borderColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
                      }
            }
        }
    }
    
}
