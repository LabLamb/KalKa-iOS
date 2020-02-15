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
                make.bottom.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(weight)
            case .bottom:
                make.top.equalToSuperview()
                make.width.equalToSuperview()
                make.height.equalTo(weight)
            case .left:
                make.right.equalToSuperview()
                make.width.equalTo(weight)
                make.height.equalToSuperview()
            case .right:
                make.left.equalToSuperview()
                make.width.equalTo(weight)
                make.height.equalToSuperview()
            }
            
        }
    }
}

