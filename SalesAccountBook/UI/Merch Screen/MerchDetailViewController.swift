//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class MerchDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    let containerView: MerchFieldsContainer
    
    let actionType: DetailsViewActionType
    var currentMerchName: String?
    weak var inventory: Inventory?
    var onSelectRowDelegate: ((String) -> Void)?
    
    // MARK: - Initializion
    init(config: DetailsConfigurator) {
        self.containerView = MerchFieldsContainer()
        
        self.actionType = config.action
        self.currentMerchName = config.id
        self.inventory = config.viewModel as? Inventory
        self.onSelectRowDelegate = config.onSelectRow
        
        super.init()
        
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
        
        if let img = merchDetails.image {
            self.containerView.merchPic.iconImage.image = img
        }
        self.containerView.merchName.textField.text = merchDetails.name
        self.containerView.merchPrice.textField.text = String(merchDetails.price)
        self.containerView.merchQty.textField.text = String(merchDetails.qty)
        self.containerView.merchRemark.textField.text = merchDetails.remark
    }
    
    private func setup() {
        self.view.backgroundColor = .groupTableViewBackground
        
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        self.containerView.backgroundColor = .white
        self.containerView.merchPic.cameraOptionPresenter = self
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    @objc private func submitMerchDetails () {
        
        let handler: (UIAlertAction) -> Void = { [weak self] alert in
            guard let `self` = self else { return }
            
            guard let merchNameText = self.containerView.merchName.textField.text, self.containerView.merchName.textField.text != "" else {
                self.promptEmptyFieldError(errorMsg: NSLocalizedString("ErrorMerchInputEmpty", comment: "Error Message - Merch name text field ."), field: self.containerView.merchName.textField)
                return
            }
            
            let merchDetails = self.makeMerchDetails(name: merchNameText)
            
            if self.actionType == .edit {
                self.editMerch(merchDetails: merchDetails)
            } else if self.actionType == .add {
                self.addMerch(merchDetails: merchDetails)
            }
            
            
        }
        
        let confirmationAlert = UIAlertController.makeConfirmation(confirmHandler: handler)
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func makeMerchDetails(name: String) -> MerchDetails {
        let parsedPrice = Double(self.containerView.merchPrice.textField.text ?? "") ?? 0.0
        let parsedQty = Int(self.containerView.merchQty.textField.text ?? "") ?? 0
        
        let img: UIImage? = {
            if self.containerView.merchPic.iconImage.image == #imageLiteral(resourceName: "MerchDefault") {
                return nil
            } else {
                return self.containerView.merchPic.iconImage.image
            }
        }()
        
        return (name: name, price: parsedPrice, qty: parsedQty, remark: (self.containerView.merchRemark.textField.text) ?? "", image: img)
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
