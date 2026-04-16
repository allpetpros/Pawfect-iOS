//
//  RegistrationMainVC.swift
//  p103-customer
//
//  Created by Alex Lebedev on 06.05.2020.
//  Copyright © 2020 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift
import Alamofire
import SwiftyJSON
import Contacts
import GooglePlaces
import ContactsUI

enum HearAboutComponents: CaseIterable {
    case thumbtack
    case google
    case yelp
    case friend
    case Instagram
    case care
    case facebook
    case other
    
    var title: String {
        switch self {
        case .facebook:
            return "Facebook"
        case .Instagram:
            return "Instagram"
        case .other:
            return "Other"
        case .google:
            return "Google"
        case .yelp:
            return "Yelp"
        case .friend:
            return "Friend"
        case .care:
            return "care"
        case .thumbtack:
            return "Thumbstack"
        }
    }
}

class RegistrationMainVC: BaseViewController, CNContactPickerDelegate {
    
    // MARK: - UI Properties
    
    private let scrollView = UIScrollView()
    private let mainView = UIView()
    
    // MARK: - Top part

    private let leftArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .color070F24
        imageView.image = R.image.leftArrow()
        return imageView
    }()

    private lazy var profileImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(profileImageTouched), for: .touchUpInside)
        return button
    }()
    
    private var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = R.image.photo_placeholder()
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        return profileImageView
    }()
    
    private var requiredAvatarLabel: UILabel = {
        let l = UILabel()
        l.text = "Photo is *required"
        l.font = R.font.aileronRegular(size: 14)
        l.textColor = .color606572
        return l
    } ()
    
    // MARK: - Main stack start
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private let billingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()
    
    private let nameStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillProportionally
        stack.spacing = 20
        return stack
    }()
    
    private lazy var nameTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Name*")
        textField.addTarget(self, action: #selector(nameTextFieldAction), for: .editingChanged)
        textField.keyboardType = .alphabet
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 1
        textField.delegate = self
        return textField
    }()
    private lazy var lastnameTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Last Name*")
        textField.addTarget(self, action: #selector(surnameTextFieldAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 2
        textField.delegate = self
        return textField
    }()
    private lazy var phoneTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Mobile Phone*", iconImage: R.image.phone(), type: .usual)
        textField.keyboardType = .phonePad
        textField.addTarget(self, action: #selector(phoneTextFieldAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 3
        textField.delegate = self
        return textField
    }()
    
    private lazy var workPhoneTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Work Phone", iconImage: R.image.phone(), type: .usual)
        textField.keyboardType = .phonePad
        textField.addTarget(self, action: #selector(workPhoneTextFieldAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 4
        textField.delegate = self
        return textField
    }()
    
    private lazy var addressTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Home Address*", iconImage: R.image.address(), type: .address)
        textField.addTarget(self, action: #selector(addressTextFieldAction), for: .editingChanged)
        textField.lineColor = .white
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 5
        textField.delegate = self
        return textField
    }()
    
    // MARK: - hearAbout group
    private let hearAboutLabel: UILabel = {
        var label = UILabel()
        label.text = "How did you hear about us?*"
        label.font = R.font.aileronBold(size: 16)
        return label
    }()
    private lazy var hearAboutTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "")
        textField.placeholder = "Choose your variant"
        textField.tag = 0
        textField.delegate = self
        return textField
    }()
    private let hearAboutChekImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = R.image.bottomChek()
        imageView.tintColor = UIColor(red: 0.776, green: 0.133, blue: 0.184, alpha: 0.5)
        return imageView
    }()
    
    private let hearAboutView: UIView = {
        let textField = UIView()
        return textField
    }()
    private var tapGesture = UITapGestureRecognizer()
    
    private lazy var hearAboutTableView: UITableView = {
        let tableView = UITableView()
        tableView.cornerRadius = 8
        tableView.delegate = self
        tableView.separatorColor = .colorC6222F
        tableView.snp.makeConstraints {
            $0.height.equalTo(HearAboutComponents.allCases.count * 40)
        }
        tableView.isScrollEnabled = false
        return tableView
    }()
    private lazy var hearAboutListView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 8
        
        view.addSubview(hearAboutTableView)
        hearAboutTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return view
    }()
    

    // MARK: - main stack end
    private lazy var billingAddressTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Billing Address*", iconImage: R.image.dollar(), type: .usual)
        textField.addTarget(self, action: #selector(billingTextFieldAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 8
        textField.delegate = self
        return textField
    }()
    private lazy var cityTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "City*", iconImage: R.image.city(), type: .usual)
        textField.addTarget(self, action: #selector(cityTextFieldAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 6
        textField.delegate = self
        return textField
    }()
    private lazy var stateTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "State*", iconImage: R.image.state(), type: .usual)
        textField.addTarget(self, action: #selector(stateTextFieldAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 7
        textField.delegate = self
        return textField
    }()
    private lazy var zipTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Zip", iconImage: R.image.zip(), type: .usual)
        textField.addTarget(self, action: #selector(zipTextFieldAction), for: .editingChanged)

        return textField
    }()
    
    lazy var sameAsHomeAddressBtn: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .sameAsHomeAddressCheckBox, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        button.delegate = self
        
        return button
    }()
    // MARK: - Emergency Contacts
    private let emergencyNameFieldView: UIView = {
        let uiView = UIView()
        return uiView
    }()
    private let emergencyNameBtnTapped: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    private lazy var emergency1ContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact Name*", iconImage: R.image.emergencyContactIcon(), type: .usual)
        
        textField.addTarget(self, action: #selector(emergencyTextFieldAction), for: .editingChanged)
        textField.tag = 9
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next

        return textField
    }()
    private lazy var emergency1ContactPhoneTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact*", iconImage: R.image.phone(), type: .usual)
        textField.keyboardType = .phonePad
        textField.tag = 10
        textField.addTarget(self, action: #selector(emergencyPhoneTextFieldAction), for: .editingChanged)
        textField.delegate = self
        return textField
    }()
    private lazy var emergency2ContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact Name #2", iconImage: R.image.emergencyContactIcon(), type: .usual)
        textField.isHidden = true
        textField.addTarget(self, action: #selector(emergencyTextFieldAction), for: .editingChanged)
        return textField
    }()
    private lazy var emergency2ContactPhoneTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #2", iconImage: R.image.phone(), type: .usual)
        textField.isHidden = true
        textField.addTarget(self, action: #selector(emergencyPhoneTextFieldAction), for: .editingChanged)
        textField.keyboardType = .phonePad
        textField.tag = 20
        textField.delegate = self
        return textField
    }()
    private lazy var emergency3ContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact Name #3", iconImage: R.image.emergencyContactIcon(), type: .usual)
        textField.isHidden = true
        textField.addTarget(self, action: #selector(emergencyTextFieldAction), for: .editingChanged)
        return textField
    }()
    private lazy var emergency3ContactPhoneTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #3", iconImage: R.image.phone(), type: .usual)
        textField.isHidden = true
        textField.addTarget(self, action: #selector(emergencyPhoneTextFieldAction), for: .editingChanged)
        textField.keyboardType = .phonePad
        textField.tag = 21
        textField.delegate = self
        return textField
    }()
    
    private lazy var addContactButton: SecondaryButton = {
        let button = SecondaryButton()
        button.setupButton(title: "Add Contact", type: .plus, bordered: true)
        let addContactButtonAction = UIButton()
        addContactButtonAction.addTarget(self, action: #selector(addContactButtonTouched), for: .touchUpInside)
        button.addSubview(addContactButtonAction)
        addContactButtonAction.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        return button
    }()
    
    private lazy var doorCodeTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Lockbox/Door code", iconImage: R.image.doorCode(), type: .usual)
        textField.addTarget(self, action: #selector(doorCodeAction), for: .editingChanged)
        textField.keyboardType = .phonePad
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 11
        textField.delegate = self
        return textField
    }()
    private lazy var locationTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Lockbox Location", iconImage: R.image.location(), type: .usual)
        textField.addTarget(self, action: #selector(locationLockboxAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 12
        textField.delegate = self
        return textField
    }()
    private lazy var homeAlarmTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Home Alarm System", iconImage: R.image.home(), type: .usual)
        textField.addTarget(self, action: #selector(homeAlarmAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 13
        textField.delegate = self
        return textField
    }()
    private lazy var otherNotesTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Other Home Access Notes", iconImage: R.image.notes(), type: .usual)
        textField.addTarget(self, action: #selector(otherNotesAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 14
        textField.delegate = self
        return textField
    }()	
    private lazy var mailBoxTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Mail Box", iconImage: R.image.mailbox(), type: .usual)
        textField.addTarget(self, action: #selector(mailBoxAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 15
        textField.delegate = self
        return textField
    }()
    private lazy var otherRequestTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Other Requests", iconImage: R.image.other(), type: .usual)
        textField.addTarget(self, action: #selector(otherRequestsAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.done
        textField.tag = 16
        textField.delegate = self
        return textField
    }()
    
    // MARK: - Yes/no part
    private lazy var mailKeyProvidedView: YesOrNoView = {
        let view = YesOrNoView()
        view.setup(type: .mailKeyProvided)
        view.delegate = self
        return view
    }()
    private lazy var someoneWillBeHomeView: YesOrNoView = {
        let view = YesOrNoView()
        view.setup(type: .someoneWillBeHome)
        view.delegate = self
        return view
    }()
    private lazy var turnLightsOnOrOffView: YesOrNoView = {
        let view = YesOrNoView()
        view.setup(type: .turnLightsOnOrOff)
        view.yesButton.setTitle("On", for: .normal)
        view.noButton.setTitle("Off", for: .normal)
        view.delegate = self
        return view
    }()
    private let waterPlantsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 40
        return stack
    }()
    private lazy var waterPlantsButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.delegate = self
        button.setup(component: .waterPlaints, typeOfCheckbox: .ok, typeOfText: .black)
        return button
    }()
    private lazy var addCommentTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Add Comment", iconImage: R.image.comment(), type: .usual)
        textField.isHidden = false
        textField.addTarget(self, action: #selector(addCommentAction), for: .editingChanged)
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    // MARK: - Garbage part
    
    private let garbageView: GarbageView = {
        let v = GarbageView()
        v.setup(userInteraction: true, title: "Trash Pick Up Days")
        return v
    } ()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 15
        button.backgroundColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
        button.addTarget(self, action: #selector(nextButtonTouched), for: .touchUpInside)
        return button
    }()
    
    private let bottomStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        return stack
    }()
    
    let blackoutView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.027, green: 0.059, blue: 0.141, alpha: 0.6)
        return view
    }()
    
    //MARK: - HomeAddress UIProperties
    
    private let backgroundHomeAddressImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.homeAddressBackground()
        iv.isHidden = true
        return iv
    }()
    
    private let locationHomeAddressImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.locationImage()
        iv.isHidden = true
        return iv
    }()
    

    private let useHomeAddressButton: UIButton = {
        let b = UIButton()
        b.setTitle("Use my current Home Address as my Billing\n Address", for: .normal)
        b.addTarget(self, action: #selector(useHomeAddressAction), for: .touchUpInside)
        b.setTitleColor(.black, for: .normal)
        b.titleLabel?.font = R.font.aileronLight(size: 14)
        b.titleLabel?.numberOfLines = 2
        b.isHidden = true
        return b
    }()
    
    private let crossAddContactButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.crossAddContact(), for: .normal)
        b.addTarget(self, action: #selector(hideAdditionalContactsAction), for: .touchUpInside)
        return b
    } ()
    
    private let autoCompletionView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.5
        v.layer.shadowOffset = .zero
        v.layer.shadowRadius = 5
        v.layer.cornerRadius = 10
        return v
    } ()
    
    private let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.locationImage()
        return iv
    } ()
    
    private let locationSecondImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.locationImage()
        return iv
    } ()
    
    private let separatorFirstView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let separatorSecondView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let separatorThirdView: UIView = {
        let v = UIView()
        v.backgroundColor = .colorE8E9EB
        return v
    } ()
    
    private let locationThirdImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.locationImage()
        return iv
    } ()
    
    private let locationFourthImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.locationImage()
        return iv
    } ()
    
    private let firstAutoCompletedResponseButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(autocompleteFirstButtonSetupAction), for: .allEvents)
        return b
    } ()
    
    private let secondAutoCompletedResponseButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(autocompleteSecondButtonSetupAction), for: .allEvents)
        return b
    } ()
    
    private let thirdAutoCompletedResponseButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(autocompleteThirdButtonSetupAction), for: .allEvents)
        return b
    } ()
    
    private let fourthAutoCompletedResponseButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(autocompleteFourthButtonSetupAction), for: .allEvents)
        return b
    } ()
    
    private let firstAutoCompletedResponseLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let secondAutoCompletedResponseLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let thirdAutoCompletedResponseLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let fourthAutoCompletedResponseLabel: UILabel = {
        let l = UILabel()
        l.textColor = .color606572
        l.font = R.font.aileronRegular(size: 14)
        return l
    } ()
    
    private let errorUnderNameLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Name field should not be empty"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderSurnameLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 2
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Last Name field should not be empty"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderPhoneNumberLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Mobile phone field should not be empty"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderWorkPhoneNumberLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Work phone field should not be empty"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderCityLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "City field should not be empty"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()

    private let errorUnderStateLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "State field should not be empty"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderEmergencyFirstLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Contact Name field should not be empty"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderEmergencyFirstPhoneLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Contact field should not be empty"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderEmergencySecondLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Contact Name field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderEmergencySecondPhoneLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Contact field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderEmergencyThirdLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Contact Name field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderEmergencyThirdPhoneLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Contact field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderLockBoxLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Lockbox/Door code field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderLockBoxLocationLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Lockbox Location field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderHomeAlarmLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Home Alarm System field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderOtherHomeAccessNotesLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Other Home Access Notes field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderMailBoxLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Mail box field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderOtherRequestsLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Other requests field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderCommentLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Comment field is invalid"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderAddressLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Home Address field should not be empty"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let errorUnderBillingAddressLabel: UILabel = {
        let l = UILabel()
        l.isHidden = true
        l.textColor = .colorC6222F
        l.text = "Billing address field should not be empty"
        l.font = R.font.aileronLight(size: 12)
        return l
    } ()
    
    private let lineUnderAddressView: UIView = {
        let v = UIView()
        v.backgroundColor = R.color.underTextViewLineColor()
        return v
    } ()
        
    // MARK: - Properties
    
    var imagePicker = UIImagePickerController()
    
    private var avatar: UIImage?
    
    private var name = ""
    private var lastName = ""
    private var phone = ""
    private var workPhone = ""
    private var address = ""
    private var autocompleteAddress = ""
    private var billingAd = ""
    private var isSameAddress: Bool?
    private var city = ""
    private var state = ""
    private var zip = ""
    private var emergencyName = ""
    private var emergencyPhone = ""
    
    private var emergencySecondName: String?
    private var emergencySecondPhone: String?
    private var emergencyThirdName: String?
    private var emergencyThirdPhone: String?
    
    private var doorCode: String?
    private var locationLockbox: String?
    private var homeAlarmSystem: String?
    private var otherNotes: String?
    private var mailBox: String?
    private var otherRequests: String?
    
    private var isMailKeyProvided: Bool?
    private var isTurnLight: Bool?
    private var isSomeoneAtHome: Bool?
    private var isSameAsHomeAddress: Bool?
    private var isWaterPlantsExists: Bool?
    
    private var hearAboutUs: HearAboutComponents?
    private var whereHear = ""
    
    private var pickUpDays: [String] = []
    private var garbage = Garbage()
    private var comment: String?
    
    private var isValid = false
    let addContactButtonView = UIView()
    var fetcher: GMSAutocompleteFetcher?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationManager.sharedInstance.startUpdatingLocation()
        
        setupNavbar()
        hideKeyboardWhenTappedAround()
        setupDelegates()
        addTargetsToFields()
        setupLayouts()
        setupHomeAddress()
    }
    
    @objc func didTappedBack() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is AuthorizationVC {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }

    }
}

