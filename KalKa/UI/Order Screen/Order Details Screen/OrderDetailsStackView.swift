//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class OrderDetailsStackView: InputFieldsSection {
    
    func appendView(view: CustomView) {
        self.stackView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.95)
            view.backgroundColor = .primary
            view.addLine(position: .bottom, color: self.separatorColor, weight: 1)
        }
    }
    
    deinit {
        
    }
}
