//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit

class MonthlyPerformanceCard: CustomView {
    
    lazy var cardLabel: UILabel = {
        let result = UILabel()
        result.text = "Sales"
        result.textAlignment = .center
        result.font = Constants.UI.Font.Bold.ExLarge
        result.textColor = .text
        return result
    }()
    
    lazy var lastMonth: MonthlyPerformanceView = {
        let result = MonthlyPerformanceView(period: .lastMonth)
        result.addLine(position: .right, color: .accent, weight: 1)
        return result
    }()
    
    lazy var currentMonth: MonthlyPerformanceView = {
        let result = MonthlyPerformanceView(period: .currentMonth)
        result.addLine(position: .left, color: .white, weight: 1)
        return result
    }()
    
    init(lastMonthSales: String,
         currentMonthSales: String) {
        super.init()
        
        self.lastMonth.salesAmountLabel.text = lastMonthSales
        self.currentMonth.salesAmountLabel.text = currentMonthSales
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        self.addSubview(self.cardLabel)
        self.cardLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.left.right.equalToSuperview()
        }
        
        self.addSubview(self.lastMonth)
        self.lastMonth.snp.makeConstraints { make in
            make.top.equalTo(self.cardLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Medium)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        self.addSubview(self.currentMonth)
        self.currentMonth.snp.makeConstraints { make in
            make.top.equalTo(self.cardLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Medium)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
    }
    
}
