//
//  TimeOffCell.swift
//  p103-customer
//
//  Created by Alex Lebedev on 25.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

protocol TimeOffCellDelegate: class {
    func startReloadSizes()
    func finishReloadSizes()
    func editButtonTapped(id: String, notes: String, dates: [Int])
}

enum TimeOffCellTypes: CaseIterable {
    case businessTrip
    case sickLeave
    case other
}

class TimeOffCell: UITableViewCell {
    
    //MARK: - IBOutlets

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bottomArrowImageView: UIImageView!

    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var stackTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var noteValueLabel: UILabel!
    
    private let statusLabel: UILabel = {
        let l = UILabel()
        l.text = "approved"
        l.font = R.font.aileronBold(size: 12)
        l.textColor = .black
        return l
    } ()
    
    private let editButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.edit(), for: .normal)
        return b
    } ()
    
    //MARK: - Properties
    
    weak var delegate: TimeOffCellDelegate?
    private var employeeId = String()
    private var statusOrder = String()
    private var datesArr = [Int]()
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        displayNote(selected)
    }
    
    //MARK: - Setup Cell
    
    private func configure() {
        addSubviews([statusLabel, editButton])
        
        statusLabel.snp.makeConstraints {
            $0.right.equalTo(bottomArrowImageView.snp.left).offset(-20)
            $0.top.equalToSuperview().offset(20)
        }
        
        editButton.isHidden = true
        
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        
        mainLabel.font = R.font.aileronRegular(size: 14)
        dateLabel.font = R.font.aileronLight(size: 12)

        dateLabel.textColor = .color606572
        
        noteLabel.text = "Notes"
                
        let origImage = R.image.edit()
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        editButton.setImage(tintedImage, for: .normal)
        editButton.tintColor = .color293147
        
        bottomArrowImageView.tintColor = .color293147
        separatorView.backgroundColor = .colorE8E9EB
        
        noteLabel.font = R.font.aileronLight(size: 12)
        noteValueLabel.font = R.font.aileronRegular(size: 14)
        noteLabel.textColor = .colorAAABAE
        noteValueLabel.textColor = .color070F24
    }
    
    private func displayNote(_ display: Bool) {
          delegate?.startReloadSizes()
        print("Display",display)
        if bottomArrowImageView.image == R.image.bottomButtonArrow() {
            if display {
            if statusOrder == "waiting" {
                bottomArrowImageView.image = R.image.topButtonArrow()
                stackTopConstraint.constant = 18
                stackBottomConstraint.constant = -25
                noteLabel.isHidden = false
                noteValueLabel.isHidden = false
                
                mainLabel.snp.remakeConstraints {
                    $0.top.equalToSuperview().offset(10)
                    $0.left.equalToSuperview().offset(60)
                }
                editButton.isHidden = false
                
                editButton.snp.makeConstraints {
                    $0.size.equalTo(16)
                    $0.left.equalToSuperview().offset(26)
                    $0.top.equalToSuperview().offset(20)
                }
                
            } else {
                bottomArrowImageView.image = R.image.topButtonArrow()
                stackTopConstraint.constant = 18
                stackBottomConstraint.constant = -25
                noteLabel.isHidden = false
                noteValueLabel.isHidden = false
            }
            }
        } else {
            bottomArrowImageView.image = R.image.bottomButtonArrow()
            stackTopConstraint.constant = 5
            stackBottomConstraint.constant = -5
            noteLabel.isHidden = true
            noteValueLabel.isHidden = true
            
            mainLabel.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(10)
                $0.left.equalToSuperview().offset(26)
            }
            
            editButton.isHidden = true
        }
        delegate?.finishReloadSizes()
        
        
    }
}

//MARK: - Action

extension TimeOffCell {
    @objc func editButtonAction() {
        
        delegate?.editButtonTapped(id: employeeId,notes: noteValueLabel.text ?? "", dates: datesArr)
    }
}

//MARK: - Public func

extension TimeOffCell {
    func setupCell(type: String, typeCalendar: String, note: String, status: String, dates: [Int], id: String) {
        
        statusOrder = status
        employeeId = id
        datesArr = dates
        mainLabel.text = type
        noteValueLabel.text = note
        setupColor(status: status)
        statusLabel.text = status
        if typeCalendar == "range" {
            if dates.count >= 2 {
                setupRange(dateFrom: dates[0], dateTo: dates[dates.count-1])
            } else {
                dateLabel.text = "\(toDate(millis: dates[0]))"
            }
        } else if typeCalendar == "separated" {
            setupSeparated(dates: dates)
        }
    }
}

//MARK: - Additional func for cell`s setup

private extension TimeOffCell {
    func setupRange(dateFrom: Int, dateTo: Int) {
        dateLabel.text = "\(toDate(millis: dateFrom)) - \(toDate(millis: dateTo))"
    }
    
    func setupSeparated(dates: [Int]) {
        var datesArr = [String]()
        for i in dates {
            datesArr.append(toDate(millis: i))
        }
        dateLabel.text = datesArr.joined(separator: ",")
    }
    
    func toDate(millis: Int) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }
    
    private func setupColor(status: String) {
        switch status {
        case "approved":
            statusLabel.textColor = R.color.approvedColor()
        case "waiting":
            statusLabel.textColor = R.color.waitingColor()
        default:
            statusLabel.textColor = R.color.declinedColor()
        }
    }
}
