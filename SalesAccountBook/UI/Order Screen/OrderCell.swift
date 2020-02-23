//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import CoreData

class OrderCell: CustomCell {
    
    lazy var orderNumLabel: IconWithTextLabelInside = {
        let result = IconWithTextLabelInside(icon: #imageLiteral(resourceName: "OrderNum").withRenderingMode(.alwaysTemplate))
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
        
        self.paddingView.addSubview(self.isShippedIcon)
        self.isShippedIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Large * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Large * 0.75)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
            make.width.equalTo(self.isShippedIcon.snp.height)
        }
        
        self.paddingView.addSubview(self.isPaidIcon)
        self.isPaidIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Large * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Large * 0.75)
            make.right.equalTo(self.isShippedIcon.snp.left).offset(-Constants.UI.Spacing.Width.Medium)
            make.width.equalTo(self.isPaidIcon.snp.height)
        }
        
        self.paddingView.addSubview(self.isDepositIcon)
        self.isDepositIcon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Large * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Large * 0.75)
            make.right.equalTo(self.isPaidIcon.snp.left).offset(-Constants.UI.Spacing.Width.Medium)
            make.width.equalTo(self.isDepositIcon.snp.height)
        }
        
        self.paddingView.addSubview(self.dateLabel)
        self.dateLabel.snp.makeConstraints { make in
            if remarkTextExists {
                make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            } else {
                make.bottom.equalTo(self.paddingView.snp.centerY)
                    .offset(-Constants.UI.Spacing.Height.ExSmall * 0.5)
            }
            make.left.equalTo(self.orderNumLabel.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
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
            make.left.equalTo(self.orderNumLabel.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
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
            let allProfits: [Double] = orderItems?.compactMap({
                if let item = $0 as? OrderItem {
                    return item.price * Double(item.qty)
                }
            }) ?? []
            
            self.profitLabel.text = "$\(allProfits.reduce(0, +))"
            self.profitLabel.isHidden = false
            self.isShippedIcon.isHidden = true
            self.isPaidIcon.isHidden = true
            self.isDepositIcon.isHidden = true
        } else {
            if data.isShipped {
                self.isShippedIcon.tintColor = .green
                self.isShippedIcon.alpha = 1
            }
            
            if data.isPaid {
                self.isPaidIcon.tintColor = .green
                self.isPaidIcon.alpha = 1
            }
            
            if data.isDeposit {
                self.isDepositIcon.tintColor = .green
                self.isDepositIcon.alpha = 1
            }
        }
    }
    
    override func prepareForReuse() {
        self.orderNumLabel.text = ""
        self.orderNumLabel.icon.image = #imageLiteral(resourceName: "OrderNum")
        
        [self.isShippedIcon,
         self.isPaidIcon,
         self.isDepositIcon].forEach({ icon in
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
