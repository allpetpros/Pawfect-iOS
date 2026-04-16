//
//  OrderDetailUpcomingViewController.swift
//  p103-customer
//
//  Created by Daria Pr on 16.04.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class OrderDetailUpcomingViewController: BaseViewController {

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
    
    private let closebutton: UIButton = {
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
        l.text = "Status: "
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    private let statusResultLabel: UILabel = {
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
        v.backgroundColor = UIColor.white
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
    
    private let dogWalkingImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    } ()
    
    private let dogWalkingLabel: UILabel = {
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
    
    private let dateDescriptionLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color293147
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let infoTimeLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color860000
        l.font = R.font.aileronRegular(size: 12)
        return l
    } ()
    
    private let commentTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Comment for sitter")
        textField.isUserInteractionEnabled = false
        textField.lineColor = UIColor.white
        return textField
    }()
    
    private let separatorThirdView: UIView = {
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
        l.text = "$5"
        return l
    } ()
    
    private let descriprionTotalLabel: UILabel = {
        let l = UILabel()
        l.text = "*for one sitting"
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 16)
        return l
    } ()
    
    private let separatorFourthView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let cancelOrderButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cancelOrderAction), for: .touchUpInside)
        button.setImage(R.image.cancelOrderImage(), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private let cancelDescriptionLabel: UILabel = {
        let l = UILabel()
        l.text = "In case of canceletion after more than 48 hours canceletion fee of 15% will be charged."
        l.numberOfLines = 2
        l.font = R.font.aileronRegular(size: 12)
        l.textColor = .color606572
        l.textAlignment = .center
        l.isHidden = true
        return l
    } ()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
    
    private let backgroundAlertView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return v
    } ()
    
    private lazy var warningTextField: SkyFloatingLabelTextField = {
        let tf = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Enter text")
//        tf.delegate = self
        tf.addTarget(self, action: #selector(warningAction), for: .editingChanged)
        return tf
    } ()
    
    private let sendButton: UIButton = {
        let b = UIButton()
        b.cornerRadius = 15
        b.setTitle("Send", for: .normal)
        b.titleLabel?.font = R.font.aileronBold(size: 18)
        b.redAndGrayStyle(active: false)
        b.isUserInteractionEnabled = false
        b.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return b
    }()
    
    //MARK: - Properties
    
    var id = String()
    var dateUpcoming = Date()
    private var reason: String?
    
    weak var delegate: OrderDetailDelegate?
    weak var upcomingDelegate: DayConfirmedDelegate?
    private var height = 150
    private var createdOrderDate: Date?
    var timeBetween_CreateAt_CurrentTime = false
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        setupScrollViewLayouts()
        setupLayout()
        setupPetCardLayout()
        setupPriceLayout()
        getUpcomingDetails()
    }
}

    //MARK: - Setup Layout
private extension OrderDetailUpcomingViewController {
    
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
        mainView.addSubviews([orderDetailsTitleLabel, closebutton, statusLabel, animalView, statusResultLabel])
        
