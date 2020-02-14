//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerViewController: SearchTableViewController {
    
    private var filteredCustomers: [Customer] {
        get {
            return self.fileredList as! [Customer]
        }
    }
    
    // MARK: - Initializion
    override init(onSelectRow: ((String) -> Void)? = nil) {
        super.init(onSelectRow: onSelectRow)
        
        self.list = CustomerList()
        
        self.tableView.register(CustomerCell.self, forCellReuseIdentifier: "CustomerListCell")
        
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
        self.navigationItem.title = NSLocalizedString("Customers", comment: "The human purchasing products.")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.navToAddCustomerView))
    }
    
    @objc private func navToAddCustomerView() {
        let customerConfig: DetailsConfigurator = {
            if let delegate = self.onSelectRowDelegate {
                return DetailsConfigurator(action: .add, id: nil, viewModel: self.list, onSelectRow: delegate)
            } else {
                return DetailsConfigurator(action: .add, id: nil, viewModel: self.list, onSelectRow: nil)
            }
        }()
        
        let newCustomerVC = CustomerDetailViewController(config: customerConfig)
        self.navigationController?.pushViewController(newCustomerVC, animated: true)
    }
    
    override func filterListByString(_ searchText: String) {
        let allCustomers = self.list.items as! [Customer]
        self.fileredList = allCustomers.filter({ customer in
            return customer.name.lowercased().contains(searchText.lowercased()) || customer.phone.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
}


// MARK: - TableView
extension CustomerViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customerName = self.filteredCustomers[indexPath.row].name
        if let delegate = self.onSelectRowDelegate {
            delegate(customerName)
        } else {
            let customerConfig = DetailsConfigurator(action: .edit, id: customerName, viewModel: self.list, onSelectRow: nil)
            let editCustomerVC = CustomerDetailViewController(config: customerConfig)
            self.navigationController?.pushViewController(editCustomerVC, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.filteredCustomers[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomerListCell", for: indexPath) as! CustomerCell
        cell.setup(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.UI.Sizing.Height.Small
    }
}
