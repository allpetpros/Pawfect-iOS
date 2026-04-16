
//  OrderDetailsViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 12.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

@objc protocol OrderDetailDelegate: AnyObject {
    func reloadOrders()
}

class OrderDetailsViewController: BaseViewController {

    //MARK: - UIProperties
    
    private let scrollView = UIScrollView()
    private let mainView = UIView()

    private let orderDetailsTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Order Details"
        l.font = R.font.aileronBold(size: 30)
        l.textColor = .color293147
        return l
    } ()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.backArrowCalendar(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.clipsToBounds = true
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private let statusLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 16)
        l.text = "Status: "
        l.textColor = .color293147
        return l
    } ()
    
    private let statusOfCurrentOrder: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    private let statusOrderLabel: UILabel = {
        let l = UILabel()
        l.textColor = R.color.statusOrderColor()
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()

    private let animalView: UIView = {
        let v = UIView()
//        v.backgroundColor = UIColor.lightGray
        
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 5
        v.layer.cornerRadius = 10
        return v
    } ()

    private let separatorView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let calendarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.calendar()
        iv.tintColor = UIColor.black
        return iv
    } ()
    
    private let dailyCheckinLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let dateLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let separatorSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let calendarLabel: UILabel = {
        let l = UILabel()
        l.text = "View calendar"
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.totalOrderArrowImage()
        return iv
    } ()
    
    private let separatorThirdView: UIView = {
        let v = UIView()
//        v.backgroundColor = .red
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let viewCalendarButton: UIButton = {
        let b = UIButton()
        return b
    } ()

    private let timeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fillEqually
        return sv
    } ()
    
    private let morningLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let afternoonLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let eveningLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let moreLabel: UILabel = {
        let l = UILabel()
        l.text = "More"
        l.isHidden = false
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorC6222F
        return l
    } ()
    
    private let moreImageView: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = false
        iv.image = R.image.moreArrowImageView()
        return iv
    } ()
    
    private let moreInfoButton: UIButton = {
        let b = UIButton()
//        b.backgroundColor = .blue
        b.addTarget(self, action: #selector(moreInfoButtonAction), for: .touchUpInside)
        return b
    }()
    
    private let infoLabel: UILabel = {
        let l = UILabel()
        l.text = "Information"
//        l.backgroundColor = .blue
        l.font = R.font.aileronBold(size: 18)
        l.textColor = .colorC6222F
        l.isHidden = true
        return l
    } ()
    
    private let dateDescriptionLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let infoTimeLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.text = "12:00 - 12:30"
        l.isHidden = true
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let statusOrdersLabel: UILabel = {
        let l = UILabel()
        l.text = "confirmed"
        l.font = R.font.aileronRegular(size: 16)
        l.textColor = R.color.statusConfirmedColor()
        l.isHidden = true
        return l
    } ()
    
    private let arrowToOrderImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.orderArrowImage()
        iv.isHidden = true
        return iv
    } ()
    
    private let separatorSixthView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()

    private let arrowSecondToOrderImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.orderArrowImage()
        iv.isHidden = true
        return iv
    } ()
    
    private let separatorSeventhView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let hideLabel: UILabel = {
        let l = UILabel()
        l.text = "Hide details"
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .colorC6222F
        return l
    } ()
    
    private let hideImageView: UIImageView = {
        let iv = UIImageView()
        iv.isHidden = false
        iv.image = R.image.hideMoreImage()
        return iv
    } ()
    
    private let hideInfoButton: UIButton = {
        let b = UIButton()
        
        b.addTarget(self, action: #selector(hideInfoButtonAction), for: .touchUpInside)
        return b
    }()
    
    private let commentTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Comment for sitter")
        textField.isUserInteractionEnabled = false
        textField.lineColor = UIColor.white
        return textField
    }()
    
    private let separatorEighthView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let totalLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronBold(size: 30)
        l.text = "Total"
        return l
    } ()
    
    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = R.font.aileronBold(size: 30)
        l.textColor = R.color.greenColor()
        return l
    } ()
    
    private let descriprionTotalLabel: UILabel = {
        let l = UILabel()
        l.text = "*for one sitting"
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    private let separatorNinthView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let totalPriceLabel: UILabel = {
        let l = UILabel()
        l.text = "Total Amount Payable"
        l.textColor = .color606572
        l.font = R.font.aileronBold(size: 16)
        return l
    } ()
    
    private let daysForPriceLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let fullPriceLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color606572
        l.font = R.font.aileronBold(size: 16)
        return l
    } ()
    
    private let holidayFeeLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let extraPriceLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color606572
        l.text = "Extras Services Price"
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let totalExtraPriceLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()

    private let cancelOrderButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cancelOrderAction), for: .touchUpInside)
        button.setImage(R.image.cancelOrderImage(), for: .normal)
        return button
    }()
    
    private let cancelDescriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "In case of canceletion after more than 48 hours canceletion fee of 15% will be charged."
        l.numberOfLines = 2
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .color606572
        l.textAlignment = .center
        return l
    } ()

    private var warningAlertImageView: UIImageView = {
        let v = UIImageView()
        v.image = R.image.alertCancelOrder()
        return v
    } ()
    
    private var titleWarningLabel: UILabel = {
        let l = UILabel()
        l.text = "Are you sure you want to cancel? It is past the cancellation time and you will be charged a %15 cancellation fee."
        l.numberOfLines = 4
        l.font = R.font.aileronBold(size: 18)
        l.textColor = .color070F24
        l.textAlignment = .center
        return l
    } ()
    
    private var yesWarningButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.yesWarning(), for: .normal)
        b.addTarget(self, action: #selector(yesWarningAction), for: .touchUpInside)
        return b
    } ()
    
    private var noWarningButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.noWarning(), for: .normal)
        b.addTarget(self, action: #selector(noWarningAction), for: .touchUpInside)
        return b
    } ()
    private let backGroundStackView: UIStackView = {
        let stack = UIStackView()
        stack.backgroundColor = .clear
        stack.spacing = 10
        stack.axis = .vertical
        return stack
    } ()
    private let backgroundAlertView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return v
    } ()
    
    private lazy var warningTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Enter text")
        tf.delegate = self
        tf.addTarget(self, action: #selector(warningAction), for: .editingChanged)
        return tf
    } ()
    
    private let sendButton: UIButton = {
        let b = UIButton()
//        b.setImage(R.image.sendWarningButton(), for: .normal)
        b.cornerRadius = 15
        b.setTitle("Send", for: .normal)
        b.titleLabel?.font = R.font.aileronBold(size: 18)
        b.redAndGrayStyle(active: false)
        b.isUserInteractionEnabled = false
        b.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return b
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
    
    private let ordersStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
//        stackView.backgroundColor = .orange
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    } ()
        
    //MARK: - Properties
    
    var id = String()
    private var reason: String?
    
    weak var delegate: OrderDetailDelegate?
    private var height = 180
    private var visit = [OrdersId]()
    private var details = [OrderDetails]()
    private var visitTime = [VisitsId]()
    private var createdOrderDate: Date?
    var idArr = [String]()
    var timeBetween_CreateAt_CurrentTime = false
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupScrollViewLayouts()

        getDescription()
      
    }
    
    func fetchOrderId() {
        for i in 0..<visit.count {
            idArr.append(visit[i].id)
        }
        
    }
}

    //MARK: - Setup Layout
