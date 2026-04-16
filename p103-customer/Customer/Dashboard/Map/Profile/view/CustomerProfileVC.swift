
//  ProfileDashboardVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 08.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

enum CustomerProfileStates {
    case pets
    case payment
    case account
}

enum StartProfileStates {
    case pets
    case payment
}

enum paymentSections: CaseIterable {
    case card
    case description
    case transactions
}

class CustomerProfileVC: BaseViewController {
    
    // MARK: - UI Property
    //TopView
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 7
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 18)
        label.textColor = .color293147
        return label
    }()
    
    private let nameBtnPressed: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(nameButtonPressed), for: .touchUpInside)
        return b
    } ()
    private lazy var navigationView: NavigationView = {
        let view = NavigationView()
        
        view.setup(state: .customerProfile)
        view.customerProfileDelegate = self
        return view
    }()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.register(UINib(nibName: PetCell.className, bundle: nil),
                           forCellReuseIdentifier: PetCell.className)
        tableView.register(UINib(nibName: CardCell.className, bundle: nil),
                           forCellReuseIdentifier: CardCell.className)
        tableView.register(UINib(nibName: DescriptionCell.className, bundle: nil),
                           forCellReuseIdentifier: DescriptionCell.className)
        tableView.register(UINib(nibName: TransactionCell.className, bundle: nil),
                           forCellReuseIdentifier: TransactionCell.className)
        return tableView
    }()
    
    private let accountTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color606572
        label.text = "My Account"
        return label
    }()
    
    private let petsLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color606572
        label.text = "My Pets"
        return label
    }()
    
    private let addPetButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Add Pet", type: .plus, bordered: true)
        button.borderColor = .colorC6222F
        let addPetButtonAction = UIButton()
        addPetButtonAction.addTarget(self, action: #selector(addPetButtonTouched), for: .touchUpInside)
        button.addSubview(addPetButtonAction)
        addPetButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    private let addCardButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Add Payment Method", type: .plus, bordered: true)
        button.borderColor = .colorC6222F
        let addPetButtonAction = UIButton()
        addPetButtonAction.addTarget(self, action: #selector(addCardButtonTouched), for: .touchUpInside)
        button.addSubview(addPetButtonAction)
        addPetButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    private let removeCardButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Remove Card", type: .close, bordered: true)
        button.borderColor = .colorC6222F
        let addPetButtonAction = UIButton()
        addPetButtonAction.addTarget(self, action: #selector(removeCardButtonTouched), for: .touchUpInside)
        button.addSubview(addPetButtonAction)
        addPetButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    private let editAccountButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Edit", type: .edit, bordered: true)
        button.borderColor = .colorC6222F
        let addPetButtonAction = UIButton()
        addPetButtonAction.addTarget(self, action: #selector(editAccountButtonTouched), for: .touchUpInside)
        button.addSubview(addPetButtonAction)
        addPetButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 15
        button.backgroundColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        button.setTitle("Share with a friend", for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
        button.addTarget(self, action: #selector(shareButtonTouched), for: .touchUpInside)
        button.shadowColor = UIColor(red: 0.886, green: 0.251, blue: 0, alpha: 1)
        button.shadowOpacity = 0.5
        button.shadowRadius = 7
        button.shadowOffset = CGSize(width: 0, height: 5)
        return button
    }()
    
    private let logOutButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.logOutCustomerAccount(), for: .normal)
        b.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
        return b
    } ()
    
    //MARK: - RemoveCardAlert UIProperties
    
    private let backgroundAlertView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return v
    } ()
    
    private let alertBoxImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.alertFriendsBoxImageView()
        return iv
    } ()
    
    private let alertTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Are you sure you want to delete the card?"
        l.textColor = .color070F24
        l.font = R.font.aileronBold(size: 18)
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    } ()
    
    private let yesButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.yesButtonImage(), for: .normal)
        b.addTarget(self, action: #selector(yesButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let noButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.noButtonImage(), for: .normal)
        b.addTarget(self, action: #selector(noButtonAction), for: .touchUpInside)
        return b
    } ()
    
    private let cardsTitleLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color606572
        label.text = "My Cards"
        return label
    } ()
    
    private lazy var accountView: AccountView = {
        let v = AccountView()
        v.delegate = self
        return v
    } ()
    
    private let shareWithFriendButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.shareFriendImage(), for: .normal)
        b.addTarget(self, action: #selector(shareButtonTouched), for: .touchUpInside)
        return b
    } ()
    
    //MARK: -  Custom Alert View Properties For Delete Pets:

    
    private let backgroundAlertViewForDelete: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return v
    } ()
    
    private let alertBoxImageViewForDelete: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.alertFriendsBoxImageView()
        return iv
    } ()
    
    private let alertTitleLabelForDelete: UILabel = {
        let l = UILabel()
        l.text = "Are you sure you want to delete the Pet?"
        l.textColor = .color070F24
        l.font = R.font.aileronBold(size: 18)
        l.numberOfLines = 2
        l.textAlignment = .center
        return l
    } ()
    
    private let yesButtonForDelete: UIButton = {
        let b = UIButton()
        b.setImage(R.image.yesButtonImage(), for: .normal)
        b.addTarget(self, action: #selector(yesButtonForDeleteAction), for: .touchUpInside)
        return b
    } ()
    
    private let noButtonForDelete: UIButton = {
        let b = UIButton()
        b.setImage(R.image.noButtonImage(), for: .normal)
        b.addTarget(self, action: #selector(noButtonForDeleteAction), for: .touchUpInside)
        return b
    } ()
        
    // MARK: - Properties
    
    private let enableColor:UIColor = .colorC6222F
    private let dissableColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
    private var tableViewState: CustomerProfileStates = .pets
    private var stateProfile: StartProfileStates = .pets
    var profile: Customer?
    var indexpath: IndexPath?
    var noofPageforPetListing: Int?
    private var pets = [TestUniversal]()
    private var transactionArr = [TransactionItem]()
    private var transactionPetsArr = [Pet]()
    
    weak var delegateCards: WorkWithCardDelegate?
    weak var delegateDescriptionHide: DescriptionCellDelegate?
    weak var delegateTransactionHide: TransactionCellDelegate?
    weak var delegateCardsHide: CardCellHide?
    
    private var numberInPaymentSection = 3
    private var numberInAccountSection = 1
    private var numberInRowsInPayment = 5

    private var page = 1
    private var transactionHistoryPage = 1
    private var totalItems = 0
    private var totalTransactionItems = 0
    
    let noPetsLabel: UILabel = {
        let l = UILabel()
        l.text = "You need to add at least one Pet"
        l.textColor = .color070F24
        l.font = R.font.aileronRegular(size: 14)
        return l
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Access Token", DBManager.shared.getAccessToken() as Any)
        showView()
        
        getTransactionHistory()
        setupLayouts()
        self.navigationController?.navigationBar.isHidden =  true
        tableView.rowHeight = UITableView.automaticDimension
        self.tabBarController?.tabBar.backgroundColor = UIColor.white
        tableView.estimatedRowHeight = 100

    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("CardDataGet"), object: nil)
        getProfile()
        page = 1
        getPets()
        tableView.reloadData()
        if CardRemoverManager.shared.isAdd {
            if CardRemoverManager.shared.isEmpty {
                delegateDescriptionHide?.addCardsSetup()
                delegateCardsHide?.cardHideSetup()
                delegateTransactionHide?.transactionShowSetup()
                
            }
            delegateCards?.addCard()
            CardRemoverManager.shared.isAdd = false
        }
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden =  true
        
    }
  
   
}

