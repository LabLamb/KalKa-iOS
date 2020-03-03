//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class DetailFormViewController: UIViewController {
    
    let scrollView: UIScrollView
    var itemExistsErrorMsg: String = ""
    var currentId: String
    var list: ViewModel?
    let mimimumBottomInset = Constants.UI.Spacing.Height.Medium * 0.75
    private var detailViewContext = 0
    private var currentContentSize: CGSize = CGSize(width: 0, height: 0)
    
    init(config: DetailsConfiguration) {
        self.scrollView = UIScrollView()
        self.currentId = config.id
        self.list = config.viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.scrollView.contentInset = .init(top: mimimumBottomInset, left: mimimumBottomInset, bottom: mimimumBottomInset, right: mimimumBottomInset)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
        }
        self.scrollView.isDirectionalLockEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: [NSKeyValueObservingOptions.new], context: &detailViewContext)
        
        self.currentContentSize = self.scrollView.contentSize
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
        NotificationCenter.default.removeObserver(self)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &detailViewContext,
            keyPath == #keyPath(UIScrollView.contentSize),
            let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
            self.scrollView.contentOffset.y += max(0, (contentSize.height - self.currentContentSize.height) * 0.99)
            self.currentContentSize = contentSize
        }
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
    
    @objc private func keyboardDidDisappeared() {
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
        self.list?.edit(oldId: self.currentId,
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