        closebutton.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(15)
            $0.top.equalToSuperview().offset(53)
            $0.left.equalToSuperview().offset(25)
        }
        
        orderDetailsTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalTo(closebutton.snp.right).offset(19)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(orderDetailsTitleLabel.snp.bottom).offset(42)
            $0.left.equalToSuperview().offset(25)
        }
        
        statusResultLabel.snp.makeConstraints {
            $0.top.equalTo(orderDetailsTitleLabel.snp.bottom).offset(42)
            $0.left.equalTo(statusLabel.snp.right).offset(1)
        }
        
        animalView.snp.makeConstraints {
            $0.top.equalTo(statusLabel.snp.bottom).offset(30)
            $0.height.equalTo(height)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
        }
    }
    
    func setupPetCardLayout() {
        mainView.addSubviews([stackView, separatorView, dogWalkingImageView, dogWalkingLabel, separatorSecondView, dateDescriptionLabel, infoTimeLabel])
        
        dogWalkingImageView.tintColor = .black
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(animalView).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }

        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalTo(animalView)
            $0.right.equalTo(animalView)
            $0.top.equalTo(stackView.snp.bottom).offset(14)
        }
        
        dogWalkingImageView.snp.makeConstraints {
            $0.width.equalTo(18)
            $0.height.equalTo(14)
            $0.top.equalTo(separatorView.snp.bottom).offset(18)
            $0.left.equalTo(animalView).offset(15)
        }
        
        dogWalkingLabel.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(16)
            $0.left.equalTo(dogWalkingImageView.snp.right).offset(5)
        }
        
        separatorSecondView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalTo(animalView)
            $0.right.equalTo(animalView)
            $0.top.equalTo(dogWalkingLabel.snp.bottom).offset(15)
        }
        
        dateDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(15)
            $0.left.equalTo(animalView.snp.left).offset(15)
        }
        
        infoTimeLabel.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(17)
            $0.left.equalTo(dateDescriptionLabel.snp.right).offset(10)
        }
    }
    
    func setupPriceLayout() {
        mainView.addSubviews([commentTextField, separatorThirdView, totalLabel, descriprionTotalLabel, priceLabel, separatorFourthView, cancelOrderButton, cancelDescriptionLabel])
        
        commentTextField.snp.makeConstraints {
            $0.top.equalTo(animalView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
        }
        
        separatorThirdView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.top.equalTo(commentTextField.snp.bottom).offset(28)
        }
        
        totalLabel.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(25)
        }
        
        descriprionTotalLabel.snp.makeConstraints {
            $0.top.equalTo(totalLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().offset(25)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(10)
            $0.right.equalToSuperview().offset(-25)
        }
        
        separatorFourthView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview()
            $0.top.equalTo(descriprionTotalLabel.snp.bottom).offset(10)
        }
        
        cancelOrderButton.snp.makeConstraints {
            $0.width.equalTo(275)
            $0.height.equalTo(60)
            $0.top.equalTo(separatorFourthView.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
        }
        
        cancelDescriptionLabel.snp.makeConstraints {
            $0.width.equalTo(275)
            $0.top.equalTo(cancelOrderButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-38)
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
            $0.height.equalTo(207)
            $0.center.equalToSuperview()
        }
        
        titleWarningLabel.snp.makeConstraints {
            $0.top.equalTo(warningAlertImageView.snp.top).offset(24)
            $0.left.equalTo(warningAlertImageView).offset(10)
            $0.right.equalTo(warningAlertImageView.snp.right).offset(-10)
        }
        
        yesWarningButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(60)
            $0.top.equalTo(titleWarningLabel.snp.bottom).offset(30)
            $0.left.equalTo(warningAlertImageView).offset(23)
        }
        
        noWarningButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(60)
            $0.top.equalTo(titleWarningLabel.snp.bottom).offset(30)
            $0.right.equalTo(warningAlertImageView).offset(-23)
        }
    }
    
}

//MARK: - Actions

extension OrderDetailUpcomingViewController {
    @objc func closeButtonTouched() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelOrderAction() {
        if timeBetween_CreateAt_CurrentTime {
            titleWarningLabel.text = "Are you sure you want to cancel the Order?"
        } else {
            titleWarningLabel.text = "Are you sure you want to cancel. It is after 48 past the cancellation time and you will be charged a %15 cancellation fee."
        }
        setupCancellationWarning()
    }
}

//MARK: - Network

private extension OrderDetailUpcomingViewController {
    func getUpcomingDetails() {
        
        CustomerService().getUpcomingOrderDetails(id: id) { result in
            
            switch result {
            case .success(let s):
                //For Difference of Created Order Time & Current Time
                let date = Date(timeIntervalSince1970: s.createdAt / 1000)
                self.createdOrderDate = CommonFunction.shared.dateFormatter(date: date)
                let now = CommonFunction.shared.dateFormatter(date: Date())


                let diffComponents = Calendar.current.dateComponents([.day ,.hour, .minute], from: self.createdOrderDate!, to: now)
                print(diffComponents)
                if diffComponents.day! < 2 && diffComponents.hour! < 24 {
                    self.timeBetween_CreateAt_CurrentTime = true
                } else {
                    self.timeBetween_CreateAt_CurrentTime = false
                }
                //Assign Data
                self.petsSetup(pets: s.pets)
                self.statusResultLabel.text = s.status
                self.priceLabel.text = "$\(String(s.service.price!))"
                self.setupStatusColor(status: s.status)
                self.dogWalkingLabel.text = s.service.title
                if let imgService = s.service.imageUrl {
                    self.dogWalkingImageView.sd_setImage(with: URL(string: imgService), placeholderImage: R.image.belt())
                }
                let timeFrom = self.toDate(millis: s.dateFrom)
                let timeTo = self.toDate(millis: s.dateTo)
                self.infoTimeLabel.text = "\(CommonFunction.shared.convertTimeTOHoursFormat(time: timeFrom)) : \(CommonFunction.shared.convertTimeTOHoursFormat(time: timeTo))"
                self.dateDescriptionLabel.text = self.fromDateToString(date: self.dateUpcoming)
                
                if s.status == "pending" {
                    self.cancelOrderButton.isHidden = false
                    self.cancelDescriptionLabel.isHidden = false
                } else if s.status == "completed" {
                    self.cancelOrderButton.isHidden = true
                    self.cancelDescriptionLabel.isHidden = true
                } else if s.status == "canceled" {
                    self.cancelOrderButton.isHidden = true
                    self.cancelDescriptionLabel.isHidden = true
                } else if s.status == "partially confirmed" {
                    self.cancelOrderButton.isHidden = false
                    self.cancelDescriptionLabel.isHidden = false
                }
                
            case .failure(let error):
                self.setupErrorAlert(error: error)
            }
        }
    }
    
