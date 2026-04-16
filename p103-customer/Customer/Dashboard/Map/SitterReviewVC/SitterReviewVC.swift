//
//  SitterReviewVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 15.06.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import Cosmos

@objc protocol SendReviewDelegate: class {
    func sendReview()
}

protocol ReloadEmployeeComment {
    func getEmployeeRating()
}

class SitterReviewVC: BaseViewController {
    
    // MARK:  - UI Properties
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.leftArrow(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.clipsToBounds = true
        button.tintColor = .black
        button.addTarget(self, action: #selector(backButtonTouched), for: .touchUpInside)
        return button
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 30)
        label.textColor = .color293147
        label.text = "Sitter"
        return label
    }()
    private let sitterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.employee_test()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .leading
        stack.spacing = 10
        return stack
    }()
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.aileronBold(size: 18)
        label.textColor = .color293147
        label.text = "James Smith"
        return label
    }()
    private let cosmosView: CosmosView = {
        let view = CosmosView()
        view.isUserInteractionEnabled = false
        view.settings.starSize = 15
//        view.settings.starMargin = 3
        return view
    }()
    private let leaveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.borderColor = .colorC6222F
        button.borderWidth = 1
        button.setTitle("Leave a Review", for: .normal)
        button.setTitleColor(.colorC6222F, for: .normal)
        button.titleLabel?.font = R.font.aileronRegular(size: 14)
        button.addTarget(self, action: #selector(leaveButtonTouched), for: .touchUpInside)
        return button
    }()

    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.estimatedRowHeight = 300
        //tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.register(UINib(nibName: SitterReviewCell.className, bundle: nil),
                           forCellReuseIdentifier: SitterReviewCell.className)
        return tableView
    }()
//    private let blurView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(red: 0.028, green: 0.06, blue: 0.142, alpha: 0.25)
//        return view
//    }()
//
//    private let commentView: UIView = {
//        let v = UIView()
//        v.backgroundColor = .white
//        return v
//    } ()
////
//    private let customerImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.image = R.image.profile_test()
//        return iv
//    } ()
//
//    private let customerNameLabel: UILabel = {
//        let l = UILabel()
//        l.text = "Kara Summer"
//        l.textColor = .color293147
//        l.font = R.font.aileronBold(size: 18)
//        return l
//    } ()
//
//    private let commentLabel: UILabel = {
//        let l = UILabel()
//        l.text = "Best sitter, my dog loves him"
//        l.textColor = .color606572
//        l.font = R.font.aileronRegular(size: 14)
//        return l
//    } ()
    
    private let raitingView = CosmosView()
    var id: String?
    var historyDetails: Histories?
    
    // MARK: - Property
    private var cardViewController: SitterRatingCardVC!
    private var cardHeight:CGFloat {
        return self.view.frame.height - 110
    }
    private var cardVisible = false
//    private var nextState: CardState {
//        return cardVisible ? .collapsed : .expanded
//    }
    
    private var runningAnimations = [UIViewPropertyAnimator]()
    private var animationProgressWhenInterrupted:CGFloat = 0
//    private var cardVisible = false
    private var nextState: CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    var employeeCommentArr = [Comment]()
    var wasOrderRated: Bool?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayouts()
        setupCard()
        setUpData()
        getEmployeeRating()
    }
    
    
    func setUpData() {
        
        if let name = historyDetails?.employee?.name, let surname = historyDetails?.employee?.surname {
            profileNameLabel.text = "\(name) \(surname)"
        }
        if let avatar = historyDetails?.employee?.imageUrl {
            sitterImageView.sd_setImage(with: URL(string: avatar),placeholderImage: R.image.employee_test())
        }
    }
    
    func setupCard() {
//        cardViewController = SitterRatingCardVC(nibName: SitterRatingCardVC.className, bundle:nil)
//        cardViewController.delegateSend = self
//        self.addChild(cardViewController)
//        self.view.addSubview(cardViewController.view)
        
//        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.bounds.width, height: cardHeight)
//        cardViewController.view.clipsToBounds = true
//        self.cardViewController.view.layer.cornerRadius = 26
//        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCardTap(recognzier:)))
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan(recognizer:)))
//        
//        cardViewController.swipeArea.addGestureRecognizer(tapGestureRecognizer)
//        cardViewController.swipeArea.addGestureRecognizer(panGestureRecognizer)
//        
//        commentView.layer.shadowColor = UIColor.black.cgColor
//        commentView.layer.shadowOpacity = 0.5
//        commentView.layer.shadowOffset = .zero
//        commentView.layer.shadowRadius = 5
//
//        commentView.layer.cornerRadius = 10
    }
    
