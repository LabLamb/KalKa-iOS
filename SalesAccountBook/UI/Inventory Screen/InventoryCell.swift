//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit
import SnapKit

class InventoryCell: UITableViewCell {
    
    lazy var iconImage: UIImageView = {
        let result = UIImageView()
        return result
    }()
    lazy var nameLabel: UILabel = {
        let result = UILabel()
        return result
    }()
    lazy var priceLabel: UILabel = {
        let result = UILabel()
        return result
    }()
    lazy var qtyLabel: UILabel = {
        let result = UILabel()
        return result
    }()
    lazy var remarkLabel: UILabel = {
        let result = UILabel()
        return result
    }()
    
    private func setupLayout() {
        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(Constants.Layout.Spacing.Large)
            make.bottom.equalToSuperview().offset(-Constants.Layout.Spacing.Large)
            make.width.equalToSuperview().dividedBy(5)
            make.height.equalTo(self.iconImage.snp.width)
        }
        self.iconImage.clipsToBounds = true
        DispatchQueue.main.async {
            self.iconImage.layer.borderColor = UIColor.black.cgColor
            self.iconImage.layer.borderWidth = 2
            self.iconImage.layer.cornerRadius = self.iconImage.frame.width / 2
        }
    }
    
    private func setupData(data: Merch) {
        self.iconImage.image = data.image
    }
    
    public func setup(data: Merch) {
        self.setupLayout()
        self.setupData(data: data)
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = ""
        self.priceLabel.text = ""
        self.qtyLabel.text = ""
        self.remarkLabel.text = ""
        self.iconImage.image = nil
    }
}
