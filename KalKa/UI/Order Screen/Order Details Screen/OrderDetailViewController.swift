//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class OrderDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    private let customerCard: CustomerDescCard
    private let orderStatusControlSection: InputFieldsSection
    private let orderInfoFieldsSection: InputFieldsSection
    private let orderItemStackView: OrderDetailsStackView
    
    weak var orderList: OrderList?
    var currentCustomerId: String?
    
    var orderItemDetailsArr: [OrderItemDetails]
    
    let betweenCellPadding = Constants.UI.Spacing.Height.Medium * 0.75
    
    var isClosed: Bool
    
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
            TitleWithTextView(title: .remark, placeholder: .optional, spacing: Constants.UI.Spacing.Width.Medium)
        ])
        
        let orderToggleBtn = UIButton()
        let delOrderBtn = UIButton()
        
        self.orderStatusControlSection = InputFieldsSection(fields: [
            OrderDetailsStatusIcons(),
            orderToggleBtn,
            delOrderBtn
        ])
        
        self.customerCard = CustomerDescCard()
        
        let orderItemAddBtn = OrderItemAddBtn()
        self.orderItemStackView = OrderDetailsStackView(fields: [
            orderItemAddBtn
        ])
        
        self.orderList = config.viewModel as? OrderList
        self.orderItemDetailsArr = []
        
        super.init(config: config)
        
        if self.actionType == .add {
            guard let nextId = self.orderList?.getNextId() else {
                fatalError("Unable to retrieve next id.")
            }
            self.currentId = nextId
        } else {
            self.currentId = config.id
        }
        
        orderNumberField.value = "#\(self.currentId)"
        orderNumberField.valueView.alpha = 0.5
        
        if self.actionType == .add {
            orderToggleBtn.removeFromSuperview()
        } else {
            orderToggleBtn.setTitleColor(.buttonIcon, for: .normal)
            let btnTitle = self.isClosed ? "Return order" : "Close order"
            orderToggleBtn.setTitle(btnTitle, for: .normal)
            orderToggleBtn.isEnabled = (config.action == .edit)
            orderToggleBtn.alpha = (config.action == .edit) ? 1 : 0.5
            orderToggleBtn.addTarget(self, action: #selector(self.toggleOrder), for: .touchUpInside)
            orderToggleBtn.translatesAutoresizingMaskIntoConstraints = false
            orderToggleBtn.heightAnchor.constraint(equalToConstant: Constants.UI.Sizing.Height.TextFieldDefault).isActive = true
        }
        
        if self.isClosed || self.actionType == .add {
            delOrderBtn.removeFromSuperview()
        } else {
            delOrderBtn.setTitleColor(.red, for: .normal)
            delOrderBtn.setTitle("Delete order", for: .normal)
            delOrderBtn.isEnabled = (config.action == .edit)
            delOrderBtn.alpha = (config.action == .edit) ? 1 : 0.5
            delOrderBtn.addTarget(self, action: #selector(self.deleteOrder), for: .touchUpInside)
            delOrderBtn.translatesAutoresizingMaskIntoConstraints = false
            delOrderBtn.heightAnchor.constraint(equalToConstant: Constants.UI.Sizing.Height.TextFieldDefault).isActive = true
        }
        
        if self.isClosed {
            orderItemAddBtn.removeFromSuperview()
            self.customerCard.isUserInteractionEnabled = !isClosed
        } else {
            orderItemAddBtn.delegate = self
            self.customerCard.delegate = self
        }
        
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
        
        if self.isClosed {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateCustomerCard()
    }
    
    private func fillCustomerCard(customer: Customer) {
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
    
    private func updateCustomerCard() {
        let customerList = CustomerList()
        
        if let id = self.currentCustomerId,
            let customer = customerList.getCustomer(id: id) {
            self.fillCustomerCard(customer: customer)
        }
    }
    
    private func insertNewOrderItemView(orderItem: OrderItemDetails) {
        let orderItemView = OrderItemView()
        orderItemView.nameLabel.text = orderItem.name
        orderItemView.priceField.textField.text = String(orderItem.price)
        orderItemView.qtyField.textField.text = String(orderItem.qty)
        orderItemView.delegate = self
        orderItemView.updatePriceTotal()
        
        orderItemView.priceField.textField.isUserInteractionEnabled = !self.isClosed
        orderItemView.qtyField.textField.isUserInteractionEnabled = !self.isClosed
        orderItemView.delBtn.isHidden = self.isClosed
        
        self.orderItemDetailsArr.append(orderItem)
        self.orderItemStackView.appendView(view: orderItemView)
    }
    
    private func appendOrderItem(id: String) {
        let inventory = Inventory()
        
        if let merchDet = inventory.getDetails(id: id) as? MerchDetails {
            let orderItemDet = OrderItemDetails(name: merchDet.name, qty: 1, price: merchDet.price)
            self.insertNewOrderItemView(orderItem: orderItemDet)
            
            DispatchQueue.main.async {
                if self.scrollView.contentSize.height > self.scrollView.frame.height {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.mimimumBottomInset), animated: true)
                }
            }
        }
    }
    
    private func prefillFieldsForEdit() {
        guard let orderDetails = self.orderList?.getDetails(id: self.currentId) as? OrderDetails else {
            fatalError("Unable to retrieve data.")
        }
        
        let valueMap: [String: String] = [
            .orderNumber: orderDetails.number,
            .remark: orderDetails.remark,
            .openedOn: orderDetails.openedOn.toString(format: Constants.System.DateFormat)
        ]
        
        self.orderInfoFieldsSection.prefillValues(values: valueMap)
        self.orderInfoFieldsSection.stackView.arrangedSubviews.forEach({ [weak self] view in
            guard let `self` = self else { return }
            view.isUserInteractionEnabled = !self.isClosed
        })
        
        self.currentCustomerId = orderDetails.customerName
        self.updateCustomerCard()
        
        if let items = orderDetails.items {
            for item in items {
                self.insertNewOrderItemView(orderItem: item)
            }
        }
        
        if let statusView = self.orderStatusControlSection.getViews(viewType: OrderDetailsStatusIcons.self).first as? OrderDetailsStatusIcons {
            statusView.isPreped = orderDetails.isPreped
            statusView.isShipped = orderDetails.isShipped
            statusView.isDeposit = orderDetails.isDeposit
            statusView.isPaid = orderDetails.isPaid
            
            statusView.iconStack.arrangedSubviews.forEach({ [weak self] view in
                guard let `self` = self else { return }
                view.alpha = self.isClosed ? 0.5 : 1
                view.isUserInteractionEnabled = !self.isClosed
            })
        }
    }
    
    @objc func deleteOrder() {
        let handler: (UIAlertAction) -> Void = { [weak self] alert in
            guard let `self` = self else { return }
            self.orderList?.removeOrder(id: self.currentId, completion: { isDeleted in
                if isDeleted {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        
        let confirmationAlert = UIAlertController.makeConfirmation(confirmHandler: handler)
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    @objc func toggleOrder() {
        let handler: (UIAlertAction) -> Void = { [weak self] alert in
            guard let `self` = self else { return }
            if !self.allFieldsIsValid { return }
            self.isClosed = !self.isClosed
            self.editItem(details: self.makeDetails())
        }
        let confirmationAlert = UIAlertController.makeConfirmation(confirmHandler: handler)
        self.present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func setup() {
        self.view.backgroundColor = .background
        
        self.scrollView.addSubview(self.customerCard)
        self.customerCard.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
        }
        self.customerCard.backgroundColor = .primary
        self.customerCard.clipsToBounds = true
        
        self.scrollView.addSubview(self.orderStatusControlSection)
        self.orderStatusControlSection.snp.makeConstraints { make in
            make.top.equalTo(self.customerCard.snp.bottom).offset(Constants.UI.Spacing.Height.Medium * 0.75)
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
        
        self.scrollView.addSubview(self.orderItemStackView)
        self.orderItemStackView.snp.makeConstraints { make in
            make.top.equalTo(self.orderInfoFieldsSection.snp.bottom).offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.bottom.equalToSuperview()
        }
        self.orderItemStackView.backgroundColor = .primary
        self.orderItemStackView.clipsToBounds = true
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.customerCard.layer.cornerRadius = self.customerCard.frame.width / 24
            self.orderStatusControlSection.layer.cornerRadius = self.orderStatusControlSection.frame.width / 24
            self.orderInfoFieldsSection.layer.cornerRadius = self.orderInfoFieldsSection.frame.width / 24
            self.orderItemStackView.layer.cornerRadius = self.orderItemStackView.frame.width / 24
        }
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    override func validateFields() -> Bool {
        guard let details = self.makeDetails() as? OrderDetails else {
            self.present(UIAlertController.makeError(message: .unexpectedErrorMsg, errorCode: .detailsCastingFailure), animated: true, completion: nil)
            return false
        }
        
        if details.customerName == "" {
            self.present(UIAlertController.makeError(message: NSLocalizedString("ErrorOrderNoCustomer", comment: "Error Message.")), animated: true, completion: nil)
            return false
        }
        
        if details.items?.isEmpty ?? false {
            self.present(UIAlertController.makeError(message: NSLocalizedString("ErrorOrderNoOrderItem", comment: "Error Message.")), animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    override func makeDetails() -> ModelDetails {
        let extractedCustomerName: String = {
            let customerList = CustomerList()
            if let id = self.currentCustomerId,
                let customer = customerList.getCustomer(id: id) {
                return customer.name
            } else {
                return ""
            }
        }()
        
        let extractedInfo = self.orderInfoFieldsSection.extractValues(mappingKeys: [.remark,
                                                                                    .openedOn])
        let statusView = self.orderStatusControlSection.getViews(viewType: OrderDetailsStatusIcons.self).first as? OrderDetailsStatusIcons
        
        let orderDetailsViews = self.orderItemStackView.getViews(viewType: OrderItemView.self) as? [OrderItemView]
        let latestDetails: [OrderItemDetails] = orderDetailsViews?.compactMap({ v in
            let name = v.nameLabel.text
            let qty = Int32(v.qtyField.textField.text ?? "0") ?? 0
            let price = Double(v.priceField.textField.text ?? "0") ?? 0
            return OrderItemDetails(name: name ?? "",
                                    qty: qty,
                                    price: price)
        }) ?? []
        
        return OrderDetails(
            number: self.currentId,
            remark: extractedInfo[.remark] ?? "",
            openedOn: extractedInfo[.openedOn]?.toDate(format: Constants.System.DateFormat) ?? Date(),
            isShipped: statusView?.isShipped ?? false,
            isPreped: statusView?.isPreped ?? false,
            isPaid: statusView?.isPaid ?? false,
            isDeposit: statusView?.isDeposit ?? false,
            isClosed: self.isClosed,
            customerName: extractedCustomerName,
            items: latestDetails
        )
    }
}

extension OrderDetailViewController: DataPicker {
    
    func pickCustomer() {
        let onSelectRowHandler: (String) -> Void = { [weak self] customerName in
            guard let `self` = self else { return }
            self.currentCustomerId = customerName
            self.updateCustomerCard()
            self.navigationController?.popToViewController(self, animated: true)
        }
        
        let prefillIds = [self.currentCustomerId ?? ""]
        
        let customerPicker = CustomerViewController(onSelectRow: onSelectRowHandler, preFilterIds: prefillIds)
        self.navigationController?.pushViewController(customerPicker, animated: true)
    }
    
    func pickOrderItem() {
        let onSelectRowHandler: (String) -> Void = { [weak self] merchName in
            guard let `self` = self else { return }
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
