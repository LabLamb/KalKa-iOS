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
        
        var fields = [UIView]()
        
        switch self.actionType {
        case .add:
            fields = [
                iconView,
                PNPRow(title: .name, config: PNPRowConfig(placeholder: .required, validation: .required)),
                PNPRow(title: .price, config: PNPRowConfig(type: .singlelineText(PNPKeyboardConfig(keyboardType: .decimalPad)),
                                                           placeholder: .optional)),
                PNPRow(title: .remark, config: PNPRowConfig(placeholder: .optional))
            ]
        case .edit:
            fields = [
                iconView,
                PNPRow(title: .name, config: PNPRowConfig(placeholder: .required, validation: .required)),
                PNPRow(title: .price, config: PNPRowConfig(type: .singlelineText(PNPKeyboardConfig(keyboardType: .decimalPad)),
                                                           placeholder: .optional)),
                PNPRow(title: .quantity, config: PNPRowConfig(type: .label, placeholder: .optional)),
                PNPRow(title: .remark, config: PNPRowConfig(placeholder: .optional))
            ]
        }
        
        return PNPForm(rows: fields, separatorColor: .background)
    }()
    
    lazy var restockList: PNPForm = {
        let labelConfig = PNPRowConfig(type: .label, placeholder: .restockRecord)
        let result = PNPForm(rows: [PNPRow(config: labelConfig)], separatorColor: .background)
        return result
    }()
    
    var enteredRestocks: [RestockDetails] = []
    var returnedRestocks: [RestockDetails] = []
    
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
        switch self.actionType {
        case .add:
            self.navigationItem.title = NSLocalizedString("NewMerch", comment: "New entry of product.")
            self.restockList.isHidden = true
        case .edit:
            self.navigationItem.title = "\(String.edit) \(self.currentId)"
        }
        
        self.setup()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateQuantityRow), name: .inventoryUpdated, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .inventoryUpdated, object: nil)
    }
    
    private func prefillFieldsForEdit() {
        guard let merchDetails = self.inventory?.getDetails(id: self.currentId) as? MerchDetails else {
            fatalError("Unable to retrieve data.")
        }
        
        if let restocks = merchDetails.restocks,
            restocks.count > 0 {
            restocks.forEach({ details in
                let restockView = RestockView(date: details.stockTimeStamp, qty: details.restockQty, returnDelegate: { [weak self] restockView in
                    guard let self = self else { return }
                    self.returnedRestocks.append(details)
                    restockView.removeFromSuperview()
                    if self.restockList.getViews().count <= 1 {
                        self.restockList.isHidden = true
                    }
                    let currentValue = self.inputForm.getRows(withLabelText: .quantity).first?.value ?? "0"
                    self.inputForm.prefillRows(titleValueMap: [
                        .quantity: String((Int(currentValue) ?? 0) - details.restockQty)
                    ])
                })
                self.restockList.appendView(view: restockView)
                restockView.snp.makeConstraints { make in
                    make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
                }
            })
        } else {
            self.restockList.isHidden = true
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
    
    @objc func navToAdditionQty(gest: UITapGestureRecognizer) {
        guard let row = gest.view as? PNPRow,
            let qty = Int(row.value ?? "") else { return }
        
        let handler: (Int) -> Void = { [weak self] restockQty in
            guard let self = self else { return }
            let newQty = Int(self.inputForm.getRows(withLabelText: .quantity).first?.value ?? "0") ?? 0
            self.inputForm.prefillRows(titleValueMap: [
                .quantity: String(newQty + restockQty)
            ])
            self.enteredRestocks.append(RestockDetails(stockTimeStamp: Date(), restockQty: restockQty))
            self.dismiss(animated: true, completion: nil)
        }
        
        self.presentPanModal(ModalNavigationViewController(rootViewController: MerchQtyDetailViewController(currentQty: qty, onSave: handler), formHeight: .contentHeight(Constants.UI.Sizing.Height.ExLarge)))
    }
    
    private func setup() {
        self.view.backgroundColor = .background
        
        self.scrollView.addSubview(self.inputForm)
        self.inputForm.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
        }
        self.inputForm.backgroundColor = .primary
        self.inputForm.clipsToBounds = true
        
        self.scrollView.addSubview(self.restockList)
        self.restockList.snp.makeConstraints { make in
            make.top.equalTo(self.inputForm.snp.bottom).offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.bottom.equalToSuperview()
        }
        self.restockList.backgroundColor = .primary
        self.restockList.clipsToBounds = true
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.inputForm.layer.cornerRadius = self.inputForm.frame.width / 24
            self.restockList.layer.cornerRadius = self.restockList.frame.width / 24
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
                            restocks: self.enteredRestocks)
        
    }
    
    override func editItem(details: ModelDetails) {
        super.editItem(details: details)
        self.inventory?.removeRestock(merchId: self.currentId, returnedDetails: self.returnedRestocks)
    }
    
    @objc func updateQuantityRow() {
        if let qtyRow = self.inputForm.getRows(withLabelText: .quantity).first,
        let details = self.inventory?.getDetails(id: self.currentId) as? MerchDetails {
            let restockTotal = self.enteredRestocks.reduce(0, { result, restock in
                return result + restock.restockQty
            })
            
            let diff = restockTotal + details.qty
            qtyRow.value = String(diff)
        }
    }
}
