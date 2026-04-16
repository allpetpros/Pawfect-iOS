//
//  UICollectionView + Extension.swift
//  Flock
//
//  Created by Anton Yanko on 12.11.2020.
//  Copyright © 2020 Anton Yanko. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register(_ cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeue<T: UICollectionViewCell>(
        _ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(
            withReuseIdentifier: String(describing: cellClass),
            for: indexPath) as? T
    }
    
    func scroll(to page: Int, section: Int = 0,
                at position: ScrollPosition = .left, animated: Bool = true) {
        scrollToItem(at: IndexPath(row: page, section: section), at: position,
                     animated: animated)
    }
}
