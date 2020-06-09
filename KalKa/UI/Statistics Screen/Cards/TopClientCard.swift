//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit

class TopClientCard: CustomView {
    
    lazy var clientImage: UIImageView = {
        let result = UIImageView()
        result.backgroundColor = .accent
        result.image = #imageLiteral(resourceName: "AvatarDefault")
        return result
    }()
    
    lazy var clientName: UILabel = {
        let result = UILabel()
        result.text = "John Smith"
        result.textAlignment = .left
        result.font = Constants.UI.Font.Bold.Small
        result.textColor = .accent
        return result
    }()
    
    lazy var cardLabel: UILabel = {
        let result = UILabel()
        result.text = .topClient
        result.textAlignment = .left
        result.font = Constants.UI.Font.Bold.Hero
        result.textColor = .text
        return result
    }()
    
    var spending = 0.00
    var spendingCounter = 0.00
    
    var orders = 0.00
    var ordersCounter = 0.00
    
    lazy var spendingView: PerformanceCounter = {
        let result = PerformanceCounter(title: .spent)
        return result
    }()
    
    lazy var ordersView: PerformanceCounter = {
        let result = PerformanceCounter(title: .orders)
        return result
    }()
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: Constants.UI.Sizing.Height.Small)
    }
    
    @objc private func updateNums() {
        if self.spendingCounter < self.spending {
            self.spendingCounter += self.spending / 45
            self.updateSpending(spending: self.spendingCounter)
        } else {
            self.updateSpending(spending: self.spending)
        }

        if self.ordersCounter < self.orders {
            self.ordersCounter += self.orders / 45
            self.updateOrders(orders: self.ordersCounter)
        } else {
            self.updateOrders(orders: self.orders)
        }
    }
    
    func updateSpending(spending: Double) {
        self.spendingView.counterLabel.text = "$\(spending.toLocalCurrency(fractDigits: 2) ?? "")"
    }

    func updateOrders(orders: Double) {
        self.ordersView.counterLabel.text = orders.toLocalCurrency(fractDigits: 0) ?? ""
    }
    
    override func setupLayout() {
        self.backgroundColor = .primary
        
        self.addSubview(self.cardLabel)
        self.cardLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.ExLarge)
        }

        self.addSubview(self.clientName)
        self.clientName.snp.makeConstraints { make in
            make.top.equalTo(self.cardLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.ExLarge)
        }
        
        self.addSubview(self.spendingView)
        self.spendingView.snp.makeConstraints { make in
            make.top.equalTo(self.clientName.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        self.addSubview(self.ordersView)
        self.ordersView.snp.makeConstraints { make in
            make.top.equalTo(self.clientName.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        self.addSubview(self.clientImage)
        self.clientImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.height.equalTo(self.cardLabel.font.lineHeight + self.clientName.font.lineHeight + Constants.UI.Spacing.Height.ExSmall)
            make.width.equalTo(self.clientImage.snp.height)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Large)
        }
        DispatchQueue.main.async {
            self.clientImage.clipsToBounds = true
            self.clientImage.layer.cornerRadius = self.clientImage.frame.width / 2
        }
    }
    
    override func setupData() {
        CADisplayLink(target: self, selector: #selector(self.updateNums)).add(to: .main, forMode: .default)
    }
    
}
