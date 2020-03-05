//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class IconWithTextLabel: DescWithValue {
    
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
    
    let iconImage: UIImageView
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height: Constants.UI.Sizing.Height.TextFieldDefault)
        }
    }
    
    private let maxTextLength: Int
    
    init(icon: UIImage, placeholder: String = "",
         spacing: CGFloat = 0, inputKeyboardType: UIKeyboardType = .default,
         textAlign: NSTextAlignment = .left, maxTextLength: Int = .max) {
        let tagView = UIView()
        let textView = UILabel()
        
        self.maxTextLength = maxTextLength
        self.iconImage = UIImageView(image: icon)
        
        super.init(descView: tagView, valueView: textView, spacing: spacing)
        
        self.iconImage.tintColor = .text
        
        textView.textAlignment = textAlign
        textView.font = UITextField().font
    }
    
    override func setupLayout() {
        self.addSubview(self.descView)
        self.descView.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(self.descView.snp.height)
        })
        
        self.descView.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.centerY.left.equalToSuperview()
            make.height.equalTo(UITextField().font?.lineHeight ?? 0 )
            make.width.equalTo(self.iconImage.snp.height)
        }
        
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
