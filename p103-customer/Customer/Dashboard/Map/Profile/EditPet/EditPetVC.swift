//
//  EditPetVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 17.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit

enum CatSections: CaseIterable {
    case ageBreed
    case feeding
    case medication
    case yesOrNoGroup
    case veterian
    case litterBox
    case friendly
    
    var footerHeight: CGFloat {
        switch self {
        case .ageBreed:
            return 30
        case .feeding:
            return 20
        case .medication:
            return 30
        case .yesOrNoGroup:
            return 20
        case .veterian:
            return 20
        case .litterBox:
            return 40
        case .friendly:
            return 50
        }
    }
}
enum DogSection: CaseIterable {
    case ageBreed
    case size
    case feeding
    case walks
    case someone
    case medication
    case yesOrNoGroup
    case veterian
    case doggyDoor
    case friendly
    
    var footerHeight: CGFloat {
        switch self {
            
        case .ageBreed:
            return 30
        case .size:
            return 15
        case .feeding:
            return 20
        case .walks:
            return 40
        case .someone:
            return 40
        case .medication:
            return 30
        case .yesOrNoGroup:
            return 20
        case .veterian:
            return 30
        case .doggyDoor:
            return 30
        case .friendly:
            return 50
        }
    }
}

enum SmallAnimalSection: CaseIterable {
    case main
}

class EditPetVC: UIViewController {
    
    // MARK: - UI Property
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.closeTest(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.clipsToBounds = true
        button.tintColor = .white
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UINib(nibName: PetProfileMainCell.className, bundle: nil),
                           forCellReuseIdentifier: PetProfileMainCell.className)
        
        tableView.register(UINib(nibName: SizeOfDogCell.className, bundle: nil),
                           forCellReuseIdentifier: SizeOfDogCell.className)
        tableView.register(UINib(nibName: FeedingCell.className, bundle: nil),
                           forCellReuseIdentifier: FeedingCell.className)
        tableView.register(UINib(nibName: walkCell.className, bundle: nil),
                           forCellReuseIdentifier: walkCell.className)
        tableView.register(UINib(nibName: SomeoneHomeCell.className, bundle: nil),
                           forCellReuseIdentifier: SomeoneHomeCell.className)
        tableView.register(UINib(nibName: MedicationCell.className, bundle: nil),
                           forCellReuseIdentifier: MedicationCell.className)
        tableView.register(UINib(nibName: YesOrNoGroup.className, bundle: nil),
                           forCellReuseIdentifier: YesOrNoGroup.className)
        tableView.register(UINib(nibName: VeterianCell.className, bundle: nil),
                           forCellReuseIdentifier: VeterianCell.className)
        tableView.register(UINib(nibName: DoggyDoorCell.className, bundle: nil),
                           forCellReuseIdentifier: DoggyDoorCell.className)
        tableView.register(UINib(nibName: LitterBoxCell.className, bundle: nil),
                           forCellReuseIdentifier: LitterBoxCell.className)
        tableView.register(UINib(nibName: FriendlyCell.className, bundle: nil),
                           forCellReuseIdentifier: FriendlyCell.className)
        
        tableView.register(UINib(nibName: SmallAnimalMainCell.className, bundle: nil),
                           forCellReuseIdentifier: SmallAnimalMainCell.className)
        
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.contentOffset = .zero
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.layoutMargins = .zero
        tableView.separatorInset = .zero
        return tableView
    }()
    private lazy var mainHeaderView: UIView = {
        let view = UIView()
        let imageView = UIImageView()
//        imageView.image = R.image.profile_test()
        imageView.image = R.image.dogAvatar()
        view.addSubviews([imageView, closeButton])
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(300)
        }
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(topSafeArea + 25)
            $0.trailing.equalToSuperview().inset(25)
            $0.size.equalTo(12)
        }
        return view
    }()
    private lazy var mainFooterView: AddPetMainFooterNexButtonView = {
        let view = AddPetMainFooterNexButtonView()
        return view
    }()
    
    // MARK: - Property
    private var animalType: AnimalsList? = .dog
    
    var topSafeArea: CGFloat = 0
    
    //MARK: - Ligecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
        } else {
            topSafeArea = topLayoutGuide.length
        }
    }
    
}

// MARK: - Layout

