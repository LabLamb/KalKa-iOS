//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit

class MonthlyPerformanceCard: CustomView {
    
    lazy var cardLabel: UILabel = {
        let result = UILabel()
        result.text = .sales
        result.textAlignment = .left
        result.font = Constants.UI.Font.Bold.Hero
        result.textColor = .text
        return result
    }()
    
    lazy var diffLabel: UILabel = {
        let result = UILabel()
        result.text = "0.00"
        result.textAlignment = .left
        result.font = Constants.UI.Font.Plain.Medium
        result.textColor = .clear
        return result
    }()
    
    var lastMonthSales = 0.00
    var lastMonthSalesCounter = 0.00
    
    var currentMonthSales = 0.00
    var currentMonthSalesCounter = 0.00
    
    lazy var lastMonth: PerformanceCounter = {
        let result = PerformanceCounter(title: .lastMonth)
        return result
    }()
    
    lazy var currentMonth: PerformanceCounter = {
        let result = PerformanceCounter(title: .currentMonth)
        return result
    }()
    
    @objc private func updateSalesNumbers() {
        if self.lastMonthSalesCounter < self.lastMonthSales {
            self.lastMonthSalesCounter += self.lastMonthSales / 45
            self.updateLastMonthSales(sales: self.lastMonthSalesCounter)
        } else {
            self.lastMonthSalesCounter = self.lastMonthSales
            self.updateLastMonthSales(sales: self.lastMonthSales)
        }
        
        if self.currentMonthSalesCounter < self.currentMonthSales {
            self.currentMonthSalesCounter += self.currentMonthSales / 45
            self.updateCurrentMonthSales(sales: self.currentMonthSalesCounter)
        } else {
            self.currentMonthSalesCounter = self.currentMonthSales
            self.updateCurrentMonthSales(sales: self.currentMonthSales)
        }
        
        let diff = self.currentMonthSalesCounter - self.lastMonthSalesCounter
        var sign = "↑"
        
        if diff >= 0 {
            sign = "↑"
            self.diffLabel.textColor = .green
        } else {
            sign = "↓"
            self.diffLabel.textColor = .red
        }
        
        self.diffLabel.text = "$\(abs(diff).toLocalCurrency(fractDigits: 2) ?? "0")\(sign) "
    }
    
    func updateLastMonthSales(sales: Double) {
        self.lastMonth.counterLabel.text = "$\(sales.toLocalCurrency(fractDigits: 2) ?? "")"
    }
    
    func updateCurrentMonthSales(sales: Double) {
        self.currentMonth.counterLabel.text = "$\(sales.toLocalCurrency(fractDigits: 2) ?? "")"
    }
    
    override func setupLayout() {
        self.backgroundColor = .primary
        
        self.addSubview(self.cardLabel)
        self.cardLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.ExLarge)
        }
        
        self.addSubview(self.diffLabel)
        self.diffLabel.snp.makeConstraints { make in
            make.top.equalTo(self.cardLabel.snp.bottom)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.ExLarge)
        }
        
        self.addSubview(self.lastMonth)
        self.lastMonth.snp.makeConstraints { make in
            make.top.equalTo(self.diffLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        self.addSubview(self.currentMonth)
        self.currentMonth.snp.makeConstraints { make in
            make.top.equalTo(self.diffLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
    }
    
    override func setupData() {
        CADisplayLink(target: self, selector: #selector(self.updateSalesNumbers)).add(to: .main, forMode: .default)
    }
    
}
