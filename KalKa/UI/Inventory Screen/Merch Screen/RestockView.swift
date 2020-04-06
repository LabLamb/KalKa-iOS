//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class RestockView: CustomView {
    
    let returnBtn: UIButton
    let restockDate: UILabel
    let restockQty: UILabel
    var returnDelegate: ((CustomView) -> Void)?
    
    init(date: Date, qty: Int, returnDelegate: @escaping (CustomView) -> Void) {
        self.returnBtn = UIButton()
        self.restockDate = UILabel()
        self.restockQty = UILabel()
        self.returnDelegate = returnDelegate
        
        super.init()
        
        let icon = UIImage(named: "Return")?.withRenderingMode(.alwaysTemplate)
        self.returnBtn.setImage(icon, for: .normal)
        self.returnBtn.imageView?.tintColor = .buttonIcon
        self.returnBtn.addTarget(self, action: #selector(self.returnBtnClicked), for: .touchUpInside)
        
        self.restockDate.text = date.toString(format: "\(Constants.System.DateFormat) hh:mm a")
        self.restockDate.font = Constants.UI.Font.Plain.Small
        self.restockDate.textColor = .accent
        
        self.restockQty.text = String(qty)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func returnBtnClicked() {
        self.returnDelegate?(self)
    }
    
    override func setupLayout() {
        
        self.addSubview(self.returnBtn)
        self.returnBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(self.restockDate)
        self.restockDate.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(self.restockQty)
        self.restockQty.snp.makeConstraints { make in
            make.left.equalTo(self.returnBtn.snp.right).offset(Constants.UI.Spacing.Width.Medium)
            make.centerY.equalToSuperview()
        }
    }
}