private extension OrderDetailsViewController {
    func setupScrollViewLayouts() {
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
        
        setupLayout()
        setupPetCardLayout()
        setupSecondPartPetLayout()
        setupLayoutAfterAnimalCard()
    }

    func setupLayout() {
        mainView.addSubviews([orderDetailsTitleLabel, backButton, statusLabel, statusOfCurrentOrder, animalView])
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(53)
            $0.left.equalToSuperview().offset(25)
        }
        
        orderDetailsTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalTo(backButton.snp.right).offset(19)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(orderDetailsTitleLabel.snp.bottom).offset(42)
            $0.left.equalToSuperview().offset(25)
        }
        
        statusOfCurrentOrder.snp.makeConstraints {
            $0.top.equalTo(orderDetailsTitleLabel.snp.bottom).offset(42)
            $0.left.equalTo(statusLabel.snp.right).offset(1)
        }
        
        animalView.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
    func setupPetCardLayout() {
        mainView.addSubviews([stackView, statusOrderLabel, separatorView, dailyCheckinLabel, calendarImageView, dateLabel])
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(animalView).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        statusOrderLabel.snp.makeConstraints {
            $0.top.equalTo(animalView).offset(14)
            $0.right.equalTo(animalView).offset(-10)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalTo(animalView)
            $0.right.equalTo(animalView)
            $0.top.equalTo(stackView.snp.bottom).offset(14)
        }
        
        calendarImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(16)
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.left.equalTo(animalView).offset(15)
        }
        
        dailyCheckinLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.left.equalTo(calendarImageView.snp.right).offset(5)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.right.equalTo(animalView).offset(-15)
        }
    }
    
    private func setupSecondPartPetLayout() {
        mainView.addSubviews([separatorSecondView, separatorThirdView, timeStackView, ordersStackView, moreLabel, moreImageView, moreInfoButton])
        
        timeStackView.addArrangedSubviews(views: morningLabel, afternoonLabel, eveningLabel)
        
        separatorSecondView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(47)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }

        timeStackView.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(18)
            $0.height.equalTo(20)
            $0.centerX.equalTo(animalView)
        }
        
        separatorThirdView.snp.makeConstraints {
            $0.top.equalTo(timeStackView.snp.bottom).offset(10)
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        
        ordersStackView.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        moreLabel.snp.makeConstraints {
            $0.top.equalTo(ordersStackView.snp.bottom)
            $0.centerX.equalTo(animalView)
        }
        
        moreImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(7)
            $0.left.equalTo(moreLabel.snp.right).offset(5)
            $0.centerY.equalTo(moreLabel)
        }
        
        moreInfoButton.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView)
            $0.left.right.equalTo(animalView)
            $0.bottom.equalTo(animalView)
            
        }
    }
    
    func setupLayoutAfterAnimalCard() {
        mainView.addSubviews([commentTextField, separatorEighthView, totalLabel, priceLabel, descriprionTotalLabel, separatorNinthView, totalPriceLabel, daysForPriceLabel, fullPriceLabel, holidayFeeLabel,extraPriceLabel,totalExtraPriceLabel ,cancelOrderButton, cancelDescriptionLabel])
        
        commentTextField.snp.makeConstraints {
            $0.top.equalTo(animalView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        separatorEighthView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(commentTextField.snp.bottom).offset(28)
        }
        
        totalLabel.snp.makeConstraints {
            $0.top.equalTo(separatorEighthView.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(25)
        }
        
        descriprionTotalLabel.snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(25)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(separatorEighthView.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-25)
        }
        
        separatorNinthView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview()
            $0.top.equalTo(descriprionTotalLabel.snp.bottom).offset(10)
        }
        
        totalPriceLabel.snp.makeConstraints {
            $0.top.equalTo(separatorNinthView.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(25)
        }
        
        daysForPriceLabel.snp.makeConstraints {
            $0.top.equalTo(totalPriceLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(25)
        }
        
        
        fullPriceLabel.snp.makeConstraints {
            $0.top.equalTo(separatorNinthView.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-25)
        }
        
        holidayFeeLabel.snp.makeConstraints {
            $0.top.equalTo(fullPriceLabel.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-25)
        }
        
        extraPriceLabel.snp.makeConstraints {
            $0.top.equalTo(holidayFeeLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(25)
        }

        totalExtraPriceLabel.snp.makeConstraints {
            $0.top.equalTo(holidayFeeLabel.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-25)
        }

        cancelOrderButton.snp.makeConstraints {
            $0.width.equalTo(275)
            $0.height.equalTo(60)
            $0.top.equalTo(extraPriceLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        cancelDescriptionLabel.snp.makeConstraints {
            $0.width.equalTo(275)
            $0.top.equalTo(cancelOrderButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-38)
        }
    }
    
    func petsSetup(pets: [PetsId]) {
        var i = 0
        
        while i != pets.count {
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.alignment = .fill
            stack.spacing = 10
            stack.translatesAutoresizingMaskIntoConstraints = false
            
            let firstSV = UIStackView()
            firstSV.axis = .horizontal
            firstSV.distribution = .fillProportionally
            firstSV.alignment = .fill
            firstSV.spacing = 5
            
            let secondSV = UIStackView()
            secondSV.axis = .horizontal
            secondSV.distribution = .fillProportionally
            secondSV.alignment = .fill
            secondSV.spacing = 5
            
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronBold(size: 18)
            label.text = pets[i].name
            
            let label2 = UILabel()
            label2.textColor = .color070F24
            label2.font = R.font.aileronBold(size: 18)
            
            let img = UIImageView()
            img.contentMode = .scaleAspectFill
            img.layer.cornerRadius = 10
            img.clipsToBounds = true
            
            let img2 = UIImageView()
            img.contentMode = .scaleAspectFill
            img2.layer.cornerRadius = 10
            img2.clipsToBounds = true
            
            if let image = pets[i].imageUrl {
                img.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
            }  else {
                img.sd_setImage(with: URL(string: ""), placeholderImage: R.image.pet_photo_placeholder())
            }
            
            i+=1
            
            if i != pets.count {
                label2.text = pets[i].name
                if let image = pets[i].imageUrl {
                    img2.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
                }  else {
                    img2.sd_setImage(with: URL(string: ""), placeholderImage: R.image.pet_photo_placeholder())
                }
                i+=1
            }
            
            firstSV.addArrangedSubviews(views: img, label)
            
            secondSV.addArrangedSubviews(views: img2, label2)
            
            img.snp.makeConstraints {
                $0.size.equalTo(30)
            }

            img2.snp.makeConstraints {
                $0.size.equalTo(30)
            }
            
            stack.addArrangedSubviews(views: firstSV, secondSV)

            stackView.addArrangedSubview(stack)
            
            height += 30
//            animalView.snp.remakeConstraints {
//                $0.top.equalTo(statusLabel.snp.bottom).offset(30)
//                $0.height.equalTo(height)
//                $0.left.equalToSuperview().offset(10)
//                $0.right.equalToSuperview().offset(-10)
//            }
            
        }
        animalView.snp.remakeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(30)
            $0.height.equalTo(height)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }
}

//MARK: - Actions

extension OrderDetailsViewController {
    @objc func closeButtonTouched() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func moreInfoButtonAction() {
        moreInfoButton.isHidden = true
        moreLabel.isHidden = true
        moreImageView.isHidden = true
//        ordersStackView.isHidden = false
        
        view.addSubviews([infoLabel, hideLabel, hideImageView, hideInfoButton])
        
        infoLabel.snp.makeConstraints {
//            $0.top.equalTo(separatorThirdView.snp.bottom).offset(15)
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(5)
            $0.height.equalTo(15)
            $0.centerX.equalToSuperview()
        }
        
        ordersStackView.snp.remakeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalTo(animalView).offset(-20)
        }
        
        hideLabel.snp.makeConstraints {
            $0.top.equalTo(ordersStackView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        hideImageView.snp.makeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(7)
            $0.left.equalTo(hideLabel.snp.right).offset(5)
            $0.top.equalTo(ordersStackView.snp.bottom).offset(35)
            $0.bottom.equalTo(animalView).offset(-30)
        }
        
        hideInfoButton.snp.makeConstraints {
            $0.top.equalTo(ordersStackView.snp.bottom)
            $0.left.right.equalTo(animalView)
            $0.bottom.equalTo(animalView)
        }
        
        hideLabel.isHidden = false
        hideImageView.isHidden = false
        hideInfoButton.isHidden = false
       
        infoLabel.isHidden = false
        
       
        
        var i = 0
        print("Heihgt Before Visits Added:\(height)")
        while i != visit.count {
            let status = visit[i].status
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillProportionally
            stack.alignment = .fill
            stack.spacing = 1
            
            let button = UIButton()
            button.setImage(R.image.orderArrowImage(), for: .normal)
            
            let line = UIView()
            line.backgroundColor = .colorE8E9EB
            
            let stackStatus = UIStackView()
            stackStatus.axis = .horizontal
            stackStatus.distribution = .fillProportionally
            stackStatus.alignment = .fill
            stackStatus.spacing = 1
            
            let stackFinal = UIStackView()
            stackFinal.axis = .horizontal
            stackFinal.distribution = .fillProportionally
            stackFinal.alignment = .fill
            stackFinal.spacing = 1
            
            let label = UILabel()
            label.textColor = .color070F24
            label.font = R.font.aileronRegular(size: 14)

            let statusLabel = UILabel()
            statusLabel.textColor = .color070F24
            statusLabel.font = R.font.aileronRegular(size: 16)
            
            let timeLabel = UILabel()
            timeLabel.textColor = .color860000
            timeLabel.font = R.font.aileronRegular(size: 14)
            
            statusLabel.text = status
            
            switch status {
            case "pending":
                statusLabel.textColor = R.color.pendingColor()
            case "partially confirmed":
                statusLabel.textColor = R.color.partiallyConfirmedColor()
            case "completed":
                statusLabel.textColor = R.color.statusConfirmedColor()
            case "confirmed":
                statusLabel.textColor = R.color.statusConfirmedColor()
            case "canceled":
                statusLabel.textColor = R.color.canceledColor()
            default:
                statusLabel.textColor = R.color.pendingColor()
            }
           
            let dateFrom = Date(timeIntervalSince1970: (Double(visit[i].dateFrom) / 1000.0))
            
            let dateTo = Date(timeIntervalSince1970: (Double(visit[i].dateTo) / 1000.0))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd"
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            
            label.text = dateFormatter.string(from: dateFrom)
            let timeFrom = timeFormatter.string(from: dateFrom)
            let timeTo = timeFormatter.string(from: dateTo)
            print(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom))
            print(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))

//            timeLabel.text = "\(timeFormatter.string(from: dateFrom)) - \(timeFormatter.string(from: dateTo))"
            timeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
            
            i+=1
            
            height += 44
            print("Heihgt while Adding \(i) Visits Added:\(height)")
            stack.addArrangedSubviews(views: label, timeLabel)
            
            stackStatus.addArrangedSubviews(views: statusLabel, button)
            
            stackFinal.addArrangedSubviews(views: stack, stackStatus)
            
            ordersStackView.addArrangedSubviews(views: stackFinal, line)
            
            line.snp.makeConstraints {
                $0.height.equalTo(1)
                $0.left.equalToSuperview()
                $0.right.equalToSuperview()
            }
//            height += 60
        }
        print("Total Visit \(visit.count)")
        animalView.snp.remakeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(30)
            $0.height.equalTo(height+40)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
        print("Height After Loop \(height)")
    }
    
    @objc func hideInfoButtonAction() {
        
        print("Height is \(height)")
        animalView.snp.remakeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(30)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
                
        hideLabel.isHidden = true
        hideImageView.isHidden = true
        hideInfoButton.isHidden = true
        
       
        infoLabel.isHidden = true
        
        for (_,vv) in ordersStackView.subviews.enumerated() {
            vv.removeFromSuperview()
            print(ordersStackView.subviews.count)
            
        }
        
        moreLabel.isHidden = false
        moreImageView.isHidden = false
        moreInfoButton.isHidden = false
        
        moreLabel.snp.remakeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(10)
            $0.centerX.equalTo(animalView)
        }
        
        moreImageView.snp.remakeConstraints {
            $0.width.equalTo(15)
            $0.height.equalTo(7)
            $0.left.equalTo(moreLabel.snp.right).offset(5)
            $0.centerY.equalTo(moreLabel)
        }
        
        moreInfoButton.snp.remakeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom)
            $0.left.right.equalTo(animalView)
            $0.bottom.equalTo(animalView)
        }
        
       

        for _ in 0..<visit.count {
            height = height - 44
        }
       
    }
    
    @objc func cancelOrderAction() {
        if timeBetween_CreateAt_CurrentTime {
//            titleWarningLabel.text = "Are you sure you want to cancel the order?"
            backgroundAlertView.subviews.forEach({ $0.removeFromSuperview()})

            titleWarningLabel.text = "Please, describe the reason for canceling"

            backgroundAlertView.addSubviews([warningAlertImageView, titleWarningLabel, sendButton, warningTextField])

            warningAlertImageView.snp.makeConstraints {
                $0.width.equalTo(327)
                $0.height.equalTo(220)
                $0.center.equalToSuperview()
            }

            titleWarningLabel.snp.makeConstraints {
                $0.top.equalTo(warningAlertImageView.snp.top).offset(24)
                $0.left.equalTo(warningAlertImageView).offset(10)
                $0.right.equalTo(warningAlertImageView.snp.right).offset(-10)
            }

            warningTextField.snp.makeConstraints {
                $0.top.equalTo(titleWarningLabel.snp.bottom).offset(15)
                $0.left.equalTo(warningAlertImageView).offset(10)
                $0.right.equalTo(warningAlertImageView).offset(-10)
            }

            sendButton.snp.makeConstraints {
                $0.top.equalTo(warningTextField.snp.bottom).offset(30)
                $0.centerX.equalToSuperview()
    //            $0.height.equalTo(50)
                $0.height.equalTo(40)
                $0.width.equalTo(100)
            }
            self.view.addSubviews([backgroundAlertView])
            backgroundAlertView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        } else {
            titleWarningLabel.text = "Are you sure you want to cancel?  It is past 48 hour cancellation time and you will be charged a 15% cancellation fee."
            setupCancellationWarning()
            
        }
     
    }
    
    @objc func noWarningAction() {
        backgroundAlertView.removeFromSuperview()
    }
    
    @objc func yesWarningAction() {
        backgroundAlertView.subviews.forEach({ $0.removeFromSuperview()})
        
        titleWarningLabel.text = "Please, describe the reason for canceling"
        
        backgroundAlertView.addSubviews([warningAlertImageView, titleWarningLabel, sendButton, warningTextField])
        
        warningAlertImageView.snp.makeConstraints {
            $0.width.equalTo(327)
            $0.height.equalTo(220)
            $0.center.equalToSuperview()
        }
        
        titleWarningLabel.snp.makeConstraints {
            $0.top.equalTo(warningAlertImageView.snp.top).offset(24)
            $0.left.equalTo(warningAlertImageView).offset(10)
            $0.right.equalTo(warningAlertImageView.snp.right).offset(-10)
        }
        
        warningTextField.snp.makeConstraints {
            $0.top.equalTo(titleWarningLabel.snp.bottom).offset(15)
            $0.left.equalTo(warningAlertImageView).offset(10)
            $0.right.equalTo(warningAlertImageView).offset(-10)
        }
        
        sendButton.snp.makeConstraints {
            $0.top.equalTo(warningTextField.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
//            $0.height.equalTo(50)
            $0.height.equalTo(40)
            $0.width.equalTo(100)
        }
        
        
    }
    
    @objc func sendButtonAction() {
        cancelOrder()
    }
    
    @objc func warningAction() {
        if let warn = warningTextField.text {
            if warn.isEmpty {
                
            } else {
                reason = warn
                sendButton.redAndGrayStyle(active: true)
                sendButton.isUserInteractionEnabled = true
            }
        }
    }
}

