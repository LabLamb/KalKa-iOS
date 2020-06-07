//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit

class StatsViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    lazy var statsCardList: UIStackView = {
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .center
        result.distribution = .fill
        result.spacing = Constants.UI.Spacing.Height.Medium
        return result
    }()
    
    lazy var recentPerformanceCard: UIView = {
        return MonthlyPerformanceCard(lastMonthSales: 5434342.23, currentMonthSales: 123343.54)
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
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        self.scrollView.addSubview(self.statsCardList)
        self.statsCardList.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.view.snp.left).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view.snp.right).offset(-Constants.UI.Spacing.Width.Medium)
        }

        self.statsCardList.addArrangedSubview(self.recentPerformanceCard)
        self.statsCardList.addArrangedSubview(self.bestSellerCard)
        self.statsCardList.addArrangedSubview(self.topClientCard)
        
        self.statsCardList.arrangedSubviews.forEach({ view in
            view.snp.makeConstraints { make in
                make.width.equalToSuperview()
            }
            view.clipsToBounds = true
            DispatchQueue.main.async {
                view.layer.cornerRadius = view.frame.width / 24
            }
        })
    }
}
