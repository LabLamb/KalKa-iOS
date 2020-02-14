//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithTextView: UIView {
    
    let title: UILabel
    let textView: UITextView
    var text: String {
        get {
            return self.textView.text ?? ""
        }
        
        set {
            self.textView.text = newValue
        }
    }
    
    var spacing: CGFloat {
        didSet {
            self.textView.snp.updateConstraints { make in
                make.left.equalTo(self.title.snp.right).offset(self.spacing)
            }
            self.layoutIfNeeded()
        }
    }
    
    private let placeholder: String
    
    init(title: String, placeholder: String = "", textAlign: NSTextAlignment = .left) {
        self.title = UILabel()
        self.textView = UITextView()
        self.spacing = 5
        self.placeholder = placeholder
        
        super.init(frame: .zero)
        
        self.addSubview(self.title)
        self.title.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        })
        self.title.text = title
        self.title.textAlignment = .left
        self.title.numberOfLines = 0
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(focusTextView))
        self.title.isUserInteractionEnabled = true
        self.title.addGestureRecognizer(tapGest)
        
        self.addSubview(self.textView)
        self.textView.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.title.snp.right).offset(self.spacing)
        })
        
        self.textView.text = self.placeholder
        self.textView.textColor = UIColor.lightGray
        
        self.textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        
        self.textView.textAlignment = textAlign
        self.textView.isScrollEnabled = false
        self.textView.delegate = self
    }
    
    @objc func focusTextView() {
        self.textView.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TitleWithTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }
        
        return false
    }
}