    func cancelOrder() {
        let order = CancelOrder(id: id, reason: reason)
        
        CustomerService().cancelSingleOrder(order: order) { result in
            switch result {
                
            case .success(_):
                self.backgroundAlertView.removeFromSuperview()
                self.navigationController?.popViewController(animated: true, completion: {
                    self.upcomingDelegate?.get(date: self.dateUpcoming)
                })
            case .failure(let error):
                self.backgroundAlertView.removeFromSuperview()
                self.setupErrorAlert(error: error)
            }
        }

    }
    
    func setupStatusColor(status: String) {
        switch status {
        case "pending":
            statusResultLabel.textColor = R.color.pendingColor()
        case "partially confirmed":
            statusResultLabel.textColor = R.color.partiallyConfirmedColor()
        case "confirmed":
            statusResultLabel.textColor = R.color.statusConfirmedColor()
        case "completed":
            statusLabel.textColor = R.color.statusConfirmedColor()
        case "canceled":
            statusResultLabel.textColor = R.color.canceledColor()
        default:
            statusResultLabel.textColor = R.color.pendingColor()
        }
    }
    
    func toDate(millis: Int64) -> String {
        let date = Date(timeIntervalSince1970: (Double(millis) / 1000.0))
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func fromDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM dd"
        return dateFormatter.string(from: date)
    }
    
    func petsSetup(pets: [PetsId]) {
        var i = 0
        
        while i != pets.count {
            
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.alignment = .fill
            stack.spacing = 40
            stack.translatesAutoresizingMaskIntoConstraints = false
            
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
            img.contentMode = .scaleAspectFill
            img.clipsToBounds = true
            
            let img2 = UIImageView()
            img2.layer.cornerRadius = 10
            img2.contentMode = .scaleAspectFill
            img2.clipsToBounds = true
            
            if let image = pets[i].imageUrl {
                img.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
            } else {
                img.sd_setImage(with: URL(string: ""), placeholderImage: R.image.pet_photo_placeholder())
            }
            
            i+=1
            
            if i != pets.count {
                label2.text = pets[i].name
                if let image = pets[i].imageUrl {
                    img2.sd_setImage(with: URL(string: image), placeholderImage: R.image.pet_photo_placeholder())
                } else {
                    img2.sd_setImage(with: URL(string: ""), placeholderImage: R.image.pet_photo_placeholder())
                }
                i+=1
            }
            
            firstSV.addArrangedSubviews(views: img, label)
            
            if label2.text != nil {
                secondSV.addArrangedSubviews(views: img2, label2)
                stack.addArrangedSubviews(views: firstSV, secondSV)
            } else {
                stack.addArrangedSubviews(views: firstSV, secondSV)
            }
            
            img.snp.makeConstraints {
                $0.size.equalTo(30)
            }

            img2.snp.makeConstraints {
                $0.size.equalTo(30)
            }

            stackView.addArrangedSubview(stack)
            
            height += 30
            animalView.snp.remakeConstraints {
                $0.top.equalTo(statusLabel.snp.bottom).offset(30)
                $0.height.equalTo(height)
                $0.left.equalToSuperview().offset(10)
                $0.right.equalToSuperview().offset(-10)
            }
        }
    }
}

//MARK: - Actions

extension OrderDetailUpcomingViewController {
    @objc func noWarningAction() {
        backgroundAlertView.removeFromSuperview()
    }
    
    @objc func yesWarningAction() {
        backgroundAlertView.subviews.forEach({ $0.removeFromSuperview()})
        
        titleWarningLabel.text = "Please, describe the reason for canceling"
        
        backgroundAlertView.addSubviews([warningAlertImageView, titleWarningLabel, sendButton, warningTextField])
        
        warningAlertImageView.snp.makeConstraints {
            $0.width.equalTo(327)
            $0.height.equalTo(207)
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
            $0.top.equalTo(warningTextField.snp.bottom).offset(27)
            $0.centerX.equalToSuperview()
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
extension OrderDetailUpcomingViewController: UITextViewDelegate {
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
