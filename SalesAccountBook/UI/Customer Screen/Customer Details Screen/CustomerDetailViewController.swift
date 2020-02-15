//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    private let inputFieldsSection: InputFieldsSection
    
    let actionType: DetailsViewActionType
    var currentCustomerName: String?
    weak var customerList: CustomerList?
    var onSelectRowDelegate: ((String) -> Void)?
    
    // MARK: - Initializion
    init(config: DetailsConfigurator) {
        let iconView = IconView(image: #imageLiteral(resourceName: "AvatarDefault"))
        self.inputFieldsSection = InputFieldsSection(fields:
            [
                iconView,
                TitleWithTextField(title: Constants.UI.Label.Name, placeholder: Constants.UI.Label.Required),
                TitleWithTextField(title: Constants.UI.Label.Phone, placeholder: Constants.UI.Label.Optional),
                TitleWithTextView(title: Constants.UI.Label.Address, placeholder: Constants.UI.Label.Optional),
                TitleWithTextView(title: Constants.UI.Label.Remark, placeholder: Constants.UI.Label.Optional),
                TitleWithDatePicker(title: Constants.UI.Label.LastContacted, placeholder: Constants.UI.Label.Optional)
            ]
        )
        
        self.actionType = config.action
        self.currentCustomerName = config.id
        self.customerList = config.viewModel as? CustomerList
        self.onSelectRowDelegate = config.onSelectRow
        
        super.init()
        
        self.itemExistsErrorMsg = NSLocalizedString("ErrorCustomerExists", comment: "Error Message - Customer exists with the same name.")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func viewDidLoad() {
        self.navigationItem.title = {
            if self.actionType == .edit {
                return "\(NSLocalizedString("Edit", comment: "The action to change.")) \(self.currentCustomerName ?? "")"
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
        guard let customerDetails = self.customerList?.get(name: self.currentCustomerName ?? "") as? CustomerDetails else {
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
        //        self.inputFieldsSection.customerPic.cameraOptionPresenter = self
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    @objc private func submitCustomerDetails () {
        let customerDetails = self.makeCustomerDetails()
               if customerDetails.name == "" {
                   //            self.promptEmptyFieldError(errorMsg: NSLocalizedString("ErrorMerchInputEmpty", comment: "Error Message - Merch name text field ."), field: self.inputFieldsSection.merchName.textField)
                   return
               }
               
               let handler: (UIAlertAction) -> Void = { [weak self] alert in
                   guard let `self` = self else { return }
                   if self.actionType == .edit {
                       self.editCustomer(customerDetails: customerDetails)
                   } else if self.actionType == .add {
                       self.editCustomer(customerDetails: customerDetails)
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
    
    private func editCustomer(customerDetails: CustomerDetails) {
        guard let oldName = self.currentCustomerName else {
            fatalError()
        }
        
        self.customerList?.edit(oldName: oldName,
                                details: customerDetails,
                                completion: { success in 
                                    if success {
                                        self.navigationController?.popViewController(animated: true)
                                    } else {
                                        self.promptItemExistsError()
                                    }
        })
    }
}
