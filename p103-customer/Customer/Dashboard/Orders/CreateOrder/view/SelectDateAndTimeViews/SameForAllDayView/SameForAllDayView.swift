//
//  SameForAllDayView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 22.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
protocol SameForAllDayViewDelegate: class {
    func close(with: Bool)
}
class SameForAllDayView: UIView {
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorH: UIView!
    @IBOutlet weak var separatorV: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    // MARK: - Property
    weak var delegate: SameForAllDayViewDelegate?
    
    @IBAction func leftButtonAction(_ sender: UIButton) {
        delegate?.close(with: true)
    }
    @IBAction func rightButtonAction(_ sender: UIButton) {
         delegate?.close(with: false)
    }
    
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
        Bundle.main.loadNibNamed(SameForAllDayView.className, owner: self, options: nil)
        self.addSubview(containerView)
        containerView.frame = self.bounds
        self.isUserInteractionEnabled = true
        self.snp.makeConstraints {
            $0.width.equalTo(212)
            $0.height.equalTo(106)
        }
        configure()
    }
    
    private func configure() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        titleLabel.text = "Will scheduled times be the same for all days?"
        leftButton.setTitle("Yes", for: .normal)
        rightButton.setTitle("No", for: .normal)
        titleLabel.textColor = .color070F24
        leftButton.setTitleColor(.color070F24, for: .normal)
        rightButton.setTitleColor(.color070F24, for: .normal)
        titleLabel.font = R.font.aileronRegular(size: 14)
        leftButton.titleLabel?.font = R.font.aileronRegular(size: 14)
        rightButton.titleLabel?.font = R.font.aileronRegular(size: 14)
        separatorH.backgroundColor = .colorE8E9EB
        separatorV.backgroundColor = .colorE8E9EB
        
    }
}