//MARK: - Network

private extension OrderDetailsViewController {
    func getDescription() {
        CustomerService().getDetailsOrder(id: id) { [self] result in
            print("Order Description",result)
            switch result {
            case .success(let allPets):
                //For Difference of Created Order Time & Current Time
                let date = Date(timeIntervalSince1970: allPets.createdAt / 1000)
                self.createdOrderDate = dateFormatter(date: date)
                let now = dateFormatter(date: Date())
                let diffComponents = Calendar.current.dateComponents([.day ,.hour, .minute], from: createdOrderDate!, to: now)
                print(diffComponents)
                
                if diffComponents.day! < 2 && diffComponents.hour! < 24 {
                    timeBetween_CreateAt_CurrentTime = true
                } else {
                    timeBetween_CreateAt_CurrentTime = false
                }
                //Assign Data
                self.priceLabel.text = "$\(allPets.service.price!)"
                self.statusOfCurrentOrder.text = allPets.status
                self.dailyCheckinLabel.text = allPets.service.title
                self.setupStatusColor(status: allPets.status)
                self.details.append(allPets)
                if let comm = allPets.comment {
                    self.commentTextField.text = comm
                }
                self.getDate(firstDate: allPets.firstDate, lastDate: allPets.lastDate)
                for j in 0..<allPets.visits.count {
                    let timeFrom = String(CommonFunction.shared.toDate(millis: Int64(allPets.visits[j].timeFrom)))
                    let timeTo = String(CommonFunction.shared.toDate(millis: Int64(allPets.visits[j].timeTo)))
                    print("Time From \(timeFrom)")
                    print("Time From \(timeTo)")
                    if allPets.visits[j].type == "morning" {
                        self.morningLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
                        } else if allPets.visits[j].type == "afternoon" {
                            self.afternoonLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
                        } else if allPets.visits[j].type == "evening" {
                            self.eveningLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) - \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
                        }
                }
                visitTime = allPets.visits
                var holidayAmount = 0
                var datesHoliday = [String]()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM"
                dateFormatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
                if let holidays = allPets.total.holidays {
                    for i in holidays {
                        holidayAmount += i.price
                        let date = Date(timeIntervalSince1970: Double(i.date) / 1000.0)
                        let strDate = dateFormatter.string(from: date)
                        datesHoliday.append(strDate)
                    }
                    
                    self.daysForPriceLabel.text = "*\(datesHoliday.joined(separator:", ")) - Holiday Fee"
                    self.holidayFeeLabel.text = "+ $\(holidayAmount)"
                    
                }
                self.fullPriceLabel.text = "$\(allPets.total.totalAmount)"
                
                if allPets.status == "canceled" {
                    cancelOrderButton.isHidden = true
                    cancelDescriptionLabel.isHidden = true
                }
                extraPriceLabel.isHidden = true
                totalExtraPriceLabel.isHidden = true
                self.visit = allPets.orders
                self.petsSetup(pets: allPets.pets)
                
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func dateFormatter(date: Date) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        let result = formatter.string(from: date)
        print(result)
        
        let addedDate = result
        let objformatter = DateFormatter()
        objformatter.timeZone = (NSTimeZone(name: "UTC")! as TimeZone)
        objformatter.dateFormat = "yyyy-MMM-dd hh:mm a"
        let date1 = objformatter.date(from: addedDate)
        print("DATE \(String(describing: date1!))")
        return date1!
    }
    
    func cancelOrder() {
        fetchOrderId()
        print("Ids Are",idArr)
        let order = CancelOrder(id: id, reason: reason, orderIds: idArr)
        print("Order Body",order)
        CustomerService().cancel(order: order) { result in
            print(result)
            switch result {
            case .success(_):
                
                self.backgroundAlertView.removeFromSuperview()
                self.navigationController?.popViewController(animated: true, completion: {
                    self.delegate?.reloadOrders()
                })
            case .failure(let error):
                self.backgroundAlertView.removeFromSuperview()
                self.setupErrorAlert(error: error)
            }
        }
    }

    func setupCancellationWarning() {
        view.addSubview(backgroundAlertView)
        
        backgroundAlertView.addSubviews([warningAlertImageView, titleWarningLabel, yesWarningButton, noWarningButton])
        
        backgroundAlertView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        warningAlertImageView.snp.makeConstraints {
            $0.width.equalTo(327)
            $0.height.equalTo(180)
            $0.center.equalToSuperview()
        }
        
        titleWarningLabel.snp.makeConstraints {
            $0.top.equalTo(warningAlertImageView.snp.top).offset(10)
            $0.left.equalTo(warningAlertImageView).offset(10)
            $0.right.equalTo(warningAlertImageView.snp.right).offset(-10)
        }
        
        yesWarningButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(60)
            $0.top.equalTo(titleWarningLabel.snp.bottom).offset(20)
            $0.left.equalTo(warningAlertImageView).offset(23)
            $0.bottom.equalTo(warningAlertImageView.snp.bottom).offset(10)

        }
        
        noWarningButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(60)
            $0.top.equalTo(titleWarningLabel.snp.bottom).offset(20)
            $0.right.equalTo(warningAlertImageView).offset(-23)
            $0.bottom.equalTo(warningAlertImageView.snp.bottom).offset(10)
        }
    }
}

