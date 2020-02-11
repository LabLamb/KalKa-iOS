//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class IconWithTextLabel: UIView {
    
    let icon: UIImageView
    let textLabel: UILabel
    
    var spacing: CGFloat {
        didSet {
            self.textLabel.snp.updateConstraints { make in
                make.left.equalTo(self.icon.snp.right).offset(self.spacing)
            }
            self.layoutIfNeeded()
        }
    }
    
    init(icon: UIImage, text: String = "", textAlign: NSTextAlignment = .center) {
        self.icon = UIImageView(image: icon)
        self.textLabel = UILabel()
        self.spacing = 0
        
        super.init(frame: .zero)
        
        self.addSubview(self.icon)
        self.icon.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalTo(self.snp.height)
        })
        
        self.addSubview(self.textLabel)
        self.textLabel.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.icon.snp.right).offset(self.spacing)
        })
        
        self.textLabel.text = text
        self.textLabel.numberOfLines = 1
        self.textLabel.textAlignment = textAlign
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
