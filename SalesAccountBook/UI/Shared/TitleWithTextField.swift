//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithTextField: UIView {
    
    let title: UILabel
    let textField: UITextField
    
    var spacing: CGFloat {
        didSet {
            self.textField.snp.updateConstraints { make in
                make.left.equalTo(self.title.snp.right).offset(self.spacing)
            }
            self.layoutIfNeeded()
        }
    }
    
    init(title: String, placeholder: String = "", textAlign: NSTextAlignment = .left) {
        self.title = UILabel()
        self.textField = UITextField()
        self.spacing = 0
        
        super.init(frame: .zero)
        
        self.addSubview(self.title)
        self.title.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        })
        self.title.text = title
        self.title.textAlignment = .left
        
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
        
    }
    
    @objc func focusTextField() {
        self.textField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
