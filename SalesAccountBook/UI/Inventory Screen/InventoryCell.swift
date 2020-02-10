//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit
import SnapKit

class InventoryCell: UITableViewCell {
    
    let iconImage: UIImageView
    let nameLabel: UILabel
    let priceLabel: UILabel
    let qtyLabel: UILabel
    let remarkLabel: UILabel
    
    init(data: Merch) {
        self.iconImage = UIImageView()
        self.nameLabel = UILabel()
        self.priceLabel = UILabel()
        self.qtyLabel = UILabel()
        self.remarkLabel = UILabel()
        
        super.init(style: .default, reuseIdentifier: "InventoryCell")
        
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(5)
        }
        self.iconImage.clipsToBounds = true
        DispatchQueue.main.async {
            self.iconImage.layer.cornerRadius = self.iconImage.frame.width / 2
        }
    }
    
    override func prepareForReuse() {
        self.nameLabel.text = ""
        self.priceLabel.text = ""
        self.qtyLabel.text = ""
        self.remarkLabel.text = ""
        self.iconImage.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
