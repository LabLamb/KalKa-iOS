//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class MerchIconView: UIView {
    
    let iconImage: UIImageView
    
    init() {
        self.iconImage = UIImageView(image: #imageLiteral(resourceName: "MerchDefault"))
        super.init(frame: .zero)
        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.width.equalTo(self.iconImage.snp.height)
        }
        DispatchQueue.main.async {
            self.iconImage.backgroundColor = Constants.UI.Color.Grey
            self.iconImage.clipsToBounds = true
            self.iconImage.layer.borderColor = UIColor.black.cgColor
            self.iconImage.layer.borderWidth = 2.5
            self.iconImage.layer.cornerRadius = self.iconImage.frame.width / 2
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
