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
        self.calculateAndUpdateData()
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
    
    private func calculateAndUpdateData() {
        self.calculateAndUpdateCurrentSales()
        self.calculateAndUpdateLastMonthSales()
    }
    
    private func calculateAndUpdateCurrentSales() {
        let startDate = DateInRegion().dateAtStartOf(.month).date // Current start of month
        let endDate = DateInRegion().dateAtEndOf(.month).date // Current end of month
        
        let sales = self.calculateSalesBetween(startDate: startDate, endDate: endDate)
        
        self.recentPerformanceCard.currentMonthSales = sales
    }
    
    private func calculateAndUpdateLastMonthSales() {
        let startDate = (DateInRegion().dateAtStartOf(.month) - 1.months).date // Previous start of month
        let endDate = (DateInRegion().dateAtEndOf(.month) - 1.months).date // Previous end of month
        
        let sales = self.calculateSalesBetween(startDate: startDate, endDate: endDate)
        
        self.recentPerformanceCard.lastMonthSales = sales
    }
    
    private func calculateSalesBetween(startDate: Date, endDate: Date) -> Double {
        let orders = self.queryClosedOrderBetween(startDate: startDate, endDate: endDate)
        let sales = orders?.reduce(0.00, { result, order in
            return result + self.accumulateSales(order: order)
        }) ?? 0.00
        return sales
    }
    
    private func queryClosedOrderBetween(startDate: Date, endDate: Date) -> [Order]? {
        let orderList = OrderList()
        let predicate = NSPredicate(format: "openedOn >= %@ AND openedOn <= %@ AND isClosed = %@", argumentArray: [startDate, endDate, true])
        return orderList.query(clause: predicate) as? [Order]
    }
    
    private func accumulateSales(order: Order) -> Double {
        let orderSales = order.items?.compactMap({ orderItem in
            return orderItem.price * Double(orderItem.qty)
        }).reduce(0.00, +)
        return orderSales ?? 0.00
    }
}
