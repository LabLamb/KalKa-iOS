//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import CoreData

class CustomerCell: CustomCell {
    
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
    
//    lazy var quickChatBtn: UIButton = {
//        let result = UIButton()
//        result.setImage(#imageLiteral(resourceName: "Address"), for: .normal)
//        result.addTarget(self, action: #selector(self.linkWhatsapp), for: .touchUpInside)
//        return result
//    }()
    
    override func setupLayout() {
        super.setupLayout()
        
        self.paddingView.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Width.Medium)
            make.width.equalTo(self.iconImage.snp.height)
        }
        
        self.paddingView.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Large)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
        }
        
        self.paddingView.addSubview(self.phoneLabel)
        self.phoneLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.left.equalTo(self.iconImage.snp.right).offset(Constants.UI.Spacing.Width.Large)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
        }
        
//        self.paddingView.addSubview(self.quickChatBtn)
//        self.quickChatBtn.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
//            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
//            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Medium)
//        }
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
    }
}
