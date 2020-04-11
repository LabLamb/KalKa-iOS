//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import PanModal
import StoreKit

class MembershipPurchaseViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        self.navigationItem.title = .membership
        
        let appIcon = #imageLiteral(resourceName: "Premium").withRenderingMode(.alwaysTemplate)
        let appIconImageView = UIImageView(image: appIcon)
        appIconImageView.tintColor = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
        self.view.addSubview(appIconImageView)
        appIconImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top).offset(Constants.UI.Spacing.Height.Large)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(5)
            make.width.equalTo(appIconImageView.snp.height)
        }
    }
    
}

extension MembershipPurchaseViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
}
