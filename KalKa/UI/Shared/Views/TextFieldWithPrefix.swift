//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class TextFieldWithPrefix: CustomView {

    let prefixLabel: UILabel
    let textField: UITextField
    
    init(prefix: String, textField: UITextField) {
        self.prefixLabel = UILabel()
        self.textField = textField
        self.prefixLabel.text = prefix
        self.prefixLabel.textAlignment = .center
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupLayout() {
        self.addSubview(self.prefixLabel)
        self.prefixLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            let textWidth = ceil(self.prefixLabel.text?.size(withAttributes:[.font: UILabel().font as Any]).width ?? 0)
            make.width.equalTo(textWidth)
        }
        
        self.addSubview(self.textField)
        self.textField.snp.makeConstraints { make in
            make.left.equalTo(self.prefixLabel.snp.right)
            make.top.bottom.right.equalToSuperview()
        }
    }
}
