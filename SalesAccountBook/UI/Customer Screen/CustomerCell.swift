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
        result.font = Constants.UI.Font.Plain.ExLarge
        result.numberOfLines = 2
        return result
    }()
    
    lazy var phoneLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Medium
        result.textColor = Constants.UI.Color.Grey
        return result
    }()
    
    private func setupLayout(remarkExists: Bool) {
        
        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Small)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Small)
            make.width.equalTo(self.iconImage.snp.height)
        }
        self.iconImage.clipsToBounds = true
        DispatchQueue.main.async {
            self.iconImage.layer.cornerRadius = self.iconImage.frame.width / 2
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Small)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Large)
            make.width.equalTo(Constants.UI.Sizing.Width.Large)
        }
        
        self.addSubview(self.phoneLabel)
        self.phoneLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(Constants.UI.Sizing.Height.ExSmall / 2)
            make.left.equalTo(self.nameLabel.snp.right).offset(Constants.UI.Spacing.Width.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
        }
    }
    
    private func setupData(data: Customer) {
        if let imageData = data.image {
            self.iconImage.image = UIImage(data: imageData)?.resizeImage(newWidth: 60)
        } else {
            self.iconImage.image = #imageLiteral(resourceName: "AvatarDefault").resizeImage(newWidth: 60)
        }
        self.nameLabel.text = data.name == "" ? NSLocalizedString("Absent", comment: "Missing info.") : data.name
        self.phoneLabel.text = data.phone == "" ? NSLocalizedString("Absent", comment: "Missing info.") : data.phone
    }
    
    public func setup(data: Customer) {
        self.selectionStyle = .none
        self.setupLayout(remarkExists: data.remark != "")
        self.setupData(data: data)
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = ""
        self.phoneLabel.text = ""
        self.iconImage.image = nil
    }
}