//MARK: - Actions

extension CustomerProfileVC {
    @objc func methodOfReceivedNotification(notification: Notification) {
        hideActivityIndicator()
    }
    
    @objc func addPetButtonTouched() {
        let vc = AddPetViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addCardButtonTouched() {
        let vc = AddCardVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func removeCardButtonTouched() {
        if CardRemoverManager.shared.isEmpty {
            self.setupWarning(alert: "No Cards Added", isOrders: false)
        }
        
        if CardRemoverManager.shared.indexChoosen != -1 {
            view.addSubview(backgroundAlertView)
            backgroundAlertView.addSubviews([alertBoxImageView, alertTitleLabel, yesButton, noButton])
            backgroundAlertView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            alertBoxImageView.snp.makeConstraints {
                $0.height.equalTo(164)
                $0.width.equalTo(327)
                $0.center.equalToSuperview()
            }
            
            alertTitleLabel.snp.makeConstraints {
                $0.top.equalTo(alertBoxImageView.snp.top).offset(25)
                $0.left.equalTo(alertBoxImageView).offset(46)
                $0.right.equalTo(alertBoxImageView).offset(-46)
            }
            
            yesButton.snp.makeConstraints {
                $0.width.equalTo(120)
                $0.height.equalTo(55)
                $0.top.equalTo(alertBoxImageView).offset(100)
                $0.left.equalTo(alertBoxImageView).offset(23)
            }
            
            noButton.snp.makeConstraints {
                $0.width.equalTo(120)
                $0.height.equalTo(55)
                $0.top.equalTo(alertBoxImageView).offset(100)
                $0.left.equalTo(yesButton.snp.right).offset(40)
            }
        }
    }
    
    @objc func editAccountButtonTouched() {
        let vc = EditProfileViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func shareButtonTouched() {
        let vc = ShareWithFriendAlertViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - SetupLayouts

private extension CustomerProfileVC {
    
    private func setupNoPetsAdded() {
        view.addSubview(noPetsLabel)
        
        noPetsLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(100)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupTopView() {
        view.addSubviews([topView])
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(256)
        }
        topView.addSubviews([profileImageView, profileNameLabel, nameBtnPressed ,navigationView, logOutButton])
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.equalToSuperview().offset(16)
            $0.leading.equalToSuperview().inset(25)
        }
        profileNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalTo(logOutButton.snp.leading).offset(-15)
        }
        
        nameBtnPressed.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.leading)
            $0.trailing.equalTo(profileNameLabel.snp.trailing)
        }
        
        logOutButton.snp.makeConstraints {
            $0.width.equalTo(67)
            $0.height.equalTo(30)
            $0.top.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-25)
        }
        navigationView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(35)
        }
    }
    
    func setupTableView() {
        
        view.addSubviews([tableView, petsLabel, addPetButton, cardsTitleLabel, addCardButton, removeCardButton, editAccountButton, accountTitleLabel, accountView, shareWithFriendButton])
        switch stateProfile {
        case .pets:
            petsLabel.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom).offset(30)
                $0.leading.equalToSuperview().inset(25)
            }
            addPetButton.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom).offset(30)
                $0.trailing.equalToSuperview().inset(25)
                $0.width.equalTo(146)
                $0.height.equalTo(30)
            }
            
            cardsTitleLabel.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom).offset(30)
                $0.leading.equalToSuperview().inset(25)
            }
            addCardButton.snp.makeConstraints {
                $0.top.equalTo(cardsTitleLabel.snp.bottom).offset(20)
                $0.left.equalToSuperview().offset(15)
                $0.width.equalTo(180)
                $0.height.equalTo(30)
            }
            removeCardButton.snp.makeConstraints {
                $0.top.equalTo(addCardButton)
                $0.width.equalTo(146)
                $0.height.equalTo(30)
                $0.right.equalToSuperview().offset(-15)
            }
            
            accountTitleLabel.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom).offset(33)
                $0.left.equalToSuperview().inset(25)
            }

            editAccountButton.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom).offset(30)
                $0.right.equalToSuperview().offset(-25)
                $0.width.equalTo(146)
                $0.height.equalTo(30)
            }
            tableView.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom).offset(70)
                $0.leading.trailing.equalToSuperview()
                print(tabBarController?.tabBar.frame.height)
                $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? -20)
            }
            
            addCardButton.isHidden = true
            removeCardButton.isHidden = true
            editAccountButton.isHidden = true
            accountTitleLabel.isHidden = true
            cardsTitleLabel.isHidden = true
            accountView.isHidden = true
        case .payment:
            tableView.snp.makeConstraints {
                $0.top.equalTo(navigationView.snp.bottom).offset(70)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? -20)
            }
        }
    }
    
    func setupLayouts() {
       view.backgroundColor = .white
        setupTopView()
        setupTableView()
    }
    
    func removePet() {
        view.addSubview(backgroundAlertViewForDelete)
        
        backgroundAlertViewForDelete.addSubviews([alertBoxImageViewForDelete, alertTitleLabelForDelete, yesButtonForDelete, noButtonForDelete])
        
        backgroundAlertViewForDelete.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
        }
        
        alertBoxImageViewForDelete.snp.makeConstraints {
            $0.height.equalTo(164)
            $0.width.equalTo(327)
            $0.center.equalToSuperview()
        }
        
        alertTitleLabelForDelete.snp.makeConstraints {
            $0.top.equalTo(alertBoxImageViewForDelete.snp.top).offset(25)
            $0.left.equalTo(alertBoxImageViewForDelete).offset(46)
            $0.right.equalTo(alertBoxImageViewForDelete).offset(-46)
        }
        
        yesButtonForDelete.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(55)
            $0.top.equalTo(alertBoxImageViewForDelete).offset(100)
            $0.left.equalTo(alertBoxImageViewForDelete).offset(23)
        }
        
        noButtonForDelete.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(55)
            $0.top.equalTo(alertBoxImageViewForDelete).offset(100)
            $0.left.equalTo(yesButtonForDelete.snp.right).offset(40)
        }
    }
  
}

