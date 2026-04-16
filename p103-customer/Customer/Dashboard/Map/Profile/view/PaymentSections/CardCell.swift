//
//  CardCell.swift
//  p103-customer
//
//  Created by Alex Lebedev on 18.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit



@objc protocol WorkWithCardDelegate: AnyObject {
    func deleteCard()
    func addCard()
    
}
 protocol AmountCardDelegate: AnyObject {
    func addAmount()
}

@objc protocol CardCellHide: AnyObject {
    func cardShowSetup()
    func cardHideSetup()
}




class CardCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    @IBOutlet weak var balanceLbl: UILabel!
    

    private let noCardsLabel: UILabel = {
        let l = UILabel()
        l.text = "You need to add atleast one card"
        l.textColor = .color070F24
        l.font = R.font.aileronRegular(size: 14)
        return l
    }()
    
    //MARK: - Properties
    private var isCardChoosen: Bool = true
    private var isTapped: Bool = false
    var cardsArr = [Item]()
    let collectionMargin = CGFloat(10)
    let itemSpacing = CGFloat(0)
    let itemHeight = CGFloat(185)
    var itemWidth = CGFloat(0)
    var alertView: CustomAlertView = CustomAlertView()
    var activityView: UIActivityIndicatorView?
    var currentItem = 0
    var page = 0
    var parent = CustomerProfileVC()
    var arrbuttonState = [Bool]()
    var noDataLabel = UILabel()
    var baseViewController = BaseViewController()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        let vc = CustomerProfileVC()
        vc.delegateCards = self
        vc.delegateCardsHide = self
        
        addButtonOutlet.setTitleColor(.colorC6222F, for: .normal)
        addButtonOutlet.borderColor = .colorC6222F
        getAllCards()
        setup()
        print("Card Array \(cardsArr)")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}

    // MARK: - Setup Layout CollectionView
extension CardCell {
    func setup() {
        cardCollectionView.register(UINib(nibName: CardCollectionViewCell.className, bundle: nil),
        forCellWithReuseIdentifier: CardCollectionViewCell.className)
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        cardCollectionView.showsHorizontalScrollIndicator = false
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        itemWidth =  UIScreen.main.bounds.width - collectionMargin * 5.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.headerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.footerReferenceSize = CGSize(width: collectionMargin, height: 0)
        layout.minimumLineSpacing = itemSpacing
        layout.scrollDirection = .horizontal
        cardCollectionView!.collectionViewLayout = layout
        cardCollectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        pageControl.isHidden =  false
    }
}

// MARK: - Actions
extension CardCell {
    @IBAction func addAmountBtnAction(_ sender: UIButton) {
        let alertVC = PaymentAlertView()
        alertVC.delegate = self
        alertVC.cardDetails = cardsArr[CardRemoverManager.shared.indexChoosen]
        print(cardsArr[CardRemoverManager.shared.indexChoosen])
        self.parent.present(alertVC, animated: true, completion: nil)
    }
   
}
//MARK: - UICollectionViewDataSource

extension CardCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cardsArr.count != 0 {
            self.pageControl.numberOfPages = cardsArr.count
            cardCollectionView.backgroundView = nil
            addButtonOutlet.isHidden = false
            
        } else {
            noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: cardCollectionView.bounds.size.width, height: cardCollectionView.bounds.size.height))
            addButtonOutlet.isHidden = true
        }
            return cardsArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.className, for: indexPath) as! CardCollectionViewCell
        if indexPath.row == 0 {
            cell.cardView.topColor = UIColor(red: 0.567, green: 0.567, blue: 0.567, alpha: 1)
            cell.cardView.bottomColor = UIColor(red: 0.425, green: 0.425, blue: 0.425, alpha: 1)
            cell.mainPaymentCheckImage.image = R.image.white_checbox()
           
        }
        cell.parent = self
        cell.rowIndex = indexPath.row
        
        if arrbuttonState[indexPath.row] == true {
            cell.mainPaymentCheckImage.image = R.image.white_checbox()
        } else {
            cell.mainPaymentCheckImage.image = R.image.placeForButtonImage()
        }
        print(arrbuttonState)
        
        cell.cornerRadius = 5
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        cell.lastFourDigits.text = cardsArr[indexPath.row].fourDigits
        
        return cell
    }
   
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(cardCollectionView!.contentSize.width  )
        var newPage = Float(self.pageControl.currentPage)

        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }

        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        page = pageControl.currentPage
        print(pageControl.currentPage)
        for cell in cardCollectionView.visibleCells {
            let indexPath = cardCollectionView.indexPath(for: cell)
            if let c = cell as? CardCollectionViewCell {
                if indexPath?.row == page {
                    print("Current Data", cardsArr[page])
                    isCardChoosen = true
                    c.lastFourDigits.text = cardsArr[indexPath!.row].fourDigits
                    c.cardView.topColor = UIColor(red: 0.567, green: 0.567, blue: 0.567, alpha: 1)
                    c.cardView.bottomColor = UIColor(red: 0.425, green: 0.425, blue: 0.425, alpha: 1)
                } else {
                    isCardChoosen = false
                    c.cardView.topColor = R.color.choosenCardTopColor()!
                    c.cardView.bottomColor =  R.color.choosenBottomCardColor()!
                }
            } else {
                print("Cell not found")
            }
        }
    }
}
   
    

