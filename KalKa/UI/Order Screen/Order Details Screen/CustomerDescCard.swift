//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerDescCard: CustomView {
    
    let icon: UIImageView
    let nameLabel: UILabel
    let phoneLabel: UILabel
    let addressLabel: UILabel
    let remarkLabel: UILabel
    
    var delegate: DataPicker?
    
    let placeholder: UILabel
    
    override init() {
        self.icon = UIImageView()
        self.nameLabel = UILabel()
        self.phoneLabel = UILabel()
        self.addressLabel = UILabel()
        self.remarkLabel = UILabel()
        self.placeholder = UILabel()
        
        super.init()
        
        self.placeholder.text = "+ \(String.addCustomer)"
        self.placeholder.font = Constants.UI.Font.Plain.ExLarge
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.callPickCustomer))
        self.addGestureRecognizer(tapGest)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func callPickCustomer() {
        self.delegate?.pickCustomer()
    }
    
    func updateData() {
        
    }
    
    override func setupLayout() {
        self.addSubview(self.placeholder)
        self.placeholder.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(self.icon)
        self.icon.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.5)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium * 0.75)
            make.width.equalTo(self.icon.snp.height)
        }
        
        self.addSubview(self.nameLabel)
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.left.equalTo(self.icon.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
        }
        
        self.addSubview(self.phoneLabel)
        self.phoneLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.left.equalTo(self.icon.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
        }
        
        self.addSubview(self.addressLabel)
        self.addressLabel.snp.makeConstraints { make in
            make.top.equalTo(self.phoneLabel.snp.bottom).offset(Constants.UI.Spacing.Height.Small)
            make.left.equalTo(self.icon.snp.right).offset(Constants.UI.Spacing.Width.Medium * 0.75)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Width.Small)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.icon.clipsToBounds = true
        self.icon.layer.cornerRadius = self.icon.bounds.width / 2
    }
    
}