//MARK: - UITableViewDataSource

extension CustomerProfileVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch stateProfile {
        
        case .pets:
            if pets.count > 0 {
                tableView.backgroundView = nil
            } else{
                let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
                noDataLabel.text          = "Pets are not added"
                noDataLabel.textColor     = UIColor.colorC6222F
                noDataLabel.textAlignment = .center
                tableView.backgroundView  = noDataLabel
                tableView.separatorStyle  = .none
            }
            return pets.count
        case .payment:
            tableView.backgroundView = nil
            return numberInPaymentSection
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch stateProfile {
        case .pets:
            return 1
        case .payment:
            switch paymentSections.allCases[section] {
            case .card, .description:
                return 1
            case .transactions:
                return transactionArr.count
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        switch stateProfile {
      
        case .pets:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PetCell.className, for: indexPath) as? PetCell else { return PetCell() }
            
            let frame = cell.profileImageView.frame
            let bottomLayer = CALayer()
            bottomLayer.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
            cell.profileImageView.layer.addSublayer(bottomLayer)
            
            cell.clipsToBounds = true

            cell.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.profileImageView.sd_setImage(with: URL(string: self.pets[indexPath.section].imageUrl ?? ""), placeholderImage: R.image.pet_photo_placeholder(), options: SDWebImageOptions.lowPriority, context: nil)
            cell.addGrayShadow(offset: CGSize(width: 0, height: 4), radius: 5)
            var breed = "-"
            
            if let br = pets[indexPath.section].breed {
                breed = br
            }
            cell.setup(name: pets[indexPath.section].name, breed: breed, gender: pets[indexPath.section].gender)

            if indexPath.section == pets.count - 1 {
                if totalItems > pets.count {
                        page += 1
                        getPets()
                  
                }
            }
           
            return cell
            
        case .payment:
            switch paymentSections.allCases[indexPath.section] {
            
            case .card:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.className, for: indexPath) as? CardCell else { return CardCell() }
                self.delegateCards = cell
                self.delegateCardsHide = cell
                cell.cardCollectionView.clipsToBounds = false
                cell.balanceLbl.text = "$\(DBManager.shared.getBalance())"
                cell.parent = self
                cell.clipsToBounds = false
                cell.layer.masksToBounds = false
                return cell
            case .description:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.className, for: indexPath) as? DescriptionCell else { return DescriptionCell() }
                self.delegateDescriptionHide = cell
                return cell
            case .transactions:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionCell.className, for: indexPath) as? TransactionCell else { return TransactionCell() }
                self.delegateTransactionHide = cell
                cell.transactionCostLabel.text = "$\(String(transactionArr[indexPath.row].totalAmount))"
                cell.transactionDateLabel.text = CommonFunction.shared.getDateInString(dates: transactionArr[indexPath.row].createdAt)
                // Display Pets Name
                var petsNameArr = [String]()
                let pets = transactionArr[indexPath.row].pets
//                print(pets.count)
                for i in pets {
                    petsNameArr.append(i.name)
                }
                let mapNameToString = (petsNameArr.map{String($0)}).joined(separator: " , ")
//                print(mapNameToString)
                cell.transactionNameLabel.text = mapNameToString
                petsNameArr.removeAll()
                if indexPath.row == transactionArr.count - 1 {
                    if totalTransactionItems > transactionArr.count {
                            transactionHistoryPage += 1
                            getTransactionHistory()
                      
                    }
                }
                return cell
                
                
            }
            
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableViewState == .pets {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else { return }
        if let cell = tableView.cellForRow(at: indexPath) as? PetCell {
            cell.editingStyle(false)
        }
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            tableView.cellForRow(at: indexPath)?.layoutIfNeeded()
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        indexpath = indexPath
        let action = UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            completionHandler(true)
            let vc = EditPetViewController()
            vc.delegate = self
            vc.id = self.pets[indexPath.section].id
            if let breed = self.pets[indexPath.section].breed {
                vc.breed = breed
            }
            vc.name = self.pets[indexPath.section].name
            vc.gender = self.pets[indexPath.section].gender
            vc.imageString = self.pets[indexPath.section].imageUrl ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        })
        
        if let cell = tableView.cellForRow(at: indexPath) as? PetCell {
            cell.editingStyle(true)
        }
        
        let action2 = UIContextualAction(style: .normal, title: "", handler: { (action,view,completionHandler ) in
            completionHandler(true)
            print("Indexpath trailing",indexPath.section)
            self.removePet()

        })
        
        action2.image = R.image.deleteAction2()
        action2.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.2509803922, blue: 0, alpha: 0.12)
        
        action.image = R.image.editAction()
        action.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.5254901961, blue: 0.2, alpha: 0.12)
        
        let configuration = UISwipeActionsConfiguration(actions: [action, action2])
        
        return configuration
    }
}

