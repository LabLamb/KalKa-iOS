//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    private let containerView: CustomerFieldsContainer
    
    let actionType: DetailsViewActionType
    var currentCustomerName: String?
    weak var customerList: CustomerList?
    var onSelectRowDelegate: ((String) -> Void)?
    
    // MARK: - Initializion
    init(config: DetailsConfigurator) {
        self.containerView = CustomerFieldsContainer()
        
        self.actionType = config.action
        self.currentCustomerName = config.id
        self.customerList = config.viewModel as? CustomerList
        self.onSelectRowDelegate = config.onSelectRow
        
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func viewDidLoad() {
        self.navigationItem.title = {
            if self.actionType == .edit {
                return "\(NSLocalizedString("Edit", comment: "The action to change.")) \(self.currentCustomerName ?? "")"
            } else if self.actionType == .add {
                return NSLocalizedString("NewCustomer", comment: "New entry of product.")
            } else {
                return ""
            }
        }()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: "The action of storing data on disc."), style: .done, target: self, action: #selector(self.submitCustomerDetails))
        
        self.setup()
    }
    
    private func prefillFieldsForEdit() {
        guard let customerDetails = self.customerList?.get(name: self.currentCustomerName ?? "") as? CustomerDetails else {
            fatalError()
        }
        
        if let img = customerDetails.image {
            self.containerView.customerPic.iconImage.image = img
        }
        self.containerView.customerName.text = customerDetails.name
        self.containerView.customerAddress.text = customerDetails.address
        self.containerView.lastContacted.text = customerDetails.lastContacted.toString(format: Constants.System.DateFormat)
        self.containerView.customerPhone.text = customerDetails.phone
        self.containerView.customerRemark.text = customerDetails.remark
    }
    
    private func setup() {
        self.view.backgroundColor = .groupTableViewBackground
        
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.scrollView.setContentOffset(.init(x: 0, y: self.scrollView.contentOffset.y), animated: false)
        self.scrollView.isDirectionalLockEnabled = true
        
        self.scrollView.addSubview(self.containerView)
        self.containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.containerView.backgroundColor = .white
        
        self.containerView.setup()
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.showImageUploadOption))
        self.containerView.customerPic.addGestureRecognizer(tapGest)
        self.containerView.customerPic.isUserInteractionEnabled = true
    }
    
    
    // MARK: - Data
    @objc private func submitCustomerDetails () {
        
        let handler: (UIAlertAction) -> Void = { [weak self] alert in
            guard let `self` = self else { return }
            
            let customerNameText = self.containerView.customerName.text
            if  customerNameText == "" {
                self.promptEmptyFieldError(field: self.containerView.customerName.textField)
                return
            }
            
            
            let customerDetails = self.makeCustomerDetails(name: customerNameText)
            
            if self.actionType == .edit {
                if self.currentCustomerName == customerNameText {
                    self.editCustomer(customerDetails: customerDetails)
                } else {
                    self.customerList?.exists(name: customerNameText,
                                                      completion: { [weak self] exists in
                                                        guard let `self` = self else { return }
                                                        if exists {
                                                            self.promptCustomerNameExistsError()
                                                        } else {
                                                            self.editCustomer(customerDetails: customerDetails)
                                                        }
                    })
                }
            } else if self.actionType == .add {
                self.customerList?.exists(name: customerNameText,
                                                  completion: { [weak self] exists in
                                                    guard let `self` = self else { return }
                                                    if exists {
                                                        self.promptCustomerNameExistsError()
                                                    } else {
                                                        self.addCustomer(customerDetails: customerDetails)
                                                    }
                })
            }
            
            
        }
        
        let confirmationAlert = UIAlertController.makeConfirmation(confirmHandler: handler)
        
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func makeCustomerDetails(name: String) -> CustomerDetails {
        //        let parsedQty = Int(self.containerView.customerQty.text ?? "") ?? 0
        
        let img: UIImage? = {
            if self.containerView.customerPic.iconImage.image == #imageLiteral(resourceName: "AvatarDefault") {
                return nil
            } else {
                return self.containerView.customerPic.iconImage.image
            }
        }()
        
        return (image: img,
                address: self.containerView.customerAddress.text,
                lastContacted: self.containerView.lastContacted.text.toDate(format: Constants.System.DateFormat) ?? Date(),
                name: name,
                phone: self.containerView.customerPhone.text,
                orders: nil,
                remark: self.containerView.customerRemark.text)
    }
    
    private func addCustomer(customerDetails: CustomerDetails) {
        self.customerList?.add(details: customerDetails)
        
        if let delegate = self.onSelectRowDelegate {
            delegate(customerDetails.name)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    private func editCustomer(customerDetails: CustomerDetails) {
        guard let oldName = self.currentCustomerName else {
            fatalError()
        }
        
        self.customerList?.edit(oldName: oldName,
                                        details: customerDetails,
                                        completion: {
                                            self.navigationController?.popViewController(animated: true)
        })
    }
}

// MARK: - Camera
extension CustomerDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
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
        
        resetBtn.isEnabled = !(self.containerView.customerPic.iconImage.image?.isEqual(#imageLiteral(resourceName: "AvatarDefault")) ?? false)
        
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
        self.containerView.customerPic.iconImage.image = #imageLiteral(resourceName: "AvatarDefault")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.containerView.customerPic.iconImage.image = img
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
