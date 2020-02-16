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
        result.font = Constants.UI.Font.Plain.Large
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
        result.icon.alpha = 0.1
        result.textLabel.textColor = .text
        result.textLabel.font = Constants.UI.Font.Bold.Medium
        return result
    }()
    
    lazy var remarkLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Small
        result.textColor = .text
        return result
    }()
    
    override func setupLayout() {
        super.setupLayout()
        
        self.paddingView.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.width.equalTo(self.iconImage.snp.height)
        }
        
        self.paddingView.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
        }
        
        self.paddingView.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
        }
        
        self.paddingView.addSubview(self.qtyLabel)
        self.qtyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Small)
            make.bottom.right.equalToSuperview().offset(-Constants.UI.Spacing.Height.Small)
            make.width.equalTo(self.qtyLabel.snp.height)
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
        self.priceLabel.text = "$\(data.price)"
        self.qtyLabel.text = String(data.qty)
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
        self.remarkLabel.removeFromSuperview()
    }
}
