//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerFieldsContainer: UIView {
    
    let customerPic: CustomerIconView
    let customerName: TitleWithTextField
    let customerPhone: TitleWithTextField
    let customerAddress: TitleWithTextField
    let customerRemark: TitleWithTextField
    let lastContacted: TitleWithDatePicker
    
    init() {
        self.customerPic = CustomerIconView()
        self.customerName = TitleWithTextField(title: NSLocalizedString("Name", comment: ""))
        self.customerPhone = TitleWithTextField(title: NSLocalizedString("Phone", comment: ""))
        self.customerAddress = TitleWithTextField(title: NSLocalizedString("Address", comment: ""))
        self.customerRemark = TitleWithTextField(title: NSLocalizedString("Remark", comment: ""))
        self.lastContacted = TitleWithDatePicker(title: NSLocalizedString("LastContacted", comment: "Date of last contact."))
        
        super.init(frame: .zero)
    }
    
    public func setup() {
        self.addSubview(self.customerPic)
        self.customerPic.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            if let superView = self.superview {
                make.height.equalTo(superView).dividedBy(5)
            }
        }
        self.customerPic.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        self.customerPic.backgroundColor = .white
        DispatchQueue.main.async {
            self.customerPic.iconImage.clipsToBounds = true
            self.customerPic.iconImage.layer.cornerRadius = self.customerPic.iconImage.frame.width / 2
        }
        
        self.addSubview(self.customerName)
        self.customerName.snp.makeConstraints { make in
            make.top.equalTo(self.customerPic.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.height.equalTo(44)
        }
        self.customerName.textField.clearButtonMode = .whileEditing
        self.customerName.backgroundColor = .white
        self.customerName.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.addSubview(self.customerPhone)
        self.customerPhone.snp.makeConstraints { make in
            make.top.equalTo(self.customerName.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.height.equalTo(44)
        }
        self.customerPhone.textField.clearButtonMode = .whileEditing
        self.customerPhone.textField.keyboardType = .numberPad
        self.customerPhone.backgroundColor = .white
        self.customerPhone.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.addSubview(self.customerAddress)
        self.customerAddress.snp.makeConstraints { make in
            make.top.equalTo(self.customerPhone.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.height.equalTo(44)
        }
        self.customerAddress.textField.clearButtonMode = .whileEditing
        self.customerAddress.backgroundColor = .white
        self.customerAddress.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.addSubview(self.customerRemark)
        self.customerRemark.snp.makeConstraints { make in
            make.top.equalTo(self.customerAddress.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.height.equalTo(44)
        }
        self.customerRemark.textField.clearButtonMode = .whileEditing
        self.customerRemark.backgroundColor = .white
        self.customerRemark.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.addSubview(self.lastContacted)
        self.lastContacted.snp.makeConstraints { make in
            make.top.equalTo(self.customerRemark.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
        self.lastContacted.textField.clearButtonMode = .whileEditing
        self.lastContacted.backgroundColor = .white
        self.lastContacted.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.setupPlaceholders()
    }
    
    private func setupPlaceholders() {
        self.customerName.textField.placeholder = NSLocalizedString("Required(Input)", comment: "Must input.")
        self.customerPhone.textField.placeholder = NSLocalizedString("Optional(Input)", comment: "Can leave blank.")
        self.customerAddress.textField.placeholder = NSLocalizedString("Optional(Input)", comment: "Can leave blank.")
        self.customerRemark.textField.placeholder = NSLocalizedString("Optional(Input)", comment: "Can leave blank.")
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
