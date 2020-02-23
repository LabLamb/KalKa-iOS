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
        result.font = Constants.UI.Font.Bold.Medium
        result.textColor = .text
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
    
    override func setupLayout() {
        super.setupLayout()
        
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
    }
    
    override func setupData(data: NSManagedObject) {
        guard let `data` = data as? Order else { return }
        
        self.orderNumLabel.text = "#\(data.number)"
        if data.isClosed {
            self.orderNumLabel.icon.image = #imageLiteral(resourceName: "isClosed")
        }
        
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
    
    //    override func layoutSubviews() {
    //        self.iconImage.clipsToBounds = true
    //        self.iconImage.layer.cornerRadius = self.iconImage.frame.width / 2
    //        super.layoutSubviews()
    //    }
    
    override func prepareForReuse() {
        //        self.nameLabel.text = ""
        //        self.priceLabel.text = ""
        self.orderNumLabel.text = ""
        self.orderNumLabel.icon.image = #imageLiteral(resourceName: "OrderNum")
        
        self.isPaidIcon.tintColor = .text
        self.isPaidIcon.alpha = 0.1
        
        self.isShippedIcon.tintColor = .text
        self.isShippedIcon.alpha = 0.1
        
        self.isDepositIcon.tintColor = .text
        self.isDepositIcon.alpha = 0.1
        //        self.remarkLabel.text = ""
        //        self.iconImage.image = nil
        
        //        self.nameLabel.removeFromSuperview()
        //        self.priceLabel.removeFromSuperview()
        //        self.remarkLabel.removeFromSuperview()
    }
}