//MARK: - Actions

extension RegistrationMainVC {
    
    @objc func nameTextFieldAction() {
        if let firstName = nameTextField.text {
            if firstName.isEmpty {
                errorUnderNameLabel.text = "Name field should not be empty"
            } else {
                if firstName.isValidName {
                    errorUnderNameLabel.isHidden = true
                    name = firstName
                } else {
                    errorUnderNameLabel.text = "Invalid First Name"
                    errorUnderNameLabel.isHidden = false
                    name = firstName
                }
            }
        }
    }
    
    @objc func surnameTextFieldAction() {
        if let last = lastnameTextField.text {
            if last.isEmpty {
                errorUnderSurnameLabel.text = "Last Name field should not be empty"
            } else {
                if last.isValidName {
                    errorUnderSurnameLabel.isHidden = true
                    lastName = last
                } else {
                    errorUnderSurnameLabel.text = "Invalid Last Name"
                    errorUnderSurnameLabel.isHidden = false
                    lastName = last
                }
            }
        }
    }
    
    @objc func phoneTextFieldAction() {
        if let ph = phoneTextField.text {
            if ph.isEmpty {
                errorUnderPhoneNumberLabel.isHidden = false
                phone = ph
            } else {
                if ph.isValidPhone {
                    errorUnderPhoneNumberLabel.isHidden = true
                    phone = ph
                } else {
                    errorUnderPhoneNumberLabel.text = "Invalid Phone Number"

                    errorUnderPhoneNumberLabel.isHidden = false
                    phone = ph
                }
            }
            phone = phone.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
            if phone.isValidPhone {
                errorUnderPhoneNumberLabel.isHidden = true
            }
        }
    }
    
