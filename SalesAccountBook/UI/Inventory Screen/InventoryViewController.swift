//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

class InventoryViewController: UITableViewController {
    
    let inventory: Inventory
    
    init() {
        self.inventory = Inventory()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = NSLocalizedString("Inventory", comment: "The collections of goods.")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addMerch))
    }
    
    @objc private func addMerch() {}
    
}
