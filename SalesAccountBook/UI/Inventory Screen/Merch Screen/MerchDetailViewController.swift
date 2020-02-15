//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class MerchDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    let inputFieldsSection: InputFieldsSection
    
    let actionType: DetailsViewActionType
    var currentMerchName: String?
    weak var inventory: Inventory?
    var onSelectRowDelegate: ((String) -> Void)?
    
    // MARK: - Initializion
    init(config: DetailsConfigurator) {
        let iconView = IconView(image: #imageLiteral(resourceName: "MerchDefault"))
        let fields = [
            iconView,
            TitleWithTextField(title: Constants.UI.Label.Name, placeholder: Constants.UI.Label.Required),
            TitleWithTextField(title: Constants.UI.Label.Price, placeholder: Constants.UI.Label.Optional),
            TitleWithTextField(title: Constants.UI.Label.Quantity, placeholder: Constants.UI.Label.Optional),
            TitleWithTextField(title: Constants.UI.Label.Remark, placeholder: Constants.UI.Label.Optional),
        ]
        
        self.inputFieldsSection = InputFieldsSection(fields: fields)
        
        self.actionType = config.action
        self.currentMerchName = config.id
        self.inventory = config.viewModel as? Inventory
        self.onSelectRowDelegate = config.onSelectRow
        
        super.init()
        
        iconView.cameraOptionPresenter = self
        self.itemExistsErrorMsg = NSLocalizedString("ErrorMerchExists", comment: "Error Message - Merch name text field .")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func viewDidLoad() {
        self.navigationItem.title = {
            if self.actionType == .edit {
                return "\(NSLocalizedString("Edit", comment: "The action to change.")) \(self.currentMerchName ?? "")"
            } else if self.actionType == .add {
                return NSLocalizedString("NewMerch", comment: "New entry of product.")
            } else {
                return ""
            }
        }()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: "The action of storing data on disc."), style: .done, target: self, action: #selector(self.submitMerchDetails))
        
        self.setup()
    }
    
    private func prefillFieldsForEdit() {
        guard let merchDetails = self.inventory?.get(name: self.currentMerchName ?? "") as? MerchDetails else {
            fatalError()
        }
        
        let valueMap = [
            Constants.UI.Label.Name: merchDetails.name,
            Constants.UI.Label.Price: String(merchDetails.price),
            Constants.UI.Label.Quantity: String(merchDetails.qty),
            Constants.UI.Label.Remark: merchDetails.remark
        ]
        
        self.inputFieldsSection.prefillValues(values: valueMap)
        
        self.inputFieldsSection.prefillValues(values: valueMap)
    }
    
    private func setup() {
        self.view.backgroundColor = .groupTableViewBackground
        
        self.view.addSubview(self.inputFieldsSection)
        self.inputFieldsSection.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        self.inputFieldsSection.backgroundColor = .white
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    @objc private func submitMerchDetails () {
        let merchDetails = self.makeMerchDetails()
        if merchDetails.name == "" {
            //            self.promptEmptyFieldError(errorMsg: NSLocalizedString("ErrorMerchInputEmpty", comment: "Error Message - Merch name text field ."), field: self.inputFieldsSection.merchName.textField)
            return
        }
        
        let handler: (UIAlertAction) -> Void = { [weak self] alert in
            guard let `self` = self else { return }
            if self.actionType == .edit {
                self.editMerch(merchDetails: merchDetails)
            } else if self.actionType == .add {
                self.addMerch(merchDetails: merchDetails)
            }
        }
        
        let confirmationAlert = UIAlertController.makeConfirmation(confirmHandler: handler)
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func makeMerchDetails() -> MerchDetails {
        let extractedValue = self.inputFieldsSection.extractValues(valMapping: [
            Constants.UI.Label.Name,
            Constants.UI.Label.Price,
            Constants.UI.Label.Quantity,
            Constants.UI.Label.Remark
        ])
        
        let iconView = self.inputFieldsSection.getView(viewType: IconView.self).first as? IconView
        let image: UIImage? = {
            if let img = iconView?.iconImage.image {
                return img  == #imageLiteral(resourceName: "MerchDefault") ? nil : img
            } else {
                return nil
            }
        }()
        
        let parsedPrice = Double(extractedValue[Constants.UI.Label.Price] ?? "") ?? 0.0
        let parsedQty = Int(extractedValue[Constants.UI.Label.Quantity] ?? "") ?? 0
        
        return (name: extractedValue[Constants.UI.Label.Name] ?? "",
                price: parsedPrice,
                qty: parsedQty,
                remark: extractedValue[Constants.UI.Label.Remark] ?? "",
                image: image)
        
    }
    
    private func addMerch(merchDetails: MerchDetails) {
        self.inventory?.add(details: merchDetails, completion: { success in
            if !success {
                self.promptItemExistsError()
            }
        })
        
        if let delegate = self.onSelectRowDelegate {
            delegate(merchDetails.name)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func editMerch(merchDetails: MerchDetails) {
        guard let oldName = self.currentMerchName else {
            fatalError()
        }
        
        self.inventory?.edit(oldName: oldName,
                             details: merchDetails,
                             completion: { success in
                                if success {
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    self.promptItemExistsError()
                                }
        })
    }
}