//MARK: - UITableViewDelegate

extension CustomerProfileVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableViewState == .pets {
            let vc = PetProfileViewController()
            vc.delegate = self
            vc.isEmployee = false
            vc.id = pets[indexPath.section].id
            if let breed = pets[indexPath.section].breed {
                vc.breed = breed
            }
            
            vc.name = pets[indexPath.section].name
            vc.gender = pets[indexPath.section].gender
            vc.imageString = pets[indexPath.section].imageUrl ?? ""
            
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.pushViewController(vc, animated: true)
            self.tabBarController?.tabBar.isHidden = true

        }
    }
}

//MARK: - Actions

extension CustomerProfileVC {
    @objc func yesButtonAction() {
        
        delegateCards?.deleteCard()
        backgroundAlertView.removeFromSuperview()
        
        if CardRemoverManager.shared.isEmpty {
            delegateDescriptionHide?.noCardsSetup()
            delegateTransactionHide?.transactionHideSetup()
            delegateCardsHide?.cardShowSetup()
            numberInRowsInPayment = 0
            tableView.reloadData()
        }
    }
    
    @objc func noButtonAction() {
        backgroundAlertView.removeFromSuperview()
    }
    
    @objc func noButtonForDeleteAction() {
        backgroundAlertViewForDelete.removeFromSuperview()
    }
    
