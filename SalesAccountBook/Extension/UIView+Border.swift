//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

extension UIView {
    func addLine(position : LinePosition, color: UIColor, weight: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        self.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            switch position {
            case .top:
                make.top.centerX.width.equalToSuperview()
            case .bottom:
                make.bottom.centerX.width.equalToSuperview()
            case .left:
                make.left.centerY.height.equalToSuperview()
            case .right:
                make.right.centerY.height.equalToSuperview()
            }
            
        }
    }
}

