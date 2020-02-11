//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class InventoryHeader: UITableViewHeaderFooterView {
    
    lazy var priceTag: UIImageView = {
        let result = UIImageView()
        result.image = #imageLiteral(resourceName: "PriceTag")
        return result
    }()
    
    let stock: UIImageView = {
        let result = UIImageView()
        result.image = #imageLiteral(resourceName: "InStock")
        return result
    }()
    
    public func setup() {
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = .white
            
        self.addSubview(self.priceTag)
        self.priceTag.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.ExSmall)
            make.left.equalTo(self.snp.centerX).offset(Constants.UI.Spacing.ExLarge + Constants.UI.Spacing.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.ExSmall)
            make.width.equalTo(self.priceTag.snp.height)
        }
        
        self.addSubview(self.stock)
        self.stock.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.ExSmall)
            make.left.equalTo(self.priceTag.snp.right).offset(Constants.UI.Spacing.ExLarge + Constants.UI.Spacing.Medium + Constants.UI.Spacing.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.ExSmall)
            make.width.equalTo(self.stock.snp.height)
        }
        

        
    }
    
}
