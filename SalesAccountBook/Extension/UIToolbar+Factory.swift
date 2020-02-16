//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

extension UIToolbar {
    static func makeKeyboardToolbar(target: Any?, doneAction: Selector) -> UIToolbar {
        let result = UIToolbar()
        result.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: target, action: doneAction)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        result.setItems([spaceButton, doneButton], animated: false)
        
        return result
    }
    
    static func makeKeyboardToolbar(target: Any?, doneAction: Selector, cancelAction: Selector) -> UIToolbar {
        let result = UIToolbar()
        result.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: target, action: doneAction)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: target, action: cancelAction)

        result.setItems([doneButton, spaceButton, cancelButton], animated: false)
        
        return result
    }
}
