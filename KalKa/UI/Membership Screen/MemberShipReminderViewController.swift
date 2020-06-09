//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit

class MemberShipReminderViewController: UIViewController {
    
    let premiumIcon: UIImageView = {
        let appIcon = #imageLiteral(resourceName: "Premium").withRenderingMode(.alwaysTemplate)
        let result = UIImageView(image: appIcon)
        result.tintColor = .gold
        return result
    }()
    
    let premiumLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Bold.Hero
        result.text = NSLocalizedString("MembershipTitle", comment: "")
        return result
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(self.premiumIcon)
        self.premiumIcon.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalTo(self.premiumIcon.snp.height)
        }
        
        self.view.addSubview(self.premiumLabel)
        self.premiumLabel.snp.makeConstraints { make in
            make.top.equalTo(self.premiumIcon.snp.bottom).offset(Constants.UI.Spacing.Height.Medium)
            make.centerX.equalToSuperview()
        }
    }
}
