//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.tintColor = .buttonIcon
        if var textAttributes = self.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.text
            self.navigationBar.titleTextAttributes = textAttributes
        } else {
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            self.navigationBar.titleTextAttributes = textAttributes
        }
    }
}
