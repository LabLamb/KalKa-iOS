//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import PNPForm

class MerchDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    let inputForm: PNPForm
    weak var inventory: Inventory?
    
    // MARK: - Initializion
    override init(config: DetailsConfiguration) {
        let iconView = IconView(image: #imageLiteral(resourceName: "MerchDefault"))
        
        let fields: [UIView] = [
            iconView,
            PNPRow(title: .name, config: PNPRowConfig(placeholder: .required)),
            PNPRow(title: .price, config: PNPRowConfig(type: .singlelineText(PNPKeyboardConfig(keyboardType: .decimalPad)),
                                                       placeholder: .optional)),
            PNPRow(title: .quantity, config: PNPRowConfig(type: .singlelineText(PNPKeyboardConfig(keyboardType: .numberPad)),
                                                          placeholder: .optional)),
            PNPRow(title: .remark, config: PNPRowConfig(placeholder: .optional))
        ]
        
        self.inputForm = PNPForm(rows: fields, separatorColor: .background)
        
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
            fatalError("Unable to retrieve data.")
        }
        
        let valueMap: [String: String] = [
            .name: merchDetails.name,
            .price: String(merchDetails.price),
            .quantity: String(merchDetails.qty),
            .remark: merchDetails.remark
        ]
        
        let iconView = self.inputForm.getViews(withViewClass: IconView.self).first as? IconView
        if merchDetails.image != nil {
            iconView?.iconImage.image = merchDetails.image
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
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    override func validateFields() -> Bool {
        if self.makeDetails().id == "" {
//            let textField = self.inputForm.getRows(withLabelText: .name).first
//            let inputField = textField?.value
            
            self.promptEmptyFieldError(errorMsg: NSLocalizedString("ErrorMerchInputEmpty", comment: "Error Message - Merch name text field ."))
            
            return false
        }
        
        return true
    }
    
    override func makeDetails() -> ModelDetails {
        let extractedValue = self.inputForm.extractRowValues(withLabelTextList: [
            .name,
            .price,
            .quantity,
            .remark
        ])
        
        let iconView = self.inputForm.getViews(withViewClass: IconView.self).first as? IconView
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
