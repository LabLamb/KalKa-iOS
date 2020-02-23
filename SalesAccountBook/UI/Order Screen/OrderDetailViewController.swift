//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class OrderDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    private let orderInfoFieldsSection: InputFieldsSection
    private let custInfoFieldsSection: InputFieldsSection
    private let orderItemInfoFieldsSectino: InputFieldsSection
    
    let actionType: DetailsViewActionType
    weak var orderList: OrderList?
    
    // MARK: - Initializion
    override init(config: DetailsConfigurator) {
        
        self.orderInfoFieldsSection = InputFieldsSection(fields: [])
        self.custInfoFieldsSection = InputFieldsSection(fields: [])
        self.orderItemInfoFieldsSectino = InputFieldsSection(fields: [])
        
        self.actionType = config.action
        self.orderList = config.viewModel as? OrderList
        
        super.init(config: config)
    
        self.itemExistsErrorMsg = NSLocalizedString("ErrorOrderExists", comment: "Error Message - Order exists with the same name.")
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = {
            if self.actionType == .edit {
                return "\(String.edit) \(self.currentId ?? "")"
            } else if self.actionType == .add {
                return NSLocalizedString("NewOrder", comment: "New entry of product.")
            } else {
                return ""
            }
        }()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.submitOrderDetails))
        
        self.setup()
    }
    
    private func prefillFieldsForEdit() {
        guard let orderDetails = self.orderList?.getDetails(id: self.currentId ?? "") as? OrderDetails else {
            fatalError()
        }
        
//        let valueMap: [String: String] = [
//            .number: orderDetails.number,
//            .phone: orderDetails.phone,
//            .address: orderDetails.address,
//            .remark: orderDetails.remark,
//            .lastContacted: orderDetails.lastContacted.toString(format: Constants.System.DateFormat),
//        ]
//
//        let iconView = self.inputFieldsSection.getView(viewType: IconView.self).first as? IconView
//        if orderDetails.image != nil {
//            iconView?.iconImage.image = orderDetails.image
//        }
//
//        self.inputFieldsSection.prefillValues(values: valueMap)
    }
    
    private func setup() {
        self.view.backgroundColor = .background
        
//        self.scrollView.addSubview(self.inputFieldsSection)
//        self.inputFieldsSection.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
//            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
//            make.bottom.equalToSuperview()
//        }
//        self.inputFieldsSection.backgroundColor = .primary
//        self.inputFieldsSection.clipsToBounds = true
//
//        DispatchQueue.main.async {
//            self.inputFieldsSection.layer.cornerRadius = self.inputFieldsSection.frame.width / 24
//        }
//
//        (self.inputFieldsSection.getView(viewType: IconView.self).first as? IconView)?.cameraOptionPresenter = self
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    @objc private func submitOrderDetails () {
//        let orderDetails = self.makeOrderDetails()
//        if orderDetails.name == "" {
//            if let textField = self.inputFieldsSection
//                .getView(labelText: .name) as? TitleWithTextField {
//                self.promptEmptyFieldError(errorMsg: NSLocalizedString("ErrorOrderInputEmpty", comment: "Error Message - Order name text field ."), field: textField.textView as! UITextField)
//            }
//            return
//        }
//
//        let handler: (UIAlertAction) -> Void = { [weak self] alert in
//            guard let `self` = self else { return }
//            if self.actionType == .edit {
//                self.editItem(details: orderDetails)
//            } else if self.actionType == .add {
//                self.addOrder(orderDetails: orderDetails)
//            }
//        }
//
//        let confirmationAlert = UIAlertController.makeConfirmation(confirmHandler: handler)
//
//        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func makeOrderDetails() -> OrderDetails {
        let extractedValues = self.orderInfoFieldsSection.extractValues(valMapping: [])
        
        let extractedItems = [OrderItem]()
        let extractedCustomer = Customer()
        
        return (
            number: extractedValues[.orderNumber] ?? "",
            remark: extractedValues[.remark] ?? "",
            openedOn: extractedValues[.openedOn]?.toDate(format: Constants.System.DateFormat) ?? Date(),
            isShipped: false,
            isPaid: false,
            isDeposit: false,
            isClosed: false,
            customerName: extractedCustomer.name,
            items: extractedItems
        )

        
    }
    
    private func addOrder(orderDetails: OrderDetails) {
        self.orderList?.add(details: orderDetails, completion: { success in
            if !success {
                self.promptItemExistsError()
            }
        })
        self.navigationController?.popViewController(animated: true)
    }
}
