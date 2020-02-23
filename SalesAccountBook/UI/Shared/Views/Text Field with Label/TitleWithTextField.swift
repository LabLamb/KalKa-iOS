//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithTextField: DescWithValue {
    
    override var value: String {
        get {
            return (self.valueView as? UITextField)?.text ?? ""
        }

        set {
            (self.valueView as? UITextField)?.text = newValue
        }
    }
    
    override var desc: Any {
        get {
            return (self.descView as? UILabel)?.text ?? ""
        }
        
        set {
            (self.descView as? UILabel)?.text = newValue as? String
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height: Constants.UI.Sizing.Height.TextFieldDefault)
        }
    }
    
    private let maxTextLength: Int
    
    init(title: String, placeholder: String = "", spacing: CGFloat = 0, inputKeyboardType: UIKeyboardType = .default, textAlign: NSTextAlignment = .left, maxTextLength: Int = .max) {
        let tagView = UILabel()
        let textView = UITextField()
        self.maxTextLength = maxTextLength
        
        super.init(tagView: tagView, textView: textView)
        
        self.spacing = spacing
        
        tagView.text = title
        tagView.textAlignment = .left
        tagView.numberOfLines = 0
        
        textView.keyboardType = inputKeyboardType
        textView.placeholder = placeholder
        textView.textAlignment = textAlign
        textView.delegate = self
        textView.inputAccessoryView = UIToolbar.makeKeyboardToolbar(target: self, doneAction: #selector(self.unfocusTextView))
    }
    
    override func setupLayout() {
        self.addSubview(self.descView)
        self.descView.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        })
        
        self.addSubview(self.valueView)
        self.valueView.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.descView.snp.right).offset(self.spacing)
        })
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
