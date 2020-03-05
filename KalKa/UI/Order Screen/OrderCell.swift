//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import CoreData

class OrderCell: CustomCell {
    
    lazy var iconStack: UIStackView = {
        let result = UIStackView()
        result.axis = .horizontal
        result.distribution = .equalCentering
        result.alignment = .center
        return result
    }()
    
    lazy var orderNumLabel: IconWithTextLabelInside = {
        let icon = #imageLiteral(resourceName: "OrderNum").withRenderingMode(.alwaysTemplate)
        let result = IconWithTextLabelInside(icon: icon)
        result.icon.tintColor = .accent
        result.icon.alpha = 0.25
        result.textLabel.textColor = .text
        result.textLabel.font = Constants.UI.Font.Bold.Medium
        return result
    }()
    
    lazy var dateLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Bold.Small
        result.textColor = .accent
        return result
    }()
    
    lazy var custNameLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Medium
        result.textColor = .text
        return result
    }()
    
    lazy var remarkLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Small
        result.textColor = .accent
        return result
    }()
    
    lazy var isShippedIcon: UIImageView = {
        let icon = #imageLiteral(resourceName: "isShipped").withRenderingMode(.alwaysTemplate)
        let result = UIImageView(image: icon)
        result.tintColor = .text
        result.alpha = 0.1
        return result
    }()
    
    lazy var isPrepedIcon: UIImageView = {
        let icon = #imageLiteral(resourceName: "isPreped").withRenderingMode(.alwaysTemplate)
        let result = UIImageView(image: icon)
        result.tintColor = .text
        result.alpha = 0.1
        return result
    }()
    
    lazy var isPaidIcon: UIImageView = {
        let icon = #imageLiteral(resourceName: "isPaid").withRenderingMode(.alwaysTemplate)
        let result = UIImageView(image: icon)
        result.tintColor = .text
        result.alpha = 0.1
        return result
    }()
    
    lazy var isDepositIcon: UIImageView = {
        let icon = #imageLiteral(resourceName: "isDeposit").withRenderingMode(.alwaysTemplate)
        let result = UIImageView(image: icon)
        result.tintColor = .text
        result.alpha = 0.1
        return result
    }()
    
    lazy var profitLabel: IconWithTextLabelInside = {
        let result = IconWithTextLabelInside(icon: #imageLiteral(resourceName: "Earnings").withRenderingMode(.alwaysTemplate))
        result.icon.tintColor = .accent
        result.icon.alpha = 0.075
        result.textLabel.textColor = .text
        result.textLabel.font = Constants.UI.Font.Bold.Medium
        result.isHidden = true
        return result
    }()
    
    override func setupLayout() {
        super.setupLayout()
        
        let remarkTextExists = self.remarkLabel.text != ""
        
        self.paddingView.addSubview(self.orderNumLabel)
        self.orderNumLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(Constants.UI.Spacing.Height.ExSmall * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.ExSmall * 0.75)
            make.width.equalTo(self.orderNumLabel.snp.height)
        }
//
        self.paddingView.addSubview(self.iconStack)
        self.iconStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Large * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Large * 0.75)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
            make.left.equalTo(self.paddingView.snp.centerX).offset(Constants.UI.Spacing.Width.ExLarge * 1.25)
        }
        
        [self.isDepositIcon,
         self.isPrepedIcon,
         self.isPaidIcon,
         self.isShippedIcon].forEach({ icon in
            self.iconStack.addArrangedSubview(icon)
            icon.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalTo(icon.snp.height)
            }
         })
        
        self.paddingView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            if remarkTextExists {
                make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            } else {
                make.bottom.equalTo(self.paddingView.snp.centerY)
                    .offset(-Constants.UI.Spacing.Height.ExSmall * 0.5)
            }
            make.left.equalTo(self.orderNumLabel.snp.right).offset(Constants.UI.Spacing.Width.ExSmall)
            make.right.equalTo(self.isDepositIcon.snp.left).offset(-Constants.UI.Spacing.Width.Small)
        }
        
        self.paddingView.addSubview(self.custNameLabel)
        self.custNameLabel.snp.makeConstraints { make in
            if remarkTextExists {
                make.top.equalTo(self.dateLabel.snp.bottom)
                    .offset(Constants.UI.Spacing.Height.ExSmall)
            } else {
                
                make.top.equalTo(self.paddingView.snp.centerY)
                    .offset(Constants.UI.Spacing.Height.ExSmall * 0.5)
            }
            make.top.equalTo(self.dateLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
            make.left.equalTo(self.orderNumLabel.snp.right).offset(Constants.UI.Spacing.Width.ExSmall)
            make.right.equalTo(self.isDepositIcon.snp.left).offset(-Constants.UI.Spacing.Width.Small)
        }
        
        if remarkTextExists {
            self.paddingView.addSubview(self.remarkLabel)
            self.remarkLabel.snp.makeConstraints { make in
                make.top.equalTo(self.custNameLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
                make.left.equalTo(self.orderNumLabel.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
                make.right.equalTo(self.isDepositIcon.snp.left).offset(-Constants.UI.Spacing.Width.Small)
            }
        }
        
        self.paddingView.addSubview(self.profitLabel)
        self.profitLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Small)
            make.bottom.right.equalToSuperview().offset(-Constants.UI.Spacing.Height.Small)
            make.width.equalTo(self.profitLabel.snp.height)
        }
    }
    
    override func setupData(data: NSManagedObject) {
        guard let `data` = data as? Order else { return }
        
        self.orderNumLabel.text = "#\(data.number)"
        self.dateLabel.text = data.openedOn?.toString(format: Constants.System.DateFormat)
        self.custNameLabel.text = data.customer.name
        self.remarkLabel.text = data.remark
        
        if data.isClosed {
            self.orderNumLabel.icon.image = #imageLiteral(resourceName: "isClosed")
            let orderItems = data.items
            let totalProfit = orderItems?.compactMap({ $0.price * Double($0.qty) }).reduce(0, +).toLocalCurrencyWithoutFractionDigits() ?? "0"
            self.profitLabel.text = "$\(totalProfit)"
            self.profitLabel.isHidden = false
            self.iconStack.arrangedSubviews.forEach({ $0.isHidden = true })
        } else {
            if data.isShipped {
                self.isShippedIcon.tintColor = .buttonIcon
                self.isShippedIcon.alpha = 1
            }
            
            if data.isPaid {
                self.isPaidIcon.tintColor = .buttonIcon
                self.isPaidIcon.alpha = 1
            }
            
            if data.isDeposit {
                self.isDepositIcon.tintColor = .buttonIcon
                self.isDepositIcon.alpha = 1
            }
            
            if data.isPreped {
                self.isPrepedIcon.tintColor = .buttonIcon
                self.isPrepedIcon.alpha = 1
            }
        }
    }
    
    override func prepareForReuse() {
        self.orderNumLabel.text = ""
        self.orderNumLabel.icon.image = #imageLiteral(resourceName: "OrderNum").withRenderingMode(.alwaysTemplate)
        
        self.iconStack.arrangedSubviews.forEach({ icon in
            icon.tintColor = .text
            icon.alpha = 0.1
            icon.isHidden = false
         })
        
        self.profitLabel.isHidden = true
        
        self.dateLabel.removeFromSuperview()
        self.custNameLabel.removeFromSuperview()
        self.remarkLabel.removeFromSuperview()
    }
}
