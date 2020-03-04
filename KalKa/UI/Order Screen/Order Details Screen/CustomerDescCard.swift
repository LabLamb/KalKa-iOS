//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerDescCard: CustomView {
    
    let icon: UIImageView
    
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
    
    lazy var addressLabel: UILabel = {
        let result = UILabel()
        result.font = Constants.UI.Font.Plain.Small
        result.textColor = .accent
        return result
    }()
    
    var delegate: DataPicker?
    
    let placeholder: IconWithTextLabel = {
        let plusImg = UIImage(named: "Plus") ?? UIImage()
        let result = IconWithTextLabel(icon: plusImg.withRenderingMode(.alwaysTemplate), spacing: -Constants.UI.Spacing.Width.Medium * 1.5)
        (result.valueView as? UILabel)?.font = UITextField().font
        (result.valueView as? UILabel)?.textColor = .buttonIcon
        result.iconImage.tintColor = .buttonIcon
        return result
    }()
    
    override init() {
        self.icon = UIImageView()
        
        super.init()
        
        self.placeholder.value = .customers
        (self.placeholder.valueView as? UILabel)?.font = Constants.UI.Font.Plain.ExLarge
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.pickCustomer))
        self.addGestureRecognizer(tapGest)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func pickCustomer() {
        self.delegate?.pickCustomer()
    }
    
    override func setupLayout() {
        
        self.placeholder.removeFromSuperview()
        self.icon.removeFromSuperview()
        self.nameLabel.removeFromSuperview()
        self.phoneLabel.removeFromSuperview()
        self.addressLabel.removeFromSuperview()
        
        self.addSubview(self.placeholder)
        self.placeholder.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let addressTextExists = self.addressLabel.text != ""

        self.addSubview(self.icon)
        self.icon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium * 0.75)
            make.width.equalTo(self.icon.snp.height)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            if addressTextExists {
                make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            } else {
                make.bottom.equalTo(self.snp.centerY).offset(-Constants.UI.Spacing.Height.ExSmall * 0.5)
                
            }
            make.left.equalTo(self.icon.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
        }
        
        self.addSubview(self.phoneLabel)
        self.phoneLabel.snp.makeConstraints { make in
            if addressTextExists {
                make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
            } else {
                make.top.equalTo(self.snp.centerY).offset(Constants.UI.Spacing.Height.ExSmall * 0.5)
            }
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
            make.left.equalTo(self.icon.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
        }
        
        if addressTextExists {
            self.addSubview(self.addressLabel)
            self.addressLabel.snp.makeConstraints { make in
                make.top.equalTo(self.phoneLabel.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
                make.left.equalTo(self.icon.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
                make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.icon.clipsToBounds = true
        self.icon.layer.cornerRadius = self.icon.bounds.width / 2
    }
    
}
