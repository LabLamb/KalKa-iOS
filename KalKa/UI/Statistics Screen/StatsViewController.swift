//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit

class StatsViewController: UIViewController {
    
    let standardStatsCardHeight = Constants.UI.Sizing.Height.Medium
    
    lazy var recentPerformanceCard: UIView = {
        return MonthlyPerformanceCard(lastMonthSales: "$\(5434342.toLocalCurrency(fractDigits: 2) ?? "")", currentMonthSales: "$\(123343.toLocalCurrency(fractDigits: 2) ?? "")")
    }()
    
    lazy var bestSellerCard: UIView = {
        return UIView()
    }()
    
    lazy var topClientCard: UIView = {
        return UIView()
    }()
    
    lazy var moreBtn: UIButton = {
        return UIButton()
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        self.navigationItem.title = .stats
        self.setup()
    }
    
    private func setup() {
        self.view.addSubview(self.recentPerformanceCard)
        self.recentPerformanceCard.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top).offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.height.equalTo(self.standardStatsCardHeight)
        }
        self.recentPerformanceCard.backgroundColor = .primary
        self.recentPerformanceCard.clipsToBounds = true
        
        self.view.addSubview(self.bestSellerCard)
        self.bestSellerCard.snp.makeConstraints { make in
            make.top.equalTo(self.recentPerformanceCard.snp.bottom).offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.height.equalTo(self.standardStatsCardHeight)
        }
        self.bestSellerCard.backgroundColor = .primary
        self.bestSellerCard.clipsToBounds = true
        
        self.view.addSubview(self.topClientCard)
        self.topClientCard.snp.makeConstraints { make in
            make.top.equalTo(self.bestSellerCard.snp.bottom).offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.height.equalTo(self.standardStatsCardHeight)
        }
        self.topClientCard.backgroundColor = .primary
        self.topClientCard.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.recentPerformanceCard.layer.cornerRadius = self.recentPerformanceCard.frame.width / 24
            self.bestSellerCard.layer.cornerRadius = self.bestSellerCard.frame.width / 24
            self.topClientCard.layer.cornerRadius = self.topClientCard.frame.width / 24
        }
    }
}