    @objc func yesButtonForDeleteAction() {
        print("Indexpath is", indexpath)
        deletePet(indexPath: indexpath!)
        backgroundAlertViewForDelete.removeFromSuperview()
    }
    
    
}

//MARK: - ProfileNavigationViewCustomerProfileDelegate

extension CustomerProfileVC: ProfileNavigationViewCustomerProfileDelegate {
    func stateChanged(state: CustomerProfileStates) {
        self.tableViewState = state
        if state == .pets {
            stateProfile = .pets
        } else if state == .payment {
            stateProfile = .payment
        }
        
        switch state {
        case .pets:
            addPetButton.isHidden = false
            petsLabel.isHidden = false
            addCardButton.isHidden = true
            removeCardButton.isHidden = true
            editAccountButton.isHidden = true
            accountTitleLabel.isHidden = true
            cardsTitleLabel.isHidden = true
            tableView.isHidden = false
            accountView.isHidden = true
            shareWithFriendButton.isHidden = true
        case .payment:
            addPetButton.isHidden = true
            petsLabel.isHidden = true
            addCardButton.isHidden = false
            cardsTitleLabel.isHidden = false
            removeCardButton.isHidden = false
            editAccountButton.isHidden = true
            accountTitleLabel.isHidden = true
            tableView.isHidden = false
            accountView.isHidden = true
            shareWithFriendButton.isHidden = true
          
             showActivityIndicator()
            delegateCards?.addCard()
            tableView.snp.remakeConstraints {
                $0.top.equalTo(removeCardButton.snp.bottom).offset(2)
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? -20)
            }
            tableView.reloadData()
        case .account:
            addPetButton.isHidden = true
            petsLabel.isHidden = true
            addCardButton.isHidden = true
            removeCardButton.isHidden = true
            editAccountButton.isHidden = false
            accountTitleLabel.isHidden = false
            cardsTitleLabel.isHidden = true
            tableView.isHidden = true
            accountView.isHidden = false
            shareWithFriendButton.isHidden = false
            
            accountView.snp.makeConstraints {
                $0.top.equalTo(accountTitleLabel.snp.bottom).offset(20)
                $0.left.right.equalToSuperview()
                $0.bottom.equalTo(shareWithFriendButton.snp.top).offset(-5)
            }
            
            shareWithFriendButton.snp.makeConstraints {
                $0.height.equalTo(70)
                $0.left.equalToSuperview().offset(40)
                $0.right.equalToSuperview().offset(-40)
                $0.bottom.equalToSuperview().inset(tabBarController?.tabBar.frame.height ?? -20)
            }
        }
        tableView.setContentOffset(.zero, animated: true)

