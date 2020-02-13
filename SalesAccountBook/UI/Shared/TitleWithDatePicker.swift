//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithDatePicker: UIView {
    
    let title: UILabel
    let textField: UITextField
    let datePicker: UIDatePicker
    var text: String {
        get {
            return self.textField.text ?? ""
        }
        
        set {
            self.textField.text = newValue
        }
    }
    
    var spacing: CGFloat {
        didSet {
            self.textField.snp.updateConstraints { make in
                make.left.equalTo(self.title.snp.right).offset(self.spacing)
            }
            self.layoutIfNeeded()
        }
    }
    
    init(title: String,
         placeholder: String = Date().toString(format: Constants.Data.DateFormat),
         textAlign: NSTextAlignment = .left) {
        self.title = UILabel()
        self.textField = UITextField()
        self.spacing = 5
        self.datePicker = UIDatePicker()
        
        super.init(frame: .zero)
        
        self.addSubview(self.title)
        self.title.snp.makeConstraints({ make in
            make.top.left.bottom.equalToSuperview()
            make.width.equalToSuperview().dividedBy(3)
        })
        self.title.text = title
        self.title.textAlignment = .left
        self.title.numberOfLines = 0
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(focusTextField))
        self.title.isUserInteractionEnabled = true
        self.title.addGestureRecognizer(tapGest)
        
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints({ make in
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(self.title.snp.right).offset(self.spacing)
        })
        
        self.textField.placeholder = placeholder
        self.textField.textAlignment = textAlign
        
        self.datePicker.datePickerMode = .date
        
        let toolbar: UIToolbar = {
            let result = UIToolbar()
            result.sizeToFit()
            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(dateDidPick))
            
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            
            let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelDatePicker))
            
            result.setItems([doneButton, spaceButton, cancelButton], animated: false)
            
            return result
        }()
        
        self.textField.inputAccessoryView = toolbar
        self.textField.inputView = self.datePicker
        
    }
    
    @objc func focusTextField() {
        self.textField.becomeFirstResponder()
    }
    
    @objc func dateDidPick(){
        self.textField.text = self.datePicker.date.toString(format: Constants.Data.DateFormat)
        self.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
