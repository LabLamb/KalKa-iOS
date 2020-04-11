//
//  Copyright © LabLambWorks. All rights reserved.
//

import SnapKit
import PNPForm
import StoreKit

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
    
    lazy var feedbackForm: PNPForm = {
        let feedbackBtn = UIButton()
        feedbackBtn.setTitleColor(.buttonIcon, for: .normal)
        feedbackBtn.setTitle(.giveFeedback, for: .normal)
        feedbackBtn.addTarget(self, action: #selector(self.callFeedback), for: .touchUpInside)
        feedbackBtn.heightAnchor.constraint(equalToConstant: Constants.UI.Sizing.Height.TextFieldDefault).isActive = true
        return PNPForm(rows: [feedbackBtn], separatorColor: .background)
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        self.navigationItem.title = .settings
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveSettings))
        self.setup()
        
        self.settingsForm.prefillRowsInOrder(orderedValues: [currentLang])
    }
    
    @objc private func callFeedback() {
        SKStoreReviewController.requestReview()
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
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top).offset(Constants.UI.Spacing.Width.Medium)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
        }
        self.settingsForm.backgroundColor = .primary
        self.settingsForm.clipsToBounds = true
        
        self.view.addSubview(self.feedbackForm)
        self.feedbackForm.snp.makeConstraints { make in
            make.top.equalTo(self.settingsForm.snp.bottom).offset(Constants.UI.Spacing.Width.Medium)
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
        }
        self.feedbackForm.backgroundColor = .primary
        self.feedbackForm.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.settingsForm.layer.cornerRadius = self.settingsForm.frame.width / 24
            self.feedbackForm.layer.cornerRadius = self.feedbackForm.frame.width / 24
        }
    }
}
