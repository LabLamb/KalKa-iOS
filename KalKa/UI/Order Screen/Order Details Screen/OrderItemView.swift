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
    
    lazy var multipleSign: UILabel = {
        let result = UILabel()
        result.font = UITextField().font
        result.text = "✕"
        result.textAlignment = .center
        return result
    }()
    
    lazy var priceField: TextFieldWithPrefix = {
        let tf = UITextField()
        tf.delegate = self
        tf.text = "1"
        tf.keyboardType = .decimalPad
        tf.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        tf.textAlignment = .right
        
        let result = TextFieldWithPrefix(prefix: "$", textField: tf)
        return result
    }()
    
    lazy var qtyField: TextFieldWithPrefix = {
        let tf = UITextField()
        tf.delegate = self
        tf.text = "1"
        tf.keyboardType = .decimalPad
        tf.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        tf.textAlignment = .right
        
        let result = TextFieldWithPrefix(prefix: "$", textField: tf)
        result.prefixLabel.text = ""
        return result
    }()
    
    lazy var totalLabel: TextFieldWithPrefix = {
        let tf = UITextField()
        tf.delegate = self
        tf.text = "1"
        tf.textAlignment = .right
        tf.isUserInteractionEnabled = false
        
        if let priceValue = Double(self.priceField.textField.text ?? "0"),
            let qtyValue = Double(self.qtyField.textField.text ?? "0") {
            let totalValue = priceValue * qtyValue
            tf.text = totalValue.toLocalCurrency(fractDigits: 2)
        }
        
        let result = TextFieldWithPrefix(prefix: "$", textField: tf)
        return result
    }()
    
    lazy var delBtn: UIButton = {
        let result = UIButton()
        let trashImg = UIImage(named: "Trash") ?? UIImage()
        result.setImage(trashImg.withRenderingMode(.alwaysTemplate), for: .normal)
        result.imageView?.tintColor = .buttonIcon
        result.addTarget(self, action: #selector(self.remove), for: .touchUpInside)
        return result
    }()
    
    var delegate: DataPicker?
    
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
            make.width.equalTo(Constants.UI.Sizing.Width.Medium * 0.85)
        }
        
        self.addSubview(self.priceField)
        self.priceField.snp.makeConstraints { make in
            make.right.equalTo(self.qtyField.snp.left).offset(-Constants.UI.Spacing.Width.ExLarge)
            make.top.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
            make.width.equalTo(Constants.UI.Sizing.Width.Medium * 0.85)
        }
        
        self.addSubview(self.multipleSign)
        self.multipleSign.snp.makeConstraints { make in
            make.left.equalTo(self.priceField.snp.right)
            make.right.equalTo(self.qtyField.snp.left)
            make.top.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Small)
            make.right.equalTo(self.priceField.snp.left).offset(-Constants.UI.Spacing.Width.Small)
            make.top.equalToSuperview()
            make.bottom.equalTo(self.snp.centerY)
        }
        
        self.addSubview(self.totalLabel)
        self.totalLabel.snp.makeConstraints { make in
            make.left.equalTo(self.priceField.snp.left)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
            make.top.equalTo(self.snp.centerY)
            make.bottom.equalToSuperview()
        }
        
        self.addSubview(self.delBtn)
        self.delBtn.snp.makeConstraints { make in
            make.top.equalTo(self.snp.centerY)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Small)
            make.bottom.equalToSuperview()
//            make.right.equalTo(self.priceField.snp.left)
        }
    }
    
    @objc func remove() {
        self.delegate?.removeOrderItem(id: self.nameLabel.text ?? "")
        self.removeFromSuperview()
    }
}

extension OrderItemView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text?.count ?? 0 < 7 || string == ""
    }
    
    @objc func textFieldDidChange() {
        if let priceValue = Double(self.priceField.textField.text ?? "0"),
            let qtyValue = Double(self.qtyField.textField.text ?? "0") {
            let totalValue = priceValue * qtyValue
            self.totalLabel.textField.text = totalValue.toLocalCurrency(fractDigits: 2)
        }
    }
}