    @objc func workPhoneTextFieldAction() {
        if let ph = workPhoneTextField.text {
            if ph.isEmpty {
                errorUnderWorkPhoneNumberLabel.isHidden = true
                workPhone = ph
            } else {
                if ph.isValidPhone {
                    errorUnderWorkPhoneNumberLabel.isHidden = true
                    workPhone = ph
                } else{
                    errorUnderWorkPhoneNumberLabel.text = "Invalid Work Phone Number"
                    errorUnderWorkPhoneNumberLabel.isHidden = false 
                    workPhone = ph
                }
            }
            workPhone = workPhone.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
            if workPhone.isValidPhone {
                
                errorUnderWorkPhoneNumberLabel.isHidden = true
            }
        }
    }
    
    @objc func addressTextFieldAction() {
        lineUnderAddressView.backgroundColor = .colorC6222F

        if let ph = addressTextField.text {
            if ph.isEmpty {
                address = ph
                autocompleteAddress = ""
                errorUnderAddressLabel.text = "Home Address field should not be empty"
                errorUnderAddressLabel.isHidden = false
                autoCompletionView.isHidden = true
                firstAutoCompletedResponseLabel.isHidden = true
                secondAutoCompletedResponseLabel.isHidden = true
                thirdAutoCompletedResponseLabel.isHidden = true
                fourthAutoCompletedResponseLabel.isHidden = true
                
                locationImageView.isHidden = true
                locationSecondImageView.isHidden = true
                locationThirdImageView.isHidden = true
                locationFourthImageView.isHidden = true
                separatorFirstView.isHidden = true
                separatorSecondView.isHidden = true
                separatorThirdView.isHidden = true
                firstAutoCompletedResponseButton.isHidden = true
                secondAutoCompletedResponseButton.isHidden = true
                thirdAutoCompletedResponseButton.isHidden = true
                fourthAutoCompletedResponseButton.isHidden = true
                
            } else {
                address = ph
                errorUnderAddressLabel.isHidden = true
            }
        }
    }
    
    @objc func billingTextFieldAction() {
        if let ph = billingAddressTextField.text {
            if ph.isEmpty {
                billingAd = ph
                errorUnderBillingAddressLabel.isHidden = false
            } else {
                billingAd = ph
                errorUnderBillingAddressLabel.isHidden = true
            }
        }
    }
    
    @objc func cityTextFieldAction() {
        if let ph = cityTextField.text {
            if ph.isEmpty {
                city = ph
                errorUnderCityLabel.isHidden = false
            } else {
                if ph.isValidName {
                    errorUnderCityLabel.isHidden = true
                    city = ph
                    
                } else {
                    errorUnderCityLabel.text = "Invalid City Name"
                    errorUnderCityLabel.isHidden = false
                    city = ph
                }
            }
        }
    }
    
    @objc func stateTextFieldAction() {
        if let ph = stateTextField.text {
            if ph.isEmpty {
                state = ph
                errorUnderStateLabel.isHidden = false
            } else {
                if ph.isValidName {
                    state = ph
                    errorUnderStateLabel.isHidden = true
                } else {
                    errorUnderStateLabel.text = "Invalid State Name"
                    errorUnderStateLabel.isHidden = false
                    state = ph
                }
            }
        }
    }
    
    @objc func zipTextFieldAction() {
        if let ph = zipTextField.text {
            if !ph.isEmpty && ph.count >= 1 {
                zip = ph
            }
        }
    }
    
    @objc func emergencyTextFieldAction(field: SkyFloatingLabelTextField) {

        if field == emergency1ContactNameTextField {
           
            if let emerg = emergency1ContactNameTextField.text {

                if emerg.isEmpty {
                    emergencyName = emerg
                    errorUnderEmergencyFirstLabel.isHidden = false
                } else {
                    if emerg.isValidName {
                        emergencyName = emerg
                        errorUnderEmergencyFirstLabel.isHidden = true
                    } else {
                        emergencyName = emerg
                        errorUnderEmergencyFirstLabel.text = "Invalid Emergency Name"
                        errorUnderEmergencyFirstLabel.isHidden = false
                    }
                }
            }
        }/* else if field == emergency1ContactPhoneTextField {
            if let emerg = emergency1ContactPhoneTextField.text {
                if emerg.isEmpty {
                    emergencyPhone = text!
                    errorUnderEmergencyFirstPhoneLabel.isHidden = false
                } else {
                    if emerg.isEmergencyValidPhone {
                        emergencyPhone = text!
                        errorUnderEmergencyFirstPhoneLabel.isHidden = true
                    } else {
                        emergencyPhone = text!
                        errorUnderEmergencyFirstPhoneLabel.text = "Invalid Emergency Phone Number"
                        errorUnderEmergencyFirstPhoneLabel.isHidden = false
                    }
                }
                emergencyPhone = emergencyPhone.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
                if emergencyPhone.isEmergencyValidPhone {
                    errorUnderEmergencyFirstPhoneLabel.isHidden = true
                }
            }
        }*/ else if field == emergency2ContactNameTextField {
            if let emerg = emergency2ContactNameTextField.text {
                emergencySecondName = emerg
            }
        } /*else if field == emergency2ContactPhoneTextField {
            if let emerg = emergency2ContactPhoneTextField.text {
                emergencySecondPhone = emerg
            }
            emergencySecondPhone = emergencySecondPhone!.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            if emergencySecondPhone!.isEmergencyValidPhone {
                errorUnderEmergencySecondPhoneLabel.isHidden = true
            }
        }*/ else if field == emergency3ContactNameTextField {
            if let emerg = emergency3ContactNameTextField.text {
                emergencyThirdName = emerg
            }
        } /*else if field == emergency3ContactPhoneTextField {
            if let emerg = emergency3ContactPhoneTextField.text {
                emergencyThirdPhone = emerg
            }
            emergencyThirdPhone = emergencyThirdPhone!.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            if emergencyThirdPhone!.isEmergencyValidPhone {
                errorUnderEmergencyThirdLabel.isHidden = true
            }
        }*/
    }
    
    @objc func emergencyPhoneTextFieldAction(field: SkyFloatingLabelTextField) {
        var text = field.text
        text = text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")

        if text!.count <= Constant.USMobileNumberLimit {
            field.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            print(text!.count)
        } else if text!.count > Constant.USMobileNumberLimit {
            field.text = text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            print(text!.count)
        }
        
        
        if field == emergency1ContactPhoneTextField {
            if let emerg = emergency1ContactPhoneTextField.text {
                if emerg.isEmpty {
                    emergencyPhone = text!
                    errorUnderEmergencyFirstPhoneLabel.isHidden = false
                } else {
                    if emerg.isEmergencyValidPhone {
                        emergencyPhone = text!
                        errorUnderEmergencyFirstPhoneLabel.isHidden = true
                    } else {
                        emergencyPhone = text!
                        errorUnderEmergencyFirstPhoneLabel.text = "Invalid Emergency Phone Number"
                        errorUnderEmergencyFirstPhoneLabel.isHidden = false
                    }
                }
                emergencyPhone = emergencyPhone.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
                if emergencyPhone.isEmergencyValidPhone {
                    errorUnderEmergencyFirstPhoneLabel.isHidden = true
                }
            } else if field == emergency2ContactPhoneTextField {
                if let emerg = emergency2ContactPhoneTextField.text {
                    emergencySecondPhone = emerg
                }
                emergencySecondPhone = emergencySecondPhone!.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
                if emergencySecondPhone!.isEmergencyValidPhone {
                    errorUnderEmergencySecondPhoneLabel.isHidden = true
                }
            } else if field == emergency3ContactPhoneTextField {
                if let emerg = emergency3ContactPhoneTextField.text {
                    emergencyThirdPhone = emerg
                }
                emergencyThirdPhone = emergencyThirdPhone!.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
                if emergencyThirdPhone!.isEmergencyValidPhone {
                    errorUnderEmergencyThirdLabel.isHidden = true
                }
            }
        }
        
    }
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let contact1Name = emergency1ContactNameTextField.text ?? ""
        let contact1Phone = emergency1ContactPhoneTextField.text ?? ""
        
