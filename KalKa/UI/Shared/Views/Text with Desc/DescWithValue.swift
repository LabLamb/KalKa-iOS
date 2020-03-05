//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class DescWithValue: CustomView {
    
    internal var descView: UIView
    internal var valueView: UIView
    
    var desc: Any {
        get {
            return ""
        }
    }
    
    var value: String {
        get {
            return ""
        }
        
        set {
        }
    }
    
    var spacing: CGFloat
    
    init(descView: UIView, valueView: UIView, spacing: CGFloat) {
        self.descView = descView
        self.valueView = valueView
        self.spacing = spacing
        
        super.init()
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(focusTextView))
        self.descView.isUserInteractionEnabled = true
        self.descView.addGestureRecognizer(tapGest)
    }
    
    override func setupLayout() {
        self.addSubview(self.descView)
        self.descView.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(self.descView.snp.height)
        })
        self.descView.backgroundColor = .clear
        
        self.addSubview(self.valueView)
        self.valueView.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.descView.snp.right).offset(self.spacing)
        })
        self.valueView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func focusTextView() {
        self.valueView.becomeFirstResponder()
    }
    
    @objc func unfocusTextView() {
        self.valueView.resignFirstResponder()
    }
    
}
