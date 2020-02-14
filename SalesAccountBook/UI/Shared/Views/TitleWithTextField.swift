//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithTextField: UIView {
    
    let title: UILabel
    let textField: UITextField
    var text: String {
        get {
            return self.textField.text ?? ""
        }
        
        set {
            self.textField.text = newValue
        }
    }
    
    var spacing: CGFloat {
        didSet {
            self.textField.snp.updateConstraints { make in
                make.left.equalTo(self.title.snp.right).offset(self.spacing)
            }
            self.layoutIfNeeded()
        }
    }
    
    private let maxTextLength: Int
    
    init(title: String, placeholder: String = "", textAlign: NSTextAlignment = .left, maxTextLength: Int = .max) {
        self.title = UILabel()
        self.textField = UITextField()
        self.spacing = 5
        self.maxTextLength = maxTextLength
        
        super.init(frame: .zero)
        
        self.addSubview(self.title)
        self.title.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        })
        self.title.text = title
        self.title.textAlignment = .left
        self.title.numberOfLines = 0
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(focusTextField))
        self.title.isUserInteractionEnabled = true
        self.title.addGestureRecognizer(tapGest)
        
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.title.snp.right).offset(self.spacing)
        })
        
        self.textField.placeholder = placeholder
        self.textField.textAlignment = textAlign
        self.textField.delegate = self
        
    }
    
    @objc func focusTextField() {
        self.textField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TitleWithTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text?.count ?? 0 < self.maxTextLength || string == ""
    }
}
