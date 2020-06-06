//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import PNPForm

class CustomerDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    private lazy var inputForm: PNPForm = {
        let iconView = IconView(image: #imageLiteral(resourceName: "AvatarDefault"))
        iconView.cameraOptionPresenter = self
        return PNPForm(rows: [
            iconView,
            PNPRow(title: .name,
                   config: PNPRowConfig(placeholder: .required,
                                        validation: .required)),
            
            PNPRow(title: .phone,
                   config: PNPRowConfig(type: .singlelineText(PNPKeyboardConfig(keyboardType: .phonePad)),
                                        placeholder: .optional)),
            
            PNPRow(title: .address,
                   config: PNPRowConfig(type: .multilineText(),
                                        placeholder: .optional)),
            
            PNPRow(title: .remark,
                   config: PNPRowConfig(type: .multilineText(),
                                        placeholder: .optional)),
            
            PNPRow(title: .lastContacted,
                   config: PNPRowConfig(type: .date(format: Constants.System.DateFormat),
                                        placeholder: Date().toString(format: Constants.System.DateFormat)))
            ],
                       separatorColor: .background
        )
    }()
    weak var customerList: CustomerList?
    
    // MARK: - Initializion
    override init(config: DetailsConfiguration) {
        self.customerList = config.viewModel as? CustomerList
        super.init(config: config)
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
            fatalError("Unable to retrieve data.")
        }
        
        let valueMap: [String: String] = [
            .name: customerDetails.name,
            .phone: customerDetails.phone,
            .address: customerDetails.address,
            .remark: customerDetails.remark,
            .lastContacted: customerDetails.lastContacted.toString(format: Constants.System.DateFormat),
        ]
        
        let iconView = self.inputForm.getViews(withViewClass: IconView.self).first as? IconView
        if customerDetails.image != nil {
            iconView?.iconImage.image = customerDetails.image
        }
        
        self.inputForm.prefillRows(titleValueMap: valueMap)
    }
    
    private func setup() {
        self.view.backgroundColor = .background
        
        self.scrollView.addSubview(self.inputForm)
        self.inputForm.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.bottom.equalToSuperview()
        }
        self.inputForm.backgroundColor = .primary
        self.inputForm.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.inputForm.layer.cornerRadius = self.inputForm.frame.width / 24
        }
        
        (self.inputForm.getViews(withViewClass: IconView.self).first as? IconView)?.cameraOptionPresenter = self
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    override func validateFields() -> Bool {
        let isValid = self.inputForm.validateRows()
        if !isValid {
            self.promptEmptyFieldError(errorMsg: NSLocalizedString("ErrorCustomerInputEmpty", comment: "Error Message - Customer name text field ."))
        }
        return isValid
    }
    
    override func makeDetails() -> ModelDetails {
        let extractedValues = self.inputForm.extractRowValues(withLabelTextList: [
            .name,
            .phone,
            .address,
            .remark,
            .lastContacted
        ])
        
        let iconView = self.inputForm.getViews(withViewClass: IconView.self).first as? IconView
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
