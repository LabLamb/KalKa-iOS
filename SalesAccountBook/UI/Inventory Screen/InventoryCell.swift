//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit
import SnapKit

class InventoryCell: UITableViewCell {
    
    lazy var iconImage: UIImageView = {
        let result = UIImageView()
        result.backgroundColor = Constants.UI.Color.DarkGrey
        return result
    }()
    
    lazy var nameLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.ExLargeBold
        return result
    }()
    
    lazy var priceLabel: IconWithTextLabel = {
        let result = IconWithTextLabel(icon: #imageLiteral(resourceName: "PriceTag"), textAlign: .right)
        return result
    }()
    
    lazy var qtyLabel: IconWithTextLabel = {
        let result = IconWithTextLabel(icon: #imageLiteral(resourceName: "InStock"), textAlign: .right)
        return result
    }()
    
    lazy var remarkLabel: UILabel = {
        let result = UILabel()
        result.textColor = Constants.UI.Color.Grey
        result.font = Constants.UI.Font.Medium
        return result
    }()
    
    private func setupLayout() {
        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Medium)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Medium)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Medium)
            make.width.equalTo(self.iconImage.snp.height)
        }
        self.iconImage.clipsToBounds = true
        DispatchQueue.main.async {
            self.iconImage.layer.borderColor = UIColor.black.cgColor
            self.iconImage.layer.borderWidth = 2.5
            self.iconImage.layer.cornerRadius = self.iconImage.frame.width / 2
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Medium)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Large)
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalToSuperview().dividedBy(3)
        }
        
        self.addSubview(self.remarkLabel)
        self.remarkLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Medium)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Large)
            make.width.equalToSuperview().dividedBy(3)
            make.height.equalToSuperview().dividedBy(3)
        }
        
        self.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Medium)
            make.left.equalTo(self.remarkLabel.snp.right).offset(Constants.UI.Spacing.ExLarge)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.ExLarge)
            make.height.equalToSuperview().dividedBy(3)
        }
        self.priceLabel.spacing = CGFloat(Constants.UI.Spacing.Medium)
        
        self.addSubview(self.qtyLabel)
        self.qtyLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Medium)
            make.left.equalTo(self.remarkLabel.snp.right).offset(Constants.UI.Spacing.ExLarge)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.ExLarge)
            make.height.equalToSuperview().dividedBy(3)
        }
        self.qtyLabel.spacing = CGFloat(Constants.UI.Spacing.Medium)
    }
    
    private func setupData(data: Merch) {
        self.iconImage.image = data.image
        self.nameLabel.text = data.name
        self.remarkLabel.text = data.remark
        self.priceLabel.textLabel.text = String(data.price)
        self.qtyLabel.textLabel.text = String(data.qty)
    }
    
    public func setup(data: Merch) {
        self.selectionStyle = .none
        self.setupLayout()
        self.setupData(data: data)
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = ""
        self.priceLabel.textLabel.text = ""
        self.qtyLabel.textLabel.text = ""
        self.remarkLabel.text = ""
        self.iconImage.image = nil
    }
}
