//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit
import PanModal

class ModalNavigationViewController: CustomNavigationController, PanModalPresentable {
    
    let formHeight: PanModalHeight
    
    init(rootViewController: UIViewController, formHeight: PanModalHeight) {
        self.formHeight = formHeight
        super.init(rootViewController: rootViewController)
        rootViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeView))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return self.formHeight
    }
    
    @objc private func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
}
