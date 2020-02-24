//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class InventoryViewController: SearchTableViewController {
    
    private var filteredMerchs: [Merch] {
        get {
            return self.fileredList as! [Merch]
        }
    }
    
    // MARK: - Initializion
    override init(onSelectRow: ((String) -> Void)? = nil) {
        super.init(onSelectRow: onSelectRow)
        
        self.cellIdentifier = "InventoryCell"
        self.tableView.register(InventoryCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        self.list = Inventory()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = .inventory
    }
    
    override func filterListByString(_ searchText: String) {
        let merchs = self.list.items as! [Merch]
        if searchText == "" {
            self.fileredList = self.list.items
        } else {
            self.fileredList = merchs.filter({ merch in
                return merch.name.lowercased().contains(searchText.lowercased()) || merch.remark.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
    
    override func navigateToDetailView(config: DetailsConfigurator) {
        let editVC = MerchDetailViewController(config: config)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
}