extension EditPetVC {
    private func setupLayouts() {
        view.backgroundColor = .white
        view.addSubviews([tableView])
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension EditPetVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let type = animalType else { return 1 }
        switch type {
        case .cat:
            return CatSections.allCases.count
        case .dog:
            return DogSection.allCases.count
        case .smallAnimal:
            return SmallAnimalSection.allCases.count
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = animalType else {
            let cell = UITableViewCell()
            cell.isHidden = true
            return cell}
        switch type {
        case .cat:
            return catRows(indexPath: indexPath)
        case .dog:
            return dogRows(indexPath: indexPath)
        case .smallAnimal:
            return smallAnimalRows(indexPath: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return mainHeaderView
        }
        if section == tableView.numberOfSections {
            
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let type = animalType else { return 0}
        if section == tableView.lastSection {
            return UITableView.automaticDimension
        }
        switch type {
        case .cat:
            return CatSections.allCases[section].footerHeight
        case .dog:
            return DogSection.allCases[section].footerHeight
        case .smallAnimal:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == tableView.lastSection {
            return mainFooterView
        }
        return UIView()
    }
    private func dogRows(indexPath: IndexPath) -> UITableViewCell {
        switch DogSection.allCases[indexPath.section] {
        case .ageBreed:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PetProfileMainCell.className, for: indexPath) as? PetProfileMainCell else { return PetProfileMainCell() }
            return cell
        case .size:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SizeOfDogCell.className, for: indexPath) as? SizeOfDogCell else { return SizeOfDogCell() }
            return cell
        case .feeding:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedingCell.className, for: indexPath) as? FeedingCell else { return FeedingCell() }
            cell.delegate = self
            return cell
        case .walks:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: walkCell.className, for: indexPath) as? walkCell else { return walkCell() }
            return cell
        case .someone:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SomeoneHomeCell.className, for: indexPath) as? SomeoneHomeCell else { return SomeoneHomeCell() }
            return cell
        case .medication:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MedicationCell.className, for: indexPath) as? MedicationCell else { return MedicationCell() }
            cell.delegate = self
            return cell
        case .yesOrNoGroup:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YesOrNoGroup.className, for: indexPath) as? YesOrNoGroup else { return YesOrNoGroup() }
            return cell
        case .veterian:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VeterianCell.className, for: indexPath) as? VeterianCell else { return VeterianCell() }
            return cell
        case .doggyDoor:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DoggyDoorCell.className, for: indexPath) as? DoggyDoorCell else { return DoggyDoorCell() }
            return cell
        case .friendly:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendlyCell.className, for: indexPath) as? FriendlyCell else { return FriendlyCell() }
            cell.setup(animal: .dog)
            return  cell
            
        }
    }
    private func catRows(indexPath: IndexPath) -> UITableViewCell {
        switch CatSections.allCases[indexPath.section] {

        case .ageBreed:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AgeBreedCell.className, for: indexPath) as? AgeBreedCell else { return AgeBreedCell() }
            return cell
        case .feeding:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedingCell.className, for: indexPath) as? FeedingCell else { return FeedingCell() }
            cell.delegate = self
            return cell
        case .medication:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MedicationCell.className, for: indexPath) as? MedicationCell else { return MedicationCell() }
            cell.delegate = self
            return cell
        case .yesOrNoGroup:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YesOrNoGroup.className, for: indexPath) as? YesOrNoGroup else { return YesOrNoGroup() }
            return cell
        case .veterian:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VeterianCell.className, for: indexPath) as? VeterianCell else { return VeterianCell() }
            return cell
        case .litterBox:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LitterBoxCell.className, for: indexPath) as? LitterBoxCell else { return LitterBoxCell() }
            return cell
        case .friendly:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendlyCell.className, for: indexPath) as? FriendlyCell else { return FriendlyCell() }
            cell.setup(animal: .cat)
            return  cell
        }
    }
    private func smallAnimalRows(indexPath: IndexPath) -> UITableViewCell {
        switch SmallAnimalSection.allCases[indexPath.section] {
        case .main:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SmallAnimalMainCell.className, for: indexPath) as? SmallAnimalMainCell else { return SmallAnimalMainCell() }
            return  cell
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - AddPetMainHeaderViewDelegate

extension EditPetVC: AddPetMainHeaderViewDelegate {
    func animalChoose(animal: AnimalsList) {
        animalType = animal
        tableView.reloadData()
    }
    
    func closeButtonAction() {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - FeedingCellDelegate

extension EditPetVC: FeedingCellDelegate {
    func textChanged() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

//MARK: - Action

extension EditPetVC {
    @objc func closeButtonTouched() {
        dismiss(animated: true)
    }
}
