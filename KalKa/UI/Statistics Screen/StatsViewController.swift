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
    
    lazy var bestSellerCard: BestSellerCard = {
        return BestSellerCard()
    }()
    
    lazy var topClientCard: TopClientCard = {
        return TopClientCard()
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        self.navigationItem.title = .stats
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        self.updateTopClient()
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
        let bestSeller = SalesCalculator().getBestSeller()
        
        self.bestSellerCard.productName.text = bestSeller.name
        self.bestSellerCard.sales = bestSeller.sales
        self.bestSellerCard.quantity = Double(bestSeller.sold)
        
        let inventory = Inventory()
        if let merchDet = inventory.getDetails(id: bestSeller.name) as? MerchDetails,
            let img = merchDet.image {
            self.bestSellerCard.productImage.image = img
        }
    }
    
    private func updateTopClient() {
        let topClient = SalesCalculator().getTopClient()
        
        self.topClientCard.clientName.text = topClient.name
        self.topClientCard.spending = topClient.spent
        self.topClientCard.orders = Double(topClient.orders)
        
        let customerList = CustomerList()
        if let custDet = customerList.getDetails(id: topClient.name) as? CustomerDetails,
            let img = custDet.image {
            self.topClientCard.clientImage.image = img
        }
    }
}
