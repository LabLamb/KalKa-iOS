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
    
    init(title: String, placeholder: String = "", textAlign: NSTextAlignment = .left) {
        self.title = UILabel()
        self.textView = UITextView()
        self.spacing = 5
        
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
        
        self.textView.textColor = UIColor.lightGray
        
        self.textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        
        self.textView.textAlignment = textAlign
        self.textView.isScrollEnabled = false
//        self.textView.textContainerInset.left = .zero
        self.textView.textContainer.lineFragmentPadding = 0
    }
    
    @objc func focusTextView() {
        self.textView.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
