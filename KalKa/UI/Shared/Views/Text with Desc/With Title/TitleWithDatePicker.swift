//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithDatePicker: TitleWithTextField {
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height: Constants.UI.Sizing.Height.TextFieldDefault)
        }
    }
    
    var datePicker: UIDatePicker
    
    init(title: String,
         placeholder: String = Date().toString(format: Constants.System.DateFormat),
         textAlign: NSTextAlignment = .left,
         spacing: CGFloat = 0) {
        self.datePicker = UIDatePicker()
        
        super.init(title: title, placeholder: placeholder, spacing: spacing, textAlign: textAlign)

        self.datePicker.datePickerMode = .date
        
        (self.valueView as? UITextField)?.inputAccessoryView = UIToolbar.makeKeyboardToolbar(target: self, doneAction: #selector(self.dateDidPick), cancelAction: #selector(self.cancelDatePicker))
        (self.valueView as? UITextField)?.inputView = self.datePicker
        
    }
    
    @objc func dateDidPick(){
        (self.valueView as? UITextField)?.text = self.datePicker.date.toString(format: Constants.System.DateFormat)
        self.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.endEditing(true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
