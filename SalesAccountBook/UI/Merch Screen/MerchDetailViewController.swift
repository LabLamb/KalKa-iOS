//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import SwiftForms

class MerchDetailViewController: FormViewController {
    
    let merchName: FormRowDescriptor
    let merchPic: FormRowDescriptor
    let merchPrice: FormRowDescriptor
    let merchQty: FormRowDescriptor
    let merchRemark: FormRowDescriptor
    let actionType: DetailsViewActionType
    
    var currentMerchName: String?
    weak var inventory: Inventory?
    var onSelectRowDelegate: ((String) -> Void)?
    
    init(config: MerchDetailsConfigurator) {
        self.merchPic = FormRowDescriptor(tag: "MerchPic", type: .button,
                                          title: NSLocalizedString("MerchPic", comment: "New entry of product."))
        self.merchName = FormRowDescriptor(tag: "MerchName", type: .text,
                                           title: NSLocalizedString("MerchName", comment: "New entry of product."))
        self.merchPrice = FormRowDescriptor(tag: "MerchPrice", type: .decimal,
                                            title: NSLocalizedString("MerchPrice", comment: "New entry of product."))
        self.merchQty = FormRowDescriptor(tag: "MerchQty", type: .number,
                                          title: NSLocalizedString("MerchQty", comment: "New entry of product."))
        self.merchRemark = FormRowDescriptor(tag: "MerchRemark", type: .text,
                                             title: NSLocalizedString("MerchRemark", comment: "New entry of product."))
        self.actionType = config.action
        
        self.currentMerchName = config.merchName
        self.inventory = config.inventory
        self.onSelectRowDelegate = config.onSelectRow
        
        super.init(nibName: nil, bundle: nil)
        
        let section = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        
        let tempView = UIView()
        tempView.backgroundColor = .clear
        section.headerView = tempView
        section.footerView = tempView
        
        self.form = FormDescriptor(title: NSLocalizedString("NewMerch", comment: "Label for new product."))
        self.form.sections.append(section)
        
        self.merchPic.configuration.cell.cellClass = MerchImageCell.self
        
        section.rows = {
            if self.actionType == .edit {
                return [self.merchPic,
                        self.merchPrice,
                        self.merchQty,
                        self.merchRemark]
            } else if self.actionType == .add {
                return [self.merchPic,
                        self.merchName,
                        self.merchPrice,
                        self.merchQty,
                        self.merchRemark]
            } else {
                return [self.merchPic,
                        self.merchName,
                        self.merchPrice,
                        self.merchQty,
                        self.merchRemark]
            }
        }()
        
        if self.actionType == .edit {
            guard let merchDetails = self.inventory?.getMerch(name: self.currentMerchName ?? "") else {
                fatalError()
            }
            self.merchPrice.value = String(merchDetails.price) as AnyObject
            self.merchQty.value = String(merchDetails.qty) as AnyObject
            self.merchRemark.value = merchDetails.remark as AnyObject
        }
        
        self.form.sections = [section]
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
//        self.view.backgroundColor = .white
    }
    
    @objc private func submitMerchDetails () {
        if self.actionType == .edit {
            self.submitNewDetails()
        } else if self.actionType == .add {
            self.submitNewMerch()
        }
    }
    
    private func makeMerchDetails(name: String) -> MerchDetails {
        let parsedPrice = Double(self.merchPrice.value as? String ?? "") ?? 0.0
        let parsedQty = Int(self.merchQty.value as? String ?? "") ?? 0
        
        return (name: name, price: parsedPrice, qty: parsedQty, remark: (self.merchRemark.value as? String) ?? "", image: self.merchPic.value as? UIImage)
    }
    
    private func submitNewMerch() {
        guard let merchNameText = self.merchName.value as? String else {
            // alertBox
            let errorMessage = NSLocalizedString("ErrorMerchInputEmpty", comment: "Error Message - Merch name text field .")
            self.present(UIAlertController.makeError(message: errorMessage), animated: true, completion: nil)
            return
        }
        
        let merchDetails = self.makeMerchDetails(name: merchNameText)
        
        self.inventory?.existsMerch(name: merchNameText,
                                    completion: { [weak self] exists in
                                        guard let `self` = self else { return }
                                        if exists {
                                            let errorMessage = NSLocalizedString("ErrorMerchExists", comment: "Error Message - Merch exists with the same name.")
                                            self.present(UIAlertController.makeError(message: errorMessage), animated: true, completion: nil)
                                        } else {
                                            self.inventory?.addMerch(details: merchDetails)
                                            if let delegate = self.onSelectRowDelegate {
                                                delegate(merchNameText)
                                            } else {
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        }
        })
    }
    
    private func submitNewDetails() {
        guard let merchNameText = self.currentMerchName else {
            fatalError()
        }
        
        let merchDetails = self.makeMerchDetails(name: merchNameText)
        
        self.inventory?.editMerch(details: merchDetails,
                                  completion: {
                                    self.navigationController?.popViewController(animated: true)
        })
    }
    
}

