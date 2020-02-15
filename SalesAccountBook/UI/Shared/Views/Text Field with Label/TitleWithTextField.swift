//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import SnapKit

class TitleWithTextField: DescWithText {
    
    override var text: String {
        get {
            return (self.textView as? UITextField)?.text ?? ""
        }

        set {
            (self.textView as? UITextField)?.text = newValue
        }
    }
    
    private let maxTextLength: Int
    
    init(title: String, placeholder: String = "", textAlign: NSTextAlignment = .left, maxTextLength: Int = .max) {
        let tagView = UILabel()
        let textView = UITextField()
        self.maxTextLength = maxTextLength
        
        super.init(tagView: tagView, textView: textView)
        
        tagView.text = title
        tagView.textAlignment = .left
        tagView.numberOfLines = 0
        
        textView.placeholder = placeholder
        textView.textAlignment = textAlign
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TitleWithTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.text?.count ?? 0 < self.maxTextLength || string == ""
    }
}
