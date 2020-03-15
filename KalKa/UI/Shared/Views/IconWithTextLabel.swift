//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class IconWithTextLabel: CustomView {

    let iconImageView: UIImageView
    let textField: UITextField
    let spacing: CGFloat
    
    init(icon: UIImage, textField: UITextField, spacing: CGFloat) {
        self.iconImageView = UIImageView(image: icon)
        self.textField = textField
        self.spacing = spacing
        super.init()
        
        self.textField.isEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
        }
        
        self.addSubview(self.iconImageView)
        self.iconImageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium * 0.75)
            make.width.equalTo(self.iconImageView.snp.height)
        }
        
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints { make in
            make.left.equalTo(self.iconImageView.snp.right).offset(self.spacing)
            make.top.bottom.right.equalToSuperview()
        }
    }
}