        let contact2Name = emergency2ContactNameTextField.text ?? ""
        let contact2Phone = emergency2ContactPhoneTextField.text ?? ""
        let contact3Name = emergency3ContactNameTextField.text ?? ""
        let contact3Phone = emergency3ContactPhoneTextField.text ?? ""
        
        
        if contact1Name.isEmpty == true || contact1Phone.isEmpty == true {
            emergency1ContactNameTextField.text = contact.givenName
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            var number = ((contact.phoneNumbers.first?.value)! as CNPhoneNumber).stringValue
            number = NSString(string: number.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")) as String
            if number.count <= 10 {
                emergency1ContactPhoneTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            } else if number.count > 10 && number.count < 14  {
                emergency1ContactPhoneTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            } else if number.count < 14 {
                emergency1ContactNameTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
                errorUnderEmergencyFirstPhoneLabel.isHidden = false
                errorUnderEmergencyFirstPhoneLabel.text = "Invalid Phone Number"
                nextButton.redAndGrayStyle(active: false)
            }
            
            emergencyPhone = emergency1ContactPhoneTextField.text!.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            if emergencyPhone.isEmergencyValidPhone {
                errorUnderEmergencyFirstPhoneLabel.isHidden = true
                errorUnderEmergencyFirstPhoneLabel.text = "Invalid Phone Number"
            } else {
                errorUnderEmergencyFirstPhoneLabel.isHidden = false
                errorUnderEmergencyFirstPhoneLabel.text = "Invalid Phone Number"
            }
            emergencyName = contact.givenName
            
        } else if contact2Name.isEmpty && contact2Phone.isEmpty {
            emergency2ContactNameTextField.text = contact.givenName
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            var number = ((contact.phoneNumbers.first?.value)! as CNPhoneNumber).stringValue
            number = NSString(string: number.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")) as String
            if number.count <= 10 {
                emergency2ContactPhoneTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            } else if number.count > 10 && number.count < 14  {
                emergency2ContactPhoneTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            } else if number.count < 14 {
                emergency2ContactPhoneTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
                errorUnderEmergencySecondPhoneLabel.isHidden = false
                errorUnderEmergencySecondPhoneLabel.text = "Invalid Phone Number"
            }
            
           emergencySecondPhone = emergency2ContactPhoneTextField.text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            if emergencySecondPhone!.isEmergencyValidPhone {
                errorUnderEmergencySecondPhoneLabel.isHidden = true
                errorUnderEmergencySecondPhoneLabel.text = "Invalid Phone Number"
                
            } else {
                errorUnderEmergencySecondPhoneLabel.isHidden = false
                errorUnderEmergencySecondPhoneLabel.text = "Invalid Phone Number"
            }
           
           emergencySecondName = contact.givenName
        } else if contact3Name.isEmpty && contact3Phone.isEmpty {
            emergency3ContactNameTextField.text = contact.givenName
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
            var number = ((contact.phoneNumbers.first?.value)! as CNPhoneNumber).stringValue
            number = NSString(string: number.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")) as String
            if number.count <= 10 {
                emergency3ContactPhoneTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            } else if number.count > 10 && number.count < 14  {
                emergency3ContactPhoneTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            } else if number.count < 14 {
                emergency3ContactPhoneTextField.text = firstPhoneNumber.stringValue.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
                errorUnderEmergencyThirdPhoneLabel.isHidden = false
                errorUnderEmergencyThirdPhoneLabel.text = "Invalid Phone Number"
            }
            
           emergencyThirdPhone = emergency3ContactPhoneTextField.text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            if emergencyThirdPhone!.isEmergencyValidPhone {
                errorUnderEmergencyThirdPhoneLabel.isHidden = true
                errorUnderEmergencyThirdPhoneLabel.text = "Invalid Phone Number"
                
            } else {
                errorUnderEmergencyThirdPhoneLabel.isHidden = false
                errorUnderEmergencyThirdPhoneLabel.text = "Invalid Phone Number"
            }
           
           emergencyThirdName = contact.givenName
        }
    }
    
    @objc func doorCodeAction() {
        if let code = doorCodeTextField.text {
            doorCode = code
        }
    }
    
    @objc func locationLockboxAction() {
        if let code = locationTextField.text {
            locationLockbox = code
        }
    }
    
    @objc func homeAlarmAction() {
        if let home = homeAlarmTextField.text {
            homeAlarmSystem = home
        }
    }
    
    @objc func otherNotesAction() {
        if let home = otherNotesTextField.text {
            otherNotes = home
        }
    }
    
    @objc func mailBoxAction() {
        if let home = mailBoxTextField.text {
            mailBox = home
        }
    }
    
    @objc func otherRequestsAction() {
        if let home = otherRequestTextField.text {
            otherRequests = home
        }
    }

    @objc func addCommentAction() {
        if let home = addCommentTextField.text {
            comment = home
        }
    }
    
}

//MARK: - Setup Properties

private extension RegistrationMainVC {
    func addTargetsToFields() {
        let massOfField = [nameTextField, lastnameTextField, phoneTextField, workPhoneTextField, addressTextField, billingAddressTextField, cityTextField, stateTextField, zipTextField, emergency1ContactNameTextField, emergency1ContactPhoneTextField, emergency2ContactNameTextField, emergency2ContactPhoneTextField, emergency3ContactNameTextField, emergency3ContactPhoneTextField, doorCodeTextField, locationTextField, homeAlarmTextField, otherNotesTextField, mailBoxTextField, otherRequestTextField, addCommentTextField, hearAboutTextField]
        for field in massOfField {
            field.addTarget(self, action: #selector(checkStateOfField), for: .editingChanged)
        }
        
        addressTextField.addTarget(self, action: #selector(addressTextFieldDidEndEditing), for: .editingDidEnd)
    }
    
    func setupDelegates() {
        hearAboutTableView.delegate = self
        hearAboutTableView.dataSource = self
        waterPlantsButton.delegate = self
    }
}

//MARK: - Validation

extension RegistrationMainVC {
    
    @objc func checkStateOfField(field: SkyFloatingLabelTextFieldWithIcon) {
        if field.text?.isEmpty ?? true {
            field.style(active: false)
        } else {
            field.style(active: true)
        }
        if field == addressTextField {
            setupAutoCompleteView()
            if let address = field.text {
                if address != "" {
                    autoCompletionView.isHidden = false
                    let request = replaceWhiteSpacesToUnderscore(request: address)
                    autocompleteLocation(text: request)
                }  else {
                    autoCompletionView.isHidden = true
                    firstAutoCompletedResponseLabel.isHidden = true
                    secondAutoCompletedResponseLabel.isHidden = true
                    thirdAutoCompletedResponseLabel.isHidden = true
                    fourthAutoCompletedResponseLabel.isHidden = true
                    
                    locationImageView.isHidden = true
                    locationSecondImageView.isHidden = true
                    locationThirdImageView.isHidden = true
                    locationFourthImageView.isHidden = true
                    separatorFirstView.isHidden = true
                    separatorSecondView.isHidden = true
                    separatorThirdView.isHidden = true
                    firstAutoCompletedResponseButton.isHidden = true
                    secondAutoCompletedResponseButton.isHidden = true
                    thirdAutoCompletedResponseButton.isHidden = true
                    fourthAutoCompletedResponseButton.isHidden = true
                    
                }
            }
        }
        checkStateOfNextButton()
    }
    
    func replaceWhiteSpacesToUnderscore(request: String) -> String {
        return request.replacingOccurrences(of: " ", with: "_")
    }
    
    func autocompleteLocation(text: String) {
//        LocationManager.sharedInstance.startUpdatingLocation()
//
//        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(text)&types=address&key=\(googleApiKey)"
//
//        AF.request(urlString, method: .get, headers: nil)
//            .validate()
//            .responseJSON { (response) in
//                print(response)
//                switch response.result {
//                case.success(let value):
//                    let json = JSON(value)
//
//                    self.firstAutoCompletedResponseLabel.text = self.parseResult(response: "\(json["predictions"][0]["description"])")
//
//                    self.secondAutoCompletedResponseLabel.text = self.parseResult(response: "\(json["predictions"][1]["description"])")
//
//                    self.thirdAutoCompletedResponseLabel.text = self.parseResult(response: "\(json["predictions"][2]["description"])")
//
//                    self.fourthAutoCompletedResponseLabel.text = self.parseResult(response: "\(json["predictions"][3]["description"])")
//
//                case.failure(let error):
//                    self.setupErrorAlert(error: error)
//                }
//            }
        
            let filter = GMSAutocompleteFilter()

            let token: GMSAutocompleteSessionToken = GMSAutocompleteSessionToken.init()

            // Create the fetcher.
          
            fetcher = GMSAutocompleteFetcher(filter: filter)
            fetcher?.delegate = self
            fetcher?.provide(token)
            fetcher?.sourceTextHasChanged(text)


    }
    
    func parseResult(response: String) -> String {
        if response == "null" {
            return ""
        } else {
            return response
        }
    }
    
    @objc func autocompleteFirstButtonSetupAction() {
        addressTextField.text = firstAutoCompletedResponseLabel.text
        if let add = firstAutoCompletedResponseLabel.text {
            address = add
            autocompleteAddress = add
        }
    }
    
    @objc func autocompleteSecondButtonSetupAction() {
        addressTextField.text = secondAutoCompletedResponseLabel.text
        if let add = secondAutoCompletedResponseLabel.text {
            address = add
            autocompleteAddress = add
        }
    }
    
    @objc func autocompleteThirdButtonSetupAction() {
        addressTextField.text = thirdAutoCompletedResponseLabel.text
        if let add = thirdAutoCompletedResponseLabel.text {
            address = add
            autocompleteAddress = add
        }
    }
    
    @objc func autocompleteFourthButtonSetupAction() {
        addressTextField.text = fourthAutoCompletedResponseLabel.text
        if let add = fourthAutoCompletedResponseLabel.text {
            address = add
            autocompleteAddress = add
        }
    }
    
    func setupAutoCompleteView() {
        view.addSubviews([autoCompletionView, firstAutoCompletedResponseLabel, secondAutoCompletedResponseLabel, locationImageView, separatorFirstView, locationSecondImageView, separatorSecondView, separatorThirdView, locationThirdImageView, locationFourthImageView, thirdAutoCompletedResponseLabel, fourthAutoCompletedResponseLabel, firstAutoCompletedResponseButton, secondAutoCompletedResponseButton, thirdAutoCompletedResponseButton, fourthAutoCompletedResponseButton])
        
        autoCompletionView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.height.equalTo(192)
            $0.top.equalTo(addressTextField.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        
        locationImageView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(16)
            $0.top.equalTo(autoCompletionView).offset(16)
            $0.left.equalTo(autoCompletionView).offset(16)
        }
        
        firstAutoCompletedResponseLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationImageView)
            $0.left.equalTo(locationImageView.snp.right).offset(7)
            $0.right.equalTo(autoCompletionView).offset(-2)
        }
        
        separatorFirstView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(locationImageView.snp.bottom).offset(16)
            $0.left.equalTo(autoCompletionView).offset(16)
            $0.right.equalTo(autoCompletionView)
        }
        
        locationSecondImageView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(16)
            $0.top.equalTo(separatorFirstView.snp.bottom).offset(16)
            $0.left.equalTo(autoCompletionView).offset(16)
        }
        
        secondAutoCompletedResponseLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationSecondImageView)
            $0.left.equalTo(locationSecondImageView.snp.right).offset(7)
            $0.right.equalTo(autoCompletionView).offset(-2)
        }
        
        separatorSecondView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(locationSecondImageView.snp.bottom).offset(16)
            $0.left.equalTo(autoCompletionView).offset(16)
            $0.right.equalTo(autoCompletionView)
        }
        
        locationThirdImageView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(16)
            $0.top.equalTo(separatorSecondView.snp.bottom).offset(16)
            $0.left.equalTo(autoCompletionView).offset(16)
        }
        
        thirdAutoCompletedResponseLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationThirdImageView)
            $0.left.equalTo(locationThirdImageView.snp.right).offset(7)
            $0.right.equalTo(autoCompletionView).offset(-2)
        }
        
        separatorThirdView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(locationThirdImageView.snp.bottom).offset(16)
            $0.left.equalTo(autoCompletionView).offset(16)
            $0.right.equalTo(autoCompletionView)
        }
        
        locationFourthImageView.snp.makeConstraints {
            $0.width.equalTo(13)
            $0.height.equalTo(16)
            $0.top.equalTo(separatorThirdView.snp.bottom).offset(16)
            $0.left.equalTo(autoCompletionView).offset(16)
        }
        
        fourthAutoCompletedResponseLabel.snp.makeConstraints {
            $0.centerY.equalTo(locationFourthImageView)
            $0.left.equalTo(locationFourthImageView.snp.right).offset(7)
            $0.right.equalTo(autoCompletionView).offset(-2)
        }
        
        firstAutoCompletedResponseButton.snp.makeConstraints {
            $0.top.left.right.equalTo(autoCompletionView)
            $0.bottom.equalTo(separatorFirstView.snp.top)
        }
        
        secondAutoCompletedResponseButton.snp.makeConstraints {
            $0.top.equalTo(separatorFirstView.snp.bottom)
            $0.left.right.equalTo(autoCompletionView)
            $0.bottom.equalTo(separatorSecondView.snp.top)
        }
        
        thirdAutoCompletedResponseButton.snp.makeConstraints {
            $0.top.equalTo(separatorSecondView.snp.bottom)
            $0.left.right.equalTo(autoCompletionView)
            $0.bottom.equalTo(separatorThirdView.snp.top)
        }
        
        fourthAutoCompletedResponseButton.snp.makeConstraints {
            $0.top.equalTo(separatorThirdView.snp.bottom)
            $0.left.right.equalTo(autoCompletionView)
            $0.bottom.equalTo(autoCompletionView)
        }
    }
    
    @objc func addressTextFieldDidEndEditing() {
        addressTextField.lineColor = .white

        if autocompleteAddress.isEmpty {
            lineUnderAddressView.backgroundColor = R.color.underTextViewLineColor()
            errorUnderAddressLabel.isHidden = false
            errorUnderAddressLabel.text = "Home address must be selected from the dropdown list"
        } else {
            lineUnderAddressView.backgroundColor = .colorC6222F
            errorUnderAddressLabel.isHidden = true
        }

        autoCompletionView.removeFromSuperview()
        firstAutoCompletedResponseLabel.removeFromSuperview()
        secondAutoCompletedResponseLabel.removeFromSuperview()
        thirdAutoCompletedResponseLabel.removeFromSuperview()
        fourthAutoCompletedResponseLabel.removeFromSuperview()
        locationImageView.removeFromSuperview()
        locationSecondImageView.removeFromSuperview()
        locationThirdImageView.removeFromSuperview()
        locationFourthImageView.removeFromSuperview()
        separatorFirstView.removeFromSuperview()
        separatorSecondView.removeFromSuperview()
        separatorThirdView.removeFromSuperview()
        firstAutoCompletedResponseButton.removeFromSuperview()
        secondAutoCompletedResponseButton.removeFromSuperview()
        thirdAutoCompletedResponseButton.removeFromSuperview()
        fourthAutoCompletedResponseButton.removeFromSuperview()
        
        checkStateOfNextButton()
    }
    
    private func checkStateOfNextButton() {
        if avatar != nil,
           let name = nameTextField.text, !name.isEmpty,
           let lastName = lastnameTextField.text, !lastName.isEmpty,
           let mobilePhone = phoneTextField.text, !mobilePhone.isEmpty,// let workPhon = workPhoneTextField.text, !workPhone.isEmpty,
           let homeAddress = addressTextField.text, !homeAddress.isEmpty,
           let billingAddress = billingAddressTextField.text, !billingAddress.isEmpty,
           let city = cityTextField.text, !city.isEmpty,
           let state = stateTextField.text, !state.isEmpty,
           let nameEmergency = emergency1ContactNameTextField.text, !nameEmergency.isEmpty, let phoneEmergency = emergency1ContactPhoneTextField.text, !phoneEmergency.isEmpty {
            
            if !workPhone.isEmpty {
                if !phone.isEmpty, workPhone.isValidPhone,  !whereHear.isEmpty, !emergencyPhone.isEmpty, !autocompleteAddress.isEmpty {
                    isValid = true
                    nextButton.redAndGrayStyle(active: true)
                } else {
                    isValid = false
                    nextButton.redAndGrayStyle(active: false)
                }
            } else {
                if !phone.isEmpty, /*!workPhone.isEmpty,*/  !whereHear.isEmpty, !emergencyPhone.isEmpty, !autocompleteAddress.isEmpty {
                    isValid = true
                    nextButton.redAndGrayStyle(active: true)
                } else {
                    isValid = false
                    nextButton.redAndGrayStyle(active: false)
                }
            }
            

        }
    }
}

