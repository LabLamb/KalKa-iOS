//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithDatePicker: TitleWithTextField {
    
    let datePicker: UIDatePicker
    
    init(title: String,
         placeholder: String = Date().toString(format: Constants.System.DateFormat),
         textAlign: NSTextAlignment = .left) {
        self.datePicker = UIDatePicker()
        
        super.init(title: title, placeholder: placeholder, textAlign: textAlign)
        
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
    
    @objc func dateDidPick(){
        self.textField.text = self.datePicker.date.toString(format: Constants.System.DateFormat)
        self.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
