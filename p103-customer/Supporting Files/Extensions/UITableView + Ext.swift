//
//  UITableView + Ext.swift
//  u92
//
//  Created by Developer on 4/11/19.
//  Copyright © 2019 Anastasia Zhdanova. All rights reserved.
//
// swiftlint:disable all


import UIKit

extension UITableView {
    
    var indexPathForLastRow: IndexPath? {
        return indexPathForLastRow(inSection: lastSection)
    }
    
    var lastSection: Int {
        return numberOfSections > 0 ? numberOfSections - 1 : 0
    }
    
    func scrollAtBottomToRow(at indexPath: IndexPath?, animated: Bool = true) {
        guard let indexPath = indexPath else { return }
        DispatchQueue.main.async {
            self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
    func scrollToVeryBottom(animated: Bool = true) {
        scrollAtBottomToRow(at: indexPathForLastRow, animated: animated)
    }
    
    func indexPathForLastRow(inSection section: Int) -> IndexPath? {
        guard section >= 0 else { return nil }
        guard numberOfRows(inSection: section) > 0 else {
            return IndexPath(row: 0, section: section)
        }
        return IndexPath(row: numberOfRows(inSection: section) - 1, section: section)
    }
    
    /// Reload data with a completion handler.
    ///
    /// - Parameter completion: completion handler to run after reloadData finishes.
    func reloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() }, completion: { _ in completion() })
    }
    
    func register(_ cellClass: AnyClass) {
        register(cellClass,
                 forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeue<T: UITableViewCell>(
        _ cellClass: T.Type, for indexPath: IndexPath) -> T? {
        dequeueReusableCell(withIdentifier: String(describing: cellClass),
                            for: indexPath) as? T
    }
    
    func dequeue<T: UITableViewCell>(
        _ cellClass: T.Type, for row: Int) -> T? {
        dequeue(cellClass, for: IndexPath(row: row, section: 0))
    }
    
    func scroll(to item: Int, section: Int = 0,
                at position: ScrollPosition = .top, animated: Bool = true) {
        scrollToRow(at: IndexPath(row: item, section: section), at: position,
                    animated: animated)
    }
    
    func selectRow(at index: Int, animated: Bool = true,
                   scrollPosition: UITableView.ScrollPosition = .top) {
        let indexPath = IndexPath(row: index, section: 0)
        selectRow(at: indexPath, animated: animated,
                  scrollPosition: scrollPosition)
    }
    
    func deselectSelectedRows(animated: Bool) {
        if let indexPathsForSelectedRows = self.indexPathsForSelectedRows {
            indexPathsForSelectedRows.forEach { indexPath in
                self.deselectRow(at: indexPath, animated: animated)
            }
        }
    }
}
