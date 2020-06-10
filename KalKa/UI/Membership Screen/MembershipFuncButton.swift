//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class MembershipFuncButton: CustomView {
    
    lazy var title: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.ExLarge
        result.numberOfLines = 0
        return result
    }()
    
    lazy var icon: UIImageView = {
        let result = UIImageView()
        return result
    }()
    
    var isEnabled: Bool = false {
        didSet {
            if self.isEnabled {
                self.icon.tintColor = .buttonIcon
                self.icon.alpha = 1
            } else {
                self.icon.tintColor = .accent
                self.icon.alpha = 0.5
            }
        }
    }
    
    init(title: String, icon: UIImage) {
        super.init()
        self.title.text = title
        self.icon.image = icon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        self.addSubview(self.title)
        self.title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Large)
//            make.right.equalTo(self.snp.centerX).offset(Constants.UI.Spacing.Width.Large)
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Width.Large)
        }
        
        self.addSubview(self.icon)
        self.icon.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(Constants.UI.Spacing.Width.Large)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(1.5)
            make.width.equalTo(self.icon.snp.height)
        }
        
//        self.addSubview(self.disabledOverlay)
//        self.disabledOverlay.snp.makeConstraints { make in
//            make.top.bottom.left.right.equalToSuperview()
//        }
    }
    
}
