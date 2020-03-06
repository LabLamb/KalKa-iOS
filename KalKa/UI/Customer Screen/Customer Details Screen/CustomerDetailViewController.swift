//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    private let inputFieldsSection: InputFieldsSection
    weak var customerList: CustomerList?

    // MARK: - Initializion
    override init(config: DetailsConfiguration) {
        let iconView = IconView(image: #imageLiteral(resourceName: "AvatarDefault"))
        
        
        self.inputFieldsSection = InputFieldsSection(fields:
            [
                iconView,
                TitleWithTextField(title: .name,
                                   placeholder: .required,
                                   spacing: Constants.UI.Spacing.Width.Medium),
                TitleWithTextField(title: .phone,
                                   placeholder: .optional,
                                   spacing: Constants.UI.Spacing.Width.Medium,
                                   inputKeyboardType: .phonePad,
                                   maxTextLength: 15),
                TitleWithTextView(title: .address,
                                  placeholder: .optional,
                                  spacing: Constants.UI.Spacing.Width.Medium),
                TitleWithTextView(title: .remark,
                                  placeholder: .optional,
                                  spacing: Constants.UI.Spacing.Width.Medium),
                TitleWithDatePicker(title: .lastContacted,
                                    placeholder: .optional,
                                    spacing: Constants.UI.Spacing.Width.Medium)
            ]
        )
        
        self.customerList = config.viewModel as? CustomerList
        
        super.init(config: config)
        iconView.cameraOptionPresenter = self
    
        self.itemExistsErrorMsg = NSLocalizedString("ErrorCustomerExists", comment: "Error Message - Customer exists with the same name.")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = {
            if self.actionType == .edit {
                return "\(String.edit) \(self.currentId)"
            } else if self.actionType == .add {
                return NSLocalizedString("NewCustomer", comment: "New entry of product.")
            } else {
                return ""
            }
        }()
        
        self.setup()
    }
    
    private func prefillFieldsForEdit() {
        guard let customerDetails = self.customerList?.getDetails(id: self.currentId) as? CustomerDetails else {
            fatalError()
        }
        
        // Add to past orders table view
        print("\(customerDetails.name) has \(customerDetails.orders?.count ?? 0) orders.")
        
        let valueMap: [String: String] = [
            .name: customerDetails.name,
            .phone: customerDetails.phone,
            .address: customerDetails.address,
            .remark: customerDetails.remark,
            .lastContacted: customerDetails.lastContacted.toString(format: Constants.System.DateFormat),
        ]
        
        let iconView = self.inputFieldsSection.getViews(viewType: IconView.self).first as? IconView
        if customerDetails.image != nil {
            iconView?.iconImage.image = customerDetails.image
        }
        
        self.inputFieldsSection.prefillValues(values: valueMap)
    }
    
    private func setup() {
        self.view.backgroundColor = .background
        
        self.scrollView.addSubview(self.inputFieldsSection)
        self.inputFieldsSection.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.bottom.equalToSuperview()
        }
        self.inputFieldsSection.backgroundColor = .primary
        self.inputFieldsSection.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.inputFieldsSection.layer.cornerRadius = self.inputFieldsSection.frame.width / 24
        }
        
        (self.inputFieldsSection.getViews(viewType: IconView.self).first as? IconView)?.cameraOptionPresenter = self
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    override func validateFields() -> Bool {
        if self.makeDetails().id == "" {
            let textField = self.inputFieldsSection.getViews(descText: .name).first as? TitleWithTextField
            self.promptEmptyFieldError(errorMsg: NSLocalizedString("ErrorCustomerInputEmpty", comment: "Error Message - Customer name text field ."), field: textField?.valueView as? UITextField)
            return false
        }
        
        return true
    }
    
    override func makeDetails() -> ModelDetails {
        let extractedValues = self.inputFieldsSection.extractValues(mappingKeys: [
            .name,
            .phone,
            .address,
            .remark,
            .lastContacted
        ])
        
        let iconView = self.inputFieldsSection.getViews(viewType: IconView.self).first as? IconView
        let image: UIImage? = {
            if let img = iconView?.iconImage.image {
                return img  == #imageLiteral(resourceName: "AvatarDefault") ? nil : img
            } else {
                return nil
            }
        }()
        
        return CustomerDetails(image: image,
                               address: extractedValues[.address] ?? "",
                               lastContacted: extractedValues[.lastContacted]?.toDate(format: Constants.System.DateFormat) ?? Date(),
                               name: extractedValues[.name] ?? "",
                               phone: extractedValues[.phone] ?? "",
                               orders: nil,
                               remark: extractedValues[.remark] ?? "")
        
    }
}
