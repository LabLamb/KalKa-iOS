//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit

class PerformanceCounter: CustomView {
    
    let titleLabel: UILabel
    let counterLabel: UILabel
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: (self.titleLabel.font.lineHeight + self.counterLabel.font.lineHeight + Constants.UI.Spacing.Height.Medium + Constants.UI.Spacing.Height.Small) * 1.05)
    }
    
    init(title: String) {
        self.titleLabel = UILabel()
        self.counterLabel = UILabel()
        
        super.init()
        
        self.titleLabel.text = title
        self.titleLabel.textColor = .accent
        
        self.titleLabel.font = Constants.UI.Font.Plain.Small
        self.counterLabel.font = Constants.UI.Font.Plain.ExLarge
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.ExLarge)
        }
        
        self.addSubview(self.counterLabel)
        self.counterLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.ExLarge)
        }
    }
    
}
