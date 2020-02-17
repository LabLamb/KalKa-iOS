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
                make.height.equalTo(weight)
            case .bottom:
                make.bottom.centerX.width.equalToSuperview()
                make.height.equalTo(weight)
            case .left:
                make.left.centerY.height.equalToSuperview()
                make.width.equalTo(weight)
            case .right:
                make.right.centerY.height.equalToSuperview()
                make.width.equalTo(weight)
            }
            
        }
    }
}

