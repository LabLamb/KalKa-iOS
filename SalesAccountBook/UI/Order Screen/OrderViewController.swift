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
                return order.number.lowercased().contains(searchText.lowercased()) || order.customer.phone.lowercased().contains(searchText.lowercased()) ||
                    order.customer.name.lowercased().contains(searchText.lowercased()) ||
                    order.customer.remark.lowercased().contains(searchText.lowercased())
            })
        } else {
            self.fileredList = self.list.items
        }
        self.tableView.reloadData()
    }
    
}


// MARK: - TableView
extension OrderViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderName = self.fileredOrders[indexPath.row].number
        if let delegate = self.onSelectRowDelegate {
            delegate(orderName)
        } else {
            let orderConfig = DetailsConfigurator(action: .edit, id: orderName, viewModel: self.list, onSelectRow: nil)
            let editOrderVC = OrderDetailViewController(config: orderConfig)
            self.navigationController?.pushViewController(editOrderVC, animated: true)
        }
    }
}
