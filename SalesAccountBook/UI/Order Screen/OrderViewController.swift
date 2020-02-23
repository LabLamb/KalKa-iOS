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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.navToAddOrderView))
    }
    
    @objc private func navToAddOrderView() {
        let orderConfig = DetailsConfigurator(action: .add, id: nil, viewModel: self.list, onSelectRow: self.onSelectRowDelegate)
        
        let newOrderVC = OrderDetailViewController(config: orderConfig)
        self.navigationController?.pushViewController(newOrderVC, animated: true)
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
                return String(order.number).lowercased().contains(searchText.lowercased()) || order.customer.phone.lowercased().contains(searchText.lowercased()) ||
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
    
}

// MARK: - SearchBar
extension OrderViewController {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterListByString(self.searchBar.text ?? "")
    }
}

// MARK: - TableView
extension OrderViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderName = String(self.fileredOrders[indexPath.row].number)
        if let delegate = self.onSelectRowDelegate {
            delegate(orderName)
        } else {
            let orderConfig = DetailsConfigurator(action: .edit, id: orderName, viewModel: self.list, onSelectRow: nil)
            let editOrderVC = OrderDetailViewController(config: orderConfig)
            self.navigationController?.pushViewController(editOrderVC, animated: true)
        }
    }
}
