//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class InventoryViewController: UIViewController {
    
    let inventory: Inventory
    var filteredMerchs: [Merch]
    let searchBar: UISearchBar
    let tableView: UITableView
    var onSelectRowDelegate: ((String) -> Void)?
    
    init(onSelectRow: ((String) -> Void)? = nil) {
        self.inventory = Inventory()
        self.filteredMerchs = [Merch]()
        self.searchBar = UISearchBar()
        self.tableView = UITableView()
        self.onSelectRowDelegate = onSelectRow
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.register(InventoryCell.self, forCellReuseIdentifier: "InventoryCell")
        self.tableView.register(InventoryHeader.self, forHeaderFooterViewReuseIdentifier: "InventoryHeader")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.unfocusSearchBar))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tapGest)
        self.tableView.backgroundView?.isUserInteractionEnabled = true
        
        let refreshCtrl = UIRefreshControl()
        refreshCtrl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshCtrl
        
        DispatchQueue.main.async {
            self.refresh()
        }
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = NSLocalizedString("Search", comment: "The action to look for something.")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = NSLocalizedString("Inventory", comment: "The collections of goods.")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.navToAddMerchView))
        
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unfocusSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.inventory.fullFetch(completion: { [weak self] in
                guard let `self` = self  else { return }
                if let txt = self.searchBar.text, txt != "" {
                    self.filterMerchByString(txt)
                } else {
                    self.refresh()
                }
            })
        }
    }
    
    @objc private func navToAddMerchView() {
        let merchConfig: MerchDetailsConfigurator = {
            if let delegate = self.onSelectRowDelegate {
                return MerchDetailsConfigurator(action: .add, merchName: nil, inventory: self.inventory, onSelectRow: delegate)
            } else {
                return MerchDetailsConfigurator(action: .add, merchName: nil, inventory: self.inventory, onSelectRow: nil)
            }
        }()
        
        let newMerchVC = MerchDetailViewController(config: merchConfig)
        self.navigationController?.pushViewController(newMerchVC, animated: true)
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
    
}

extension InventoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let merchName = self.filteredMerchs[indexPath.row].name
        if let delegate = self.onSelectRowDelegate {
            delegate(merchName)
        } else {
            let merchConfig = MerchDetailsConfigurator(action: .edit, merchName: merchName, inventory: self.inventory, onSelectRow: nil)
            let editMerchVC = MerchDetailViewController(config: merchConfig)
            self.navigationController?.pushViewController(editMerchVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.filteredMerchs[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        cell.setup(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredMerchs.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "InventoryHeader") as! InventoryHeader
        header.setup()
        return header
    }
}

extension InventoryViewController: Refreshable {
    func refresh() {
        self.inventory.fullFetch(completion: {
            self.searchBar.text = ""
            self.filteredMerchs = self.inventory.merchs
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        })
    }
}

extension InventoryViewController: UISearchBarDelegate {
    
    private func filterMerchByString(_ searchText: String) {
        self.filteredMerchs = self.inventory.merchs.filter({ merch in
            return merch.name.lowercased().contains(searchText.lowercased()) || merch.remark.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.filterMerchByString(searchText)
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
