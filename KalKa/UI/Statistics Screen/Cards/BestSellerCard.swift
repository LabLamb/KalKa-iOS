//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit

class BestSellerCard: CustomView {
    
    lazy var productImage: UIImageView = {
        let result = UIImageView()
        result.backgroundColor = .accent
        result.image = #imageLiteral(resourceName: "MerchDefault")
        return result
    }()
    
    lazy var productName: UILabel = {
        let result = UILabel()
        result.text = .absent
        result.textAlignment = .left
        result.font = Constants.UI.Font.Bold.Small
        result.textColor = .accent
        return result
    }()
    
    lazy var cardLabel: UILabel = {
        let result = UILabel()
        result.text = .bestSeller
        result.textAlignment = .left
        result.font = Constants.UI.Font.Bold.Hero
        result.textColor = .text
        return result
    }()
    
    var sales = 0.00
    var salesCounter = 0.00
    
    var quantity = 0.00
    var quantityCounter = 0.00
    
    lazy var salesView: PerformanceCounter = {
        let result = PerformanceCounter(title: .sales)
        return result
    }()
    
    lazy var quantityView: PerformanceCounter = {
        let result = PerformanceCounter(title: .quantity)
        return result
    }()
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: Constants.UI.Sizing.Height.Small)
    }
    
    @objc private func updateNums() {
        if self.salesCounter < self.sales {
            self.salesCounter += self.sales / 45
            self.updateSales(sales: self.salesCounter)
        } else {
            self.updateSales(sales: self.sales)
        }

        if self.quantityCounter < self.quantity {
            self.quantityCounter += self.quantity / 45
            self.updateQty(qty: self.quantityCounter)
        } else {
            self.updateQty(qty: self.quantity)
        }
    }
    
    func updateSales(sales: Double) {
        self.salesView.counterLabel.text = "$\(sales.toLocalCurrency(fractDigits: 2) ?? "")"
    }

    func updateQty(qty: Double) {
        self.quantityView.counterLabel.text = qty.toLocalCurrency(fractDigits: 0) ?? ""
    }
    
    override func setupLayout() {
        self.backgroundColor = .primary
        
        self.addSubview(self.cardLabel)
        self.cardLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.ExLarge)
        }
        
        self.addSubview(self.productName)
        self.productName.snp.makeConstraints { make in
            make.top.equalTo(self.cardLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.ExLarge)
        }
        
        self.addSubview(self.salesView)
        self.salesView.snp.makeConstraints { make in
            make.top.equalTo(self.productName.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        self.addSubview(self.quantityView)
        self.quantityView.snp.makeConstraints { make in
            make.top.equalTo(self.productName.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.right.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
        
        self.addSubview(self.productImage)
        self.productImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.height.equalTo(self.cardLabel.font.lineHeight + self.productName.font.lineHeight + Constants.UI.Spacing.Height.ExSmall)
            make.width.equalTo(self.productImage.snp.height)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Large)
        }
        DispatchQueue.main.async {
            self.productImage.clipsToBounds = true
            self.productImage.layer.cornerRadius = self.productImage.frame.width / 2
        }
    }
    
    override func setupData() {
        CADisplayLink(target: self, selector: #selector(self.updateNums)).add(to: .main, forMode: .default)
    }
    
}
