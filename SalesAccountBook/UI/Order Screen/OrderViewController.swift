//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class OrderViewController: SearchTableViewController {
    
    private var fileredOrders: [Order] {
        get {
            return self.fileredList as! [Order]
        }
    }
    
    var customerName: String?
    
    // MARK: - Initializion
    override init(onSelectRow: ((String) -> Void)? = nil) {
        super.init(onSelectRow: onSelectRow)
        
        self.list = OrderList()
        
        self.cellIdentifier = "OrderListCell"
        self.tableView.register(OrderCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
        self.searchBar.scopeButtonTitles = [.all, .open, .closed]
        self.searchBar.selectedScopeButtonIndex = 1
        self.searchBar.showsScopeBar = true
        self.tableView.reloadData()
        self.searchBar.scopeBarBackgroundImage = UIImage()
        
        DispatchQueue.main.async {
            self.refresh()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = .orders
    }
    
    override func filterListByString(_ searchText: String) {
        let allOrders = self.list.items as! [Order]
        if searchText != "" {
            self.fileredList = allOrders.filter({ order in
                if self.searchBar.selectedScopeButtonIndex == 0 {
                    return true
                } else if self.searchBar.selectedScopeButtonIndex == 1 {
                    return order.isClosed == false
                } else {
                    return order.isClosed
                }
            }).filter({ order in
                let dateString = order.openedOn?.toString(format: Constants.System.DateFormat) ?? ""
                return String(order.number).lowercased().contains(searchText.lowercased()) || dateString.lowercased().contains(searchText.lowercased()) ||
                    order.customer.name.lowercased().contains(searchText.lowercased()) ||
                    order.customer.remark.lowercased().contains(searchText.lowercased())
            })
        } else {
            self.fileredList = allOrders.filter({ order in
                if self.searchBar.selectedScopeButtonIndex == 0 {
                    return true
                } else if self.searchBar.selectedScopeButtonIndex == 1 {
                    return order.isClosed == false
                } else {
                    return order.isClosed
                }
            })
        }
        self.tableView.reloadData()
    }
    
    override func navigateToDetailView(config: DetailsConfigurator) {
        let editVC = OrderDetailViewController(config: config)
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
}

// MARK: - SearchBar
extension OrderViewController {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterListByString(self.searchBar.text ?? "")
    }
}
