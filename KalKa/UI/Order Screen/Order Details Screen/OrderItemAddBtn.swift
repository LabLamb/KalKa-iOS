//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class OrderItemAddBtn: CustomView {
    
    lazy var addLabel: IconWithTextLabel = {
        let plusImg = UIImage(named: "Plus") ?? UIImage()
        let result = IconWithTextLabel(icon: plusImg.withRenderingMode(.alwaysTemplate), spacing: -Constants.UI.Spacing.Width.Medium * 1.5)
        result.value = "Order item"
        (result.valueView as? UILabel)?.font = UITextField().font
        (result.valueView as? UILabel)?.textColor = .buttonIcon
        result.iconImage.tintColor = .buttonIcon
        return result
    }()
    
    weak var delegate: DataPicker?
    
    override init() {
        super.init()
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.pickMerch))
        self.addGestureRecognizer(tapGest)
        self.isUserInteractionEnabled = true
        
        self.addLabel.isUserInteractionEnabled = false
    }
    
    @objc func pickMerch() {
        self.delegate?.pickOrderItem()
    }
    
    deinit {
        self.delegate = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height: Constants.UI.Sizing.Height.TextFieldDefault)
        }
    }
    
    override func setupLayout() {
        self.addSubview(self.addLabel)
        self.addLabel.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}
