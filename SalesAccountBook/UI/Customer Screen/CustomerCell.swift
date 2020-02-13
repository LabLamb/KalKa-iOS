//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerCell: UITableViewCell {
    
    lazy var iconImage: UIImageView = {
        let result = UIImageView()
        result.backgroundColor = Constants.UI.Color.Grey
        return result
    }()
    
    lazy var nameLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.LargeBold
        return result
    }()
    
//    lazy var priceLabel: UILabel = {
//        let result = UILabel()
//        return result
//    }()
//
//    lazy var qtyLabel: UILabel = {
//        let result = UILabel()
//        result.textAlignment = .right
//        return result
//    }()
    
    lazy var remarkLabel: UILabel = {
        let result = UILabel()
        result.textColor = Constants.UI.Color.Grey
        result.font = Constants.UI.Font.Small
        return result
    }()
    
    private func setupLayout(remarkExists: Bool) {
        DispatchQueue.main.async {
            self.layer.cornerRadius = self.frame.height / 4
            self.clipsToBounds = true
        }
        
        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.width.equalTo(self.iconImage.snp.height)
        }
        self.iconImage.clipsToBounds = true
        DispatchQueue.main.async {
            self.iconImage.layer.cornerRadius = self.iconImage.frame.width / 2
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Medium)
            make.width.equalToSuperview().dividedBy(3)
            if remarkExists {
                make.top.equalToSuperview().offset(Constants.UI.Spacing.Small)
                make.height.equalToSuperview().dividedBy(3)
            } else {
                make.top.bottom.equalToSuperview()
            }
        }
        
        if remarkExists {
            self.addSubview(self.remarkLabel)
            self.remarkLabel.snp.makeConstraints { make in
                make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.UI.Spacing.ExSmall)
                make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Medium)
                make.width.equalToSuperview().dividedBy(3)
                make.height.equalToSuperview().dividedBy(3)
            }
        }
        
//        self.addSubview(self.priceLabel)
//        self.priceLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(self.nameLabel.snp.right).offset(Constants.UI.Spacing.Medium)
//            make.height.equalToSuperview().dividedBy(3)
//            make.width.equalToSuperview().dividedBy(5)
//        }
//
//        self.addSubview(self.qtyLabel)
//        self.qtyLabel.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.left.equalTo(self.priceLabel.snp.right).offset(Constants.UI.Spacing.ExSmall)
//            make.height.equalToSuperview().dividedBy(3)
//            make.width.equalToSuperview().dividedBy(7)
//        }
    }
    
    private func setupData(data: Customer) {
        if let imageData = data.image {
            self.iconImage.image = UIImage(data: imageData)?.resizeImage(newWidth: 60)
        } else {
            self.iconImage.image = #imageLiteral(resourceName: "AvatarDefault").resizeImage(newWidth: 60)
        }
        self.nameLabel.text = data.name
        self.remarkLabel.text = data.remark
//        self.priceLabel.text = "$\(data.price)"
//        self.qtyLabel.text = String(data.qty)
    }
    
    public func setup(data: Customer) {
        self.selectionStyle = .none
        self.setupLayout(remarkExists: data.remark != "")
        self.setupData(data: data)
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = ""
//        self.priceLabel.text = ""
//        self.qtyLabel.text = ""
        self.remarkLabel.text = ""
        self.iconImage.image = nil
        
        self.nameLabel.removeFromSuperview()
        self.remarkLabel.removeFromSuperview()
    }
}
