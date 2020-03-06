//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

//class IconWithTextView: TagWithText {
//    
//    let icon: UIImageView
//    let textView: UITextView
//    var text: String {
//        get {
//            return self.textView.text ?? ""
//        }
//        
//        set {
//            self.textView.text = newValue
//        }
//    }
//    
//    var spacing: CGFloat {
//        didSet {
//            self.layoutIfNeeded()
//        }
//    }
//    
//    override var intrinsicContentSize: CGSize {
//        get {
//            return CGSize(width: 0, height: Constants.UI.Sizing.Height.TextFieldDefault)
//        }
//    }
//    
//    init(icon: UIImage, text: String = "", textAlign: NSTextAlignment = .left) {
//        self.icon = UIImageView(image: icon)
//        self.textView = UITextView()
//        self.spacing = 0
//        
//        super.init()
//        
//        self.textView.isEditable = false
//        self.textView.isSelectable = false
//        self.textView.isUserInteractionEnabled = false
//        self.textView.isScrollEnabled = false
//        self.textView.text = text
//        self.textView.textAlignment = textAlign
//        self.textView.textContainerInset = .zero
//        self.textView.textContainer.lineFragmentPadding = 0
//        self.textView.backgroundColor = .clear
//    }
//    
//    override func setupLayout() {
//        self.addSubview(self.icon)
//        self.icon.snp.makeConstraints({ make in
//            make.top.left.equalToSuperview()
//            make.height.equalToSuperview().dividedBy(2)
//            make.width.equalTo(self.icon.snp.height)
//        })
//        
//        self.addSubview(self.textView)
//        self.textView.snp.makeConstraints({ make in
//            make.top.right.bottom.equalToSuperview()
//            make.left.equalTo(self.icon.snp.right).offset(self.spacing)
//        })
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
