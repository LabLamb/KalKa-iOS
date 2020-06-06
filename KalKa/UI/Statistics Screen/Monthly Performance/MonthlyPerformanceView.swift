//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit

class MonthlyPerformanceView: CustomView {
    
    let periodLabel: UILabel
    let salesAmountLabel: UILabel
    
    init(period: String) {
        self.periodLabel = UILabel()
        self.salesAmountLabel = UILabel()
        
        super.init()
        
        self.periodLabel.text = period
        self.periodLabel.textColor = .accent
        
        self.periodLabel.font = Constants.UI.Font.Plain.Small
        self.salesAmountLabel.font = Constants.UI.Font.Plain.ExLarge
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        self.addSubview(self.periodLabel)
        self.periodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.centerX.equalToSuperview()
        }
        
        self.addSubview(self.salesAmountLabel)
        self.salesAmountLabel.snp.makeConstraints { make in
            make.top.equalTo(self.periodLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Medium)
            make.centerX.equalToSuperview()
        }
    }
    
}
