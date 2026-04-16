//
//  HistoryVisitSummaryViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 29.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit

class HistoryVisitSummaryViewController: BaseViewController {

    //MARK: - UIProperties
    
    private let scrollView = UIScrollView()
    private let mainView = UIView()
    var checkListImageArr = [String]()
    
    
    private let backButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.backButtonImage(), for: .normal)
        b.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let visitSummaryTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Visit Summary"
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    } ()
    
    private let petOwnerTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Pet Owner"
        l.font = R.font.aileronHeavy(size: 16)
        l.textColor = .black
        return l
    } ()
    
    private let customerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.profile_test()
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    } ()
    
    private let customerNameLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronBold(size: 18)
        return l
    } ()
    
    private let petsTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Pets"
        l.font = R.font.aileronHeavy(size: 16)
        l.textColor = .black
        return l
    } ()
    
    private let animalView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 5
        v.layer.cornerRadius = 10
        return v
    } ()
    
    private let reportTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Report"
        l.textColor = .black
        l.font =  R.font.aileronHeavy(size: 16)
        return l
    } ()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
//
    private let timeOfOrderLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .black
        return l
    } ()
    
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

    //MARK: - Properties
    
    var id = String()
    var typeOfHistory = String()
    var service = String()
    
    private var pets = [PetsId]()
    private var height = 65
    var checkListArr = [Checklist] ()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        getEmployeeHistoryDetails()

        setupScrollViewLayouts()
        setupLayout()
    }
}

//MARK: - Setup Layout

private extension HistoryVisitSummaryViewController {
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
    }
    
    func setupLayout() {
        mainView.addSubviews([backButton, visitSummaryTitleLabel, petOwnerTitleLabel, customerImageView, customerNameLabel, petsTitleLabel, animalView, stackView])
        
        visitSummaryTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.left.equalToSuperview().offset(60)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalTo(visitSummaryTitleLabel)
            $0.width.equalTo(21)
            $0.height.equalTo(15)
            $0.left.equalToSuperview().offset(25)
        }
        
        petOwnerTitleLabel.snp.makeConstraints {
            $0.top.equalTo(visitSummaryTitleLabel.snp.bottom).offset(34)
            $0.left.equalToSuperview().offset(25)
        }
        
        customerImageView.snp.makeConstraints {
            $0.top.equalTo(petOwnerTitleLabel.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(25)
            $0.size.equalTo(30)
        }
        
        customerNameLabel.snp.makeConstraints {
            $0.left.equalTo(customerImageView.snp.right).offset(13)
            $0.centerY.equalTo(customerImageView)
        }
        
        petsTitleLabel.snp.makeConstraints {
            $0.top.equalTo(customerImageView.snp.bottom).offset(30)
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
        setupReportLayout()
    }
    
    func setupReportLayout() {

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

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension HistoryVisitSummaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return checkListImageArr.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeue(AttachmentsPhotoCollectionViewCell.self, for: indexPath) else { return UICollectionViewCell() }
        let image = checkListImageArr[indexPath.row]
        cell.attachmentImageView.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension HistoryVisitSummaryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

//MARK: - Action

extension HistoryVisitSummaryViewController {
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Network

private extension HistoryVisitSummaryViewController {
    func getEmployeeHistoryDetails() {
        
        EmployeeService().getHistoryDetails(id: id) { result in
            print("Employee History Details",result)
            switch result {
            case .success(let success):
                
                self.customerNameLabel.text = "\(success.customer.name) \(success.customer.surname)"
                if let imgCustomer = success.customer.imageUrl {
                    self.customerImageView.sd_setImage(with: URL(string: imgCustomer))
                }
                self.pets = success.pets
                self.timeOfOrderLabel.text = "\(success.totalDuration) min"

                self.checkListArr = success.checklist
                self.petsSetup()
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
}

//MARK: - UITableviewDelegate & UITableviewDataSource Methods

extension HistoryVisitSummaryViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        cell.actionDurationLabel.text = CommonFunction.shared.toDate(millis: Int64(checkListArr[indexPath.row].actions?[0].time ?? 0))
        cell.setupUI()
        cell.actionImageCollectionView.reloadData()
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