//MARK: - UICollectionViewDelegate

extension CardCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for row in 0..<collectionView.numberOfItems(inSection: 0) {
            let i = NSIndexPath(row: row, section: 0)
            if let cellCurrent = collectionView.cellForItem(at: i as IndexPath) as? CardCollectionViewCell {
                if row == indexPath.row {
                    if isCardChoosen {
                        isCardChoosen = !isCardChoosen
                        cellCurrent.cardView.isChoosen = false
                        cellCurrent.cardView.isChoosen = true
                        cellCurrent.cardView.topColor = UIColor(red: 0.567, green: 0.567, blue: 0.567, alpha: 1)
                        cellCurrent.cardView.bottomColor = UIColor(red: 0.425, green: 0.425, blue: 0.425, alpha: 1)
                    } else {
                        isCardChoosen = !isCardChoosen
                        cellCurrent.cardView.isChoosen = false
                        cellCurrent.cardView.isChoosen = true
                        cellCurrent.cardView.topColor = R.color.choosenCardTopColor()!
                        cellCurrent.cardView.bottomColor = R.color.choosenBottomCardColor()!
                    }
                } else {
                    if cellCurrent.cardView.topColor == UIColor(red: 0.567, green: 0.567, blue: 0.567, alpha: 1) {
                        cellCurrent.cardView.isChoosen = false

                        cellCurrent.cardView.isChoosen = true
                        cellCurrent.cardView.topColor = R.color.choosenCardTopColor()!
                        cellCurrent.cardView.bottomColor = R.color.choosenBottomCardColor()!
                    }
                }
            }
        }
    }
}
//MARK: - Network
extension CardCell  {
    func getAllCards() {
        cardsArr = []
        PaymentService().getAllCards() { [weak self] result in
            guard let self = self else { return }
            print(result)
            switch result {
            case .success(let s):
                print(s.items)
                self.cardsArr = s.items
                for _ in 0..<s.items.count {
                    self.arrbuttonState.append(false)
                }
                if self.cardsArr.count != 0 {
                    self.arrbuttonState[0] = true
                    CardRemoverManager.shared.indexChoosen = 0
                    CardRemoverManager.shared.isEmpty = false
                    self.noCardsLabel.isHidden = true
                } else {
                    self.noCardsLabel.isHidden = false
                    self.noDataLabel.text          = "You need to add at least one card"
                    self.noDataLabel.textColor     = UIColor.colorC6222F
                    self.noDataLabel.textAlignment = .center
                    self.cardCollectionView.backgroundView  = self.noDataLabel
                    CardRemoverManager.shared.isEmpty = true
                }
                
            case .failure(let error):
                print(error)
            }
            NotificationCenter.default.post(name: Notification.Name("CardDataGet"), object: nil)
    
            self.cardCollectionView.reloadData()
            
        }
    }
    
    func getProfile() {
        CustomerService().getCustomerShort { [weak self] result in
            guard let self = self else { return }
            print("Customer Profile ", result)
            switch result {
            case .success(let profile):
                if profile.balance != 0 {
                    self.balanceLbl.text = "$\(profile.balance)"
                    DBManager.shared.saveBalance(profile.balance)
                    print("Balance is \(DBManager.shared.getBalance())")
                }
                print(profile)
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - CardDelegate

extension CardCell: WorkWithCardDelegate {

    func addCard() {
        CardRemoverManager.shared.indexChoosen = -1
        cardCollectionView.reloadData()
        getAllCards()
    }
    
    func deleteCard() {
        PaymentService().deleteCard(id: self.cardsArr[CardRemoverManager.shared.indexChoosen].id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                
                let indexPath = NSIndexPath(row: CardRemoverManager.shared.indexChoosen, section: 0) as IndexPath
                print("indexpath",indexPath)
                self.cardCollectionView.deleteItems(at: [indexPath])
                self.cardsArr.remove(at: indexPath.row)
                if self.cardsArr.count == 0 {
                    CardRemoverManager.shared.indexChoosen = -1
                    
                    CardRemoverManager.shared.isEmpty = true
                    self.addButtonOutlet.isHidden = true
                } else {
                    self.addButtonOutlet.isHidden = false
                    CardRemoverManager.shared.isEmpty = false
                }
                
            case .failure(let error):
                print(error)
            }
            self.cardCollectionView.reloadData()
        }
    }
    
    
}

// MARK: - AmountCardDelegate
extension CardCell: AmountCardDelegate {
    func addAmount() {
        getProfile()
        cardCollectionView.reloadData()
    }
    
   
}

//MARK: - CardCellHide

extension CardCell: CardCellHide {
    func cardShowSetup() {
        noCardsLabel.isHidden = false
    }
    
    func cardHideSetup() {
        noCardsLabel.isHidden = true
    }
}

//MARK: - ScrollView
extension UIScrollView {
    var currentPage:Int{
        return Int((self.contentOffset.x+(0.5*self.frame.size.width))/self.frame.width)+1
    }
}


