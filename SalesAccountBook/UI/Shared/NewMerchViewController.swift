//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class NewMerchViewController: UIViewController {

    let stackView: UIStackView
    let merchName: UITextField
    let merchPic: UIButton
    let merchPrice: UITextField
    let merchQty: UITextField
    let merchRemark: UITextField
    
    init() {
        self.stackView = UIStackView()
        self.merchName = UITextField()
        self.merchPic = UIButton()
        self.merchPrice = UITextField()
        self.merchQty = UITextField()
        self.merchRemark = UITextField()
        super.init(nibName: nil, bundle: nil)
        self.stackView.axis = .vertical
        self.stackView.addArrangedSubview(self.merchName)
        self.stackView.addArrangedSubview(self.merchPic)
        self.stackView.addArrangedSubview(self.merchPrice)
        self.stackView.addArrangedSubview(self.merchQty)
        self.stackView.addArrangedSubview(self.merchRemark)
        
        self.merchName.placeholder = NSLocalizedString("MerchName", comment: "The name for merch.")
        self.merchPrice.placeholder = NSLocalizedString("MerchPrice", comment: "The name for merch.")
        self.merchQty.placeholder = NSLocalizedString("MerchQty", comment: "The name for merch.")
        self.merchRemark.placeholder = NSLocalizedString("MerchRemark", comment: "The name for merch.")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        self.merchName.snp.makeConstraints { make in
            make.height.equalTo(self.view.snp.height).dividedBy(10)
        }
        
        self.merchPic.snp.makeConstraints { make in
            make.height.equalTo(self.view.snp.height).dividedBy(10)
        }
        
        self.merchPrice.snp.makeConstraints { make in
            make.height.equalTo(self.view.snp.height).dividedBy(10)
        }

        self.merchQty.snp.makeConstraints { make in
            make.height.equalTo(self.view.snp.height).dividedBy(10)
        }
        
        self.merchRemark.snp.makeConstraints { make in
            make.height.equalTo(self.view.snp.height).dividedBy(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
