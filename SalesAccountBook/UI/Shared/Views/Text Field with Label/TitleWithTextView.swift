//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithTextView: DescWithText {
    
    override var text: String {
        get {
            return (self.textView as? UITextView)?.text ?? ""
        }
        
        set {
            self.placeholderLabel.isHidden = newValue != ""
            (self.textView as? UITextView)?.text = newValue
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
    
    init(title: String, placeholder: String = "", spacing: CGFloat = 0, textAlign: NSTextAlignment = .left) {
        let tagView = UILabel()
        let textView = UITextView()
        
        self.defaultPlaceholder = placeholder
        self.placeholderLabel = UILabel()
        
        super.init(tagView: tagView, textView: textView)
        
        self.spacing = spacing
        
        textView.delegate = self
        
        tagView.text = title
        tagView.textAlignment = .left
        tagView.numberOfLines = 0
        
        textView.textContainer.heightTracksTextView = true
        textView.textContainer.widthTracksTextView = false
        textView.textAlignment = textAlign
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.font = UITextField().font
        textView.textContainerInset = .init(top: 10.515, left: 0, bottom: 10.515, right: 0)
        textView.inputAccessoryView = UIToolbar.makeKeyboardToolbar(target: self, doneAction: #selector(self.unfocusTextView))
        
        self.placeholderLabel.text = self.defaultPlaceholder
        self.placeholderLabel.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.3)
        self.placeholderLabel.textAlignment = .left
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        self.placeholderLabel.backgroundColor = .clear
    }
    
    override func setupLayout() {
        self.addSubview(self.descView)
        self.descView.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        })
        
        self.addSubview(self.textView)
        self.textView.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.descView.snp.right).offset(self.spacing)
        })
        
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.textView)
        }
    }
    
    @objc func unfocusTextView() {
        self.textView.resignFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TitleWithTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let isAtBeginning: Bool = (textView.selectedTextRange?.start == textView.beginningOfDocument)
        
        let isDeletingLastChar: Bool = (textView.text.count == 1) //1 Charater remaining
            && (text == "") // is deleting action
            && !isAtBeginning // cursor is not at beginning
        
        let isDeletingNothing: Bool = (textView.text.count == 0) //
            && (text == "")
        
        if isDeletingLastChar || isDeletingNothing {
            self.placeholderLabel.isHidden = false
        } else {
            self.placeholderLabel.isHidden = true
        }
        return true
    }
}
