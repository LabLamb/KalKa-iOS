//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit

class MonthlyPerformanceCard: CustomView {
    
    lazy var cardLabel: UILabel = {
        let result = UILabel()
        result.text = "Sales"
        result.textAlignment = .left
        result.font = Constants.UI.Font.Bold.Hero
        result.textColor = .text
        return result
    }()
    
    var lastMonthSales = 0.00
    var lastMonthSalesCounter = 0.00
    
    var currentMonthSales = 0.00
    var currentMonthSalesCounter = 0.00
    
    lazy var lastMonth: MonthlyPerformanceView = {
        let result = MonthlyPerformanceView(period: .lastMonth)
        return result
    }()
    
    lazy var currentMonth: MonthlyPerformanceView = {
        let result = MonthlyPerformanceView(period: .currentMonth)
        return result
    }()
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: Constants.UI.Sizing.Height.Small)
    }
    
    @objc private func updateSalesNumbers() {
        if self.lastMonthSalesCounter < self.lastMonthSales {
            self.lastMonthSalesCounter += self.lastMonthSales / 45
            self.updateLastMonthSales(sales: self.lastMonthSalesCounter)
        } else {
            self.updateLastMonthSales(sales: self.lastMonthSales)
        }
        
        if self.currentMonthSalesCounter < self.currentMonthSales {
            self.currentMonthSalesCounter += self.currentMonthSales / 45
            self.updateCurrentMonthSales(sales: self.currentMonthSalesCounter)
        } else {
            self.updateCurrentMonthSales(sales: self.currentMonthSales)
        }
    }
    
    func updateLastMonthSales(sales: Double) {
        self.lastMonth.salesAmountLabel.text = "$\(sales.toLocalCurrency(fractDigits: 2) ?? "")"
    }
    
    func updateCurrentMonthSales(sales: Double) {
        self.currentMonth.salesAmountLabel.text = "$\(sales.toLocalCurrency(fractDigits: 2) ?? "")"
    }
    
    override func setupLayout() {
        self.backgroundColor = .primary
        
        self.addSubview(self.cardLabel)
        self.cardLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.ExLarge)
        }
        
        self.addSubview(self.lastMonth)
        self.lastMonth.snp.makeConstraints { make in
            make.top.equalTo(self.cardLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        self.addSubview(self.currentMonth)
        self.currentMonth.snp.makeConstraints { make in
            make.top.equalTo(self.cardLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
    }
    
    override func setupData() {
        CADisplayLink(target: self, selector: #selector(self.updateSalesNumbers)).add(to: .main, forMode: .default)
    }
    
}
