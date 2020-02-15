//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    private let inputFieldsSection: InputFieldsSection
    
    let actionType: DetailsViewActionType
    weak var customerList: CustomerList?
    var onSelectRowDelegate: ((String) -> Void)?
    
    // MARK: - Initializion
    override init(config: DetailsConfigurator) {
        let iconView = IconView(image: #imageLiteral(resourceName: "AvatarDefault"))
        
        
        self.inputFieldsSection = InputFieldsSection(fields:
            [
                iconView,
                TitleWithTextField(title: Constants.UI.Label.Name,
                                   placeholder: Constants.UI.Label.Required,
                                   spacing: 2.5),
                TitleWithTextField(title: Constants.UI.Label.Phone,
                                   placeholder: Constants.UI.Label.Optional,
                                   spacing: 2.5),
                TitleWithTextView(title: Constants.UI.Label.Address,
                                  placeholder: Constants.UI.Label.Optional,
                                  spacing: 2.5),
                TitleWithTextView(title: Constants.UI.Label.Remark,
                                  placeholder: Constants.UI.Label.Optional,
                                  spacing: 2.5),
                TitleWithDatePicker(title: Constants.UI.Label.LastContacted, placeholder: Constants.UI.Label.Optional)
            ]
        )
        
        self.actionType = config.action
        self.customerList = config.viewModel as? CustomerList
        self.onSelectRowDelegate = config.onSelectRow
        
        super.init(config: config)
        iconView.cameraOptionPresenter = self
    
        self.itemExistsErrorMsg = NSLocalizedString("ErrorCustomerExists", comment: "Error Message - Customer exists with the same name.")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func viewDidLoad() {
        self.navigationItem.title = {
            if self.actionType == .edit {
                return "\(NSLocalizedString("Edit", comment: "The action to change.")) \(self.currentId ?? "")"
            } else if self.actionType == .add {
                return NSLocalizedString("NewCustomer", comment: "New entry of product.")
            } else {
                return ""
            }
        }()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: "The action of storing data on disc."), style: .done, target: self, action: #selector(self.submitCustomerDetails))
        
        self.setup()
    }
    
    private func prefillFieldsForEdit() {
        guard let customerDetails = self.customerList?.get(name: self.currentId ?? "") as? CustomerDetails else {
            fatalError()
        }
        
        let valueMap = [
            Constants.UI.Label.Name: customerDetails.name,
            Constants.UI.Label.Phone: customerDetails.phone,
            Constants.UI.Label.Address: customerDetails.address,
            Constants.UI.Label.Remark: customerDetails.remark,
            Constants.UI.Label.LastContacted: customerDetails.lastContacted.toString(format: Constants.System.DateFormat),
        ]
        
        self.inputFieldsSection.prefillValues(values: valueMap)
    }
    
    private func setup() {
        self.view.backgroundColor = .groupTableViewBackground
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.scrollView.setContentOffset(.init(x: 0, y: self.scrollView.contentOffset.y), animated: false)
        self.scrollView.isDirectionalLockEnabled = true
        
        self.scrollView.addSubview(self.inputFieldsSection)
        self.inputFieldsSection.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.inputFieldsSection.backgroundColor = .white
        (self.inputFieldsSection.getView(viewType: IconView.self).first as? IconView)?.cameraOptionPresenter = self
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    @objc private func submitCustomerDetails () {
        let customerDetails = self.makeCustomerDetails()
        if customerDetails.name == "" {
            if let textField = self.inputFieldsSection
                .getView(labelText: Constants.UI.Label.Name) as? TitleWithTextField {
                self.promptEmptyFieldError(errorMsg: NSLocalizedString("ErrorCustomerInputEmpty", comment: "Error Message - Customer name text field ."), field: textField.textView as! UITextField)
            }
            return
        }
        
        let handler: (UIAlertAction) -> Void = { [weak self] alert in
            guard let `self` = self else { return }
            if self.actionType == .edit {
                self.editItem(details: customerDetails)
            } else if self.actionType == .add {
                self.addCustomer(customerDetails: customerDetails)
            }
        }
        
        let confirmationAlert = UIAlertController.makeConfirmation(confirmHandler: handler)
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func makeCustomerDetails() -> CustomerDetails {
        let extractedValues = self.inputFieldsSection.extractValues(valMapping: [
            Constants.UI.Label.Name,
            Constants.UI.Label.Phone,
            Constants.UI.Label.Address,
            Constants.UI.Label.Remark,
            Constants.UI.Label.LastContacted
        ])
        
        return (image: nil,
                name: extractedValues[Constants.UI.Label.Name] ?? "",
                phone: extractedValues[Constants.UI.Label.Phone] ?? "",
                address: extractedValues[Constants.UI.Label.Address] ?? "",
                remark: extractedValues[Constants.UI.Label.Remark] ?? "",
                lastContacted: extractedValues[Constants.UI.Label.LastContacted]?
                    .toDate(format: Constants.System.DateFormat) ?? Date(),
                orders: nil)
        
    }
    
    private func addCustomer(customerDetails: CustomerDetails) {
        self.customerList?.add(details: customerDetails, completion: { success in
            if !success {
                self.promptItemExistsError()
            }
        })
        
        if let delegate = self.onSelectRowDelegate {
            delegate(customerDetails.name)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
