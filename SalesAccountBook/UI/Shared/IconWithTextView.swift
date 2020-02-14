//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class IconWithTextView: UIView {
    
    let icon: UIImageView
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
                make.left.equalTo(self.icon.snp.right).offset(self.spacing)
            }
            self.layoutIfNeeded()
        }
    }
    
    init(icon: UIImage, text: String = "", textAlign: NSTextAlignment = .left) {
        self.icon = UIImageView(image: icon)
        self.textView = UITextView()
        self.spacing = 0
        
        super.init(frame: .zero)
        
        self.addSubview(self.icon)
        self.icon.snp.makeConstraints({ make in
            make.top.left.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)
            make.width.equalTo(self.icon.snp.height)
        })
        
        self.addSubview(self.textView)
        self.textView.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.icon.snp.right).offset(self.spacing)
        })
        
        self.textView.isEditable = false
        self.textView.isSelectable = false
        self.textView.isUserInteractionEnabled = false
        self.textView.isScrollEnabled = false
        self.textView.text = text
        self.textView.textAlignment = textAlign
        self.textView.textContainerInset = .zero
        self.textView.textContainer.lineFragmentPadding = 0
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
