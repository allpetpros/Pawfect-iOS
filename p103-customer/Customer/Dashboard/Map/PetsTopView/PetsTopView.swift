//
//  PetsTopView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 10.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
protocol PetsTopViewDelegate: class {
   func stateButtonTouched(open: Bool )
}
class PetsTopView: UIView {
    
    // MARK: - Outlets
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stateButton: UIButton!

    weak var delegate: PetsTopViewDelegate?
    private var open: Bool = false {
        willSet {
            stateButton.setImage(newValue ? R.image.topButtonArrow() : R.image.bottomButtonArrow(), for: .normal)
        }
    }
    var cells = 3
    // MARK: - Actions
    @IBAction func stateButtonAction(_ sender: UIButton) {
        self.open = !open
        cells = open ? 7 : 3
        delegate?.stateButtonTouched(open: open)
        collectionView.reloadData()
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
        Bundle.main.loadNibNamed("PetsTopView", owner: self, options: nil)
        self.addSubview(containerView)
        containerView.backgroundColor = .white
        containerView.frame = self.bounds
        self.isUserInteractionEnabled = true
        configure()
       
    }
    
    // MARK: - Functions
    private func configure() {
        configureCollectionView()
        stateButton.tintColor = .colorC6222F
        
        mainLabel.textColor = .color606572
        mainLabel.font = R.font.aileronRegular(size: 14)
        mainLabel.text = "Sitting with"
        
        containerView.layer.cornerRadius = 2
        containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
//        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
//        containerView.layer.shadowOpacity = 1
//        containerView.layer.shadowRadius = 15
//        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
//        containerView.addShadowToSide(top: false, left: false, bottom: true, right: true, shadowRadius: 15, color: UIColor(red: 0, green: 0, blue: 0, alpha: 1), offSet: CGSize(width: 0, height: 4), opacity: 1)
    }
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: PetWithNameCell.className, bundle: nil), forCellWithReuseIdentifier: PetWithNameCell.className)
    }
}

// MARK: - Extensions
extension PetsTopView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetWithNameCell.className, for: indexPath) as? PetWithNameCell else { return PetWithNameCell() }
        cell.clipsToBounds = false
        return cell
    }
}
extension PetsTopView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 - 10, height: 30)
    }
}
