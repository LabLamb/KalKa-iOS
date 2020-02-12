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
}
