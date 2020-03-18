//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit
import PNPForm

class SettingsViewController: UIViewController {
    
    lazy var settingsForm: PNPForm = {
        let languageRowConfig = PNPRowConfig(type: .picker(options: ["English", "Chinese"]), placeholder: .settings)
        let languageRow = PNPRow(title: "Language", config: languageRowConfig)
        
        let result = PNPForm(rows: [languageRow], separatorColor: .background)
        return result
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        self.navigationItem.title = .settings
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveSettings))
        self.setup()
    }
    
    @objc private func saveSettings() {}
    
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
        
        self.view.addSubview(self.settingsForm)
        self.settingsForm.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
        }
        self.settingsForm.backgroundColor = .primary
        self.settingsForm.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.settingsForm.layer.cornerRadius = self.settingsForm.frame.width / 24
        }
    }
}