//    private func blur(_ add: Bool) {
//        if add {
//            view.insertSubview(blurView, at: 1)
//            blurView.snp.makeConstraints {$0.edges.equalToSuperview()}
//        } else {
//            blurView.removeFromSuperview()
//        }
//    }
    // MARK: - Selectors
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
            
        default:
            break
        }
    }
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
//            startInteractiveTransition(state: nextState, duration: 0.9)
            break
        case .changed:
            let translation = recognizer.translation(in: self.cardViewController.mainView)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
//        if state == .collapsed {
//            blur(false)
//        }
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHeight
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
        }
    }
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    @objc func backButtonTouched() {
        dismiss(animated: true, completion: nil)
    }
    @objc func leaveButtonTouched() {
//        blur(true)
//        animateTransitionIfNeeded(state: nextState, duration: 0.9)
//        break
        let vc = SitterRatingCardVC(nibName: SitterRatingCardVC.className, bundle:nil)
        vc.orderId = id
        vc.delegate = self
        vc.employeeId = historyDetails?.employee?.id
//        cardViewController.delegateSend = self
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - Extensions
extension SitterReviewVC {
    private func setupLayouts() {
        view.backgroundColor = .white
        view.addSubviews([backButton, descriptionLabel, sitterImageView, stackView, profileNameLabel, cosmosView, leaveButton, tableView])
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(21)
            $0.height.equalTo(15)
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalToSuperview().inset(60)
        }
        descriptionLabel.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.leading.equalTo(backButton.snp.trailing).offset(20)
        }
        sitterImageView.snp.makeConstraints {
            $0.size.equalTo(80)
            $0.leading.equalToSuperview().inset(25)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(34)
        }
        stackView.addArrangedSubviews(views: profileNameLabel, cosmosView)
        stackView.snp.makeConstraints {
            $0.centerY.equalTo(sitterImageView)
            $0.leading.equalTo(sitterImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(25)
        }
        leaveButton.snp.makeConstraints {
            $0.top.equalTo(sitterImageView.snp.bottom).offset(30)
            $0.height.equalTo(30)
            $0.leading.trailing.equalToSuperview().inset(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(leaveButton.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.bottom.equalToSuperview().offset(-20)
        }

    }
}

//MARK: - SendReviewDelegate

extension SitterReviewVC: SendReviewDelegate {
    func sendReview() {
//        animateTransitionIfNeeded(state: nextState, duration: 0.9)
        leaveButton.removeFromSuperview()
//        commentView.snp.makeConstraints {
//            $0.top.equalTo(sitterImageView.snp.bottom).offset(30)
//            $0.height.equalTo(120)
//            $0.left.equalToSuperview().offset(10)
//            $0.right.equalToSuperview().offset(-10)
//        }
        
    }
    
}


extension SitterReviewVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employeeCommentArr.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SitterReviewCell.className, for: indexPath) as? SitterReviewCell else { return SitterReviewCell() }
        cell.employeeRating.settings.starSize = 20
        cell.employeeNameLabel.text = "\(employeeCommentArr[indexPath.row].name) \(employeeCommentArr[indexPath.row].surname)"
        cell.employeeImage.sd_setImage(with: URL(string: employeeCommentArr[indexPath.row].imageUrl ?? ""), placeholderImage: R.image.pet_photo_placeholder())
       
        cell.commentlabel.text = employeeCommentArr[indexPath.row].comment
        cell.employeeRating.rating = employeeCommentArr[indexPath.row].rating ?? 0.0
        cell.addGrayShadow(offset: CGSize(width: 0, height: 2), radius: 10)
        cell.configure()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension SitterReviewVC: ReloadEmployeeComment {
    func getEmployeeRating() {
        showActivityIndicator()
        CustomerService().getEmployeeDetails(employeeId: historyDetails?.employee?.id ?? "", orderId: historyDetails?.id ?? "") { result in
            switch result {
            case .success(let result):
                
                self.wasOrderRated = result.wasOrderRated
                self.cosmosView.rating = result.rating ?? 0.0
                if self.wasOrderRated == true {
                    self.leaveButton.isHidden = true
                } else {
                    self.leaveButton.isHidden = false
                }
                self.employeeCommentArr = result.comments
                self.hideActivityIndicator()
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
                self.tableView.reloadData()
            }
        }
    }
}
