//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import PanModal
import StoreKit

class MembershipPurchaseViewController: UIViewController {
    
    let featureSpotlight: [String: String] = [
        "": ""
    ]
    
    let premiumIcon: UIImageView = {
        let appIcon = #imageLiteral(resourceName: "Premium").withRenderingMode(.alwaysTemplate)
        let result = UIImageView(image: appIcon)
        result.tintColor = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
        return result
    }()
    
    let premiumLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Bold.Hero
//        result.textColor = .buttonIcon
        result.text = NSLocalizedString("MembershipTitle", comment: "")
        return result
    }()
    
    let premiumDesc: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Medium
        result.textColor = .accent
        result.textAlignment = .center
        result.numberOfLines = 0
        result.text = NSLocalizedString("MembershipDesc", comment: "")
        return result
    }()
    
    let priceLabel: UILabel = {
        let result = UILabel()
        result.text = "$20 / month."
        result.textAlignment = .center
        return result
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        
        self.view.addSubview(self.premiumIcon)
        self.premiumIcon.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(5)
            make.width.equalTo(self.premiumIcon.snp.height)
        }
        
        self.view.addSubview(self.premiumLabel)
        self.premiumLabel.snp.makeConstraints { make in
            make.top.equalTo(self.premiumIcon.snp.bottom).offset(Constants.UI.Spacing.Height.Medium)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.premiumDesc)
        self.premiumDesc.snp.makeConstraints { make in
            make.top.equalTo(self.premiumLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Medium)
            make.width.equalToSuperview().multipliedBy(0.75)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.premiumDesc.snp.bottom).offset(Constants.UI.Spacing.Height.Medium)
            make.width.equalToSuperview().multipliedBy(0.75)
            make.centerX.equalToSuperview()
        }
    }
    
}
