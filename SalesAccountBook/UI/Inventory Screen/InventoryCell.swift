//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class InventoryCell: UITableViewCell {
    
    lazy var iconImage: UIImageView = {
        let result = UIImageView()
        result.backgroundColor = Constants.UI.Color.Grey
        return result
    }()
    
    lazy var nameLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.ExLarge
        return result
    }()
    
    lazy var priceLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Small
        return result
    }()
    
    lazy var qtyLabel: IconWithTextLabelInside = {
        let result = IconWithTextLabelInside(icon: #imageLiteral(resourceName: "Remaining").withRenderingMode(.alwaysTemplate))
        let color = UIColor(red:1.00, green:0.84, blue:0.00, alpha:1.0)
        result.icon.tintColor = .orange
        result.textLabel.textColor = color
        result.icon.transform = CGAffineTransform(rotationAngle: CGFloat(Int.random(in: 0...2)))
        return result
    }()
    
    lazy var remarkLabel: UILabel = {
        let result = UILabel()
        result.textColor = Constants.UI.Color.Grey
        result.font = Constants.UI.Font.Plain.Small
        return result
    }()
    
    private func setupData(data: Merch) {
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
    
    public func setup(data: Merch) {
        self.selectionStyle = .none
        self.setupData(data: data)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Medium)
            make.width.equalTo(self.iconImage.snp.height)
        }
        self.iconImage.clipsToBounds = true
        self.iconImage.layer.cornerRadius = self.iconImage.frame.width / 2
        
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
        }
        
//        self.addSubview(self.remarkLabel)
//        self.remarkLabel.snp.makeConstraints { make in
//            make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
//            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium)
//            make.width.equalToSuperview().dividedBy(3)
//        }
        
        self.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
        }
        
        self.addSubview(self.qtyLabel)
        self.qtyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
            make.width.equalTo(self.qtyLabel.snp.height)
        }
        self.qtyLabel.icon.addSpinAnimation()
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
