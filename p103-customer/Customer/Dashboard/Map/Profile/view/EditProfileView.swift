//
//  EditProfileView.swift
//  p103-customer
//
//  Created by Daria Pr on 19.05.2021.
//  Copyright © 2021 PULS Software. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import SDWebImage
import Contacts
import GooglePlaces
import ContactsUI

@objc protocol EditProfileDelegate: AnyObject {
    func closeScreen()
    func chooseProfilePhoto()
    func toChangePassword()
    func setup(error: Error)
    func allowContacts()
}

class EditProfileView: UIView, CNContactPickerDelegate {
    
    //MARK: - UIProperties
    
    private let closebutton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.closeTest(), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageView?.clipsToBounds = true
        button.tintColor = .black
        button.addTarget(self, action: #selector(closeButtonTouched), for: .touchUpInside)
        return button
    }()

    private lazy var profileImageButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(profileImageTouched), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    
    private let profileEditImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = R.image.editPhoto()
        return profileImageView
    }()
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        label.text = "Account"
        label.font = R.font.aileronSemiBold(size: 16)
        label.textColor = .color606572
        return label
    }()
    
    private let emailTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Email", iconImage: R.image.email(), type: .usual)
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let changePasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 10
        button.borderColor = .colorC6222F
        button.borderWidth = 1
        button.setTitle("Change Password", for: .normal)
        button.setTitleColor(.colorC6222F, for: .normal)
        button.titleLabel?.font = R.font.aileronRegular(size: 14)
        button.addTarget(self, action: #selector(changeButtonTouched), for: .touchUpInside)
        return button
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
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 1

        return textField
    }()
    private lazy var lastNameTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfieldWithoutIcon(placeholder: "Last Name*")
        textField.addTarget(self, action: #selector(lastNameTextFieldAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 2

        return textField
    }()
    
    private let nameErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Name field should not be empty")
        return l
    } ()
    
    private let lastNameErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Last Name field should not be empty")
        return l
    } ()
    
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
    
    let addContactButton: SecondaryButton = {
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
    
    private let backgroundHomeAddressImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.homeAddressBackground()
        iv.isHidden = true
        return iv
    }()
    
    private lazy var phoneTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Mobile Phone*", iconImage: R.image.phone(), type: .usual)
        textField.keyboardType = .phonePad
        textField.addTarget(self, action: #selector(phoneTextFieldAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 3
        return textField
    }()
    private lazy var workPhoneTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Work Phone ", iconImage: R.image.phone(), type: .usual)
        textField.keyboardType = .phonePad
        textField.addTarget(self, action: #selector(workPhoneTextFieldAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 4
        return textField
    }()
    private lazy var addressTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Home Address*", iconImage: R.image.address(), type: .address)
        textField.addTarget(self, action: #selector(addressTextFieldAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 5

        return textField
    }()
    
    private lazy var cityTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "City*", iconImage: R.image.city(), type: .usual)
        textField.addTarget(self, action: #selector(cityTextFieldAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 6
        return textField
    }()
    private lazy var stateTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "State*", iconImage: R.image.state(), type: .usual)
        textField.addTarget(self, action: #selector(stateTextFieldAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 7
        return textField
    }()
    
    private lazy var billingAddressTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Billing Address*", iconImage: R.image.dollar(), type: .usual)
        textField.addTarget(self, action: #selector(billingTextFieldAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 8
        return textField
    }()
    lazy var sameAsHomeAddressBtn: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .sameAsHomeAddressCheckBox, typeOfCheckbox: .ok, typeOfText: .activeRedDisactiveGray)
        button.delegate = self
        return button
    }()
    
    lazy var emergency1ContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact*", iconImage: R.image.phone(), type: .usual)
        textField.addTarget(self, action: #selector(emergencyFirstPhoneAction(textField:)), for: .editingChanged)
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 10
        textField.delegate = self
        return textField
    }()
    
    lazy var emergency1ContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact Name*", iconImage: R.image.phone(), type: .usual)
        textField.addTarget(self, action: #selector(emergencyFirstNameAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 9
        return textField
    }()
    
    lazy var emergency2ContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #2", iconImage: R.image.phone(), type: .usual)
        textField.isHidden = true
        textField.addTarget(self, action: #selector(emergencySecondPhoneAction(textField:)), for: .editingChanged)
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.tag = 20
        textField.returnKeyType = UIReturnKeyType.next
        return textField
    }()
    
    lazy var emergency2ContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #2 Name", iconImage: R.image.phone(), type: .usual)
        textField.isHidden = true
        textField.addTarget(self, action: #selector(emergencySecondNameAction), for: .editingChanged)
        return textField
    }()
    
    lazy var emergency3ContactTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #3", iconImage: R.image.phone(), type: .usual)
        textField.isHidden = true
        textField.addTarget(self, action: #selector(emergencyThirdPhoneAction(textField:)), for: .editingChanged)
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.tag = 21
        return textField
    }()
    
    let emergency3ContactNameTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Emergency Contact #3 Name", iconImage: R.image.phone(), type: .usual)
        textField.isHidden = true
        textField.addTarget(self, action: #selector(emergencyThirdNameAction), for: .editingChanged)
        return textField
    }()
    
    private lazy var doorCodeTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Lockbox/Door code", iconImage: R.image.doorCode(), type: .usual)
        textField.addTarget(self, action: #selector(doorCodeAction), for: .editingChanged)
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 11
        return textField
    }()
    
    private lazy var locationTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Lockbox Location", iconImage: R.image.location(), type: .usual)
        textField.addTarget(self, action: #selector(locationLockboxAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 12
        return textField
    }()
    
    private lazy var homeAlarmTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Home Alarm System", iconImage: R.image.home(), type: .usual)
        textField.addTarget(self, action: #selector(homeAlarmAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 13
        return textField
    }()
    
    private lazy var otherNotesTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Other Home Access Notes", iconImage: R.image.notes(), type: .usual)
        textField.addTarget(self, action: #selector(otherNotesAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 14
        return textField
    }()
    
    private lazy var mailBoxTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Mail Box", iconImage: R.image.mailbox(), type: .usual)
        textField.addTarget(self, action: #selector(mailBoxAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 15
        return textField
    }()
    
    private lazy var otherRequestTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Other Requests", iconImage: R.image.other(), type: .usual)
        textField.addTarget(self, action: #selector(otherRequestsAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.next
        textField.tag = 16
        return textField
    }()
    
    private let locationHomeAddressImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = R.image.locationImage()
        iv.isHidden = true
        return iv
    }()
    
    private let phoneErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Mobile phone field should not be empty")
        return l
    } ()
    
    private let workPhoneErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Work phone field should not be empty")
        return l
    } ()
    
    private let homeAddressErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Home address field should not be empty")
        return l
    } ()
    
    private let billingAddressErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Billing address field should not be empty")
        return l
    } ()
    
    private let cityErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "City field should not be empty")
        return l
    } ()
    
    private let stateErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "State field should not be empty")
        return l
    } ()
    
    let emergNameErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Emergency Contact Name field should not be empty")
        return l
    } ()
    
    let emerg2NameErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Emergency Contact Name field should not be empty")
        return l
    } ()
    
    let emerg3NameErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Emergency Contact Name field should not be empty")
        return l
    } ()
    
    let emergPhoneErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Emergency Contact field should not be empty")
        return l
    } ()
    
    let emerg2PhoneErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Emergency Contact field should not be empty")
        return l
    } ()
    let emerg3PhoneErrorLabel: ErrorRequiredFieldsView = {
        let l = ErrorRequiredFieldsView()
        l.setup(isHidden: true, text: "Emergency Contact field should not be empty")
        return l
    } ()
    
    private let crossAddContactButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.crossAddContact(), for: .normal)
        b.addTarget(self, action: #selector(hideAdditionalContactsAction), for: .touchUpInside)
        return b
    } ()
    
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
    
    private lazy var mailKeyProvidedView: YesOrNoView = {
        let view = YesOrNoView()
        view.delegate = self
        view.setup(type: .mailKeyProvided)
        return view
    }()
    private lazy var someoneWillBeHomeView: YesOrNoView = {
        let view = YesOrNoView()
        view.delegate = self
        view.setup(type: .someoneWillBeHome)
        return view
    }()
    
    private lazy var turnLightsOnOrOffView: YesOrNoView = {
        let view = YesOrNoView()
        view.delegate = self
        view.setup(type: .turnLightsOnOrOff)
        return view
    }()
    private let waterPlantsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    lazy var waterPlantsButton: ButtonWithTrailingCheckbox = {
        let button = ButtonWithTrailingCheckbox()
        button.setup(component: .waterPlaints, typeOfCheckbox: .ok, typeOfText: .black)
        button.delegate = self
        return button
    }()
    private lazy var addCommentTextField: SkyFloatingLabelTextFieldWithIcon = {
        let textField = SkyFloatingLabelTextField().authTextfield(placeholder: "Add Comment", iconImage: R.image.comment(), type: .usual)
        textField.addTarget(self, action: #selector(addCommentAction), for: .editingChanged)
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    private let garbageView: GarbageView = {
        let v = GarbageView()
        v.setup(userInteraction: true, title: "Garbage")
        return v
    } ()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.cornerRadius = 15
        button.backgroundColor = UIColor(red: 0.666, green: 0.671, blue: 0.683, alpha: 1)
        button.setTitle("Next", for: .normal)
        button.titleLabel?.font = R.font.aileronBold(size: 18)
        button.addTarget(self, action: #selector(doneButtonTouched), for: .touchUpInside)
        button.redAndGrayStyle(active: true)
        return button
    }()
    
    private let autoCompletionView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
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
    
    private let homeAddressButton: UIButton = {
        let b = UIButton()
        b.setImage(R.image.homeAddressButton(), for: .normal)
        b.addTarget(self, action: #selector(homeAddressAsBillingAddressAction), for: .touchUpInside)
        return b
    }()
    
    private let lineUnderAddressView: UIView = {
        let v = UIView()
        v.backgroundColor = R.color.underTextViewLineColor()
        return v
    } ()
    
    private var activityView: UIActivityIndicatorView?
    
    //MARK: - Properties
    var parent: EditProfileViewController?
    private let scrollView = UIScrollView()
    private let mainView = UIView()
    var flag: Bool?
    weak var delegate: EditProfileDelegate?
    var contactStore = CNContactStore()
    private var isValidate: Bool = true
    private var firstName = ""
    private var lastName = ""
    private var phone = ""
    private var workPhone = ""
    private var address = ""
    private var billingAddress = ""
    private var isSameAddress: Bool?
    private var city = ""
    private var state = ""
    private var email = ""
    private var autocompleteAddress = ""
    
    var emergenciesNameFirst = ""
    var emergenciesPhoneFirst = ""
    var emergenciesNameSecond: String?
    var emergenciesPhoneSecond: String?
    var emergenciesNameThird: String?
    var emergenciesPhoneThird: String?
    
    private var lockboxDoorCode: String?
    private var lockboxLocation: String?
    private var homeAlarmSystem: String?
    private var otherHomeAccessNotes: String?
    private var otherRequestsNotes: String?
    private var mailbox: String?
    
    private var isMailKeyProvided: Bool?
    private var isTurnLight: Bool?
    private var isSomeoneAtHome: Bool?
    private var isWaterPlantsExists: Bool?
    private var isSameAsHomeAddress: Bool?
    private var comment: String?
    private var garbageArray: [String]?
    private var homePosition = [HomePosition]()
    private var garbage = Garbage()
    private var avatar: UIImage?
    
    private var emergArr = [EmergenciesGetResponse]()
    
    var fetcher: GMSAutocompleteFetcher?
    
    private var emergencyAmount = 0
    let addContactButtonView = UIView()
    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
      
        setupLayouts()
        setupHomeAddress()
        addTargetsToFields()
        setInfo()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Actions

extension EditProfileView {
    @objc func closeButtonTouched() {
        delegate?.closeScreen()
    }
    
    @objc func profileImageTouched() {
        delegate?.chooseProfilePhoto()
    }
    
    @objc func changeButtonTouched() {
        delegate?.toChangePassword()
    }
    
    @objc func nameTextFieldAction() {
        if let name = nameTextField.text {
            if !name.isValidName {
                doneButton.redAndGrayStyle(active: false)
                nameErrorLabel.setup(isHidden: false, text: "Invalid First Name")
                isValidate = false
            } else {
                nameErrorLabel.setup(isHidden: true, text: "Name field should not be empty")
                doneButton.redAndGrayStyle(active: true)
                isValidate = true
                firstName = name
            }
        }
    }
    
    @objc func lastNameTextFieldAction() {
        if let name = lastNameTextField.text {
            if !name.isValidName {
                doneButton.redAndGrayStyle(active: false)
                lastNameErrorLabel.setup(isHidden: false, text: "Invalid Last Name")
                isValidate = false
            } else {
                lastNameErrorLabel.setup(isHidden: true, text: "Last Name field should not be empty")
                doneButton.redAndGrayStyle(active: true)
                isValidate = true
                lastName = name
            }
        }
    }
    
    @objc func phoneTextFieldAction() {
        if let mobileNumber = phoneTextField.text {
            if mobileNumber.isEmpty {
                doneButton.redAndGrayStyle(active: false)
                phoneErrorLabel.setup(isHidden: false, text: "Mobile phone field should not be empty")
                isValidate = false
            } else {
                if phoneValidation(phone: mobileNumber) == true {
                    doneButton.redAndGrayStyle(active: true)
                    phoneErrorLabel.setup(isHidden: true, text: "Mobile phone field should not be empty")
                    isValidate = true
                    phone = mobileNumber
                } else {
                    doneButton.redAndGrayStyle(active: false)
                    phoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                    isValidate = false
                }
            }
            
            let phone = phoneTextField.text!.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
            if phone.isValidPhone {
                isValidate = true
                phoneErrorLabel.setup(isHidden: true, text: "Mobile phone field should not be empty")
            } else {
                isValidate = false
                phoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
            }
        }
       
       
    }
    
    @objc func workPhoneTextFieldAction() {
        if let phone = workPhoneTextField.text {
            if phone.isEmpty {
                doneButton.redAndGrayStyle(active: true)
                workPhoneErrorLabel.setup(isHidden: true, text: "Work phone field should not be empty")
                isValidate = true
            } else {
                if phoneValidation(phone: phone) == true {
                    doneButton.redAndGrayStyle(active: true)
                    workPhoneErrorLabel.setup(isHidden: true, text: "Work phone field should not be empty")
                    isValidate = true
                    workPhone = phone
                } else {
                    doneButton.redAndGrayStyle(active: false)
                    workPhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                    isValidate = false
                }
            }
            let phone = workPhoneTextField.text!.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
            if !phone.isEmpty {
                if phone.isValidPhone {
                isValidate = true
                workPhoneErrorLabel.setup(isHidden: true, text: "Mobile phone field should not be empty")
            }else {
                isValidate = false
                workPhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
            }
            } else {
                isValidate = true
                workPhoneErrorLabel.setup(isHidden: true, text: "Mobile phone field should not be empty")
            }
        }
   
    }
    
    @objc func addressTextFieldAction() {
        lineUnderAddressView.backgroundColor = .colorC6222F

        if let ph = addressTextField.text {
            if ph.isEmpty {
                address = ph
                autocompleteAddress = ""
                homeAddressErrorLabel.setup(isHidden: false, text: "Home address field should not be empty")
            } else {
                address = ph
                homeAddressErrorLabel.setup(isHidden: true, text: "Home address field should not be empty")
            }
        }
    }
    
    @objc func billingTextFieldAction() {
        if let address = billingAddressTextField.text {
            if isSameAsHomeAddress! {
                billingAddressTextField.isUserInteractionEnabled = false
                isValidate = true
            } else {
                if address.isEmpty {
                    billingAddressErrorLabel.isHidden = false
                    doneButton.redAndGrayStyle(active: false)
                    billingAddressErrorLabel.setup(isHidden: false, text: "Billing address field should not be empty")
                    isValidate = false
                } else {
                    doneButton.redAndGrayStyle(active: true)
                    billingAddressErrorLabel.setup(isHidden: true, text: "Billing address field should not be empty")
                    isValidate = true
                    billingAddress = address
                }
            }
            
        }
    }
    
    @objc func cityTextFieldAction() {
        if let address = cityTextField.text {
            if address.isEmpty {
                doneButton.redAndGrayStyle(active: false)
                cityErrorLabel.setup(isHidden: false, text: "City field should not be empty")
                isValidate = false
            } else {
                if address.isValidName == true {
                doneButton.redAndGrayStyle(active: true)
                cityErrorLabel.setup(isHidden: true, text: "City field should not be empty")
                isValidate = true
                city = address
                } else {
                    doneButton.redAndGrayStyle(active: false)
                    cityErrorLabel.setup(isHidden: false, text: "Invalid City Name")
                    isValidate = false
                }
        }
    }
    }
    
    @objc func stateTextFieldAction() {
        if let address = stateTextField.text {
            if address.isEmpty {
                doneButton.redAndGrayStyle(active: false)
                stateErrorLabel.setup(isHidden: false, text: "State field should not be empty")
                isValidate = false
            } else {
                if address.isValidName == true {
                    doneButton.redAndGrayStyle(active: true)
                    stateErrorLabel.setup(isHidden: true, text: "State field should not be empty")
                    isValidate = true
                    state = address
                } else {
                    doneButton.redAndGrayStyle(active: false)
                    cityErrorLabel.setup(isHidden: false, text: "Invalid State Name")
                    isValidate = false
                }
            }
        }
    }
    
    @objc func addressTextFieldDidEndEditing() {
        addressTextField.lineColor = .white
        
        if autocompleteAddress.isEmpty {
            lineUnderAddressView.backgroundColor = R.color.underTextViewLineColor()
            homeAddressErrorLabel.setup(isHidden: false, text: "Home address must be selected from the dropdown list")
            doneButton.redAndGrayStyle(active: false)
            isValidate = false
        } else {
            doneButton.redAndGrayStyle(active: true)
            lineUnderAddressView.backgroundColor = .colorC6222F
            homeAddressErrorLabel.setup(isHidden: true, text: "Home address field should not be empty")
            isValidate = true
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
    
    @objc func hideAdditionalContactsAction() {
        
        if !emergency3ContactTextField.isHidden {
            emergency3ContactTextField.isHidden = true
            emergency3ContactNameTextField.isHidden = true
            addContactButton.redAndGrayStyleAdditional(active: true)
            addContactButton.isHidden = false
            addContactButtonView.isHidden = false
            emerg3PhoneErrorLabel.isHidden = true
            
            emergenciesNameThird = ""
            emergenciesPhoneThird = ""
            emergency3ContactTextField.text = ""
            emergency3ContactNameTextField.text = ""
            
            if emergArr.count == 3 {
                deleteEmergency(id: emergArr[0].items[2].id)
            }
            return
        }
        if !emergency2ContactTextField.isHidden {
            emergency2ContactTextField.isHidden = true
            emergency2ContactNameTextField.isHidden = true
            emerg2PhoneErrorLabel.isHidden = true
            addContactButton.redAndGrayStyleAdditional(active: true)
            crossAddContactButton.removeFromSuperview()
            addContactButton.isHidden = false
            addContactButtonView.isHidden = false
            emergency2ContactTextField.text = ""
            emergency2ContactNameTextField.text = ""
            emergenciesNameSecond = ""
            emergenciesPhoneSecond = ""
            
            if emergArr.count == 2 {
                deleteEmergency(id: emergArr[0].items[1].id)
            }
            return
        }
    }
    
    @objc func emergencyFirstPhoneAction(textField: UITextField) {
//        if let phone = emergency1ContactTextField.text {
//            if phone.isEmpty {
//                emergNameErrorLabel.setup(isHidden: false, text: "Contact field should not be empty")
//                emergenciesPhoneFirst = phone
//            } else {
//                if emergencyPhoneValidation(phone: phone) ==  true {
//                    emergNameErrorLabel.setup(isHidden: true, text: "Contact field should not be empty")
//                    emergenciesPhoneFirst = phone
//                } else {
//                    emergNameErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
//                    emergenciesPhoneFirst = phone
//                }
//            }
//        }
        var text = textField.text
        text = text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")

        if text!.count <= Constant.USMobileNumberLimit {
            textField.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            print(text!.count)
            
        } else if text!.count > Constant.USMobileNumberLimit {
            textField.text = text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            print(text!.count)

        }
    
        if text!.isEmpty {
            emergPhoneErrorLabel.setup(isHidden: false, text: "Contact field should not be empty")
            emergenciesPhoneFirst = text!
        } else {
            if emergencyPhoneValidation(phone: text!) ==  true {
                emergPhoneErrorLabel.setup(isHidden: true, text: "Contact field should not be empty")
                emergenciesPhoneFirst = text!
            } else {
                emergPhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                emergenciesPhoneFirst = text!
            }
        }
        emergenciesPhoneFirst = text!
        print("Emergency First Number", emergenciesPhoneFirst)
    }
    
    @objc func emergencyFirstNameAction() {
        if let name = emergency1ContactNameTextField.text {
            if name.isEmpty {
                emergNameErrorLabel.setup(isHidden: false, text: "Contact field should not be empty")
                emergenciesNameFirst = name
            } else {
                if name.isValidName {
                    emergNameErrorLabel.setup(isHidden: true, text: "Contact field should not be empty")
                    emergenciesNameFirst = name
                } else {
                    emergNameErrorLabel.setup(isHidden: false, text: "Invalid Name")
                    emergenciesNameFirst = name
                }
            }
        }
    }
    
    @objc func emergencySecondPhoneAction(textField: UITextField) {
//        if let phone = emergency2ContactTextField.text {
//            if emergencyPhoneValidation(phone: phone) ==  true {
//                emerg2PhoneErrorLabel.isHidden = true
//                emerg2PhoneErrorLabel.setup(isHidden: true, text: "Contact field should not be empty")
//                emergenciesPhoneSecond = phone
//            } else {
//                emerg2PhoneErrorLabel.isHidden = false
//                emerg2PhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
//                emergenciesPhoneSecond = phone
//            }
//            emergenciesPhoneSecond = phone
//        }
//        emergenciesPhoneSecond = emergenciesPhoneSecond!.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
//        if emergenciesPhoneSecond!.isEmergencyValidPhone {
//            emerg2PhoneErrorLabel.setup(isHidden: true, text: "Contact field should not be empty")
//            checkStateOfDoneButton()
////            doneButton.redAndGrayStyle(active: true)
//        } else {
//            emerg2PhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
//            doneButton.redAndGrayStyle(active: false)
//
//        }
        var text = textField.text
        text = text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")

        if text!.count <= Constant.USMobileNumberLimit {
            textField.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            print(text!.count)
        } else if text!.count > Constant.USMobileNumberLimit {
            textField.text = text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            print(text!.count)
        }
    
        if text!.isEmpty {
            emerg2PhoneErrorLabel.setup(isHidden: false, text: "Contact field should not be empty")
            emergenciesPhoneSecond = text!
        } else {
            if emergencyPhoneValidation(phone: text!) ==  true {
                emerg2PhoneErrorLabel.setup(isHidden: true, text: "Contact field should not be empty")
                emergenciesPhoneSecond = text!
            } else {
                emerg2PhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                emergenciesPhoneSecond = text!
            }
        }
        emergenciesPhoneSecond = text!
//        print("Emergency Second Number", emergenciesPhoneSecond)
    }
    
    @objc func emergencySecondNameAction() {
        if let name = emergency2ContactNameTextField.text {
            emergenciesNameSecond = name
        }
    }
    
    @objc func emergencyThirdPhoneAction(textField: UITextField) {
//        if let phone = emergency3ContactTextField.text {
//            if phoneValidation(phone: phone) ==  true {
//                emerg3PhoneErrorLabel.isHidden = true
//                emerg3PhoneErrorLabel.setup(isHidden: true, text: "Contact field should not be empty")
//                emergenciesPhoneThird = phone
//            } else {
//                emerg3PhoneErrorLabel.isHidden = false
//                emerg3PhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
//                emergenciesPhoneThird = phone
//            }
//
//        }
//        emergenciesPhoneThird = emergenciesPhoneThird?.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#")
//        if emergenciesPhoneThird!.isEmergencyValidPhone {
//            emerg3PhoneErrorLabel.setup(isHidden: true, text: "Contact field should not be empty")
//            checkStateOfDoneButton()
//        } else {
//            emerg3PhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
//            doneButton.redAndGrayStyle(active: false)
//        }
        var text = textField.text
        text = text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")

        if text!.count <= Constant.USMobileNumberLimit {
            textField.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            print(text!.count)
            
        } else if text!.count > Constant.USMobileNumberLimit {
            textField.text = text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            print(text!.count)

        }
    
        if text!.isEmpty {
            emerg3PhoneErrorLabel.setup(isHidden: false, text: "Contact field should not be empty")
            emergenciesPhoneThird = text!
        } else {
            if emergencyPhoneValidation(phone: text!) ==  true {
                emerg3PhoneErrorLabel.setup(isHidden: true, text: "Contact field should not be empty")
                emergenciesPhoneThird = text!
            } else {
                emerg3PhoneErrorLabel.setup(isHidden: false, text: "Invalid Phone Number")
                emergenciesPhoneThird = text!
            }
        }
        emergenciesPhoneThird = text!
//        print("Emergency Third Number", emergenciesPhoneThird)
    }
    
    @objc func emergencyThirdNameAction() {
        if let name = emergency3ContactNameTextField.text {
            emergenciesNameThird = name
        }
    }
    
    @objc func doorCodeAction() {
        if let doorCode = doorCodeTextField.text {
            lockboxDoorCode = doorCode
        }
    }
    
    @objc func locationLockboxAction() {
        if let location = locationTextField.text {
            lockboxLocation = location
        }
    }
    
    @objc func homeAlarmAction() {
        if let alarm = homeAlarmTextField.text {
            homeAlarmSystem = alarm
        }
    }
    
    @objc func otherNotesAction() {
        if let other = otherNotesTextField.text {
            otherHomeAccessNotes = other
        }
    }

    @objc func mailBoxAction() {
        if let mail = mailBoxTextField.text {
            mailbox = mail
        }
    }
    
    @objc func otherRequestsAction() {
        if let requests = otherRequestTextField.text {
            otherRequestsNotes = requests
        }
    }
    
    @objc func addCommentAction() {
        if let commentAdd = addCommentTextField.text {
            comment = commentAdd
        }
    }
    
    @objc func useHomeAddressAction() {
        backgroundHomeAddressImageView.isHidden = true
        locationHomeAddressImageView.isHidden = true
        useHomeAddressButton.isHidden = true
        billingAddressTextField.isHidden = false
        
        billingAddressTextField.text = autocompleteAddress
        billingAddress = autocompleteAddress
        checkStateOfDoneButton()
    }
    
    @objc func addContactButtonTouched() {
        addSubview(crossAddContactButton)
        
        crossAddContactButton.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.equalTo(emergency2ContactNameTextField.snp.top).offset(10)
            $0.right.equalTo(emergency2ContactNameTextField.snp.right).offset(-5)
        }
//        delegate?.allowContacts()
        CNContactStore().requestAccess(for: .contacts) { (access, error) in
            if access {
                self.delegate?.allowContacts()
            } else {
                print("Not Allowed")
            }
        }
        if emergency2ContactTextField.isHidden || emergency2ContactNameTextField.isHidden || emergency3ContactTextField.isHidden || emergency3ContactNameTextField.isHidden {
            if emergency1ContactNameTextField.text!.isEmpty || emergency1ContactTextField.text!.isEmpty {
                emergPhoneErrorLabel.setup(isHidden: true, text: "")
                crossAddContactButton.isHidden = true
            }else {
                crossAddContactButton.isHidden = false
                if emergency2ContactTextField.isHidden {
                    emergency2ContactTextField.isHidden = false
                    emergency2ContactNameTextField.isHidden = false
                    return
                }
                if emergency3ContactTextField.isHidden {
                    emergency3ContactTextField.isHidden = false
                    emergency3ContactNameTextField.isHidden = false
                    addContactButtonView.isHidden = true
                    addContactButton.isHidden = true
                    return
                }
            }
        }
//        if emergency1ContactNameTextField.text!.isEmpty || emergency1ContactTextField.text!.isEmpty {
//
//                emergency2ContactTextField.isHidden = true
//                emergency2ContactNameTextField.isHidden = true
//                return
//
//        } else {
//        if emergency2ContactTextField.isHidden {
//            emergency2ContactTextField.isHidden = false
//            emergency2ContactNameTextField.isHidden = false
//            return
//        }
//
//        if emergency3ContactTextField.isHidden {
//            emergency3ContactTextField.isHidden = false
//            emergency3ContactNameTextField.isHidden = false
//            addContactButtonView.isHidden = true
//            addContactButton.isHidden = true
//            return
//        }
//        }
    }
    
    @objc func homeAddressAsBillingAddressAction() {
        if backgroundHomeAddressImageView.isHidden {
            backgroundHomeAddressImageView.isHidden = false
            locationHomeAddressImageView.isHidden = false
            useHomeAddressButton.isHidden = true
            billingAddressTextField.isHidden = true
        } else {
            backgroundHomeAddressImageView.isHidden = true
            locationHomeAddressImageView.isHidden = true
            useHomeAddressButton.isHidden = true
            billingAddressTextField.isHidden = false
        }
    }
    
    @objc func checkStateOfField(field: SkyFloatingLabelTextFieldWithIcon) {
        if field.text?.isEmpty ?? true {
            field.style(active: false)
        } else {
            field.style(active: true)
        }
        checkStateOfDoneButton()
        if field == addressTextField {
            setupAutoCompleteView()
            if let address = field.text {
                if address != "" {
                    autoCompletionView.isHidden = false
                    let request = replaceWhiteSpacesToUnderscore(request: address)
                    autocompleteLocation(text: request)
                } else{
                    autoCompletionView.isHidden = true
                }
            }
        }
    }
    
    @objc func doneButtonTouched() {
        if isValidate {
            editProfile()
        }
        
    }
}

//MARK: - UITextfield Delegate
extension EditProfileView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 8 {
            if isSameAsHomeAddress! {
                textField.isUserInteractionEnabled = false
            } else {
                textField.isUserInteractionEnabled = true
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newString: NSString?
        let maxLength = 14
        if textField.tag == 3 || textField.tag == 4 {
       
        let currentString: NSString = (textField.text ?? "") as NSString
        newString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            let text = textField.text
            textField.text = text?.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")

            return newString!.length <= maxLength
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
   
}

//MARK: - Autocomplete setup

private extension EditProfileView {
    func replaceWhiteSpacesToUnderscore(request: String) -> String {
        return request.replacingOccurrences(of: " ", with: "_")
    }
    
    func autocompleteLocation(text: String) {
//        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(text)&types=address&key=AIzaSyCF5o-OpGaujspYn-1LyxCCCgzM0_16Ks8"
//        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(text)&types=address&key=AIzaSyDnBiLphfhh8LzSPg6U79dWF616u8AOcuY"
//
////        let urlString = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(text)&types=address&key=AIzaSyBvRUScTY2ykA_8mYomxHNZ79gYiJUwe0U"
//
//        AF.request(urlString, method: .get, headers: nil)
//            .validate()
//            .responseJSON { (response) in
//                print("Response of Google",response)
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
//                    self.delegate?.setup(error: error)
//                }
//            }
        let filter = GMSAutocompleteFilter()
      
        // Create a new session token.
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
}

//MARK: - Network

private extension EditProfileView {

    func editProfile() {
        showActivityIndicator()
        if let image = avatar {
            AuthService().uploadAvatar(image: image) { result in
                switch result {
                case .success(_):
                    self.editAccount()
                case .failure(let error):
                    self.hideActivityIndicator()
                    self.delegate?.setup(error: error)
                }
            }
        } else {
            editAccount()
        }
        
    }
    
    func editAccount() {
        let currentLocation = ["lat": LocationManager.sharedInstance.lastKnownLatitude, "long": LocationManager.sharedInstance.lastKnownLongitude]
        garbageArray = garbageView.fillArrayWithAnswers()
        let hearAboutUs = UserDefaults.standard.string(forKey: "hearAboutUs") ?? ""
        print(hearAboutUs)
        let status = DBManager.shared.getStatus()
        
        let blank = ProfileStruct(firstName: firstName, lastName: lastName, phone: phone, workPhone: workPhone, address: autocompleteAddress, billingAddress: billingAddress, isSameAddress: isSameAddress, city: city, state: state, homePosition: currentLocation, lockboxDoorCode: lockboxDoorCode, lockboxLocation: lockboxLocation, homeAlarmSystem: homeAlarmSystem, otherHomeAccessNotes: otherHomeAccessNotes, mailBox: mailbox, otherRequestsNotes: otherRequestsNotes, isMailKeyProvided: isMailKeyProvided, isTurnLight: isTurnLight, isSomeoneAtHome: isSomeoneAtHome, isWaterPlantsExists: isWaterPlantsExists, hearAboutUs: "other", comment: comment, garbage: garbageArray, status:status)
        
        CustomerService().editCustomerAccount(blank: blank) { result in
            switch result {
            case .success(_):
                self.emergUpload()
                self.hideActivityIndicator()
            case .failure(let error):
                self.hideActivityIndicator()
                self.delegate?.setup(error: error)
            }
        }
    }
    
    func uploadAvatar() {
        if let image = avatar {
            AuthService().uploadAvatar(image: image) { result in
                switch result {
                case .success(let success):
                    print(success)
                case .failure(let error):
                    self.hideActivityIndicator()
                    self.delegate?.setup(error: error)
                }
            }
        }
    }
    
    func emergUpload() {
        
        uploadEmergencies(name: emergenciesNameFirst, phone: emergenciesPhoneFirst)
        if let secondName = emergenciesNameSecond, let secondPhone = emergenciesPhoneSecond {
            uploadEmergencies(name: secondName, phone: secondPhone)
        }
        if let thirdName = emergenciesNameThird, let thirdPhone = emergenciesPhoneThird {
            uploadEmergencies(name: thirdName, phone: thirdPhone)
        }
        self.lineUnderAddressView.isHidden = true
        self.homeAddressButton.isHidden = true
        crossAddContactButton.isHidden = true
        self.hideActivityIndicator()
        self.delegate?.closeScreen()
        
    }
    
    func uploadEmergencies(name: String, phone: String) {
        
        CustomerService().addEmergencies(name: name, phoneNumber: phone) { result in
            
            switch result {
            case .success(let success):
                print(success)
            case .failure(let error):
                self.hideActivityIndicator()
                self.delegate?.setup(error: error)
            }
        }
    }
    
    func setInfo() {
        CustomerService().getCurrentCustomer { result in
            switch result {
            case .success(let userData):
                let profile = userData
                self.setupView(profile: profile)
            case .failure(let error):
                self.hideActivityIndicator()
                self.delegate?.setup(error: error)
            }
        }
        
        CustomerService().getEmergencies { result in
            switch result {
            case .success(let emergency):
                self.emergArr.append(emergency)
                self.setupEmergences(emergency: emergency)
            case .failure(let error):
                self.delegate?.setup(error: error)
            }
        }
    }
    
    func deleteEmergency(id: String) {
        showActivityIndicator()
        CustomerService().deleteEmergencies(id: id) { result in
            switch result {
            case .success(_):
                self.hideActivityIndicator()
            case .failure(let error):
                self.delegate?.setup(error: error)
                self.hideActivityIndicator()
            }
        }
    }
}

//MARK: - Public funcs

extension EditProfileView {
    func setupProfile(image: UIImage) {
        profileImageView.image = image
        avatar = image
    }
}

//MARK: - Setup Data for request
 extension EditProfileView {
    func checkStateOfDoneButton() {
        
        if let email = emailTextField.text, !email.isEmpty, let name = nameTextField.text, !name.isEmpty, let lastName = lastNameTextField.text, !lastName.isEmpty, /*let workPhon = workPhoneTextField.text, !workPhone.isEmpty,*/ let mobilePhone = phoneTextField.text, !mobilePhone.isEmpty, let homeAddress = addressTextField.text, !homeAddress.isEmpty, let billingAddress = billingAddressTextField.text, !billingAddress.isEmpty, let city = cityTextField.text, !city.isEmpty, let state = stateTextField.text, !state.isEmpty {
            phone = (phoneTextField.text?.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#"))!
            workPhone = (workPhoneTextField.text?.applyPatternOnNumbers(pattern: "##########", replacementCharacter: "#"))!
            emergenciesPhoneFirst = (emergency1ContactTextField.text?.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#"))!
            if !workPhone.isEmpty {
                if name.isValidName, workPhone.isValidPhone,lastName.isValidName, phone.isValidPhone, workPhone.isValidPhone {
                    doneButton.redAndGrayStyle(active: true)
                    isValidate = true
                } else {
                    isValidate = false
                    doneButton.redAndGrayStyle(active: false)
                }
            } else {
                if name.isValidName, lastName.isValidName, phone.isValidPhone {
                    doneButton.redAndGrayStyle(active: true)
                    isValidate = true
                } else {
                    doneButton.redAndGrayStyle(active: false)
                    isValidate = false
                }
            }
        }
    }
    
    func addTargetsToFields() {
        let massOfField = [nameTextField, lastNameTextField, emailTextField, phoneTextField, workPhoneTextField, addressTextField, billingAddressTextField, cityTextField, stateTextField]

        for field in massOfField {
            field.addTarget(self, action: #selector(checkStateOfField), for: .editingChanged)
        }
        
        addressTextField.addTarget(self, action: #selector(addressTextFieldDidEndEditing), for: .editingDidEnd)
    }
}

//MARK: - Setup Layout

private extension EditProfileView {
    func setupLayouts() {
        setupScrollViewLayouts()
        setupTopPart()
        setupMainStackView()
        setupBottomStackView()
        setupGarbage()
    }
    
    func setupScrollViewLayouts() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(mainView)
        mainView.backgroundColor = .white
        mainView.snp.makeConstraints {
            $0.top.bottom.equalTo(self.scrollView.contentLayoutGuide)
            $0.left.right.equalTo(self.scrollView.contentLayoutGuide)
            $0.width.equalTo(self.scrollView.frameLayoutGuide)
        }
        activityView?.stopAnimating()
    }
    
    func setupTopPart() {

        mainView.addSubviews([profileImageView, profileEditImageView,profileImageButton, accountLabel, nameStackView, emailTextField, changePasswordButton, nameErrorLabel, lastNameErrorLabel])

        profileImageView.snp.makeConstraints {
            $0.size.equalTo(55)
            $0.top.equalToSuperview().offset(30)
            $0.leading.equalToSuperview().inset(25)
        }
        profileEditImageView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerX.equalTo(profileImageView.snp.trailing).inset(5)
            $0.centerY.equalTo(profileImageView.snp.bottom).inset(5)
        }
        profileImageButton.snp.makeConstraints {
            $0.edges.equalTo(profileImageView)
        }
        nameStackView.addArrangedSubviews(views: nameTextField, lastNameTextField)
        nameStackView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        nameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        lastNameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(lastNameTextField.snp.bottom).offset(3)
            $0.left.equalTo(lastNameTextField)
        }
        accountLabel.snp.makeConstraints {
            $0.top.equalTo(nameStackView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(25)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(accountLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        changePasswordButton.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(30)
        }
    }
    
    func setupMainStackView() {
        mainView.addSubview(mainStackView)
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
        mainStackView.addArrangedSubviews(views: phoneTextField, workPhoneTextField, addressTextField,backgroundHomeAddressImageView, cityTextField, stateTextField,billingStackView, emergency1ContactNameTextField, emergency1ContactTextField, emergency2ContactNameTextField, emergency2ContactTextField, emergency3ContactNameTextField, emergency3ContactTextField, addContactButtonView, doorCodeTextField, locationTextField, homeAlarmTextField, otherNotesTextField, mailBoxTextField, otherRequestTextField)
        
        addSubview(crossAddContactButton)
        crossAddContactButton.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.top.equalTo(emergency2ContactNameTextField.snp.top).offset(10)
            $0.right.equalTo(emergency2ContactNameTextField.snp.right).offset(-5)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(changePasswordButton.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
        
        addSubviews([locationHomeAddressImageView, phoneErrorLabel, workPhoneErrorLabel, homeAddressErrorLabel, billingAddressErrorLabel, cityErrorLabel, stateErrorLabel, lineUnderAddressView, emergNameErrorLabel, emergPhoneErrorLabel,emerg2NameErrorLabel,emerg2PhoneErrorLabel,emerg3NameErrorLabel,emerg3PhoneErrorLabel])
        
        lineUnderAddressView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(25)
            $0.right.equalToSuperview().offset(-25)
            $0.top.equalTo(addressTextField.snp.bottom).offset(-2)
            $0.height.equalTo(2)
        }
        
        phoneErrorLabel.snp.makeConstraints {
            $0.top.equalTo(phoneTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        workPhoneErrorLabel.snp.makeConstraints {
            $0.top.equalTo(workPhoneTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        homeAddressErrorLabel.snp.makeConstraints {
            $0.top.equalTo(addressTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        billingAddressErrorLabel.snp.makeConstraints {
            $0.top.equalTo(sameAsHomeAddressBtn.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        emergNameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(emergency1ContactNameTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        emergPhoneErrorLabel.snp.makeConstraints {
            $0.top.equalTo(emergency1ContactTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        emerg2NameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(emergency2ContactNameTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        emerg2PhoneErrorLabel.snp.makeConstraints {
            $0.top.equalTo(emergency2ContactTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        emerg3NameErrorLabel.snp.makeConstraints {
            $0.top.equalTo(emergency3ContactNameTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        emerg3PhoneErrorLabel.snp.makeConstraints {
            $0.top.equalTo(emergency3ContactTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        cityErrorLabel.snp.makeConstraints {
            $0.top.equalTo(cityTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        stateErrorLabel.snp.makeConstraints {
            $0.top.equalTo(stateTextField.snp.bottom).offset(3)
            $0.left.equalToSuperview().offset(25)
        }
        
        locationHomeAddressImageView.snp.makeConstraints {
            $0.width.equalTo(12)
            $0.height.equalTo(14)
            $0.top.equalTo(backgroundHomeAddressImageView.snp.top).offset(17.5)
            $0.left.equalTo(backgroundHomeAddressImageView.snp.left).offset(20)
        }

    }
    
    func setupBottomStackView() {
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
        waterPlantsStackView.addArrangedSubviews(views: waterPlantsButton, addCommentTextField)
        waterPlantsStackView.snp.makeConstraints {
            $0.top.equalTo(someoneWillBeHomeView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(25)
        }
    }
    
    func setupGarbage() {
        mainView.addSubviews([garbageView, doneButton])
        
        garbageView.snp.makeConstraints {
            $0.top.equalTo(waterPlantsStackView.snp.bottom).offset(20)
            $0.height.equalTo(300)
            $0.left.right.equalToSuperview()
        }
        doneButton.snp.makeConstraints {
            $0.top.equalTo(garbageView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(40)
            $0.bottom.equalToSuperview().inset(80)
        }
    }
    
    func setupHomeAddress() {
        addSubview(homeAddressButton)
    
        addressTextField.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-28)
        }
    }
    
    func setupAutoCompleteView() {
        addSubviews([autoCompletionView, firstAutoCompletedResponseLabel, secondAutoCompletedResponseLabel, locationImageView, separatorFirstView, locationSecondImageView, separatorSecondView, separatorThirdView, locationThirdImageView, locationFourthImageView, thirdAutoCompletedResponseLabel, fourthAutoCompletedResponseLabel, firstAutoCompletedResponseButton, secondAutoCompletedResponseButton, thirdAutoCompletedResponseButton, fourthAutoCompletedResponseButton])

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
    func setupEmergences(emergency: EmergenciesGetResponse) {
        
        if emergency.items.count == 1 {
            emergency1ContactNameTextField.text = emergency.items[0].name
            emergenciesNameFirst = emergency.items[0].name
            if emergency.items[0].phoneNumber.count == 10 {
                emergency1ContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            }else {
                emergency1ContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
            addContactButton.isHidden = false
            crossAddContactButton.isHidden = true
            emergenciesPhoneFirst = emergency.items[0].phoneNumber
            
        } else if emergency.items.count == 2 {
            emergency2ContactTextField.isHidden = false
            emergency2ContactNameTextField.isHidden = false
            emergency2ContactNameTextField.text = emergency.items[1].name
            emergenciesNameSecond = emergency.items[1].name
            emergenciesPhoneSecond = emergency.items[1].phoneNumber
            
            emergency1ContactNameTextField.text = emergency.items[0].name
            emergenciesNameFirst = emergency.items[0].name
            if emergency.items[0].phoneNumber.count == 10 {
                emergency1ContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            }else {
                emergency1ContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
            if emergency.items[1].phoneNumber.count == 10 {
                emergency2ContactTextField.text = emergency.items[1].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            }else {
                emergency2ContactTextField.text = emergency.items[1].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
            addContactButton.isHidden = false
            crossAddContactButton.isHidden = false
            emergenciesPhoneFirst = emergency.items[0].phoneNumber
        } else if emergency.items.count == 3 {
            emergency1ContactNameTextField.text = emergency.items[0].name
            emergenciesNameFirst = emergency.items[0].name
            self.emergenciesPhoneFirst = emergency.items[0].phoneNumber
            
            emergency2ContactTextField.isHidden = false
            emergency2ContactNameTextField.isHidden = false
            emergency2ContactNameTextField.text = emergency.items[1].name
            emergenciesNameSecond = emergency.items[1].name
            emergenciesPhoneSecond = emergency.items[1].phoneNumber
            
            emergenciesNameThird = emergency.items[2].name
            emergenciesPhoneThird = emergency.items[2].phoneNumber

            emergency3ContactTextField.isHidden = false
            emergency3ContactNameTextField.isHidden = false
            emergency3ContactNameTextField.text = emergency.items[2].name
            addContactButton.isHidden = true
            crossAddContactButton.isHidden = false
            doorCodeTextField.snp.remakeConstraints {
                $0.top.equalTo(emergency3ContactTextField.snp.bottom).offset(20)
            }
            
            if emergency.items[0].phoneNumber.count == 10 {
                emergency1ContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            }else {
                emergency1ContactTextField.text = emergency.items[0].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
            if emergency.items[1].phoneNumber.count == 10 {
                emergency2ContactTextField.text = emergency.items[1].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            }else {
                emergency2ContactTextField.text = emergency.items[1].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
            if emergency.items[2].phoneNumber.count == 10 {
                emergency3ContactTextField.text = emergency.items[2].phoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
            }else {
                emergency3ContactTextField.text = emergency.items[2].phoneNumber.applyPatternOnNumbers(pattern: "#############", replacementCharacter: "#")
            }
        }
    }
    
    func setupView(profile: CustomerStruct) {
        self.profileImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        if let img = profile.img {
            self.profileImageView.sd_setImage(with: URL(string: img), placeholderImage: nil, options: SDWebImageOptions.lowPriority, context: nil)
        } else {
            self.profileImageView.image = R.image.profile_test()
        }
        firstName = profile.firstName
        nameTextField.text = profile.firstName
        lastName = profile.lastName
        lastNameTextField.text = profile.lastName
        email = profile.email
        emailTextField.text = profile.email
        phone = profile.phone
        phoneTextField.text = profile.phone.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        workPhone = profile.workPhoneNumber
        workPhoneTextField.text = profile.workPhoneNumber.applyPatternOnNumbers(pattern: "(###) ###-####", replacementCharacter: "#")
        address = profile.address
        autocompleteAddress = profile.address
        addressTextField.text = profile.address
        billingAddress = profile.billingAddress
        billingAddressTextField.text = profile.billingAddress
        city = profile.city
        cityTextField.text = profile.city
        state = profile.state
        stateTextField.text = profile.state
        if profile.address == profile.billingAddress {
            sameAsHomeAddressBtn.vkl()
            isSameAsHomeAddress = true
            billingAddressTextField.isUserInteractionEnabled = true
        } else {
            sameAsHomeAddressBtn.vukl()
            isSameAsHomeAddress = false
            billingAddressTextField.isUserInteractionEnabled = false
        }
        doorCodeTextField.text = profile.lockboxDoorCode
        lockboxDoorCode = profile.lockboxDoorCode
        locationTextField.text = profile.lockboxLocation
        lockboxLocation = profile.lockboxLocation
        homeAlarmTextField.text = profile.homeAlarmSystem
        homeAlarmSystem = profile.homeAlarmSystem
        otherNotesTextField.text = profile.otherHomeAccessNotes
        otherHomeAccessNotes = profile.otherHomeAccessNotes
        mailBoxTextField.text = profile.mailBox
        mailbox = profile.mailBox
        otherRequestTextField.text = profile.otherRequestsNotes
        otherRequestsNotes = profile.otherRequestsNotes
        
        if let isMailKey = profile.isMailKeyProvided {
            mailKeyProvidedView.setValue(isMailKey)
            isMailKeyProvided = profile.isMailKeyProvided
        }
        if let isLight = profile.isTurnLight {
            turnLightsOnOrOffView.setValue(isLight)
            isTurnLight = profile.isTurnLight
        }
        if let isHome = profile.isSomeoneAtHome {
            someoneWillBeHomeView.setValue(isHome)
            isSomeoneAtHome = profile.isSomeoneAtHome
        }
        if let water = profile.isWaterPlantsExists {
            if water {
                waterPlantsButton.vkl()
            } else {
                waterPlantsButton.vukl()
            }
            isWaterPlantsExists = water
        }
        addCommentTextField.text = profile.comment
        comment = profile.comment
        if let garbageArr = profile.garbage {
            garbageView.setupProfileView(garbageArr: garbageArr)
            garbageArray = garbageArr
        }
    }
}

// MARK: - YesOrNoViewDelegate

extension EditProfileView: YesOrNoViewDelegate {
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
        checkStateOfDoneButton()
    } }

// MARK: - ButtonWithTrailingCheckboxDelegate

extension EditProfileView: ButtonWithTrailingCheckboxDelegate {
    
    func buttonTapped(questions: ButtonWithTrailingCheckboxComponents, answer: Bool) {
            switch questions {
        case .sameAsHomeAddressCheckBox:
           isSameAsHomeAddress = answer
            if isSameAsHomeAddress == true {
                billingAddressTextField.text = ""
                billingAddressTextField.text = addressTextField.text
                billingAddressTextField.isUserInteractionEnabled = false
                billingAddress = billingAddressTextField.text!
                isSameAddress = true
                billingAddressErrorLabel.isHidden = true
            } else {
                billingAddressTextField.isUserInteractionEnabled = true
                billingAddress = billingAddressTextField.text!
                isSameAddress = false
            }
        case .waterPlaints:
            isWaterPlantsExists = answer
        case .monday:
            garbage.toMonday = answer
        case .tuesday:
            garbage.toTuesday = answer
        case .wednesday:
            garbage.toWednesday = answer
        case .thursday:
            garbage.toThursday = answer
        case .friday:
            garbage.toFriday = answer
        case .saturday:
            garbage.toSaturday = answer
        case .sunday:
            garbage.toSunday = answer
        default:
            return
        }
        checkStateOfDoneButton()
    }
    
}

//MARK: - Activity

extension EditProfileView {
    private func showActivityIndicator() {
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        }
        activityView?.center = self.center
        self.addSubview(activityView!)
        activityView?.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    private func hideActivityIndicator(){
        activityView?.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}


extension EditProfileView: GMSAutocompleteFetcherDelegate {
  func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
    var resultsStr = NSMutableString()
    for prediction in predictions {
        resultsStr.appendFormat("%@", prediction.attributedFullText)
        print(resultsStr as String)
    }
      print("predictions",predictions)

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

  func didFailAutocompleteWithError(_ error: Error) {
  }
}
