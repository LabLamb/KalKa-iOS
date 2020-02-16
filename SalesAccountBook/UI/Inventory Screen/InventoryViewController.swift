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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.navToAddMerchView))
    }
    
    @objc private func navToAddMerchView() {
        let merchConfig: DetailsConfigurator = {
            if let delegate = self.onSelectRowDelegate {
                return DetailsConfigurator(action: .add, id: nil, viewModel: self.list, onSelectRow: delegate)
            } else {
                return DetailsConfigurator(action: .add, id: nil, viewModel: self.list, onSelectRow: nil)
            }
        }()
        
        let newMerchVC = MerchDetailViewController(config: merchConfig)
        self.navigationController?.pushViewController(newMerchVC, animated: true)
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
}


// MARK: - TableView
extension InventoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let merchName = self.filteredMerchs[indexPath.row].name
        if let delegate = self.onSelectRowDelegate {
            delegate(merchName)
        } else {
            let merchConfig = DetailsConfigurator(action: .edit, id: merchName, viewModel: self.list, onSelectRow: nil)
            let editMerchVC = MerchDetailViewController(config: merchConfig)
            self.navigationController?.pushViewController(editMerchVC, animated: true)
        }
    }
}
