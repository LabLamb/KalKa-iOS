//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func makeError(message: String) -> UIAlertController {
        let alertCtrl = UIAlertController(title: .error, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: .OK, style: .default, handler: { alert in
            alertCtrl.dismiss(animated: true, completion: nil)
        })
        alertCtrl.addAction(alertAction)
        return alertCtrl
    }
    
    static func makePrompt(message: String) -> UIAlertController {
        let alertCtrl = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: .OK, style: .default, handler: { alert in
            alertCtrl.dismiss(animated: true, completion: nil)
        })
        alertCtrl.addAction(alertAction)
        return alertCtrl
    }
    
    static func makeConfirmation(confirmHandler: @escaping (UIAlertAction) -> Void,
                                 confirmationTitle: String? = nil,
                                 confirmationMsg: String? = nil) -> UIAlertController {
        let title = confirmationTitle ?? NSLocalizedString("ConfirmationTitle", comment: "Confirmation title.")
        let message = confirmationMsg ?? NSLocalizedString("ConfirmationMessage", comment: "Confirmation message.")
        
        
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: .cancel, style: .cancel, handler: nil)
        alertCtrl.addAction(cancel)
        
        let proceed = UIAlertAction(title: .OK, style: .default, handler: confirmHandler)
        
        alertCtrl.addAction(proceed)
        
        return alertCtrl
    }
}