// MARK: - SetupLayouts

extension RegistrationMainVC {
    func setupNavbar() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        let backButtonImg : UIButton = UIButton.init(type: .custom)
        backButtonImg.setImage(R.image.leftArrow(), for: .normal)
        backButtonImg.addTarget(self, action: #selector(didTappedBack), for: .touchUpInside)
        backButtonImg.frame = CGRect(x: 35, y: 0, width: 30, height: 30)
        let addButton = UIBarButtonItem(customView: backButtonImg)
        self.navigationItem.setLeftBarButtonItems([addButton], animated: false)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.title = "Step 2.  Entry & Home Care"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Aileron-Bold", size: 18)!]
    }
    
    private func setupLayouts() {
        view.backgroundColor = .white
        setupScrollViewLayouts()
        configureHearAboutGroup()
        setupTopPartLayouts()
        setupMainStackView()
        setupBottomStackView()
        setupGarbage()
    }
    
    private func setupScrollViewLayouts() {
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
    
    private func configureHearAboutGroup() {
        hearAboutView.addSubviews([hearAboutLabel, hearAboutTextField])
        hearAboutView.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        hearAboutLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(19)
        }
        hearAboutTextField.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.top.equalTo(hearAboutLabel.snp.bottom)
        }
        hearAboutTextField.addSubview(hearAboutChekImageView)
        hearAboutChekImageView.snp.makeConstraints {
            $0.height.equalTo(9)
            $0.width.equalTo(18)
            $0.bottom.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setupTopPartLayouts() {
        mainView.addSubviews([profileImageView, profileImageButton, requiredAvatarLabel,mainStackView])
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(55)
            $0.top.equalTo(scrollView.snp.top).inset(20)
            $0.leading.equalToSuperview().inset(25)
        }
        profileImageButton.snp.makeConstraints {
            $0.edges.equalTo(profileImageView)
        }
        
        requiredAvatarLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(15)
        }
    }
    
    private func setupMainStackView() {
        nameStackView.addArrangedSubviews(views: nameTextField, lastnameTextField)
        
        
        addContactButtonView.addSubview(addContactButton)
        addContactButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(146)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().offset(10)
            $0.top.equalToSuperview()
        }
        
        backgroundHomeAddressImageView.snp.makeConstraints {
            $0.height.equalTo(66)
            $0.width.equalTo(326)
        }
        
        
        billingStackView.addArrangedSubviews(views: billingAddressTextField,sameAsHomeAddressBtn)
        mainStackView.addArrangedSubviews(views: nameStackView, phoneTextField, workPhoneTextField, addressTextField, backgroundHomeAddressImageView, cityTextField, stateTextField,billingStackView, emergencyNameFieldView,emergency1ContactPhoneTextField, emergency2ContactNameTextField, emergency2ContactPhoneTextField,emergency3ContactNameTextField, emergency3ContactPhoneTextField, addContactButtonView, doorCodeTextField, locationTextField, homeAlarmTextField, otherNotesTextField, mailBoxTextField, otherRequestTextField)
        
        view.addSubviews([errorUnderNameLabel, errorUnderSurnameLabel, errorUnderPhoneNumberLabel, errorUnderCityLabel, errorUnderStateLabel, errorUnderEmergencyFirstLabel, errorUnderEmergencyFirstPhoneLabel, errorUnderWorkPhoneNumberLabel, errorUnderEmergencySecondLabel, errorUnderEmergencySecondPhoneLabel, errorUnderEmergencyThirdLabel, errorUnderEmergencyThirdPhoneLabel, errorUnderLockBoxLabel, errorUnderLockBoxLocationLabel, errorUnderHomeAlarmLabel, errorUnderOtherHomeAccessNotesLabel, errorUnderMailBoxLabel, errorUnderOtherRequestsLabel, errorUnderCommentLabel, errorUnderAddressLabel, errorUnderBillingAddressLabel, lineUnderAddressView])
        
        emergencyNameFieldView.addSubviews([emergency1ContactNameTextField,emergencyNameBtnTapped])
        lineUnderAddressView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalTo(addressTextField.snp.bottom).offset(-2)
            $0.height.equalTo(2)
        }
        
        errorUnderNameLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(4)
            $0.leading.equalTo(nameTextField)
        }
        
        errorUnderSurnameLabel.snp.makeConstraints {
            $0.right.equalTo(phoneTextField).offset(4)
            $0.top.equalTo(lastnameTextField.snp.bottom).offset(4)
            $0.leading.equalTo(lastnameTextField)
        }
        
        errorUnderPhoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(4)
            $0.leading.equalTo(phoneTextField)
        }
        
        errorUnderWorkPhoneNumberLabel.snp.makeConstraints {
            $0.top.equalTo(workPhoneTextField.snp.bottom).offset(4)
            $0.leading.equalTo(workPhoneTextField)
        }
        
        errorUnderAddressLabel.snp.makeConstraints {
            $0.top.equalTo(addressTextField.snp.bottom).offset(4)
            $0.leading.equalTo(addressTextField)
        }
        
        errorUnderBillingAddressLabel.snp.makeConstraints {
            $0.top.equalTo(billingStackView.snp.bottom).offset(2)
            $0.leading.equalTo(billingAddressTextField)
        }
        
        errorUnderCityLabel.snp.makeConstraints {
            $0.top.equalTo(cityTextField.snp.bottom).offset(4)
            $0.leading.equalTo(cityTextField)
        }
        
        errorUnderStateLabel.snp.makeConstraints {
            $0.top.equalTo(stateTextField.snp.bottom).offset(4)
            $0.leading.equalTo(stateTextField)
        }
        
        errorUnderEmergencyFirstLabel.snp.makeConstraints {
            $0.top.equalTo(emergencyNameFieldView.snp.bottom).offset(4)
            $0.leading.equalTo(emergencyNameFieldView)
        }
        
        errorUnderEmergencyFirstPhoneLabel.snp.makeConstraints {
            $0.top.equalTo(emergency1ContactPhoneTextField.snp.bottom).offset(4)
            $0.leading.equalTo(emergency1ContactPhoneTextField)
        }
        
        errorUnderEmergencySecondLabel.snp.makeConstraints {
            $0.top.equalTo(emergency2ContactNameTextField.snp.bottom).offset(4)
            $0.leading.equalTo(emergency2ContactNameTextField)
        }
        
        errorUnderEmergencySecondPhoneLabel.snp.makeConstraints {
            $0.top.equalTo(emergency2ContactPhoneTextField.snp.bottom).offset(4)
            $0.leading.equalTo(emergency2ContactPhoneTextField)
        }
        
        errorUnderEmergencyThirdLabel.snp.makeConstraints {
            $0.top.equalTo(emergency3ContactNameTextField.snp.bottom).offset(4)
            $0.leading.equalTo(emergency3ContactNameTextField)
        }
        
        errorUnderEmergencyThirdPhoneLabel.snp.makeConstraints {
            $0.top.equalTo(emergency3ContactPhoneTextField.snp.bottom).offset(4)
            $0.leading.equalTo(emergency3ContactPhoneTextField)
        }
        
        errorUnderLockBoxLabel.snp.makeConstraints {
            $0.top.equalTo(doorCodeTextField.snp.bottom).offset(4)
            $0.leading.equalTo(doorCodeTextField)
        }
        
        errorUnderLockBoxLocationLabel.snp.makeConstraints {
            $0.top.equalTo(locationTextField.snp.bottom).offset(4)
            $0.leading.equalTo(locationTextField)
        }
        
        errorUnderHomeAlarmLabel.snp.makeConstraints {
            $0.top.equalTo(homeAlarmTextField.snp.bottom).offset(4)
            $0.leading.equalTo(homeAlarmTextField)
        }
        
        errorUnderOtherHomeAccessNotesLabel.snp.makeConstraints {
            $0.top.equalTo(otherNotesTextField.snp.bottom).offset(4)
            $0.leading.equalTo(otherNotesTextField)
        }
        
        errorUnderMailBoxLabel.snp.makeConstraints {
            $0.top.equalTo(mailBoxTextField.snp.bottom).offset(4)
            $0.leading.equalTo(mailBoxTextField)
        }
        
        errorUnderOtherRequestsLabel.snp.makeConstraints {
            $0.top.equalTo(otherRequestTextField.snp.bottom).offset(4)
            $0.leading.equalTo(otherRequestTextField)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        emergency1ContactNameTextField.snp.makeConstraints {
            $0.leading.equalTo(emergencyNameFieldView.snp.leading)
            $0.trailing.equalTo(emergencyNameFieldView.snp.trailing)
            $0.top.equalTo(emergencyNameFieldView.snp.top)
            $0.bottom.equalTo(emergencyNameFieldView.snp.bottom)
            $0.height.equalTo(40)
            
        }

        view.addSubview(locationHomeAddressImageView)
        locationHomeAddressImageView.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(14)
            $0.top.equalTo(backgroundHomeAddressImageView.snp.top).offset(17.5)
            $0.left.equalTo(backgroundHomeAddressImageView.snp.left).offset(20)
        }
        
        view.addSubview(useHomeAddressButton)
        useHomeAddressButton.snp.makeConstraints {
            $0.centerY.equalTo(backgroundHomeAddressImageView)
            $0.left.equalTo(locationHomeAddressImageView.snp.right).offset(12)
        }
    }
    
    private func setupBottomStackView() {
        mainView.addSubviews([mailKeyProvidedView, someoneWillBeHomeView, turnLightsOnOrOffView, waterPlantsStackView])
        mailKeyProvidedView.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(60)
        }
        
        turnLightsOnOrOffView.snp.makeConstraints {
            $0.top.equalTo(mailKeyProvidedView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(60)
        }
        
        someoneWillBeHomeView.snp.makeConstraints {
            $0.top.equalTo(turnLightsOnOrOffView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(25)
            $0.height.equalTo(60)
        }
        waterPlantsStackView.addArrangedSubviews(views: waterPlantsButton, addCommentTextField, hearAboutView)
        waterPlantsStackView.snp.makeConstraints {
            $0.top.equalTo(someoneWillBeHomeView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        errorUnderCommentLabel.snp.makeConstraints {
            $0.top.equalTo(addCommentTextField.snp.bottom).offset(4)
            $0.leading.equalTo(addCommentTextField)
        }
    }
    
    private func setupGarbage() {
        mainView.addSubviews([garbageView, nextButton])
        garbageView.snp.makeConstraints {
            $0.top.equalTo(hearAboutView.snp.bottom).offset(30)
            $0.height.equalTo(300)
            $0.left.right.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.top.equalTo(garbageView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(80)
        }
        
    }
    
    private func setupHomeAddress() {

        addressTextField.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-28)
        }
    }
    
    @objc func addContactButtonTouched() {
        view.addSubview(crossAddContactButton)
        crossAddContactButton.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.equalTo(emergency1ContactPhoneTextField.snp.bottom).offset(20)
            $0.right.equalTo(emergency1ContactPhoneTextField.snp.right).offset(-5)
        }
            CNContactStore().requestAccess(for: .contacts) { (access, error) in
                if access {
                    let vc = CNContactPickerViewController()
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                } else {
                    print("Not Allowed")
                }
            }

        if emergency2ContactNameTextField.isHidden || emergency2ContactPhoneTextField.isHidden || emergency3ContactNameTextField.isHidden || emergency3ContactPhoneTextField.isHidden {
            if emergency1ContactNameTextField.text!.isEmpty || emergency1ContactPhoneTextField.text!.isEmpty {
                errorUnderEmergencyFirstPhoneLabel.isHidden = true
                errorUnderEmergencyFirstLabel.isHidden = true
                
                crossAddContactButton.isHidden = true
            }else {
                crossAddContactButton.isHidden = false
                if emergency2ContactPhoneTextField.isHidden || emergency2ContactNameTextField.isHidden {
                    emergency2ContactPhoneTextField.isHidden = false
                    emergency2ContactNameTextField.isHidden = false
                    return
                }
                if emergency3ContactPhoneTextField.isHidden {
                    emergency3ContactPhoneTextField.isHidden = false
                    emergency3ContactNameTextField.isHidden = false
                    addContactButton.redAndGrayStyleAdditional(active: false)
                    return
                }
            }
        }

    }
}

