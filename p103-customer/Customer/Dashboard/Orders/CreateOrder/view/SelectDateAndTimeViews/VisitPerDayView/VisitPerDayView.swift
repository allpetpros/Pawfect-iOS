//
//  VisitPerDayView.swift
//  p103-customer
//
//  Created by Alex Lebedev on 22.07.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

protocol VisitPerDayViewDelegate: class {
    func numberOfDayChanged(number: Int)
}
class VisitPerDayView: UIView {
    // MARK: - UI Property
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UINib(nibName: DayCountCell.className, bundle: nil), forCellReuseIdentifier: DayCountCell.className)
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.dataSource = self
        return tableView
    }()
    
    // MARK: - Property
    
    weak var delegate: VisitPerDayViewDelegate?
    var selectedItem: Int?
    
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
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.addSubview(tableView)
        self.snp.makeConstraints {
            $0.width.equalTo(190)
            $0.height.equalTo(160)
        }
        tableView.delegate = self
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
extension VisitPerDayView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DayCountCell.className, for: indexPath) as? DayCountCell else { return UITableViewCell() }
        cell.perDaySetup(value: indexPath.row, selected: selectedItem == indexPath.row)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        label.font = R.font.aileronRegular(size: 14)
        label.textColor = .color070F24
        label.text = "Visits Per Day Needed?"
        label.textAlignment = .center
        
        return view
    }
}

extension VisitPerDayView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = indexPath.row
        tableView.reloadData()
    }
}
