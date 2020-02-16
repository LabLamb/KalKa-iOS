//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class DescWithText: CustomView {
    
    internal var descView: UIView
    internal var textView: UIView
    
    var desc: Any {
        get {
            return ""
        }
    }
    
    var text: String {
        get {
            return ""
        }
        
        set {
        }
    }
    
    var spacing: CGFloat {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    init(tagView: UIView, textView: UIView) {
        self.descView = tagView
        self.textView = textView
        self.spacing = 0
        
        super.init()
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(focusTextView))
        self.descView.isUserInteractionEnabled = true
        self.descView.addGestureRecognizer(tapGest)
    }
    
    override func setupLayout() {
        
        self.addSubview(self.descView)
        self.descView.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
        })
        
        self.addSubview(self.textView)
        self.textView.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.descView.snp.right).offset(self.spacing)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func focusTextView() {
        self.textView.becomeFirstResponder()
    }
    
    @objc func unfocusTextView() {
        self.textView.resignFirstResponder()
    }
    
}