//MARK: - Setup HomeAddress Actions && additional Emergency contact

extension RegistrationMainVC {
    @objc func homeAddressAsBillingAddressAction() {
        if backgroundHomeAddressImageView.isHidden {
            errorUnderBillingAddressLabel.isHidden = true
            backgroundHomeAddressImageView.isHidden = false
            locationHomeAddressImageView.isHidden = false
            useHomeAddressButton.isHidden = false
            billingAddressTextField.isHidden = true
        } else {
            backgroundHomeAddressImageView.isHidden = true
            locationHomeAddressImageView.isHidden = true
            useHomeAddressButton.isHidden = true
            billingAddressTextField.isHidden = false
        }
    }
    
    @objc func useHomeAddressAction() {
        backgroundHomeAddressImageView.isHidden = true
        locationHomeAddressImageView.isHidden = true
        useHomeAddressButton.isHidden = true
        billingAddressTextField.isHidden = false
        
        billingAddressTextField.text = addressTextField.text
        billingAd = address
        billingAddressTextField.style(active: true)
        checkStateOfNextButton()
    }
    
    @objc func hideAdditionalContactsAction() {
        if !emergency3ContactNameTextField.isHidden {
            emergency3ContactNameTextField.text = ""
            emergency3ContactPhoneTextField.text = ""
            
            emergency3ContactNameTextField.isHidden = true
            emergency3ContactPhoneTextField.isHidden = true
            errorUnderEmergencyThirdPhoneLabel.isHidden = true
            errorUnderEmergencyThirdLabel.isHidden = true
 
            addContactButton.redAndGrayStyleAdditional(active: true)
            return
        }
        if !emergency2ContactNameTextField.isHidden {
            emergency2ContactNameTextField.text = ""
            emergency2ContactPhoneTextField.text = ""
            emergency2ContactNameTextField.isHidden = true
            emergency2ContactPhoneTextField.isHidden = true
            errorUnderEmergencySecondLabel.isHidden = true
            errorUnderEmergencySecondPhoneLabel.isHidden = true
            addContactButton.redAndGrayStyleAdditional(active: true)
            crossAddContactButton.removeFromSuperview()
            return
        }
    }
}

