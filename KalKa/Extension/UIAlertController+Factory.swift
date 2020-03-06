//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func makeError(message: String, errorCode: KalKaError? = nil) -> UIAlertController {
        let alertCtrl = UIAlertController(title: .error, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: .OK, style: .default, handler: { alert in
            alertCtrl.dismiss(animated: true, completion: nil)
        })
        alertCtrl.addAction(alertAction)
        return alertCtrl
    }
    
    static func makeConfirmation(confirmHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let alertCtrl = UIAlertController(title: NSLocalizedString("ConfirmationTitle", comment: "Confirmation title."), message: NSLocalizedString("ConfirmationMessage", comment: "Confirmation message."), preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: .cancel, style: .cancel, handler: nil)
        alertCtrl.addAction(cancel)
        
        let proceed = UIAlertAction(title: .OK, style: .default, handler: confirmHandler)
        
        alertCtrl.addAction(proceed)
        
        return alertCtrl
    }
}