        tableView.reloadData()
        
    }
}

//MARK: - Log Out

extension CustomerProfileVC {
    
    @objc func nameButtonPressed() {
        stateChanged(state: .account)
        navigationView.thirdButton.setTitleColor(enableColor, for: .normal)
        navigationView.thirdPoint.backgroundColor = enableColor
        navigationView.thirdPoint.isHidden = false
        navigationView.firstButton.setTitleColor(dissableColor, for: .normal)
        navigationView.firstPoint.isHidden = true
        
        navigationView.secondButton.setTitleColor(dissableColor, for: .normal)
        navigationView.secondPoint.isHidden = true
        
    }
    
    @objc func logOutAction() {
//        DBManager.shared.removeAccessToken()
//        DBManager.shared.saveStatus(0)
        DBManager.shared.removeAccessToken()
        DBManager.shared.saveStatus(0)
//        DBManager.shared.removeDeviceToken()
        DBManager.shared.removeUserRole()
        let vc = UINavigationController(rootViewController: AuthorizationVC())
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true) {
            
        }
       
    }
}

//MARK: - Network

private extension CustomerProfileVC {
    
    func getPets() {
            if page == 1 {
            pets = []
        }
        PetService().getAllPets(limit: 10, page: page) { [self] result in
            print("Result", result)
            switch result {
            case .success(let allPets):
                for i in allPets.pets {
                    self.pets.append(i)
                }
                self.totalItems = allPets.meta.totalItems
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func getProfile() {
        CustomerService().getCustomerShort { [self] result in
            print("Customer Profile ", result)
            switch result {
            case .success(let profile):
                self.profileNameLabel.text = "\(profile.name) \(profile.surname)"
                DBManager.shared.saveBalance(profile.balance)
                print("Balance is \(DBManager.shared.getBalance())")
                hideView()
                if let img = profile.imageUrl {
                    self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    self.profileImageView.sd_setImage(with: URL(string: img), placeholderImage:  nil, options: SDWebImageOptions.lowPriority, context: nil)
                } else {
                    self.profileImageView.image = R.image.pet_photo_placeholder()
                }
            case .failure(let error):
                hideView()
                self.setupErrorAlert(error: error)
            }
            tableView.reloadData()
        }
    }
    
    func deletePet(indexPath: IndexPath) {
        CustomerService().deletePet(id: self.pets[indexPath.section].id) { [self] result in
            switch result {
            case .success(_):
                let indexSet = NSMutableIndexSet()
                indexSet.add(indexPath.section)
                self.pets.remove(at: indexPath.section)
                page = 1
                getPets()
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
            if self.pets.count == 0 {
                print("Pets Count",pets.count)
            }
            tableView.reloadData()
        }
    }
    
    func getTransactionHistory() {
        if transactionHistoryPage == 1 {
            transactionArr = []
        }
        
        PaymentService().getTransactionHistory(limit: 10, page: transactionHistoryPage) { [weak self] result in
            guard let self = self else { return }
            print("Result", result)
            switch result {
            case .success(let allTransaction):
                for i in allTransaction.items {
                    self.transactionArr.append(i)
                    print("Pets are",i.pets)
                }
                self.totalTransactionItems = allTransaction.meta.totalItems
                
                self.tableView.reloadData()
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    
}

//MARK: - PetsDelegate

extension CustomerProfileVC: PetsDelegate {
    func reloadPets() {

    }
}

//MARK: - ReloadPetDelegate

extension CustomerProfileVC: ReloadPetDelegate {
    func reloadAllPetsList() {
    }
}

//MARK: - EditAccountDelegate

extension CustomerProfileVC: EditAccountDelegate {
    func reloadAccount() {
        getProfile()
        accountView.reloadAccount()
    }
}

//MARK: - AccountDelegate

extension CustomerProfileVC: AccountDelegate {
    func setup(error: Error) {
        self.setupErrorAlert(error: error)
    }
}
