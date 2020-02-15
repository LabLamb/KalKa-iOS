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
            (self.textView as? UITextView)?.text = newValue
        }
    }
    
    let defaultPlaceholder: String
    let placeholderLabel: UILabel
    
    init(title: String, placeholder: String = "", textAlign: NSTextAlignment = .left) {
        let tagView = UILabel()
        let textView = UITextView()
        
        self.defaultPlaceholder = placeholder
        self.placeholderLabel = UILabel()
        
        super.init(tagView: tagView, textView: textView)
        
        textView.delegate = self
        
        tagView.text = title
        tagView.textAlignment = .left
        tagView.numberOfLines = 0
        
        textView.textAlignment = textAlign
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        
        self.placeholderLabel.text = self.defaultPlaceholder
        self.placeholderLabel.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.3)
        self.placeholderLabel.textAlignment = .left
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        self.placeholderLabel.backgroundColor = .clear
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.textView)
        }
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
