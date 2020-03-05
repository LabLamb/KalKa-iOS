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
    
    var focusedView: UIView?
    var scrollOffset: CGFloat = 0
    var distance: CGFloat = 0
    
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
        self.scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: [NSKeyValueObservingOptions.new], context: &detailViewContext)
        self.currentContentSize = self.scrollView.contentSize
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if self.scrollView.observationInfo != nil {
            self.scrollView.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &detailViewContext,
            keyPath == #keyPath(UIScrollView.contentSize),
            let contentSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
            self.scrollView.contentOffset.y += max(0, (contentSize.height - self.currentContentSize.height) * 0.99)
            self.currentContentSize = contentSize
        }
    }
    
    deinit {
        self.list = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
                        completion: { [weak self] success in
                            guard let `self` = self else { return }
                            if success {
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                self.promptItemExistsError()
                            }
        })
    }
}
