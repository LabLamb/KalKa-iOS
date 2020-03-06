//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class DetailFormViewController: UIViewController {
    
    let scrollView: UIScrollView
    var itemExistsErrorMsg = ""
    let mimimumBottomInset = Constants.UI.Spacing.Height.Medium * 0.75
    private var detailViewContext = 0
    private var currentContentSize = CGSize(width: 0, height: 0)
    final var allFieldsIsValid: Bool {
        get {
            return self.validateFields()
        }
    }
    
    // MARK: - DetailsConfiguration Properties
    var currentId: String
    var list: ViewModel?
    let actionType: DetailsViewActionType
    var onSelectRowDelegate: ((String) -> Void)?
    weak var presentingRefreshAble: Refreshable?
    
    init(config: DetailsConfiguration) {
        self.scrollView = UIScrollView()
        self.currentId = config.id
        self.list = config.viewModel
        self.actionType = config.action
        self.onSelectRowDelegate = config.onSelectRow
        self.presentingRefreshAble = config.presentingRefreshable
        
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
        
        if self.actionType == .add {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.closeAndRefresh))
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.submitDetails))
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
    
    @objc func closeAndRefresh() {
        self.dismiss(animated: true, completion: nil)
        self.presentingRefreshAble?.refresh()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    func addItem(details: ModelDetails) {
        self.list?.add(details: details, completion: { [weak self] success in
            guard let `self` = self else { return }
            if !success {
                self.promptItemExistsError()
            }
            if let delegate = self.onSelectRowDelegate {
                self.dismiss(animated: true, completion: {
                    delegate(details.id)
                })
            } else {
                self.closeAndRefresh()
            }
        })
    }
    
    func editItem(details: Any) {
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
    
    func makeDetails() -> ModelDetails {
        fatalError("Make Details is not implemented.")
    }
    
    @objc private func submitDetails () {
        if self.allFieldsIsValid {
            let handler: (UIAlertAction) -> Void = { [weak self] alert in
                guard let `self` = self else { return }
                if self.actionType == .edit {
                    self.editItem(details: self.makeDetails())
                } else if self.actionType == .add {
                    self.addItem(details: self.makeDetails())
                }
            }
            
            let confirmationAlert = UIAlertController.makeConfirmation(confirmHandler: handler)
            
            self.present(confirmationAlert, animated: true, completion: nil)
        }
    }
    
    func validateFields() -> Bool {
        return true
    }
    
    // MARK: - Errors
    func promptItemExistsError() {
        self.present(UIAlertController.makeError(message: self.itemExistsErrorMsg), animated: true, completion: nil)
    }
    
    func promptEmptyFieldError(errorMsg: String, field: UITextField?) {
        self.present(UIAlertController.makeError(message: errorMsg), animated: true, completion: nil)
        
        field?.attributedPlaceholder = NSAttributedString(
            string: .required,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red.withAlphaComponent(0.5)])
    }
}
