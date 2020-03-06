//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerViewController: SearchTableViewController {
    
    private var filteredCustomers: [Customer] {
        get {
            return self.filteredList as! [Customer]
        }
    }
    
    // MARK: - Initializion
    override init(onSelectRow: ((String) -> Void)? = nil,
                  preFilterIds: [String]? = nil) {
        super.init(onSelectRow: onSelectRow, preFilterIds: preFilterIds)
        self.list = CustomerList()
        
        self.cellIdentifier = "CustomerListCell"
        self.tableView.register(CustomerCell.self, forCellReuseIdentifier: self.cellIdentifier)
        
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
        self.navigationItem.title = .customers
    }
    
    override func filterListByString(_ searchText: String) {
        guard let allCustomers = self.list?.items as? [Customer] else { return }
        if searchText != "" {
            self.filteredList = allCustomers.filter({ customer in
                return customer.name.lowercased().contains(searchText.lowercased()) || customer.phone.lowercased().contains(searchText.lowercased())
            })
        } else {
            self.filteredList = allCustomers
        }
        self.tableView.reloadData()
    }
    
    override func makeDetailViewController(config: DetailsConfiguration) -> DetailFormViewController {
        return CustomerDetailViewController(config: config)
    }
    
}
