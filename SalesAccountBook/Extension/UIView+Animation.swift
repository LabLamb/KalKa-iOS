//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public func addShakeAnimation() {
        UIView.animateKeyframes(withDuration: 1.6, delay: 0, options: [.repeat], animations: {
            for i in 0...5 {
                var angle: CGFloat = 0.25
                if i % 2 == 0 {
                    angle = -0.25
                }
                UIView.addKeyframe(withRelativeStartTime: Double(i) / 10.0, relativeDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(rotationAngle: angle)
                })
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 1, animations: {
                self.transform = .identity
            })
        }, completion: nil)
    }
}


enum LINE_POSITION {
    case LINE_POSITION_TOP
    case LINE_POSITION_BOTTOM
}

extension UIView {
    func addLine(position : LINE_POSITION, color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        lineView.translatesAutoresizingMaskIntoConstraints = false // This is important!
        self.addSubview(lineView)

        let metrics = ["width" : NSNumber(value: width)]
        let views = ["lineView" : lineView]
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lineView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))

        switch position {
        case .LINE_POSITION_TOP:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lineView(width)]", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        case .LINE_POSITION_BOTTOM:
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lineView(width)]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics:metrics, views:views))
            break
        }
    }
}
