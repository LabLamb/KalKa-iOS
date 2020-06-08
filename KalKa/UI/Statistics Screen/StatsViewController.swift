//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit
import SwiftDate

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
    
    lazy var recentPerformanceCard: MonthlyPerformanceCard = {
        return MonthlyPerformanceCard()
    }()
    
    lazy var bestSellerCard: UIView = {
        return BestSellerCard()
    }()
    
    lazy var topClientCard: UIView = {
        return TopClientCard()
    }()
    
    lazy var moreBtn: UIButton = {
        let result = UIButton()
        result.backgroundColor = .primary
        result.setTitle("More", for: .normal)
        result.setTitleColor(.buttonIcon, for: .normal)
        return result
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        self.navigationItem.title = .stats
        self.setup()
        self.updateData()
    }
    
    private func setup() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
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
//        self.statsCardList.addArrangedSubview(self.moreBtn)
        
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
    
    private func updateData() {
        self.updateRecentPerformance()
        self.updateBestSeller()
    }
    
    private func updateRecentPerformance() {
        self.updateCurrentSales()
        self.updateLastMonthSales()
    }
    
    private func updateCurrentSales() {
        let startDate = DateInRegion().dateAtStartOf(.month).date // Current start of month
        let endDate = DateInRegion().dateAtEndOf(.month).date // Current end of month
        
        let sales = SalesCalculator().calculateSalesBetween(startDate: startDate, endDate: endDate)
        
        self.recentPerformanceCard.currentMonthSales = sales
    }
    
    private func updateLastMonthSales() {
        let startDate = (DateInRegion().dateAtStartOf(.month) - 1.months).date // Previous start of month
        let endDate = (DateInRegion().dateAtEndOf(.month) - 1.months).date // Previous end of month
        
        let sales = SalesCalculator().calculateSalesBetween(startDate: startDate, endDate: endDate)
        
        self.recentPerformanceCard.lastMonthSales = sales
    }
    
    private func updateBestSeller() {
        
    }
}
