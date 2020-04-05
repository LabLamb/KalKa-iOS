//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import PNPForm
import PanModal

class MerchDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    weak var inventory: Inventory?
    lazy var inputForm: PNPForm = {
        let iconView = IconView(image: #imageLiteral(resourceName: "MerchDefault"))
        iconView.cameraOptionPresenter = self
        
        let qtyRow: PNPRow = {
            if self.actionType == .edit {
                return PNPRow(title: .quantity, config: PNPRowConfig(type: .label, placeholder: .optional))
            } else {
                return PNPRow(title: .quantity, config: PNPRowConfig(type: .singlelineText(PNPKeyboardConfig(keyboardType: .numberPad)), placeholder: .optional))
            }
        }()
        
        let fields: [UIView] = [
            iconView,
            PNPRow(title: .name, config: PNPRowConfig(placeholder: .required, validation: .required)),
            PNPRow(title: .price, config: PNPRowConfig(type: .singlelineText(PNPKeyboardConfig(keyboardType: .decimalPad)),
                                                       placeholder: .optional)),
            qtyRow,
            PNPRow(title: .remark, config: PNPRowConfig(placeholder: .optional))
        ]
        
        return PNPForm(rows: fields, separatorColor: .background)
    }()
    
    // MARK: - Initializion
    override init(config: DetailsConfiguration) {
        self.inventory = config.viewModel as? Inventory
        super.init(config: config)
        self.itemExistsErrorMsg = NSLocalizedString("ErrorMerchExists", comment: "Error Message - Merch name text field .")
        if self.actionType == .edit,
            let qtyRow = self.inputForm.getRows(withLabelText: .quantity).first {
            let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.navToAdditionQty(gest:)))
            qtyRow.addGestureRecognizer(tapGest)
            qtyRow.isUserInteractionEnabled = true
        }
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
        
        merchDetails.restocks?.forEach({
            print("Added \($0.restockQty) on \($0.stockTimeStamp)")
        })
        
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
    
    @objc func navToAdditionQty(gest: UITapGestureRecognizer) {
        guard let row = gest.view as? PNPRow,
            let qty = Int(row.value ?? "") else { return }
        
        let handler: (Int) -> Void = { [weak self] newQty in
            guard let self = self else { return }
            self.inputForm.prefillRows(titleValueMap: [
                .quantity: String(newQty)
            ])
            self.dismiss(animated: true, completion: nil)
        }
        
        self.presentPanModal(MerchQtyDetailNavViewController(rootViewController: MerchQtyDetailViewController(currentQty: qty, onSave: handler)))
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
        let isValid = self.inputForm.validateRows()
        if !isValid {
            self.promptEmptyFieldError(errorMsg: NSLocalizedString("ErrorMerchInputEmpty", comment: "Error Message - Merch name text field ."))
        }
        return isValid
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
                            image: image,
                            restocks: [])
        
    }
}
