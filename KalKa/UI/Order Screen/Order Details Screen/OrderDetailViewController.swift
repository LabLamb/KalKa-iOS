//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class OrderDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    private let customerCard: CustomerDescCard
    private let orderStatusControlSection: InputFieldsSection
    private let orderInfoFieldsSection: InputFieldsSection
    private let orderItemTableView: OrderDetailsStackView
    
    let actionType: DetailsViewActionType
    weak var orderList: OrderList?
    var currentCustomerId: String?
    
    var orderItemDetailsArr: [OrderItemDetails] = [
        OrderItemDetails(name: "test", qty: 1, price: 1)
    ]
    
    let betweenCellPadding = Constants.UI.Spacing.Height.Medium * 0.75
    
    let isClosed: Bool
    
    // MARK: - Initializion
    override init(config: DetailsConfiguration) {
        
        if let orderConfig = config as? OrderDetailsConfigurator {
            self.isClosed = orderConfig.isClosed
        } else {
            self.isClosed = false
        }
        
        let orderNumberField = TitleWithTextLabel(title: .orderNumber, spacing: Constants.UI.Spacing.Width.Medium)
        
        self.orderInfoFieldsSection = InputFieldsSection(fields: [
            orderNumberField,
            TitleWithDatePicker(title: .openedOn, placeholder: .optional, spacing: Constants.UI.Spacing.Width.Medium),
//            TitleWithSwitch(title: .deposited, spacing: Constants.UI.Spacing.Width.Medium),
//            TitleWithSwitch(title: .paid, spacing: Constants.UI.Spacing.Width.Medium),
//            TitleWithSwitch(title: .shipped, spacing: Constants.UI.Spacing.Width.Medium),
            TitleWithTextView(title: .remark, placeholder: .optional, spacing: Constants.UI.Spacing.Width.Medium)
        ])
        
        let tempBtn = UIButton()
        tempBtn.setTitleColor(.buttonIcon, for: .normal)
        tempBtn.setTitle("Mark as closed", for: .normal)
        tempBtn.isEnabled = false
        tempBtn.alpha = 0.5
        
        tempBtn.translatesAutoresizingMaskIntoConstraints = false
        tempBtn.heightAnchor.constraint(equalToConstant: Constants.UI.Sizing.Height.TextFieldDefault).isActive = true
        
        self.orderStatusControlSection = InputFieldsSection(fields: [
            OrderDetailsStatusIcons(),
            tempBtn
        ])
        
        self.customerCard = CustomerDescCard()
        
        let orderItemAddBtn = OrderItemAddBtn()
        self.orderItemTableView = OrderDetailsStackView(fields: [
            orderItemAddBtn
        ])
        
        self.actionType = config.action
        self.orderList = config.viewModel as? OrderList
        
        super.init(config: config)
        
        guard let nextId = self.orderList?.getNextId() else {
            fatalError("Unable to retrieve next id.")
        }
        
        if self.actionType == .add {
            orderNumberField.value = "#\(nextId)"
        } else {
            orderNumberField.value = "#\(self.currentId)"
        }
        orderNumberField.valueView.alpha = 0.5
        
        self.customerCard.delegate = self
        orderItemAddBtn.delegate = self
        
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
                return "\(String.edit) \(self.currentId)"
            } else if self.actionType == .add {
                return NSLocalizedString("NewOrder", comment: "New entry of product.")
            } else {
                return ""
            }
        }()
        
        self.navigationItem.rightBarButtonItem = {
            if self.isClosed {
                return UIBarButtonItem(title: .reopen, style: .done, target: self, action: #selector(self.submitOrderDetails))
            } else {
                return UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.submitOrderDetails))
            }
        }()
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fillCustomerCard()
    }
    
    private func fillCustomerCard() {
        let customerList = CustomerList()
        
        if let id = self.currentCustomerId,
            let customer = customerList.getCustomer(id: id) {
            
            self.customerCard.placeholder.isHidden = true
            self.customerCard.nameLabel.text = customer.name
            self.customerCard.addressLabel.text = customer.address
            self.customerCard.phoneLabel.text = customer.phone == "" ? .absent : customer.phone
            self.customerCard.icon.backgroundColor = .accent
            
            let customerImage: UIImage? = {
                if let imgData = customer.image {
                    return UIImage(data: imgData)
                } else {
                    return nil
                }
            }()
            
            self.customerCard.icon.image = customerImage ?? #imageLiteral(resourceName: "AvatarDefault")
            
            self.customerCard.setupLayout()
        }
    }
    
    private func appendOrderItem(id: String) {
        let inventory = Inventory()
        
        if let orderItem = inventory.getDetails(id: id) as? MerchDetails {
            let orderItemView = OrderItemView()
            orderItemView.nameLabel.text = orderItem.name
            orderItemView.priceField.textField.text = String(orderItem.price)
            orderItemView.delegate = self
            
            self.orderItemDetailsArr.append(OrderItemDetails(name: orderItem.name, qty: 1, price: orderItem.price))
            self.orderItemTableView.appendView(view: orderItemView)
        }
    }
    
    private func prefillFieldsForEdit() {
        //        guard let orderDetails = self.orderList?.getDetails(id: self.currentId ?? "") as? OrderDetails else {
        //            fatalError()
        //        }
        
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
        
        self.scrollView.addSubview(self.customerCard)
        self.customerCard.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.height.equalTo((Constants.UI.Sizing.Height.Small * 1.25))
        }
        self.customerCard.backgroundColor = .primary
        self.customerCard.clipsToBounds = true
        
        self.scrollView.addSubview(self.orderStatusControlSection)
        self.orderStatusControlSection.snp.makeConstraints { make in
            make.top.equalTo(self.customerCard.snp.bottom).offset(Constants.UI.Spacing.Height.Medium * 0.75)
//            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault * 2)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
        }
        self.orderStatusControlSection.backgroundColor = .primary
        self.orderStatusControlSection.clipsToBounds = true
        
        self.scrollView.addSubview(self.orderInfoFieldsSection)
        self.orderInfoFieldsSection.snp.makeConstraints { make in
            make.top.equalTo(self.orderStatusControlSection.snp.bottom).offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
        }
        self.orderInfoFieldsSection.backgroundColor = .primary
        self.orderInfoFieldsSection.clipsToBounds = true
        
        self.scrollView.addSubview(self.orderItemTableView)
        self.orderItemTableView.snp.makeConstraints { make in
            make.top.equalTo(self.orderInfoFieldsSection.snp.bottom).offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.bottom.equalToSuperview()
        }
        self.orderItemTableView.backgroundColor = .primary
        self.orderItemTableView.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.customerCard.layer.cornerRadius = self.customerCard.frame.width / 24
            self.orderStatusControlSection.layer.cornerRadius = self.orderStatusControlSection.frame.width / 24
            self.orderInfoFieldsSection.layer.cornerRadius = self.orderInfoFieldsSection.frame.width / 24
            self.orderItemTableView.layer.cornerRadius = self.orderItemTableView.frame.width / 24
        }
        
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
        let extractedValues = self.orderInfoFieldsSection.extractValues(mappingKeys: [])
        
        let extractedCustomer = Customer()
        
        return OrderDetails(
            number: extractedValues[.orderNumber] ?? "",
            remark: extractedValues[.remark] ?? "",
            openedOn: extractedValues[.openedOn]?.toDate(format: Constants.System.DateFormat) ?? Date(),
            isShipped: false,
            isPreped: false,
            isPaid: false,
            isDeposit: false,
            isClosed: false,
            customerName: extractedCustomer.name,
            items: self.orderItemDetailsArr
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

extension OrderDetailViewController: DataPicker {
    
    func pickCustomer() {
        
        let onSelectRowHandler: (String) -> Void = { customerName in
            self.currentCustomerId = customerName
            self.fillCustomerCard()
            self.navigationController?.popToViewController(self, animated: true)
        }
        
        let prefillIds = [self.currentCustomerId ?? ""]
        
        let customerPicker = CustomerViewController(onSelectRow: onSelectRowHandler, preFilterIds: prefillIds)
        self.navigationController?.pushViewController(customerPicker, animated: true)
    }
    
    func pickOrderItem() {
        let onSelectRowHandler: (String) -> Void = { merchName in
            self.appendOrderItem(id: merchName)
            self.navigationController?.popToViewController(self, animated: true)
        }
        let prefillIds = self.orderItemDetailsArr.compactMap({ $0.name })
        
        let merchPicker = InventoryViewController(onSelectRow: onSelectRowHandler, preFilterIds: prefillIds)
        
        self.navigationController?.pushViewController(merchPicker, animated: true)
    }
    
    func removeOrderItem(id: String) {
        self.orderItemDetailsArr = self.orderItemDetailsArr.filter({ $0.name != id })
    }
}
