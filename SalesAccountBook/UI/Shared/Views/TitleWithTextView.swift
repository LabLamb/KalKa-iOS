//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithTextView: CustomView {
    
    let title: UILabel
    let textView: UITextView
    var text: String {
        get {
            return self.textView.text ?? ""
        }
        
        set {
            self.textView.text = newValue
            if newValue != "" {
                self.placeholderLabel.isHidden = true
            }
        }
    }
    
    var spacing: CGFloat {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    let defaultPlaceholder: String
    let placeholderLabel: UILabel
    
    init(title: String, placeholder: String = "", textAlign: NSTextAlignment = .left) {
        self.title = UILabel()
        self.textView = UITextView()
        self.spacing = 5
        self.defaultPlaceholder = placeholder
        self.placeholderLabel = UILabel()
        
        super.init()
        
        self.textView.delegate = self
        
        
        self.title.text = title
        self.title.textAlignment = .left
        self.title.numberOfLines = 0
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(focusTextView))
        self.title.isUserInteractionEnabled = true
        self.title.addGestureRecognizer(tapGest)
        
        
        self.textView.textAlignment = textAlign
        self.textView.isScrollEnabled = false
        self.textView.textContainer.lineFragmentPadding = 0
        
        self.placeholderLabel.text = self.defaultPlaceholder
        self.placeholderLabel.textColor = UIColor(red: 0.24, green: 0.24, blue: 0.26, alpha: 0.3)
        self.placeholderLabel.textAlignment = .left
        self.placeholderLabel.font = UIFont.systemFont(ofSize: 17)
        self.placeholderLabel.backgroundColor = .clear
    }
    
    override func setupLayout() {
        self.addSubview(self.title)
        self.title.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        })
        
        self.addSubview(self.textView)
        self.textView.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.title.snp.right).offset(self.spacing)
        })
        
        self.addSubview(self.placeholderLabel)
        self.placeholderLabel.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(self.textView)
        }
    }
    
    @objc func focusTextView() {
        self.textView.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TitleWithTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return false
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" && textView.text.count <= 1 {
            self.placeholderLabel.isHidden = false
        } else {
            self.placeholderLabel.isHidden = true
        }
        return true
    }
}
