//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class MerchDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    let inputFieldsSection: InputFieldsSection
    weak var inventory: Inventory?
    
    // MARK: - Initializion
    override init(config: DetailsConfiguration) {
        let iconView = IconView(image: #imageLiteral(resourceName: "MerchDefault"))
        
        let fields = [
            iconView,
            TitleWithTextField(title: .name,
                               placeholder: .required,
                               spacing: Constants.UI.Spacing.Width.Medium,
                               maxTextLength: 15),
            TitleWithTextField(title: .price,
                               placeholder: .optional,
                               spacing: Constants.UI.Spacing.Width.Medium,
                               inputKeyboardType: .decimalPad,
                               maxTextLength: 9),
            TitleWithTextField(title: .quantity,
                               placeholder: .optional,
                               spacing: Constants.UI.Spacing.Width.Medium,
                               inputKeyboardType: .numberPad,
                               maxTextLength: 7),
            TitleWithTextView(title: .remark,
                              placeholder: .optional,
                              spacing: Constants.UI.Spacing.Width.Medium)
        ]
        
        self.inputFieldsSection = InputFieldsSection(fields: fields)
        
        self.inventory = config.viewModel as? Inventory
        
        super.init(config: config)
        iconView.cameraOptionPresenter = self
        
        self.itemExistsErrorMsg = NSLocalizedString("ErrorMerchExists", comment: "Error Message - Merch name text field .")
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
                return NSLocalizedString("NewMerch", comment: "New entry of product.")
            } else {
                return ""
            }
        }()
        self.setup()
    }
    
    private func prefillFieldsForEdit() {
        guard let merchDetails = self.inventory?.getDetails(id: self.currentId) as? MerchDetails else {
            fatalError()
        }
        
        let valueMap: [String: String] = [
            .name: merchDetails.name,
            .price: String(merchDetails.price),
            .quantity: String(merchDetails.qty),
            .remark: merchDetails.remark
        ]
        
        let iconView = self.inputFieldsSection.getViews(viewType: IconView.self).first as? IconView
        if merchDetails.image != nil {
            iconView?.iconImage.image = merchDetails.image
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
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    override func validateFields() -> Bool {
        if self.makeDetails().id == "" {
            let textField = self.inputFieldsSection.getViews(viewType: TitleWithTextField.self)
                .first(where: { view in
                    (((view as? TitleWithTextField)?.desc) as? String) == .name
                }) as? TitleWithTextField
            
            let inputField = textField?.valueView as? UITextField
            
            self.promptEmptyFieldError(errorMsg: NSLocalizedString("ErrorMerchInputEmpty", comment: "Error Message - Merch name text field ."), field: inputField)
            
            return false
        }
        
        return true
    }
    
    override func makeDetails() -> ModelDetails {
        let extractedValue = self.inputFieldsSection.extractValues(mappingKeys: [
            .name,
            .price,
            .quantity,
            .remark
        ])
        
        let iconView = self.inputFieldsSection.getViews(viewType: IconView.self).first as? IconView
        let image: UIImage? = {
            if let img = iconView?.iconImage.image {
                return img  == #imageLiteral(resourceName: "MerchDefault") ? nil : img
            } else {
                return nil
            }
        }()
        
        let parsedPrice = Double(extractedValue[.price] ?? "") ?? 0.0
        let parsedQty = Int(extractedValue[.quantity] ?? "") ?? 0
        
        return MerchDetails(name: extractedValue[.name] ?? "",
                            price: parsedPrice,
                            qty: parsedQty,
                            remark: extractedValue[.remark] ?? "",
                            image: image)
        
    }
}
