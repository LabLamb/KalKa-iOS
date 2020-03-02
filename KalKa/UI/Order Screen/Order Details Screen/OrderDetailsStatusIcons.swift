//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class OrderDetailsStatusIcons: CustomView {
    
    var isDeposit: Bool = false {
        didSet {
            if self.isDeposit {
                self.isDepositIcon.icon.tintColor = .buttonIcon
                self.isDepositIcon.alpha = 1
            } else {
                self.isDepositIcon.icon.tintColor = .text
                self.isDepositIcon.alpha = 0.1
            }
        }
    }

    var isPaid: Bool = false {
        didSet {
            if self.isPaid {
                self.isPaidIcon.icon.tintColor = .buttonIcon
                self.isPaidIcon.alpha = 1
            } else {
                self.isPaidIcon.icon.tintColor = .text
                self.isPaidIcon.alpha = 0.1
            }
        }
    }

    var isShipped: Bool = false {
        didSet {
            if self.isShipped {
                self.isShippedIcon.icon.tintColor = .buttonIcon
                self.isShippedIcon.alpha = 1
            } else {
                self.isShippedIcon.icon.tintColor = .text
                self.isShippedIcon.alpha = 0.1
            }
        }
    }
    
    lazy var isDepositIcon: IconWithTextLabelUnder = {
        let result = IconWithTextLabelUnder(icon: #imageLiteral(resourceName: "isDeposit").withRenderingMode(.alwaysTemplate), text: .deposited)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.toggleIcon(gest:)))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        result.icon.tintColor = .text
        result.alpha = 0.1
        result.font = UITextField().font
        
        return result
    }()

    lazy var isPaidIcon: IconWithTextLabelUnder = {
        let result = IconWithTextLabelUnder(icon: #imageLiteral(resourceName: "isPaid").withRenderingMode(.alwaysTemplate), text: .paid)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.toggleIcon(gest:)))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        result.icon.tintColor = .text
        result.alpha = 0.1
        result.font = UITextField().font
        
        return result
    }()

    lazy var isShippedIcon: IconWithTextLabelUnder = {
        let result = IconWithTextLabelUnder(icon: #imageLiteral(resourceName: "isShipped").withRenderingMode(.alwaysTemplate), text: .shipped)
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.toggleIcon(gest:)))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        result.icon.tintColor = .text
        result.alpha = 0.1
        result.font = UITextField().font
        
        return result
    }()
    
    override func setupLayout() {
        self.addSubview(self.isPaidIcon)
        self.isPaidIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium * 0.75)
            make.width.equalTo(self.isPaidIcon.snp.height).multipliedBy(1.5)
        }
        
        self.addSubview(self.isDepositIcon)
        self.isDepositIcon.snp.makeConstraints { make in
            make.right.equalTo(self.isPaidIcon.snp.left).offset(-Constants.UI.Spacing.Width.Large)
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium * 0.75)
            make.width.equalTo(self.isDepositIcon.snp.height).multipliedBy(1.5)
        }
        
        self.addSubview(self.isShippedIcon)
        self.isShippedIcon.snp.makeConstraints { make in
            make.left.equalTo(self.isPaidIcon.snp.right).offset(Constants.UI.Spacing.Width.Large)
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium * 0.75)
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium * 0.75)
            make.width.equalTo(self.isShippedIcon.snp.height).multipliedBy(1.5)
        }
    }
    
    @objc func toggleIcon(gest: UITapGestureRecognizer) {
        guard let icon = gest.view as? IconWithTextLabelUnder else { return }
        guard let iconText = icon.textLabel.text else { return }
        switch iconText {
        case .deposited:
            self.isDeposit = !isDeposit
        case .paid:
            self.isPaid = !isPaid
        case .shipped:
            self.isShipped = !isShipped
        default:
            break
        }
    }
}
