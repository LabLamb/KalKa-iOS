//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import PNPForm
import PanModal

class MerchQtyDetailViewController: UIViewController {
    
    let scrollView: UIScrollView
    let mimimumBottomInset = Constants.UI.Spacing.Height.Medium * 0.75
    let currentQty: Int
    let onSaveDelegate: (Int) -> Void
    lazy var calcForm: PNPForm = {
        let currAndTotalQtyRowConfig = PNPRowConfig(type: .label, placeholder: String(self.currentQty))
        let newQtyRowConfig = PNPRowConfig(type: .singlelineText(PNPKeyboardConfig(keyboardType: .decimalPad)),
                                           placeholder: .required)
        
        let totalRowUpdateHandler: (Int) -> Void = { [weak self] newValue in
            guard let self = self else { return }
            guard let currValue = self.calcForm.extractRowValues(withLabelTextList: [.inStock])[.inStock],
                let inStock = Int(currValue) else {
                    self.navigationItem.rightBarButtonItem?.isEnabled = false
                    return
            }
            
            self.calcForm.prefillRows(titleValueMap: [
                .subtotal: String(newValue + inStock)
            ])
            
            if newValue <= 0 {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
        
        return PNPForm(rows: [
            PNPRow(title: .inStock, config: currAndTotalQtyRowConfig),
            NewQtyRow(textFieldOnChange: totalRowUpdateHandler),
            PNPRow(title: .subtotal, config: currAndTotalQtyRowConfig)
        ], separatorColor: .background)
    }()
    
    init(currentQty: Int, onSave: @escaping (Int) -> Void) {
        self.scrollView = UIScrollView()
        self.currentQty = currentQty
        self.onSaveDelegate = onSave
        
        super.init(nibName: nil, bundle: nil)
        
        self.scrollView.contentInset = .init(top: mimimumBottomInset, left: mimimumBottomInset, bottom: mimimumBottomInset, right: mimimumBottomInset)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .background
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.bottom.left.right.equalToSuperview()
        }
        self.scrollView.isDirectionalLockEnabled = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.submitDetails))
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(self.closeView))
        
        self.scrollView.addSubview(self.calcForm)
        self.calcForm.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(self.view).offset(Constants.UI.Spacing.Width.Medium)
            make.right.equalTo(self.view).offset(-Constants.UI.Spacing.Width.Medium)
            make.bottom.equalToSuperview()
        }
        self.calcForm.backgroundColor = .primary
        self.calcForm.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.calcForm.layer.cornerRadius = self.calcForm.frame.width / 24
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Data
    @objc private func submitDetails() {
        guard let rowValue = self.calcForm.getRows(withLabelText: .restock).first?.value,
            let restockQty = Int(rowValue) else { return }
        self.onSaveDelegate(restockQty)
    }
}

class MerchQtyDetailNavViewController: UINavigationController, PanModalPresentable {

    var panScrollable: UIScrollView? {
           return nil
       }
       
       var shortFormHeight: PanModalHeight {
           return .contentHeight(Constants.UI.Sizing.Height.ExLarge)
       }
}
