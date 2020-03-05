//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithSwitch: DescWithValue {
    
    override var value: String {
        get {
            return String(self.isChecked)
        }

        set {
            self.isChecked = newValue.boolValue
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
    
    let checkedImage: UIImageView
    
    var isChecked: Bool {
        didSet {
            if self.isChecked {
                self.checkedImage.image = UIImage(named: "CheckMark")
            } else {
                self.checkedImage.image = UIImage()
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height: Constants.UI.Sizing.Height.TextFieldDefault)
        }
    }
    
    private let maxTextLength: Int
    
    init(title: String, placeholder: String = "",
         spacing: CGFloat = 0, inputKeyboardType: UIKeyboardType = .default,
         textAlign: NSTextAlignment = .left, maxTextLength: Int = .max) {
        let tagView = UILabel()
        tagView.text = title
        tagView.textAlignment = .left
        tagView.numberOfLines = 0
        
        let switchView = UIButton()
        self.isChecked = false
        
        self.maxTextLength = maxTextLength
        self.checkedImage = UIImageView()
        
        super.init(descView: tagView, valueView: switchView, spacing: spacing)
    
        self.checkedImage.tintColor = .buttonIcon
        
        switchView.addTarget(self, action: #selector(self.focusTextView), for: .touchUpInside)
    }
    
    override func setupLayout() {
        self.addSubview(self.descView)
        self.descView.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(Constants.UI.Sizing.Width.Medium * 1.25)
        })
        
        self.addSubview(self.valueView)
        self.valueView.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.descView.snp.right).offset(self.spacing)
        })
        
        self.valueView.addSubview(self.checkedImage)
        self.checkedImage.snp.makeConstraints { make in
            make.centerY.left.equalToSuperview()
            make.height.equalTo(UITextField().font?.lineHeight ?? 0 )
            make.width.equalTo(self.checkedImage.snp.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func focusTextView() {
        self.isChecked = !self.isChecked
    }
}
