//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShakeAnimation() {
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
    
    func addSpinAnimation() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: -Float.pi * 2)
        rotation.duration = 60
        rotation.isCumulative = true
        rotation.repeatCount = .greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}


