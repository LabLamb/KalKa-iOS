//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class OrderDetailsStatusIcons: CustomView {
    
    lazy var iconStack: UIStackView = {
        let result = UIStackView()
        result.axis = .horizontal
        result.distribution = .fillEqually
        result.alignment = .center
        return result
    }()
    
    var isDeposit: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.25, animations: {
                if self.isDeposit {
                    self.isDepositIcon.icon.tintColor = .buttonIcon
                    self.isDepositIcon.icon.alpha = 1
                } else {
                    self.isDepositIcon.icon.tintColor = .text
                    self.isDepositIcon.icon.alpha = 0.1
                }
            })
        }
    }
    
    var isPaid: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.25, animations: {
                if self.isPaid {
                    self.isPaidIcon.icon.tintColor = .buttonIcon
                    self.isPaidIcon.icon.alpha = 1
                } else {
                    self.isPaidIcon.icon.tintColor = .text
                    self.isPaidIcon.icon.alpha = 0.1
                }
            })
        }
    }
    
    var isPreped: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.25, animations: {
                if self.isPreped {
                    self.isPrepedIcon.icon.tintColor = .buttonIcon
                    self.isPrepedIcon.icon.alpha = 1
                } else {
                    self.isPrepedIcon.icon.tintColor = .text
                    self.isPrepedIcon.icon.alpha = 0.1
                }
            })
        }
    }
    
    var isShipped: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.25, animations: {
                if self.isShipped {
                    self.isShippedIcon.icon.tintColor = .buttonIcon
                    self.isShippedIcon.icon.alpha = 1
                } else {
                    self.isShippedIcon.icon.tintColor = .text
                    self.isShippedIcon.icon.alpha = 0.1
                }
            })
        }
    }
    
    lazy var isDepositIcon: IconWithTextLabelUnder = {
        let result = IconWithTextLabelUnder(icon: #imageLiteral(resourceName: "isDeposit").withRenderingMode(.alwaysTemplate), text: .deposited)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.toggleIcon(gest:)))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        result.icon.tintColor = .text
        result.icon.alpha = 0.1
        result.font = UITextField().font
        
        return result
    }()
    
    lazy var isPaidIcon: IconWithTextLabelUnder = {
        let result = IconWithTextLabelUnder(icon: #imageLiteral(resourceName: "isPaid").withRenderingMode(.alwaysTemplate), text: .paid)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.toggleIcon(gest:)))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        result.icon.tintColor = .text
        result.icon.alpha = 0.1
        result.font = UITextField().font
        
        return result
    }()
    
    lazy var isPrepedIcon: IconWithTextLabelUnder = {
        let result = IconWithTextLabelUnder(icon: #imageLiteral(resourceName: "isPreped").withRenderingMode(.alwaysTemplate), text: .preped)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.toggleIcon(gest:)))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        result.icon.tintColor = .text
        result.icon.alpha = 0.1
        result.font = UITextField().font
        
        return result
    }()
    
    lazy var isShippedIcon: IconWithTextLabelUnder = {
        let result = IconWithTextLabelUnder(icon: #imageLiteral(resourceName: "isShipped").withRenderingMode(.alwaysTemplate), text: .shipped)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.toggleIcon(gest:)))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        result.icon.tintColor = .text
        result.icon.alpha = 0.1
        result.font = UITextField().font
        
        return result
    }()
    
    override func setupLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault * 2)
        }
        
        [self.isDepositIcon,
         self.isPrepedIcon,
         self.isPaidIcon,
         self.isShippedIcon].forEach({ icon in
            self.iconStack.addArrangedSubview(icon)
            icon.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
            }
         })
        
        self.addSubview(self.iconStack)
        self.iconStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Small)
            make.left.equalToSuperview().offset(Constants.UI.Spacing.Height.Small)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Small)
            make.right.equalToSuperview().offset(-Constants.UI.Spacing.Height.Small)
        }
    }
    
    @objc func toggleIcon(gest: UITapGestureRecognizer) {
        guard let icon = gest.view as? IconWithTextLabelUnder else { return }
        guard let iconText = icon.textLabel.text else { return }
        switch iconText {
        case .deposited:
            self.isDeposit = !self.isDeposit
        case .paid:
            self.isPaid = !self.isPaid
        case .preped:
            self.isPreped = !self.isPreped
        case .shipped:
            self.isShipped = !self.isShipped
        default:
            break
        }
    }
}
