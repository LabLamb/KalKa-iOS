//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithTextView: DescWithValue {
    
    override var value: String {
        get {
            return (self.valueView as? UITextView)?.text ?? ""
        }
        
        set {
            self.placeholderLabel.isHidden = newValue != ""
            (self.valueView as? UITextView)?.text = newValue
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
    
    let defaultPlaceholder: String
    let placeholderLabel: UILabel
    
    init(title: String, placeholder: String = "", spacing: CGFloat = 0, inputKeyboardType: UIKeyboardType = .default, textAlign: NSTextAlignment = .left) {
        let tagView = UILabel()
        let textView = UITextView()
        
        self.defaultPlaceholder = placeholder
        self.placeholderLabel = UILabel()
        
        super.init(descView: tagView, valueView: textView, spacing: spacing)
        
        textView.delegate = self
        
        tagView.text = title
        tagView.textAlignment = .left
        tagView.numberOfLines = 0
        tagView.backgroundColor = .clear
        
        textView.textContainer.heightTracksTextView = true
        textView.textContainer.widthTracksTextView = false
        textView.textAlignment = textAlign
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.font = UITextField().font
        textView.textContainerInset = .init(top: 10.515, left: 0, bottom: 10.515, right: 0)
        textView.inputAccessoryView = UIToolbar.makeKeyboardToolbar(target: self, doneAction: #selector(self.unfocusTextView))
        textView.backgroundColor = .clear
        textView.keyboardType = inputKeyboardType
        
        self.placeholderLabel.text = self.defaultPlaceholder
        self.placeholderLabel.textColor = {
            let tempUITextField = UITextField()
            tempUITextField.placeholder = "temp"
            let inspect = tempUITextField.attributedPlaceholder!
            return inspect.attribute(NSAttributedString.Key.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        }()
        self.placeholderLabel.textAlignment = .left
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        self.placeholderLabel.backgroundColor = .clear
    }
    
    override func setupLayout() {
        self.addSubview(self.descView)
        self.descView.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(Constants.UI.Sizing.Width.Medium * 1.25)
        })
        
        self.addSubview(self.valueView)
        self.valueView.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.descView.snp.right).offset(self.spacing)
        })
        
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.valueView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TitleWithTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let isDeletingAll: Bool = (range.length == textView.text.count) && (text == "")
        self.placeholderLabel.isHidden = !isDeletingAll
        return true
    }
}
