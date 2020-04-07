//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class MembershipViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        self.navigationItem.title = .membership
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveSettings))
        self.setup()
    }
    
    private func setup() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .buttonIcon
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.text
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        } else {
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    }
    
}
