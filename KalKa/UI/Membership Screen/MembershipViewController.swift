//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import PanModal

class MembershipViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    lazy var functionList: UIStackView = {
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .center
        result.distribution = .fill
        result.spacing = Constants.UI.Spacing.Height.Medium
        return result
    }()
    
    lazy var membership: MembershipFuncButton = {
        let result = MembershipFuncButton(title: .membership, icon: #imageLiteral(resourceName: "Premium").withRenderingMode(.alwaysTemplate) )
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.navToStatus))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        
        result.backgroundColor = .primary
        
        return result
    }()
    
    lazy var statsButton: MembershipFuncButton = {
        let result = MembershipFuncButton(title: .stats, icon: #imageLiteral(resourceName: "Stats").withRenderingMode(.alwaysTemplate))
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.navToStat))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        
        result.backgroundColor = .primary
        
        return result
    }()
    
    lazy var storeButton: MembershipFuncButton = {
        let result = MembershipFuncButton(title: .stores, icon: #imageLiteral(resourceName: "Store").withRenderingMode(.alwaysTemplate))
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.navToStore))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        
        result.backgroundColor = .primary
        result.isEnabled = false
        
        return result
    }()
    
    lazy var storesButton: MembershipFuncButton = {
        let result = MembershipFuncButton(title: .stats, icon: #imageLiteral(resourceName: "Stats").withRenderingMode(.alwaysTemplate))
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.navToStore))
        result.addGestureRecognizer(tapGest)
        result.isUserInteractionEnabled = true
        
        result.backgroundColor = .primary
        
        return result
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .background
        self.navigationItem.title = .extraFeatures
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.membership.icon.tintColor = UserSession.shared.isPremium ? .gold : .buttonIcon
        self.statsButton.isEnabled = UserSession.shared.isPremium
        self.storeButton.isEnabled = UserSession.shared.isPremium
    }
    
    private func setup() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        self.scrollView.addSubview(self.functionList)
        self.functionList.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.view.snp.left).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view.snp.right).offset(-Constants.UI.Spacing.Width.Medium)
        }
        
        self.functionList.addArrangedSubview(self.membership)
        self.functionList.addArrangedSubview(self.statsButton)
        self.functionList.addArrangedSubview(self.storeButton)
        
        self.functionList.arrangedSubviews.forEach({ view in
            view.snp.makeConstraints { make in
                make.height.equalTo(Constants.UI.Sizing.Height.Small * 1.5)
                make.width.equalToSuperview()
            }
            view.clipsToBounds = true
            DispatchQueue.main.async {
                view.layer.cornerRadius = view.frame.width / 24
            }
        })
    }
    
    @objc func navToStatus() {
        self.presentPanModal(ModalNavigationViewController(rootViewController: MembershipPurchaseViewController(),
                                                           formHeight: .maxHeightWithTopInset(Constants.UI.Sizing.Height.Small)))
    }
    
    @objc func navToStat() {
        if self.statsButton.isEnabled {
            self.navigationController?.pushViewController(StatsViewController(), animated: true)
        } else {
            self.membershipReminderPopup()
        }
    }
    
    @objc func navToStore() {
        if self.storeButton.isEnabled {
            self.navigationController?.pushViewController(UIViewController(), animated: true)
        } else {
            self.membershipReminderPopup()
        }
    }
    
    private func membershipReminderPopup() {
        self.presentPanModal(ModalNavigationViewController(rootViewController: MemberShipReminderViewController(),
                                                           formHeight: .contentHeight(Constants.UI.Sizing.Height.Large)))
    }
    
}

