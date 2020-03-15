//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import PNPForm

class OrderItemAddBtn: CustomView {
    
    lazy var addLabel: IconWithTextLabel = {
        let plusImg = UIImage(named: "Plus") ?? UIImage()
        let textField = PNPTextField()
        let result = IconWithTextLabel(icon: plusImg.withRenderingMode(.alwaysTemplate), textField: textField, spacing: Constants.UI.Spacing.Width.Medium * 0.75)
        textField.text = .addOrderItem
        textField.textColor = .buttonIcon
        result.iconImageView.tintColor = .buttonIcon
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