//MARK: - Setup dates

private extension OrderDetailsViewController {
    
    func getDate(firstDate: Int, lastDate: Int) {

        let firstDate = CommonFunction.shared.fromMillisToDate(millis:  Double(firstDate))
        let secondDate = CommonFunction.shared.fromMillisToDate(millis:  Double(lastDate))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let checkMonthFormatter = DateFormatter()
        checkMonthFormatter.dateFormat = "MMM"
        
        let dateFirst = dateFormatter.string(from: firstDate)
        let dateSecond = dateFormatter.string(from: secondDate)
        
        let monthFirst = checkMonthFormatter.string(from: firstDate)
        let monthSecond = checkMonthFormatter.string(from: secondDate)
        
        if dateFirst == dateSecond {
            dateLabel.text = dateFirst
        } else {
            if monthFirst == monthSecond {
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "MMM d"
                let day = dayFormatter.string(from: firstDate)
                dateLabel.text = "\(day) - \(dateSecond)"
            } else {
                dateLabel.text = "\(dateFirst) - \(dateSecond)"
            }
        }
    }

    func getTime(firstDate: Int, lastDate: Int) -> [String] {
        let fromDate = fromMillisToDate(millis: Double(firstDate))
        let toDate = fromMillisToDate(millis: Double(lastDate))

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        let timeFirst = timeFormatter.string(from: fromDate)
        let timeSecond = timeFormatter.string(from: toDate)

        var timeArr = [String]()

        timeArr.append(timeFirst)
        timeArr.append(timeSecond)

        return timeArr
    }
    
    func fromMillisToDate(millis: Double) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(millis) / 1000)
    }
    
    func setupStatusColor(status: String) {
        switch status {
        case "pending":
            statusOfCurrentOrder.textColor = R.color.pendingColor()
        case "partially confirmed":
            statusOfCurrentOrder.textColor = R.color.partiallyConfirmedColor()
        case "confirmed":
            
            statusOfCurrentOrder.textColor = R.color.statusConfirmedColor()
        case "completed":
            statusLabel.textColor = R.color.statusConfirmedColor()
        case "canceled":
            statusOfCurrentOrder.textColor = R.color.canceledColor()
        default:
            statusOfCurrentOrder.textColor = R.color.pendingColor()
        }
    }
}
//MARK: - UITextField Delegate
extension OrderDetailsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
}
