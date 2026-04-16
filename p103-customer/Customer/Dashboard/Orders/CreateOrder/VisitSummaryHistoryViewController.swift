//
//  VisitSummaryHistoryViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 19.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import Cosmos

class VisitSummaryHistoryViewController: BaseViewController {
    
    //MARK: - UIProperties

    private let scrollView = UIScrollView()
    private let mainView = UIView()

    private let visitSummaryTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Visit Summary"
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    } ()
    
    private let backButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.backArrowCalendar(), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        b.contentVerticalAlignment = .fill
        b.contentHorizontalAlignment = .fill
        b.imageView?.clipsToBounds = true
        b.tintColor = .black
        b.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return b
    }()
    
    private let animalView: UIView = {
        let v = UIView()
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 5
        v.layer.cornerRadius = 10
        return v
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private let timeSummaryLabel: UILabel = {
        let l = UILabel()
        l.text = "12 Mar. 17:00 - 17:30"
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    private let fullTimeSummaryLabel: UILabel = {
        let l = UILabel()
        l.text = "30 min"
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 16)
        return l
    }()
    
    private let sitterLabel: UILabel = {
        let l = UILabel()
        l.text = "Sitter"
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 16)
        return l
    }()
    
    private let sitterAvatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.profile_test()
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        return iv
    } ()
    
    private let sitterNameLabel: UILabel = {
        let l = UILabel()
        l.text = "James"
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = .color293147
        return l
    } ()
    
    private let raitingView: CosmosView = {
        let v = CosmosView()
        v.settings.starSize = 10
        v.isUserInteractionEnabled = false
        return v
    } ()
    
    private let petsTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Pets"
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 16)
        return l
    }()
    
    private let petCardView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 5
        v.layer.cornerRadius = 10
        return v
    }()
    
    private let petAvatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let petNameLabel: UILabel = {
        let l = UILabel()
        l.text = "Fluffy"
        l.textColor = .color070F24
        l.font = R.font.aileronBold(size: 18)
        return l
    } ()
    
    private let breedLabel: UILabel = {
        let l = UILabel()
        l.text = "Border Collie"
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color606572
        return l
    }()
    
    private lazy var tableView: IntrinsicTableView = {
           let tableView = IntrinsicTableView()
           tableView.delegate = self
           tableView.dataSource = self
           tableView.separatorColor = .clear
           tableView.backgroundColor = .white
           tableView.allowsSelection = false
           tableView.register(UINib(nibName: VisitHistoryActionCell.className, bundle: nil),
                              forCellReuseIdentifier: VisitHistoryActionCell.className)
           return tableView
       }()
    
    private let reportTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Report"
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()

    
    
//MARK: - Properties
    var id = String()
    var typeOfHistory = String()
    var pets = [PetsId]()
    var serviceName = String()
    private var height = 65
    var checkListImageArr = [String]()
    var checkListArr = [ChecklistDetails] ()

//MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupScrollViewLayouts()
        getHistoryDetails()
    }
}
//MARK: - Setup Layout
 
private extension VisitSummaryHistoryViewController {
    func setupScrollViewLayouts() {
        
        scrollView.isUserInteractionEnabled = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.left.right.equalTo(self.scrollView.contentLayoutGuide)
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        
        setupHeaderLayout()
        setupSitterAndPetCards()
    }

    func setupHeaderLayout() {
        mainView.addSubviews([visitSummaryTitleLabel, backButton, timeSummaryLabel, fullTimeSummaryLabel, sitterLabel])
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.left.equalToSuperview().offset(25)
            $0.width.equalTo(21)
            $0.height.equalTo(15)
        }
        
        visitSummaryTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalTo(backButton.snp.right).offset(19)
        }
        
        timeSummaryLabel.snp.makeConstraints {
            $0.top.equalTo(visitSummaryTitleLabel.snp.bottom).offset(34)
            $0.left.equalToSuperview().offset(25)
        }
        
        fullTimeSummaryLabel.snp.makeConstraints {
            $0.top.equalTo(visitSummaryTitleLabel.snp.bottom).offset(34)
            $0.right.equalToSuperview().offset(-25)
        }
        
        sitterLabel.snp.makeConstraints {
            $0.top.equalTo(timeSummaryLabel.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(25)
        }
        
        setupSitterAndPetCards()
    }
    
    func setupSitterAndPetCards() {
        mainView.addSubviews([sitterNameLabel, sitterAvatarImageView, raitingView, petsTitleLabel,animalView,stackView])
        
        sitterAvatarImageView.snp.makeConstraints {
            $0.size.equalTo(30)
            $0.top.equalTo(sitterLabel.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(25)
        }
        
        sitterNameLabel.snp.makeConstraints {
            $0.left.equalTo(sitterAvatarImageView.snp.right).offset(13)
            $0.top.equalTo(sitterLabel.snp.bottom).offset(15)
        }

        raitingView.snp.makeConstraints {
            $0.left.equalTo(sitterAvatarImageView.snp.right).offset(13)
            $0.top.equalTo(sitterNameLabel.snp.bottom).offset(1)
        }
        
        petsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(sitterAvatarImageView.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(25)
        }
        animalView.snp.makeConstraints {
            $0.height.equalTo(height)
            $0.top.equalTo(petsTitleLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(animalView).offset(25)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-20)
        }

        reportSetupLayout()
    }
    
    func reportSetupLayout() {

        mainView.addSubviews([reportTitleLabel,tableView])
        reportTitleLabel.snp.makeConstraints {
            $0.top.equalTo(animalView.snp.bottom).offset(40)
            $0.left.equalToSuperview().offset(25)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(reportTitleLabel.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? -20)
        }

    }
    

    // PETS SETUP
    func petsSetup() {
        var i = 0
        
        while i != pets.count {
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.spacing = 20
            
            let firstSV = UIStackView()
            firstSV.axis = .horizontal
            firstSV.distribution = .fillProportionally
            firstSV.alignment = .fill
            firstSV.spacing = 10
            
            let secondSV = UIStackView()
            secondSV.axis = .horizontal
            secondSV.distribution = .fillProportionally
            secondSV.alignment = .fill
            secondSV.spacing = 10
            
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronBold(size: 18)
            label.text = pets[i].name
            
            let label2 = UILabel()
            label2.textColor = .color070F24
            label2.font = R.font.aileronBold(size: 18)
            
            let img = UIImageView()
            img.layer.cornerRadius = 10
            img.clipsToBounds = true
            img.image = R.image.alertBox()
            
            let img2 = UIImageView()
            img2.layer.cornerRadius = 10
            img2.clipsToBounds = true
            img2.image = R.image.alertBox()
            
            if pets[i].name.count > 6 {
                label.font = R.font.aileronBold(size: 15)
            }
            
            if let image = pets[i].imageUrl {
                img.sd_setImage(with: URL(string: image))
            }
            
            i+=1
            
            if i != pets.count {
                label2.text = pets[i].name
                if pets[i].name.count > 6 {
                    label2.font = R.font.aileronBold(size: 15)
                }
                if let image = pets[i].imageUrl {
                    img2.sd_setImage(with: URL(string: image))
                }
                i+=1
            }
            
            firstSV.addArrangedSubviews(views: img, label)
            
            secondSV.addArrangedSubviews(views: img2, label2)
            
            img.snp.makeConstraints {
                $0.size.equalTo(45)
            }

            img2.snp.makeConstraints {
                $0.size.equalTo(45)
            }
            
            stack.addArrangedSubviews(views: firstSV, secondSV)

            stackView.addArrangedSubview(stack)

            height += 45
            animalView.snp.remakeConstraints {
                $0.top.equalTo(petsTitleLabel.snp.bottom).offset(30)
                $0.height.equalTo(height)
                $0.left.equalToSuperview().offset(10)
                $0.right.equalToSuperview().offset(-10)
            }
        }
    }
}

//MARK: - Action

extension VisitSummaryHistoryViewController {
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}


// MARK: - Network
extension VisitSummaryHistoryViewController {
    func getHistoryDetails() {
        
        CustomerService().getHistoriesDetails(ordersId: id) { result in
            print("History Detail Result",result)
            switch result {
            case .success(let success):
                self.sitterNameLabel.text = "\(success.employee!.name) \(success.employee!.surname)"
                if let imgCustomer = success.employee?.imageUrl {
                    self.sitterAvatarImageView.sd_setImage(with: URL(string: imgCustomer))
                }
                
                for i in 0..<success.checklist.count {
                    for j in 0..<success.checklist[i].attachmentUrls.count {
                        if !success.checklist[i].attachmentUrls[j].isEmpty {
                            self.checkListImageArr.append(success.checklist[i].attachmentUrls[j])
                        }
                    }
                }
               
                let timeFrom = CommonFunction.shared.toDate(millis: Int64(success.timeFrom))
                let timeTo = CommonFunction.shared.toDate(millis: Int64(success.timeFrom))
                
                self.timeSummaryLabel.text = self.getDateInString(millis: Int64(success.timeFrom)) + ". " + CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom) + "-" + CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo)
                self.raitingView.rating = success.employee?.rating ?? 0.0
                self.pets = success.pets
                self.checkListArr = success.checklist
                self.petsSetup()
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
}


extension VisitSummaryHistoryViewController {
    func getDateInString(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        
        return dateFormatter.string(from: date)
    }
}


//MARK: - UITableviewDelegate & UITableviewDataSource Methods

extension VisitSummaryHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VisitHistoryActionCell.className, for: indexPath) as? VisitHistoryActionCell else { return VisitHistoryActionCell() }
        cell.numberOfActionLabel.text = "\(indexPath.row + 1)"
        cell.actionLabel.text = checkListArr[indexPath.row].name
        cell.actionNameLabel.text = checkListArr[indexPath.row].name
        cell.actionImageArr = checkListArr[indexPath.row].attachmentUrls
        if indexPath.row == checkListArr.count - 1 {
            cell.lineView.isHidden = true
        } else {
            cell.lineView.isHidden = false
        }
        
        if checkListArr[indexPath.row].attachmentUrls.isEmpty {
            cell.attachmentLabel.isHidden = true
            cell.actionImageCollectionView.isHidden = true
        } else {
            cell.attachmentLabel.isHidden = false
            cell.actionImageCollectionView.isHidden = false
        }
        
        cell.actionDurationLabel.text = CommonFunction.shared.toDate(millis: Int64(checkListArr[indexPath.row].actions[0].time))
        cell.setupUI()
        cell.actionImageCollectionView.reloadData()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
