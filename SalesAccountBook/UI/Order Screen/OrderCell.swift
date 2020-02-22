//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import CoreData

class OrderCell: CustomCell {
    
    lazy var iconImage: UIImageView = {
        let result = UIImageView()
        result.backgroundColor = .accent
        return result
    }()
    
    lazy var nameLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Medium
        return result
    }()
    
    lazy var phoneLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Small
        result.textColor = .accent
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
        
        self.paddingView.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            if remarkTextExists {
                make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            } else {
                make.bottom.equalTo(self.paddingView.snp.centerY)
                .offset(-Constants.UI.Spacing.Height.ExSmall * 0.5)
            }
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
        }
        
        self.paddingView.addSubview(self.phoneLabel)
        self.phoneLabel.snp.makeConstraints { make in
            if remarkTextExists {
                make.top.equalTo(self.nameLabel.snp.bottom)
                .offset(Constants.UI.Spacing.Height.ExSmall)
            } else {
                
                make.top.equalTo(self.paddingView.snp.centerY)
                    .offset(Constants.UI.Spacing.Height.ExSmall * 0.5)
            }
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
        }
        
        if remarkTextExists {
            self.paddingView.addSubview(self.remarkLabel)
            self.remarkLabel.snp.makeConstraints { make in
                make.top.equalTo(self.phoneLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
                make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
                make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
            }
        }
    }
    
    @objc func linkWhatsapp() {
        let whatsAppUrl = URL(string: "https://api.whatsapp.com/send?phone=\(self.phoneLabel.text!)")
        if UIApplication.shared.canOpenURL(whatsAppUrl!) {
            UIApplication.shared.open(whatsAppUrl!, options: [:], completionHandler: nil)
        }
    }
    
    override func setupData(data: NSManagedObject) {
        guard let `data` = data as? Customer else { return }
        if let imageData = data.image {
            self.iconImage.image = UIImage(data: imageData)?.resizeImage(newWidth: 60)
        } else {
            self.iconImage.image = #imageLiteral(resourceName: "AvatarDefault").resizeImage(newWidth: 60)
        }
        self.nameLabel.text = data.name == "" ? .absent : data.name
        self.phoneLabel.text = data.phone == "" ? .absent : data.phone
        self.remarkLabel.text = data.remark
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImage.clipsToBounds = true
        self.iconImage.layer.cornerRadius = self.iconImage.bounds.width / 2
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = ""
        self.phoneLabel.text = ""
        self.iconImage.image = nil
        self.remarkLabel.text = ""
        
        self.nameLabel.removeFromSuperview()
        self.phoneLabel.removeFromSuperview()
        self.remarkLabel.removeFromSuperview()
    }
}
