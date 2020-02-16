//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class DetailFormViewController: UIViewController {
    
    let scrollView: UIScrollView
    var itemExistsErrorMsg: String = ""
    var currentId: String?
    var list: ViewModel?
    let mimimumBottomInset = Constants.UI.Spacing.Height.Medium * 0.75
    
    init(config: DetailsConfigurator) {
        self.scrollView = UIScrollView()
        self.currentId = config.id
        self.list = config.viewModel
        
        super.init(nibName: nil, bundle: nil)
        self.scrollView.setContentOffset(.init(x: 0, y: self.mimimumBottomInset), animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keboardDidDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }
        self.scrollView.isDirectionalLockEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func keyboardDidAppear(noti: NSNotification) {
        guard let info = noti.userInfo else { return }
        let rect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let kbHeight = rect.size.height - (self.tabBarController?.tabBar.frame.height ?? 0) + self.mimimumBottomInset
        self.scrollView.contentInset.bottom = kbHeight
        self.scrollView.scrollIndicatorInsets.bottom = kbHeight
    }
    
    @objc private func keboardDidDisappeared() {
        self.scrollView.contentInset.bottom = self.mimimumBottomInset
        self.scrollView.scrollIndicatorInsets.bottom = self.mimimumBottomInset
    }
    
    // MARK: - Errors
    internal func promptItemExistsError() {
        self.present(UIAlertController.makeError(message: self.itemExistsErrorMsg), animated: true, completion: nil)
    }
    
    internal func promptEmptyFieldError(errorMsg: String, field: UITextField) {
        self.present(UIAlertController.makeError(message: errorMsg), animated: true, completion: nil)
        
        field.attributedPlaceholder = NSAttributedString(
            string: .required,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red.withAlphaComponent(0.5)])
    }
    
    internal func editItem(details: Any) {
        guard let oldId = self.currentId else {
            fatalError()
        }
        
        self.list?.edit(oldId: oldId,
                        details: details,
                        completion: { success in
                            if success {
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                self.promptItemExistsError()
                            }
        })
    }
}
