//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit
import PNPForm

class SettingsViewController: UIViewController {
    
    var currentLang: String {
        get {
            let currentLangKey = (UserDefaults.standard.value(forKey: "AppleLanguages") as? Array<String>)?.first ?? ""
            return Constants.System.AppLanguageMapping.first(where:  { tuple in
                tuple.value.rawValue == currentLangKey
            })?.key ?? ""
        }
    }
    
    lazy var settingsForm: PNPForm = {
        let languageRowConfig = PNPRowConfig(type: .picker(options: Constants.System.AppLanguages), placeholder: .settings)
        let languageRow = PNPRow(title: .sysLanguage, config: languageRowConfig)
        
        let result = PNPForm(rows: [languageRow], separatorColor: .background)
        return result
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        self.navigationItem.title = .settings
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveSettings))
        self.setup()
        
        self.settingsForm.prefillRowsInOrder(orderedValues: [currentLang])
    }
    
    @objc private func saveSettings() {
        if let selectedLangauge = self.settingsForm.getRows(withLabelText: .sysLanguage).first?.value,
            self.currentLang != selectedLangauge,
            let key = Constants.System.AppLanguageMapping[selectedLangauge]?.rawValue {
            UserDefaults.standard.set([key], forKey: "AppleLanguages")
            
            let alert = UIAlertController.makePrompt(message: NSLocalizedString("RestartTakeEffect", comment: ""))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func setup() {
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
