//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import PNPForm

class OrderDetailViewController: DetailFormViewController {
    
    // MARK: - Variables
    private let customerCard: CustomerDescCard
    private let orderStatusControlForm: PNPForm
    private let orderInfoForm: PNPForm
    private let orderItemStack: PNPForm
    private let deleteButton: UIButton
    
    weak var orderList: OrderList?
    var currentCustomerId: String?
    
    var orderItemDetailsArr: [OrderItemDetails]
    
    let betweenCellPadding = Constants.UI.Spacing.Height.Medium * 0.75
    
    var isClosed: Bool
    
    // MARK: - Initializion
    init(config: OrderDetailsConfigurator) {
        self.isClosed = config.isClosed
        
        let orderNumberField = PNPRow(title: .orderNumber, config: PNPRowConfig(type: .label))
        orderNumberField.isUserInteractionEnabled = false
        
        self.orderInfoForm = PNPForm(rows: [
            orderNumberField,
            PNPRow(title: .openedOn, config: PNPRowConfig(type: .date(Constants.System.DateFormat),
                                                          placeholder: Date().toString(format: Constants.System.DateFormat))),
            PNPRow(title: .remark, config: PNPRowConfig(type: .multilineText(), placeholder: .optional))
        ], separatorColor: .background)
        
        let orderToggleBtn = UIButton()
        self.deleteButton = UIButton()
        
        self.orderStatusControlForm = PNPForm(rows: [
            OrderDetailsStatusIcons(),
            orderToggleBtn
        ], separatorColor: .background)
        
        self.customerCard = CustomerDescCard()
        
        let orderItemAddBtn = OrderItemAddBtn()
        self.orderItemStack = PNPForm(rows: [orderItemAddBtn], separatorColor: .background)
        
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
        
        if self.actionType == .add {
            orderToggleBtn.removeFromSuperview()
        } else {
            orderToggleBtn.setTitleColor(.buttonIcon, for: .normal)
            let btnTitle: String = self.isClosed ? .returnOrder : .closeOrder
            orderToggleBtn.setTitle(btnTitle, for: .normal)
            orderToggleBtn.isEnabled = (config.action == .edit)
            orderToggleBtn.alpha = (config.action == .edit) ? 1 : 0.5
            orderToggleBtn.addTarget(self, action: #selector(self.toggleOrder), for: .touchUpInside)
            orderToggleBtn.translatesAutoresizingMaskIntoConstraints = false
            orderToggleBtn.heightAnchor.constraint(equalToConstant: Constants.UI.Sizing.Height.TextFieldDefault).isActive = true
        }
        
        if self.isClosed || self.actionType == .add {
            self.deleteButton.isHidden = true
        } else {
            self.deleteButton.setTitleColor(.red, for: .normal)
            self.deleteButton.setTitle(.deleteOrder, for: .normal)
            self.deleteButton.isEnabled = (config.action == .edit)
            self.deleteButton.alpha = (config.action == .edit) ? 1 : 0.5
            self.deleteButton.addTarget(self, action: #selector(self.deleteOrder), for: .touchUpInside)
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
        self.orderItemStack.appendView(view: orderItemView)
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
            .orderNumber: "#\(orderDetails.number)",
            .remark: orderDetails.remark,
            .openedOn: orderDetails.openedOn.toString(format: Constants.System.DateFormat)
        ]
        
        self.orderInfoForm.prefillRows(titleValueMap: valueMap)
        self.orderInfoForm.getRows().forEach({ [weak self] row in
            guard let `self` = self else { return }
            row.isUserInteractionEnabled = !self.isClosed
        })
        
        self.currentCustomerId = orderDetails.customerName
        self.updateCustomerCard()
        
        if let items = orderDetails.items {
            for item in items {
                self.insertNewOrderItemView(orderItem: item)
            }
        }
        
        if let statusView = self.orderStatusControlForm.getViews(withViewClass: OrderDetailsStatusIcons.self).first as? OrderDetailsStatusIcons {
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
        
        self.scrollView.addSubview(self.orderStatusControlForm)
        self.orderStatusControlForm.snp.makeConstraints { make in
            make.top.equalTo(self.customerCard.snp.bottom).offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
        }
        self.orderStatusControlForm.backgroundColor = .primary
        self.orderStatusControlForm.clipsToBounds = true
        
        self.scrollView.addSubview(self.orderInfoForm)
        self.orderInfoForm.snp.makeConstraints { make in
            make.top.equalTo(self.orderStatusControlForm.snp.bottom).offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
        }
        self.orderInfoForm.backgroundColor = .primary
        self.orderInfoForm.clipsToBounds = true
        
        self.scrollView.addSubview(self.orderItemStack)
        self.orderItemStack.snp.makeConstraints { make in
            make.top.equalTo(self.orderInfoForm.snp.bottom).offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
        }
        self.orderItemStack.backgroundColor = .primary
        self.orderItemStack.clipsToBounds = true
        
        self.scrollView.addSubview(self.deleteButton)
        self.deleteButton.snp.makeConstraints { make in
            make.top.equalTo(self.orderItemStack.snp.bottom).offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
            make.bottom.equalToSuperview()
        }
        self.deleteButton.backgroundColor = .primary
        self.deleteButton.clipsToBounds = true
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.customerCard.layer.cornerRadius = self.customerCard.frame.width / 24
            self.orderStatusControlForm.layer.cornerRadius = self.orderStatusControlForm.frame.width / 24
            self.orderInfoForm.layer.cornerRadius = self.orderInfoForm.frame.width / 24
            self.orderItemStack.layer.cornerRadius = self.orderItemStack.frame.width / 24
            self.deleteButton.layer.cornerRadius = self.deleteButton.frame.width / 24
        }
        
        if self.actionType == .edit {
            self.prefillFieldsForEdit()
        }
    }
    
    
    // MARK: - Data
    override func validateFields() -> Bool {
        guard let details = self.makeDetails() as? OrderDetails else {
            self.present(UIAlertController.makeError(message: .unexpectedErrorMsg), animated: true, completion: nil)
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
        
        let extractedInfo = self.orderInfoForm.extractRowValues(withLabelTextList: [.remark, .openedOn])
        let statusView = self.orderStatusControlForm.getViews(withViewClass: OrderDetailsStatusIcons.self).first as? OrderDetailsStatusIcons
        
        let orderDetailsViews = self.orderItemStack.getViews(withViewClass: OrderItemView.self) as? [OrderItemView]
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
            self.navigationController?.popToViewController(self, animated: true)
            self.updateCustomerCard()
        }
        
        let prefillIds = [self.currentCustomerId ?? ""]
        
        let customerPicker = CustomerViewController(onSelectRow: onSelectRowHandler, preFilterIds: prefillIds)
        self.navigationController?.pushViewController(customerPicker, animated: true)
    }
    
    func pickOrderItem() {
        let onSelectRowHandler: (String) -> Void = { [weak self] merchName in
            guard let `self` = self else { return }
            self.navigationController?.popToViewController(self, animated: true)
            self.appendOrderItem(id: merchName)
        }
        let prefillIds = self.orderItemDetailsArr.compactMap({ $0.name })
        
        let merchPicker = InventoryViewController(onSelectRow: onSelectRowHandler, preFilterIds: prefillIds)
        
        self.navigationController?.pushViewController(merchPicker, animated: true)
    }
    
    func removeOrderItem(id: String) {
        self.orderItemDetailsArr = self.orderItemDetailsArr.filter({ $0.name != id })
    }
}
