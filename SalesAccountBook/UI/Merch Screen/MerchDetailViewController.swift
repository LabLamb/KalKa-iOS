//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class MerchDetailViewController: UIViewController {
    
    // MARK: - Variables
    let containerView: UIView
    let merchPic: MerchIconView
    let merchName: TitleWithTextField
    let merchPrice: TitleWithTextField
    let merchQty: TitleWithTextField
    let merchRemark: TitleWithTextField
    let actionType: DetailsViewActionType
    
    var currentMerchName: String?
    weak var inventory: Inventory?
    var onSelectRowDelegate: ((String) -> Void)?
    
    // MARK: - Initializion
    init(config: MerchDetailsConfigurator) {
        self.containerView = UIView()
        self.merchPic = MerchIconView()
        self.merchName = TitleWithTextField(title: NSLocalizedString("MerchName", comment: "Name of product."))
        self.merchPrice = TitleWithTextField(title: NSLocalizedString("MerchPrice", comment: "Price of product."))
        self.merchQty = TitleWithTextField(title: NSLocalizedString("MerchQty", comment: "Quantity of product."))
        self.merchRemark = TitleWithTextField(title: NSLocalizedString("MerchRemark", comment: "Remark of product."))
        
        self.actionType = config.action
        
        self.currentMerchName = config.merchName
        self.inventory = config.inventory
        self.onSelectRowDelegate = config.onSelectRow
        
        super.init(nibName: nil, bundle: nil)
        
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
    
    private func setupPlaceholders() {
        self.merchName.textField.placeholder = NSLocalizedString("Required(Input)", comment: "Must input.")
        self.merchPrice.textField.placeholder = NSLocalizedString("Optional(Input)", comment: "Can leave blank.")
        self.merchQty.textField.placeholder = NSLocalizedString("Optional(Input)", comment: "Can leave blank.")
        self.merchRemark.textField.placeholder = NSLocalizedString("Optional(Input)", comment: "Can leave blank.")
    }
    
    private func prefillFieldsForEdit() {
        guard let merchDetails = self.inventory?.getMerch(name: self.currentMerchName ?? "") else {
            fatalError()
        }
        
        if let img = merchDetails.image {
            self.merchPic.iconImage.image = img
        }
        self.merchName.textField.text = merchDetails.name
        self.merchPrice.textField.text = String(merchDetails.price)
        self.merchQty.textField.text = String(merchDetails.qty)
        self.merchRemark.textField.text = merchDetails.remark
    }
    
    private func setup() {
        self.view.backgroundColor = .groupTableViewBackground
        self.setupPlaceholders()
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
        
        self.view.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        self.containerView.backgroundColor = .white
        
        self.containerView.addSubview(self.merchPic)
        self.merchPic.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(self.view).dividedBy(5)
        }
        self.merchPic.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        self.merchPic.backgroundColor = .white
        DispatchQueue.main.async {
            self.merchPic.iconImage.clipsToBounds = true
            self.merchPic.iconImage.layer.cornerRadius = self.merchPic.iconImage.frame.width / 2
        }
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.showImageUploadOption))
        self.merchPic.addGestureRecognizer(tapGest)
        self.merchPic.isUserInteractionEnabled = true
        
        self.containerView.addSubview(self.merchName)
        self.merchName.snp.makeConstraints { make in
            make.top.equalTo(self.merchPic.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.height.equalTo(44)
        }
        self.merchName.textField.clearButtonMode = .whileEditing
        self.merchName.backgroundColor = .white
        self.merchName.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.containerView.addSubview(self.merchPrice)
        self.merchPrice.snp.makeConstraints { make in
            make.top.equalTo(self.merchName.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.height.equalTo(44)
        }
        self.merchPrice.textField.clearButtonMode = .whileEditing
        self.merchPrice.textField.keyboardType = .numberPad
        self.merchPrice.backgroundColor = .white
        self.merchPrice.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.containerView.addSubview(self.merchQty)
        self.merchQty.snp.makeConstraints { make in
            make.top.equalTo(self.merchPrice.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.height.equalTo(44)
        }
        self.merchQty.textField.clearButtonMode = .whileEditing
        self.merchQty.textField.keyboardType = .numberPad
        self.merchQty.backgroundColor = .white
        self.merchQty.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.containerView.addSubview(self.merchRemark)
        self.merchRemark.snp.makeConstraints { make in
            make.top.equalTo(self.merchQty.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
        self.merchRemark.textField.clearButtonMode = .whileEditing
        self.merchRemark.backgroundColor = .white
        self.merchRemark.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
    }
    
    
    // MARK: - Data
    @objc private func submitMerchDetails () {
        
        let handler: (UIAlertAction) -> Void = { [weak self] alert in
            guard let `self` = self else { return }
            
            guard let merchNameText = self.merchName.textField.text, self.merchName.textField.text != "" else {
                self.promptEmptyMerchNameError()
                return
            }
            
            let merchDetails = self.makeMerchDetails(name: merchNameText)
            
            if self.actionType == .edit {
                if self.currentMerchName == merchNameText {
                    self.editMerch(merchDetails: merchDetails)
                } else {
                    self.inventory?.existsMerch(name: merchNameText,
                                                completion: { [weak self] exists in
                                                    guard let `self` = self else { return }
                                                    if exists {
                                                        self.promptMerchNameExistsError()
                                                    } else {
                                                        self.editMerch(merchDetails: merchDetails)
                                                    }
                    })
                }
            } else if self.actionType == .add {
                self.inventory?.existsMerch(name: merchNameText,
                                            completion: { [weak self] exists in
                                                guard let `self` = self else { return }
                                                if exists {
                                                    self.promptMerchNameExistsError()
                                                } else {
                                                    self.addMerch(merchDetails: merchDetails)
                                                }
                })
            }
            
            
        }
        
        let confirmationAlert = UIAlertController.makeConfirmation(confirmHandler: handler)
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func makeMerchDetails(name: String) -> MerchDetails {
        let parsedPrice = Double(self.merchPrice.textField.text ?? "") ?? 0.0
        let parsedQty = Int(self.merchQty.textField.text ?? "") ?? 0
        
        return (name: name, price: parsedPrice, qty: parsedQty, remark: (self.merchRemark.textField.text) ?? "", image: self.merchPic.iconImage.image)
    }
    
    private func addMerch(merchDetails: MerchDetails) {
        self.inventory?.addMerch(details: merchDetails)
        
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
        
        self.inventory?.editMerch(oldName: oldName,
                                  details: merchDetails,
                                  completion: {
                                    self.navigationController?.popViewController(animated: true)
        })
    }
    
    
    // MARK: - Errors
    private func promptMerchNameExistsError() {
        let errorMessage = NSLocalizedString("ErrorMerchExists", comment: "Error Message - Merch exists with the same name.")
        self.present(UIAlertController.makeError(message: errorMessage), animated: true, completion: nil)
    }
    
    private func promptEmptyMerchNameError() {
        let errorMessage = NSLocalizedString("ErrorMerchInputEmpty", comment: "Error Message - Merch name text field .")
        self.present(UIAlertController.makeError(message: errorMessage), animated: true, completion: nil)
        
        self.merchName.textField.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("Required(Input)", comment: "Must input."),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red.withAlphaComponent(0.5)])
    }
}

// MARK: - Camera
extension MerchDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @objc private func showImageUploadOption() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: "Tools of taking pictures."), style: .default, handler: { _ in
            self.uploadByCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Photos", comment: "Collections of images."), style: .default, handler: { _ in
            self.uploadByLibrary()
        }))
        
        let resetBtn = UIAlertAction(title: NSLocalizedString("Remove", comment: "Collections of images."), style: .destructive, handler: { _ in
            self.resetIconDefault()
        })
        actionSheet.addAction(resetBtn)
        
        actionSheet.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Decide an event will not take place."), style: .cancel, handler: nil))
        
        resetBtn.isEnabled = !(self.merchPic.iconImage.image == #imageLiteral(resourceName: "MerchDefault"))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func uploadByCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    private func uploadByLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    private func resetIconDefault() {
        self.merchPic.iconImage.image = #imageLiteral(resourceName: "MerchDefault")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.merchPic.iconImage.image = img
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
