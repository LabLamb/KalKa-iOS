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
        
        (self.textView as? UITextField)?.inputAccessoryView = UIToolbar.makeKeyboardToolbar(target: self, doneAction: #selector(self.dateDidPick), cancelAction: #selector(self.cancelDatePicker))
        (self.textView as? UITextField)?.inputView = self.datePicker
        
    }
    
    @objc func dateDidPick(){
        (self.textView as? UITextField)?.text = self.datePicker.date.toString(format: Constants.System.DateFormat)
        self.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}