// MARK: - UITableViewDelegate

extension RegistrationMainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hearAboutTextField.text = HearAboutComponents.allCases[indexPath.row].title
        hearAboutUs = HearAboutComponents.allCases[indexPath.row]
        whereHear = HearAboutComponents.allCases[indexPath.row].title
        checkStateOfNextButton()
        hearAboutTextField.style(active: true)
        hearAboutChekImageView.tintColor = .colorC6222F
        
        hearAboutTextField.placeholder = ""
        blackoutView.removeFromSuperview()
        hearAboutListView.removeFromSuperview()
        scrollView.isScrollEnabled = true
    }
}


// MARK: - UITableViewDataSource

extension RegistrationMainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HearAboutComponents.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = HearAboutComponents.allCases[indexPath.row].title
        cell.textLabel?.font = R.font.aileronRegular(size: 14)
        cell.textLabel?.textColor = .color070F24
        cell.textLabel?.textAlignment = .left
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - ButtonWithTrailingCheckboxDelegate

extension RegistrationMainVC: ButtonWithTrailingCheckboxDelegate {
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool) {
        switch questions {
        case .sameAsHomeAddressCheckBox:
            isSameAsHomeAddress = answer
            if isSameAsHomeAddress == true {
                billingAddressTextField.text = ""
                billingAddressTextField.text = addressTextField.text
                billingAd = billingAddressTextField.text!
                billingAddressTextField.isUserInteractionEnabled = false
                isSameAddress = true
            } else {
                billingAddressTextField.isUserInteractionEnabled = true
                isSameAddress = false
            }
        case .waterPlaints:
            self.isWaterPlantsExists = answer
        default:
            return
        }
        checkStateOfNextButton()
    }
}

//MARK: - UITextFieldDelegate

extension RegistrationMainVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if textField.tag == 3 || textField.tag == 4  {
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                      return false
                  }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            let text = textField.text
            textField.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            
            return count <= Constant.MobileNumberMaxLimit
        }
        if textField.tag == 10 || textField.tag == 20 || textField.tag == 21 {
            var text = textField.text
            text = text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            guard let textFieldText = textField.text,
                  let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                      return false
                  }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = text!.count - substringToReplace.count + string.count
            return count <= Constant.EmergencyContactMaxLimit
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            
            self.view.endEditing(true)
