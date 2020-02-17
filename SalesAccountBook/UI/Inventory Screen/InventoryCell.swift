//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import CoreData

class InventoryCell: CustomCell {
    
    lazy var iconImage: UIImageView = {
        let result = UIImageView()
        result.backgroundColor = .accent
        return result
    }()
    
    lazy var nameLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Bold.Medium
        result.textColor = .text
        return result
    }()
    
    lazy var priceLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Small
        result.textColor = .accent
        return result
    }()
    
    lazy var qtyLabel: IconWithTextLabelInside = {
        let result = IconWithTextLabelInside(icon: #imageLiteral(resourceName: "Remaining").withRenderingMode(.alwaysTemplate))
        result.icon.tintColor = .accent
        result.icon.alpha = 0.075
        result.textLabel.textColor = .text
        result.textLabel.font = Constants.UI.Font.Bold.Medium
        return result
    }()
    
    lazy var remarkLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Small
        result.textColor = .accent
        return result
    }()
    
    override func setupLayout() {
        super.setupLayout()
        
        let remarkTextExists = self.remarkLabel.text != ""

        self.paddingView.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium * 0.75)
            make.width.equalTo(self.iconImage.snp.height)
        }
        
        self.paddingView.addSubview(self.qtyLabel)
        self.qtyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Small)
            make.bottom.right.equalToSuperview().offset(-Constants.UI.Spacing.Height.Small)
            make.width.equalTo(self.qtyLabel.snp.height)
        }
        
        self.paddingView.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            if remarkTextExists {
                make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            } else {
                make.bottom.equalTo(self.paddingView.snp.centerY)
                .offset(-Constants.UI.Spacing.Height.ExSmall * 0.5)
            }
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
            make.right.equalTo(self.qtyLabel.snp.left).offset(-Constants.UI.Spacing.Width.Small)
        }
        
        self.paddingView.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { make in
            if remarkTextExists {
                make.top.equalTo(self.nameLabel.snp.bottom)
                .offset(Constants.UI.Spacing.Height.ExSmall)
            } else {
                
                make.top.equalTo(self.paddingView.snp.centerY)
                    .offset(Constants.UI.Spacing.Height.ExSmall * 0.5)
            }
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
            make.right.equalTo(self.qtyLabel.snp.left).offset(-Constants.UI.Spacing.Width.Small)
        }
        
        if remarkTextExists {
            self.paddingView.addSubview(self.remarkLabel)
            self.remarkLabel.snp.makeConstraints { make in
                make.top.equalTo(self.priceLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
                make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
                make.right.equalTo(self.qtyLabel.snp.left).offset(-Constants.UI.Spacing.Width.Small)
            }
        }
    }
    
    override func setupData(data: NSManagedObject) {
        guard let `data` = data as? Merch else { return }
        
        if let imageData = data.image {
            self.iconImage.image = UIImage(data: imageData)?.resizeImage(newWidth: 60)
        } else {
            self.iconImage.image = #imageLiteral(resourceName: "MerchDefault")
        }
        self.nameLabel.text = data.name
        self.remarkLabel.text = data.remark
        self.priceLabel.text = "$\(data.price.toLocalCurrency(fractDigits: 1) ?? "")"
        self.qtyLabel.text = data.qty.toLocalCurrency() ?? ""
    }
    
    override func layoutSubviews() {
        self.iconImage.clipsToBounds = true
        self.iconImage.layer.cornerRadius = self.iconImage.frame.width / 2
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = ""
        self.priceLabel.text = ""
        self.qtyLabel.text = ""
        self.remarkLabel.text = ""
        self.iconImage.image = nil
        
        self.nameLabel.removeFromSuperview()
        self.priceLabel.removeFromSuperview()
        self.remarkLabel.removeFromSuperview()
    }
}
