//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import CoreData

class OrderViewController: SearchTableViewController {
    
    private var fileredOrders: [Order] {
        get {
            return self.filteredList as! [Order]
        }
    }
    
    // MARK: - Initializion
    override init(onSelectRow: ((String) -> Void)? = nil,
                  preFilterIds: [String]? = nil) {
        super.init(onSelectRow: onSelectRow, preFilterIds: preFilterIds)
        
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
        guard let allOrders = self.list?.items as? [Order] else { return }
        if searchText != "" {
            self.filteredList = allOrders.filter({ order in
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
            self.filteredList = allOrders.filter({ order in
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
    
    override func makeDetailViewController(config: DetailsConfiguration) -> DetailFormViewController {
        return OrderDetailViewController(config: config)
    }
    
    // MARK: - Data
    override func makeEditDetailConfig(data: NSManagedObject) -> DetailsConfiguration {
        if let `data` = data as? Order {
            return OrderDetailsConfigurator(action: .edit, id: data.id, viewModel: self.list, onSelectRow: nil, isClosed: data.isClosed)
        } else {
            return DetailsConfiguration(action: .edit, id: data.id, viewModel: self.list, onSelectRow: nil)
        }
    }
    
}


// MARK: - SearchBar
extension OrderViewController {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterListByString(self.searchBar.text ?? "")
    }
}

// MARK: - TableView
extension OrderViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (Constants.UI.Sizing.Height.Small * 1.5) + self.betweenCellPadding
    }
}
