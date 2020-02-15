//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerFieldsContainer: CustomView {
    
    let customerPic: IconView
    let customerName: TitleWithTextField
    let customerPhone: TitleWithTextField
    let customerAddress: TitleWithTextView
    let customerRemark: TitleWithTextView
    let lastContacted: TitleWithDatePicker
    
    override init() {
        self.customerPic = IconView(image: #imageLiteral(resourceName: "AvatarDefault"))
        
        self.customerName = TitleWithTextField(title: NSLocalizedString("Name", comment: ""),
                                               placeholder: NSLocalizedString("Required(Input)", comment: "Must input."), maxTextLength: 24)
        self.customerPhone = TitleWithTextField(title: NSLocalizedString("Phone", comment: ""),
                                                placeholder: NSLocalizedString("Optional(Input)", comment: "Can leave blank."), maxTextLength: 11)
        self.customerAddress = TitleWithTextView(title: NSLocalizedString("Address", comment: ""),
                                                 placeholder: NSLocalizedString("Optional(Input)", comment: "Can leave blank."))
        self.customerRemark = TitleWithTextView(title: NSLocalizedString("Remark", comment: ""),
                                                placeholder: NSLocalizedString("Optional(Input)", comment: "Can leave blank."))
        self.lastContacted = TitleWithDatePicker(title: NSLocalizedString("LastContacted", comment: "Date of last contact."),
                                                 placeholder: NSLocalizedString("Optional(Input)", comment: "Can leave blank."))
        
        super.init()
        
        
        self.customerPic.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        self.customerPic.backgroundColor = .white
        
        self.customerName.textField.clearButtonMode = .never
        self.customerName.backgroundColor = .white
        self.customerName.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.customerPhone.textField.clearButtonMode = .never
        self.customerPhone.textField.keyboardType = .phonePad
        self.customerPhone.backgroundColor = .white
        self.customerPhone.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.customerAddress.textView.textContainerInset = .init(top: 10.5, left: 0, bottom: 10.5, right: 0)
        self.customerAddress.backgroundColor = .white
        self.customerAddress.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        self.customerAddress.textView.font = UITextField().font
        
        self.customerRemark.textView.textContainerInset = .init(top: 10.515, left: 0, bottom: 10.515, right: 0)
        self.customerRemark.backgroundColor = .white
        self.customerRemark.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        self.customerRemark.textView.font = UITextField().font
        
        self.lastContacted.textField.clearButtonMode = .never
        self.lastContacted.backgroundColor = .white
        self.lastContacted.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
    }
    
    override func setupLayout() {
        self.addSubview(self.customerPic)
        self.customerPic.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(Constants.UI.Sizing.Height.Medium)
        }
        
        self.addSubview(self.customerName)
        self.customerName.snp.makeConstraints { make in
            make.top.equalTo(self.customerPic.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
        }
        
        self.addSubview(self.customerPhone)
        self.customerPhone.snp.makeConstraints { make in
            make.top.equalTo(self.customerName.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
        }
        
        self.addSubview(self.customerAddress)
        self.customerAddress.snp.makeConstraints { make in
            make.top.equalTo(self.customerPhone.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
        }
        
        self.addSubview(self.customerRemark)
        self.customerRemark.snp.makeConstraints { make in
            make.top.equalTo(self.customerAddress.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
        }
        
        self.addSubview(self.lastContacted)
        self.lastContacted.snp.makeConstraints { make in
            make.top.equalTo(self.customerRemark.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
