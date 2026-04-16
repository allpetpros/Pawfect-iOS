//
//  CustomerSummaryTableCell.swift
//  p103-customer
//
//  Created by SOTSYS371 on 17/06/22.
//  Copyright © 2022 PULS Software. All rights reserved.
//

import UIKit

class CustomerSummaryTableCell: UITableViewCell {
    //MARK: - IBOutlet
    @IBOutlet weak var thirdStepLabel: UILabel!
    @IBOutlet weak var summaryImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var summaryDataTableView: UITableView!
    @IBOutlet weak var doneButtonTapped: UIButton!
    
    //MARK: - Cell Method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
        summaryDataTableView.register(UINib(nibName: "SummaryCell", bundle: nil), forCellReuseIdentifier: "SummaryCell")
        summaryDataTableView.delegate = self
        summaryDataTableView.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        thirdStepLabel.font = R.font.aileronBold(size: 12)
        thirdStepLabel.textColor = UIColor(red: 0.992, green: 0.992, blue: 0.992, alpha: 1)
        thirdStepLabel.backgroundColor =  UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        thirdStepLabel.layer.cornerRadius = thirdStepLabel.frame.width/2
        doneButtonTapped.setTitle("Done", for: .normal)
        doneButtonTapped.cornerRadius = 15
        doneButtonTapped.titleLabel?.font = R.font.aileronBold(size: 18)
        doneButtonTapped.redAndGrayStyle(active: true)
        thirdStepLabel.layer.masksToBounds = true
    }
    
}


//MARK: - UITableview Delegate & Datasource

extension CustomerSummaryTableCell: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return summaryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! SummaryCell
        cell.summaryNameLabel.text = summaryArray[indexPath.row].name
        cell.summaryDurationLabel.text = CommonFunction.shared.toDate(millis: Int64(summaryArray[indexPath.row].starttime))
        return cell 
    }
    
}
