//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class DetailFormViewController: UIViewController {
    
    let scrollView: UIScrollView
    
    init() {
        self.scrollView = UIScrollView()
        
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keboardDidDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func keyboardDidAppear(noti: NSNotification) {
        guard let info = noti.userInfo else { return }
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        self.scrollView.contentInset = insets
        self.scrollView.scrollIndicatorInsets = insets
    }
    
    @objc private func keboardDidDisappeared() {
        self.scrollView.contentInset = UIEdgeInsets.zero
        self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // MARK: - Errors
    internal func promptCustomerNameExistsError() {
        let errorMessage = NSLocalizedString("ErrorCustomerExists", comment: "Error Message - Customer exists with the same name.")
        self.present(UIAlertController.makeError(message: errorMessage), animated: true, completion: nil)
    }
    
    internal func promptEmptyFieldError(field: UITextField) {
        let errorMessage = NSLocalizedString("ErrorCustomerInputEmpty", comment: "Error Message - Customer name text field .")
        self.present(UIAlertController.makeError(message: errorMessage), animated: true, completion: nil)
        
        field.attributedPlaceholder = NSAttributedString(
            string: NSLocalizedString("Required(Input)", comment: "Must input."),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.red.withAlphaComponent(0.5)])
    }
}
