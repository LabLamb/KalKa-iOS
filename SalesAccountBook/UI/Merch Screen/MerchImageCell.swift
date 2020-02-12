//
//  MerchImageCell.swift
//  SalesAccountBook
//
//  Created by LabLamb on 12/2/2020.
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import SwiftForms

class MerchImageCell: FormBaseCell {
    
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "MerchDefault"))
    
    override func configure() {
        super.configure()
        self.addSubview(self.iconImage)
        iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Small)
            make.centerX.equalToSuperview()
            make.width.equalTo(self.iconImage.snp.height)
        }
    }
    
    override func update() {
        super.update()
    }
}
