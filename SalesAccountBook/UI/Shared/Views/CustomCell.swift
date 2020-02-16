//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import CoreData

class CustomCell: UITableViewCell {
    
    lazy var paddingView: UIView = {
        let result = UIView()
        result.backgroundColor = .primary
        return result
    }()
    
    internal func setupLayout() {
        self.backgroundColor = .clear
        
        self.contentView.addSubview(self.paddingView)
        self.paddingView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium * 0.75)
            make.bottom.equalToSuperview()
        }
    }
    
    internal func setupData(data: NSManagedObject) {}
    
    public func setup(data: NSManagedObject) {
        self.selectionStyle = .none
        self.setupLayout()
        self.setupData(data: data)
    }
    
    override func layoutSubviews() {
        self.paddingView.clipsToBounds = true
        self.paddingView.layer.cornerRadius = self.paddingView.frame.width / 16
        super.layoutSubviews()
    }
}
