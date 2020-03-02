//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class OrderItemView: CustomView {
    
    lazy var nameLabel: UILabel = {
        let result = UILabel()
        result.font = UITextField().font
        result.text = "波波醬"
        return result
    }()
    
    lazy var dollarSignOne: UILabel = {
        let result = UILabel()
        result.font = UITextField().font
        result.text = "$"
        result.textAlignment = .center
        return result
    }()
    
    lazy var dollarSignTwo: UILabel = {
        let result = UILabel()
        result.font = UITextField().font
        result.text = "$"
        result.textAlignment = .center
        return result
    }()
    
    lazy var multipleSign: UILabel = {
        let result = UILabel()
        result.font = UITextField().font
        result.text = "✕"
        result.textAlignment = .center
        return result
    }()
    
    lazy var priceField: UITextField = {
        let result = UITextField()
        result.delegate = self
        result.text = "1"
        result.keyboardType = .decimalPad
        result.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        result.textAlignment = .right
        return result
    }()
    
    lazy var qtyField: UITextField = {
        let result = UITextField()
        result.delegate = self
        result.text = "1"
        result.keyboardType = .numberPad
        result.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        result.textAlignment = .right
        return result
    }()
    
    lazy var totalLabel: UILabel = {
        let result = UILabel()
        result.font = UITextField().font
        if let priceValue = Double(self.priceField.text ?? "0"),
            let qtyValue = Double(self.qtyField.text ?? "0") {
            let totalValue = priceValue * qtyValue
            result.text = totalValue.toLocalCurrency(fractDigits: 2)
        }
        result.textAlignment = .right
        return result
    }()
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height: Constants.UI.Sizing.Height.TextFieldDefault * 2)
        }
    }
    
    override func setupLayout() {
        
        self.addSubview(self.qtyField)
        self.qtyField.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
            make.top.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
            make.width.equalTo(Constants.UI.Sizing.Width.Medium * 0.75)
        }
        
        self.addSubview(self.priceField)
        self.priceField.snp.makeConstraints { make in
            make.right.equalTo(self.qtyField.snp.left).offset(-Constants.UI.Spacing.Width.ExLarge)
            make.top.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
            make.width.equalTo(Constants.UI.Sizing.Width.Medium * 0.75)
        }
        
        self.addSubview(self.multipleSign)
        self.multipleSign.snp.makeConstraints { make in
            make.left.equalTo(self.priceField.snp.right)
            make.right.equalTo(self.qtyField.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        
        self.addSubview(self.dollarSignOne)
        self.dollarSignOne.snp.makeConstraints { make in
            make.right.equalTo(self.priceField.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
            make.width.equalTo(self.dollarSignOne.snp.height)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Small)
            make.right.equalTo(self.dollarSignOne.snp.left).offset(-Constants.UI.Spacing.Width.Small)
            make.top.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        
        self.addSubview(self.dollarSignTwo)
        self.dollarSignTwo.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Small)
            make.top.equalTo(self.snp.centerY)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(self.totalLabel)
        self.totalLabel.snp.makeConstraints { make in
            make.left.equalTo(self.dollarSignTwo.snp.right)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
            make.top.equalTo(self.snp.centerY)
            make.bottom.equalToSuperview()
        }
        
    }
}

extension OrderItemView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text?.count ?? 0 < 7 || string == ""
    }
    
    @objc func textFieldDidChange() {
        if let priceValue = Double(self.priceField.text ?? "0"),
            let qtyValue = Double(self.qtyField.text ?? "0") {
            let totalValue = priceValue * qtyValue
            self.totalLabel.text = totalValue.toLocalCurrency(fractDigits: 2)
        }
    }
}
