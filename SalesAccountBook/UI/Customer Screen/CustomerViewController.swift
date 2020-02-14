//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class CustomerViewController: UIViewController {
    
    // MARK: - Variables
    let customerList: CustomerList
    var filteredCustomers: [Customer]
    let searchBar: UISearchBar
    let tableView: UITableView
    var onSelectRowDelegate: ((String) -> Void)?
    
    // MARK: - Initializion
    init(onSelectRow: ((String) -> Void)? = nil) {
        self.customerList = CustomerList()
        self.filteredCustomers = [Customer]()
        self.searchBar = UISearchBar()
        self.tableView = UITableView()
        self.onSelectRowDelegate = onSelectRow
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.register(CustomerCell.self, forCellReuseIdentifier: "CustomerListCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.unfocusSearchBar))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tapGest)
        self.tableView.backgroundView?.isUserInteractionEnabled = true
        
        DispatchQueue.main.async {
            self.refresh()
        }
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = NSLocalizedString("Search", comment: "The action to look for something.")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keboardDidDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func viewDidLoad() {
        self.navigationItem.title = NSLocalizedString("Customers", comment: "The human purchasing products.")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.navToAddCustomerView))
        
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unfocusSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.customerList.fullFetch(completion: { [weak self] in
                guard let `self` = self  else { return }
                if let txt = self.searchBar.text, txt != "" {
                    self.filterCustomerByString(txt)
                } else {
                    self.refresh()
                }
            })
        }
    }
    
    @objc private func navToAddCustomerView() {
        let customerConfig: CustomerDetailsConfigurator = {
            if let delegate = self.onSelectRowDelegate {
                return CustomerDetailsConfigurator(action: .add, customerName: nil, customerList: self.customerList, onSelectRow: delegate)
            } else {
                return CustomerDetailsConfigurator(action: .add, customerName: nil, customerList: self.customerList, onSelectRow: nil)
            }
        }()
        
        let newCustomerVC = CustomerDetailViewController(config: customerConfig)
        self.navigationController?.pushViewController(newCustomerVC, animated: true)
    }
    
    private func setup() {
        self.view.backgroundColor = .groupTableViewBackground
        
        self.view.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc private func keyboardDidAppear(noti: NSNotification) {
        guard let info = noti.userInfo else { return }
        let rect: CGRect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
    }
    
    @objc private func keboardDidDisappeared() {
        self.tableView.contentInset = UIEdgeInsets.zero
        self.tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
}


// MARK: - TableView
extension CustomerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customerName = self.filteredCustomers[indexPath.row].name
        if let delegate = self.onSelectRowDelegate {
            delegate(customerName)
        } else {
            let customerConfig = CustomerDetailsConfigurator(action: .edit, customerName: customerName, customerList: self.customerList, onSelectRow: nil)
            let editCustomerVC = CustomerDetailViewController(config: customerConfig)
            self.navigationController?.pushViewController(editCustomerVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.filteredCustomers[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CustomerListCell", for: indexPath) as! CustomerCell
        cell.setup(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCustomers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.UI.Sizing.Height.Medium
    }
}

// MARK: - Refreshable
extension CustomerViewController: Refreshable {
    func refresh() {
        self.customerList.fullFetch(completion: {
            self.searchBar.text = ""
            self.filteredCustomers = self.customerList.customers
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        })
    }
}


//MARK: - SearchBar
extension CustomerViewController: UISearchBarDelegate {
    
    private func filterCustomerByString(_ searchText: String) {
        self.filteredCustomers = self.customerList.customers.filter({ customer in
            return customer.name.lowercased().contains(searchText.lowercased()) || customer.remark.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.filterCustomerByString(searchText)
        } else {
            self.refresh()
            DispatchQueue.main.async {
                self.unfocusSearchBar()
            }
        }
    }
    
    @objc private func unfocusSearchBar() {
        self.searchBar.resignFirstResponder()
    }
}
