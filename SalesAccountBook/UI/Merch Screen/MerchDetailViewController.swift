//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class MerchDetailViewController: UIViewController {
    
    // MARK: - Variables
    let containerView: MerchFieldsContainer
    
    let actionType: DetailsViewActionType
    var currentMerchName: String?
    weak var inventory: Inventory?
    var onSelectRowDelegate: ((String) -> Void)?
    
    // MARK: - Initializion
    init(config: MerchDetailsConfigurator) {
        self.containerView = MerchFieldsContainer()
        
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
        
        self.containerView.setup()
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.showImageUploadOption))
        self.containerView.merchPic.addGestureRecognizer(tapGest)
        self.containerView.merchPic.isUserInteractionEnabled = true
    }
    
    
    // MARK: - Data
    @objc private func submitMerchDetails () {
        
        let handler: (UIAlertAction) -> Void = { [weak self] alert in
            guard let `self` = self else { return }
            
            guard let merchNameText = self.containerView.merchName.textField.text, self.containerView.merchName.textField.text != "" else {
                self.promptEmptyMerchNameError()
                return
            }
            
            let merchDetails = self.makeMerchDetails(name: merchNameText)
            
            if self.actionType == .edit {
                if self.currentMerchName == merchNameText {
                    self.editMerch(merchDetails: merchDetails)
                } else {
                    self.inventory?.exists(name: merchNameText,
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
                self.inventory?.exists(name: merchNameText,
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
        self.inventory?.add(details: merchDetails)
        
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
        
        self.containerView.merchName.textField.attributedPlaceholder = NSAttributedString(
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
        
        resetBtn.isEnabled = !(self.containerView.merchPic.iconImage.image?.isEqual(#imageLiteral(resourceName: "MerchDefault")) ?? false)
        
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
        self.containerView.merchPic.iconImage.image = #imageLiteral(resourceName: "MerchDefault")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.containerView.merchPic.iconImage.image = img
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