//            scrollView.scrollTo(.bottom, animated: true)
//            scrollView.setContentOffset(CGPoint(x: hearAboutTextField.frame.origin.x, y: hearAboutTextField.frame.origin.y + mainStackView.frame.origin.y - 20), animated: true)
            
            view.addSubview(blackoutView)
            blackoutView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            scrollView.isScrollEnabled = false
            tapGesture = UITapGestureRecognizer(target: self, action: #selector(panGestureTouched))
            
            tapGesture.numberOfTapsRequired = 1
            tapGesture.numberOfTouchesRequired = 1
            blackoutView.addGestureRecognizer(tapGesture)
            
            view.addSubview(hearAboutListView)
            hearAboutListView.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
                $0.leading.trailing.equalTo(hearAboutView)
            }
        } else if textField.tag != 0 {
            return true
        }
        return false
    }
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

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RegistrationMainVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func profileImageTouched() {
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.delegate = self
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        self.profileImageView.image = image
        self.avatar = image
        requiredAvatarLabel.isHidden = true
        checkStateOfNextButton()
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

//MARK: - YesOrNoViewDelegate

extension RegistrationMainVC: YesOrNoViewDelegate {
    func tapOnQuestion(question: YesOrNoViewGroups, answer: Bool) {
        switch question {
        case .mailKeyProvided:
            self.isMailKeyProvided = answer
        case .someoneWillBeHome:
            self.isSomeoneAtHome = answer
        case .turnLightsOnOrOff:
            self.isTurnLight = answer
        default:
            return
        }
        checkStateOfNextButton()
    }
}

//MARK: - Navigation

extension RegistrationMainVC {
    
    @objc func backButtonTouched() {
            for controller in self.navigationController!.viewControllers as Array {
            print("Controller are",controller)
            if controller.isKind(of: AuthorizationVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }   
    }
    
    @objc func nextButtonTouched() {
        if isValid {
            signUp()
        }
    }
    
    private func signUp() {
        showActivityIndicator()
        UIApplication.shared.beginIgnoringInteractionEvents()
        let currentLocation = ["lat": LocationManager.sharedInstance.latitude, "long": LocationManager.sharedInstance.longitude]
        
        if let hear = hearAboutTextField.text {
            whereHear = hear
        }
        UserDefaults.standard.set(hearAboutTextField.text, forKey: "hearAboutUs")
        let garbageArr = garbageView.fillArrayWithAnswers()
        
    
        let profile = ProfileStruct(firstName: name, lastName: lastName, phone: phone, workPhone: workPhone, address: autocompleteAddress, billingAddress: billingAd, isSameAddress: isSameAddress, city: city, state: state, homePosition: currentLocation, lockboxDoorCode: doorCode, lockboxLocation: locationLockbox, homeAlarmSystem: homeAlarmSystem, otherHomeAccessNotes: otherNotes, mailBox: mailBox, otherRequestsNotes: otherRequests, isMailKeyProvided: isMailKeyProvided, isTurnLight: isTurnLight, isSomeoneAtHome: isSomeoneAtHome, isWaterPlantsExists: isWaterPlantsExists, hearAboutUs: whereHear.lowercased(),comment: comment, garbage: garbageArr, status: 1)
 
        CustomerService().editCustomerAccount(blank: profile) { result in
            switch result {
            case .success(let response):
                DBManager.shared.saveStatus(1)
                self.uploadAvatar()
                LocationManager.sharedInstance.stopUpdatingLocation()
            case .failure(let error):
                self.hideActivityIndicator()
                self.setupErrorAlert(error: error)
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }
    
    private func uploadAvatar() {
        if let image = avatar {
            AuthService().uploadAvatar(image: image) { result in
                switch result {
                case .success(_):
                    self.emergUpload()
                case .failure(let error):
                    self.hideActivityIndicator()
                    self.setupErrorAlert(error: error)
                }
            }
        }
    }
    
    private func emergUpload() {
        let group = DispatchGroup()
        group.enter()
        CustomerService().addEmergencies(name: self.emergencyName, phoneNumber: self.emergencyPhone)  { result in
        switch result {
        case .success(_):
            group.leave()
        case .failure(let error):
            UIApplication.shared.endIgnoringInteractionEvents()
            self.hideActivityIndicator()
            self.setupErrorAlert(error: error)
        }
        }
        
        if let seconName = self.emergencySecondName, let secondPhone = self.emergencySecondPhone {
            group.enter()
            CustomerService().addEmergencies(name: seconName, phoneNumber: secondPhone) { result in
                group.leave()
            }
        }
        
        if let thirdName = self.emergencyThirdName, let thirdPhone = self.emergencyThirdPhone {
            group.enter()
            CustomerService().addEmergencies(name: thirdName, phoneNumber: thirdPhone) { result in
                group.leave()
            }
        }
        group.notify(queue: .main) {
            
            self.hideActivityIndicator()
            self.toProfile()
        }
    }
    
    private func toProfile() {
        let vc = CustomerDashboardTabBarController()
        UIApplication.shared.endIgnoringInteractionEvents()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func uploadEmergencies(name: String, phoneNumber: String) {
        CustomerService().addEmergencies(name: name, phoneNumber: phoneNumber) { result in
            switch result {
            case .success(let success):
                print(success)  
            case .failure(let error):
                self.hideActivityIndicator()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.setupErrorAlert(error: error)
            }
        }
    }
}

//MARK: - ScrollView

extension RegistrationMainVC {
    @objc func panGestureTouched() {
        scrollView.isScrollEnabled = true
        blackoutView.removeFromSuperview()
        hearAboutListView.removeFromSuperview()
    }
}
extension RegistrationMainVC: GMSAutocompleteFetcherDelegate {
  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
    var resultsStr = NSMutableString()
    for prediction in predictions {
        resultsStr.appendFormat("%@", prediction.attributedFullText)
        print(resultsStr as String)
    }
      print("predictions",predictions)
       if address == "" {
          firstAutoCompletedResponseLabel.isHidden = true
          secondAutoCompletedResponseLabel.isHidden = true
          thirdAutoCompletedResponseLabel.isHidden = true
          fourthAutoCompletedResponseLabel.isHidden = true
          
          locationImageView.isHidden = true
          locationSecondImageView.isHidden = true
          locationThirdImageView.isHidden = true
          locationFourthImageView.isHidden = true
          separatorFirstView.isHidden = true
          separatorSecondView.isHidden = true
          separatorThirdView.isHidden = true
          firstAutoCompletedResponseButton.isHidden = true
          secondAutoCompletedResponseButton.isHidden = true
          thirdAutoCompletedResponseButton.isHidden = true
          fourthAutoCompletedResponseButton.isHidden = true
      } else {
      if predictions.count == 1 {
          firstAutoCompletedResponseLabel.isHidden = false
          secondAutoCompletedResponseLabel.isHidden = true
          thirdAutoCompletedResponseLabel.isHidden = true
          fourthAutoCompletedResponseLabel.isHidden = true
          
          locationImageView.isHidden = false
          locationSecondImageView.isHidden = true
          locationThirdImageView.isHidden = true
          locationFourthImageView.isHidden = true
          separatorFirstView.isHidden = false
          separatorSecondView.isHidden = true
          separatorThirdView.isHidden = true
          firstAutoCompletedResponseButton.isHidden = false
          secondAutoCompletedResponseButton.isHidden = true
          thirdAutoCompletedResponseButton.isHidden = true
          fourthAutoCompletedResponseButton.isHidden = true
          
          firstAutoCompletedResponseLabel.text = predictions[0].attributedFullText.string
         
      } else if predictions.count == 2 {
          firstAutoCompletedResponseLabel.isHidden = false
          secondAutoCompletedResponseLabel.isHidden = false
          thirdAutoCompletedResponseLabel.isHidden = true
          fourthAutoCompletedResponseLabel.isHidden = true
       
          locationImageView.isHidden = false
          locationSecondImageView.isHidden = false
          locationThirdImageView.isHidden = true
          locationFourthImageView.isHidden = true
          separatorFirstView.isHidden = false
          separatorSecondView.isHidden = false
          separatorThirdView.isHidden = true
          firstAutoCompletedResponseButton.isHidden = false
          secondAutoCompletedResponseButton.isHidden = false
          thirdAutoCompletedResponseButton.isHidden = true
          fourthAutoCompletedResponseButton.isHidden = true
          
          firstAutoCompletedResponseLabel.text = predictions[0].attributedFullText.string
          secondAutoCompletedResponseLabel.text = predictions[1].attributedFullText.string
          
      } else if predictions.count == 3 {
          firstAutoCompletedResponseLabel.isHidden = false
          secondAutoCompletedResponseLabel.isHidden = false
          thirdAutoCompletedResponseLabel.isHidden = false
          fourthAutoCompletedResponseLabel.isHidden = true
         
          
          locationImageView.isHidden = false
          locationSecondImageView.isHidden = false
          locationThirdImageView.isHidden = false
          locationFourthImageView.isHidden = true
          separatorFirstView.isHidden = false
          separatorSecondView.isHidden = false
          separatorThirdView.isHidden = false
          firstAutoCompletedResponseButton.isHidden = false
          secondAutoCompletedResponseButton.isHidden = false
          thirdAutoCompletedResponseButton.isHidden = false
          fourthAutoCompletedResponseButton.isHidden = true
          
          firstAutoCompletedResponseLabel.text = predictions[0].attributedFullText.string
          secondAutoCompletedResponseLabel.text = predictions[1].attributedFullText.string
          thirdAutoCompletedResponseLabel.text = predictions[2].attributedFullText.string
          
      } else if predictions.count > 3 {
          firstAutoCompletedResponseLabel.isHidden = false
          secondAutoCompletedResponseLabel.isHidden = false
          thirdAutoCompletedResponseLabel.isHidden = false
          fourthAutoCompletedResponseLabel.isHidden = false
          locationImageView.isHidden = false
          locationSecondImageView.isHidden = false
          locationThirdImageView.isHidden = false
          locationFourthImageView.isHidden = false
          separatorFirstView.isHidden = false
          separatorSecondView.isHidden = false
          separatorThirdView.isHidden = false
          firstAutoCompletedResponseButton.isHidden = false
          secondAutoCompletedResponseButton.isHidden = false
          thirdAutoCompletedResponseButton.isHidden = false
          fourthAutoCompletedResponseButton.isHidden = false
          firstAutoCompletedResponseLabel.text = predictions[0].attributedFullText.string
          secondAutoCompletedResponseLabel.text = predictions[1].attributedFullText.string
          thirdAutoCompletedResponseLabel.text = predictions[2].attributedFullText.string
          fourthAutoCompletedResponseLabel.text = predictions[3].attributedFullText.string
      }
      }
  }

  func didFailAutocompleteWithError(_ error: Error) {
//      resultText?.text = error.localizedDescription
  }
}
