//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import SwiftForms

class NewMerchViewController: FormViewController {
    
    let merchName: FormRowDescriptor
    let merchPic: FormRowDescriptor
    let merchPrice: FormRowDescriptor
    let merchQty: FormRowDescriptor
    let merchRemark: FormRowDescriptor
    weak var inventory: Inventory?
    var onSelectRowDelegate: ((String) -> Void)?
    
    init(inventory: Inventory?, onSelectRow: ((String) -> Void)? = nil) {
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
        self.inventory = inventory
        self.onSelectRowDelegate = onSelectRow
        
        super.init(nibName: nil, bundle: nil)
        
        let section = FormSectionDescriptor(headerTitle: nil, footerTitle: nil)
        let tempView = UIView()
        tempView.backgroundColor = .groupTableViewBackground
        section.headerView = tempView
        section.footerView = tempView
        self.form = FormDescriptor(title: NSLocalizedString("NewMerch", comment: "Label for new product."))
        self.form.sections.append(section)
        
        self.merchPic.configuration.cell.cellClass = MerchImageCell.self
        
        section.rows = [self.merchPic,
                        self.merchName,
                        self.merchPrice,
                        self.merchQty,
                        self.merchRemark]
        
        self.form.sections = [section]
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = NSLocalizedString("NewMerch", comment: "New entry of product.")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Save", comment: "The action of storing data on disc."), style: .done, target: self, action: #selector(self.submitNewMerch))
        self.view.backgroundColor = .groupTableViewBackground
    }
    
    @objc private func submitNewMerch() {
        guard let merchNameText = self.merchName.value as? String else {
            // alertBox
            let errorMessage = NSLocalizedString("ErrorMerchInputEmpty", comment: "Error Message - Merch name text field .")
            self.present(UIAlertController.makeError(message: errorMessage), animated: true, completion: nil)
            return
        }
        
        let parsedPrice = Double(self.merchPrice.value as? String ?? "") ?? 0.0
        let parsedQty = Int(self.merchQty.value as? String ?? "") ?? 0
        
        let merchDetails = (name: merchNameText, price: parsedPrice, qty: parsedQty, remark: (self.merchRemark.value as? String) ?? "", image: self.merchPic.value as? UIImage)
        
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
    
}

