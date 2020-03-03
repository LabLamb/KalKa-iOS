//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

extension UIToolbar {
    static func makeKeyboardToolbar(target: Any?, doneAction: Selector) -> UIToolbar {
        let result = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.System.SupportedMiniumScreenWidth, height: 35))
        result.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: target, action: doneAction)
        doneButton.tintColor = .buttonIcon
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        result.setItems([space, doneButton], animated: false)
        return result
    }
    
    static func makeKeyboardToolbar(target: Any?, doneAction: Selector, cancelAction: Selector) -> UIToolbar {
        let result = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.System.SupportedMiniumScreenWidth, height: 35))
        result.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: target, action: cancelAction)
        cancelButton.tintColor = .buttonIcon
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: target, action: doneAction)
        doneButton.tintColor = .buttonIcon
        
        result.setItems([cancelButton, space, doneButton], animated: false)
        
        return result
    }
    
    
    static func makeKeyboardToolbar(target: Any?, doneAction: Selector, plusOrMinusAction: Selector) -> UIToolbar {
        let result = UIToolbar(frame: CGRect(x: 0, y: 0, width: Constants.System.SupportedMiniumScreenWidth, height: 35))
        result.sizeToFit()
        
        let plusOrMinus = UIBarButtonItem(image: UIImage(named: "PlusMinus"), style: .plain, target: target, action: plusOrMinusAction)
        plusOrMinus.tintColor = .buttonIcon

        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: target, action: doneAction)
        doneButton.tintColor = .buttonIcon

        result.items = [plusOrMinus, space, doneButton]

        return result
    }
}
