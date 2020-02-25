//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

class CustomView: UIView {
    
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.setupLayout()
        self.setupData()
    }
    
    internal func setupLayout() {}
    
    internal func setupData() {}
    
}
