//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class IconWithTextLabelUnder: CustomView {
    
    let icon: UIImageView
    let textLabel: UILabel
    var text: String {
        get {
            return self.textLabel.text ?? ""
        }
        
        set {
            self.textLabel.text = newValue
        }
    }
    
    var font: UIFont? {
        get {
            return self.textLabel.font
        }
        
        set {
            self.textLabel.font = newValue
        }
    }
    
    init(icon: UIImage, text: String = "") {
        self.icon = UIImageView(image: icon)
        self.textLabel = UILabel()
        
        super.init()
        
        self.text = text
        
        self.textLabel.textAlignment = .center
        
        self.setupLayout()
    }
    
    override func setupLayout() {
        self.addSubview(self.icon)
        
        self.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints({ make in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(self.textLabel.font.lineHeight)
        })
        
        self.icon.snp.makeConstraints({ make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.ExSmall * 1.5)
            make.bottom.equalTo(self.textLabel.snp.top).offset(-Constants.UI.Spacing.Height.ExSmall * 1.5)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.icon.snp.height)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
