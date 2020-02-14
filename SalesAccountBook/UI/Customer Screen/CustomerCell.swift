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
        result.font = Constants.UI.Font.MediumBold
        return result
    }()
    
    lazy var phoneLabel: IconWithTextLabel = {
        let result = IconWithTextLabel(icon: #imageLiteral(resourceName: "Phone"))
        result.textLabel.font = Constants.UI.Font.Small
        result.spacing = 2.5
        return result
    }()
    
    lazy var addressLabel: IconWithTextView = {
        let result = IconWithTextView(icon: #imageLiteral(resourceName: "Address"), text: "", textAlign: .left)
        result.textView.font = Constants.UI.Font.Small
        result.spacing = 2.5
        return result
    }()
    
    lazy var remarkLabel: IconWithTextView = {
        let result = IconWithTextView(icon: #imageLiteral(resourceName: "Remark"))
        result.textView.font = Constants.UI.Font.Small
        result.spacing = 2.5
        return result
    }()
    
    private func setupLayout(remarkExists: Bool) {
        
        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.width.equalToSuperview().dividedBy(6)
            make.height.equalTo(self.iconImage.snp.width)
        }
        self.iconImage.clipsToBounds = true
        DispatchQueue.main.async {
            self.iconImage.layer.cornerRadius = self.iconImage.frame.width / 2
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImage.snp.trailing).offset(Constants.UI.Spacing.Small)
            make.width.equalToSuperview().multipliedBy(0.45)
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.height.equalToSuperview().multipliedBy(0.139)
        }
        
        self.addSubview(self.phoneLabel)
        self.phoneLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.nameLabel.snp.trailing).offset(Constants.UI.Spacing.Small)
            make.width.equalToSuperview().multipliedBy(0.275)
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.height.equalToSuperview().multipliedBy(0.139)
        }
        
        self.addSubview(self.addressLabel)
        self.addressLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImage.snp.trailing).offset(Constants.UI.Spacing.Small)
            make.width.equalToSuperview().multipliedBy(0.75)
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.UI.Spacing.ExSmall)
            make.height.equalToSuperview().multipliedBy(0.278)
        }
        
        self.addSubview(self.remarkLabel)
        self.remarkLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.iconImage.snp.trailing).offset(Constants.UI.Spacing.Small)
            make.width.equalToSuperview().multipliedBy(0.75)
            make.top.equalTo(self.addressLabel.snp.bottom).offset(Constants.UI.Spacing.ExSmall)
            make.height.equalToSuperview().multipliedBy(0.278)
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
        self.addressLabel.text = data.address == "" ? NSLocalizedString("Absent", comment: "Missing info.") : data.address
        self.remarkLabel.text = data.remark == "" ? NSLocalizedString("Absent", comment: "Missing info.") : data.remark
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
