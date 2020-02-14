//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class MerchFieldsContainer: UIView {
    
    let merchPic: IconView
    let merchName: TitleWithTextField
    let merchPrice: TitleWithTextField
    let merchQty: TitleWithTextField
    let merchRemark: TitleWithTextField
    
    init() {
        self.merchPic = IconView(image: #imageLiteral(resourceName: "MerchDefault"))
        self.merchName = TitleWithTextField(title: NSLocalizedString("Name", comment: "Name of product."))
        self.merchPrice = TitleWithTextField(title: NSLocalizedString("Price", comment: "Price of product."))
        self.merchQty = TitleWithTextField(title: NSLocalizedString("Qty", comment: "Quantity of product."))
        self.merchRemark = TitleWithTextField(title: NSLocalizedString("Remark", comment: "Remark of product."))
        
        super.init(frame: .zero)
    }
    
    public func setup() {
        self.addSubview(self.merchPic)
        self.merchPic.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(Constants.UI.Sizing.Height.Medium)
        }
        self.merchPic.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        self.merchPic.backgroundColor = .white
        DispatchQueue.main.async {
            self.merchPic.iconImage.clipsToBounds = true
            self.merchPic.iconImage.layer.cornerRadius = self.merchPic.iconImage.frame.width / 2
        }
        
        self.addSubview(self.merchName)
        self.merchName.snp.makeConstraints { make in
            make.top.equalTo(self.merchPic.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
        }
        self.merchName.textField.clearButtonMode = .whileEditing
        self.merchName.backgroundColor = .white
        self.merchName.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.addSubview(self.merchPrice)
        self.merchPrice.snp.makeConstraints { make in
            make.top.equalTo(self.merchName.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
        }
        self.merchPrice.textField.clearButtonMode = .whileEditing
        self.merchPrice.textField.keyboardType = .numberPad
        self.merchPrice.backgroundColor = .white
        self.merchPrice.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.addSubview(self.merchQty)
        self.merchQty.snp.makeConstraints { make in
            make.top.equalTo(self.merchPrice.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
        }
        self.merchQty.textField.clearButtonMode = .whileEditing
        self.merchQty.textField.keyboardType = .numberPad
        self.merchQty.backgroundColor = .white
        self.merchQty.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.addSubview(self.merchRemark)
        self.merchRemark.snp.makeConstraints { make in
            make.top.equalTo(self.merchQty.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
            make.bottom.equalToSuperview()
        }
        self.merchRemark.textField.clearButtonMode = .whileEditing
        self.merchRemark.backgroundColor = .white
        self.merchRemark.addLine(position: .LINE_POSITION_BOTTOM, color: .groupTableViewBackground, width: 1)
        
        self.setupPlaceholders()
    }
    
    private func setupPlaceholders() {
        self.merchName.textField.placeholder = NSLocalizedString("Required(Input)", comment: "Must input.")
        self.merchPrice.textField.placeholder = NSLocalizedString("Optional(Input)", comment: "Can leave blank.")
        self.merchQty.textField.placeholder = NSLocalizedString("Optional(Input)", comment: "Can leave blank.")
        self.merchRemark.textField.placeholder = NSLocalizedString("Optional(Input)", comment: "Can leave blank.")
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
