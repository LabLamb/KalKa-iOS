//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func makeError(message: String) -> UIAlertController {
        let errorTitle = NSLocalizedString("GenericError", comment: "Error title.")
        let alertCtrl = UIAlertController(title: errorTitle, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: NSLocalizedString("OK", comment: "Word of confirming an action."), style: .default, handler: { alert in
            alertCtrl.dismiss(animated: true, completion: nil)
        })
        alertCtrl.addAction(alertAction)
        return alertCtrl
    }
    
    static func makeConfirmation(confirmHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alertCtrl = UIAlertController(title: NSLocalizedString("ConfirmationTitle", comment: "Confirmation title."), message: NSLocalizedString("ConfirmationMessage", comment: "Confirmation message."), preferredStyle: .alert)
        
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Decide an event will not take place."), style: .cancel, handler: nil)
        alertCtrl.addAction(cancel)
        
        
        let proceed = UIAlertAction(title: NSLocalizedString("OK", comment: "Word of confirming an action."), style: .default, handler: confirmHandler)
        
        alertCtrl.addAction(proceed)
        
        
        
        return alertCtrl
    }
}
