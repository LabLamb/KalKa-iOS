//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithTextLabel: DescWithValue {
    
    override var value: String {
        get {
            return (self.valueView as? UILabel)?.text ?? ""
        }

        set {
            (self.valueView as? UILabel)?.text = newValue
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
    
    private let maxTextLength: Int
    
    init(title: String, spacing: CGFloat = 0, inputKeyboardType: UIKeyboardType = .default, textAlign: NSTextAlignment = .left, maxTextLength: Int = .max) {
        let tagView = UILabel()
        let textView = UILabel()
        self.maxTextLength = maxTextLength
        
        super.init(tagView: tagView, textView: textView)
        
        self.spacing = spacing
        
        tagView.text = title
        tagView.textAlignment = .left
        tagView.numberOfLines = 0
        
        textView.textAlignment = textAlign
    }
    
    override func setupLayout() {
        self.addSubview(self.descView)
        self.descView.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        })
        
        self.addSubview(self.valueView)
        self.valueView.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.descView.snp.right).offset(self.spacing)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
