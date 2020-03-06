//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class InventoryViewController: SearchTableViewController {
    
    private var filteredMerchs: [Merch] {
        get {
            return self.filteredList as! [Merch]
        }
    }
    
    // MARK: - Initializion
    override init(onSelectRow: ((String) -> Void)? = nil,
                  preFilterIds: [String]? = nil) {
        super.init(onSelectRow: onSelectRow, preFilterIds: preFilterIds)
        
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
        guard let merchs = self.list?.items as? [Merch] else { return }
        if searchText == "" {
            self.filteredList = merchs
        } else {
            self.filteredList = merchs.filter({ merch in
                return merch.name.lowercased().contains(searchText.lowercased()) || merch.remark.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
    
    override func makeDetailViewController(config: DetailsConfiguration) -> DetailFormViewController {
        return MerchDetailViewController(config: config)
    }
}
