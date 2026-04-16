//
//  UIScrollView + Ext.swift
//  u92
//
//  Created by Developer on 4/10/19.
//  Copyright © 2019 Anastasia Zhdanova. All rights reserved.
//
// swiftlint:disable all


import UIKit

extension UIScrollView {
    
    enum ScrollDirection {
        case top
        case right
        case bottom
        case left
        case unknown
        
        func contentOffset(with scrollView: UIScrollView) -> CGPoint {
            switch self {
            case .top:
                return CGPoint(x: 0, y: -scrollView.contentInset.top)
            case .right:
                return CGPoint(x: scrollView.contentSize.width - scrollView.bounds.size.width, y: 0)
            case .bottom:
                return CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
            case .left:
                return CGPoint(x: -scrollView.contentInset.left, y: 0)
            case .unknown:
                return CGPoint.zero
            }
        }
    }
    
    func scrollTo(_ direction: ScrollDirection, animated: Bool = true) {
        self.setContentOffset(direction.contentOffset(with: self), animated: animated)
    }
    
    func resetScrollPositionToTop() {
        self.contentOffset = CGPoint(x: -contentInset.left, y: -contentInset.top)
    }
    
}
