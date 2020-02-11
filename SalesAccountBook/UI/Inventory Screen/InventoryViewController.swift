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
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.unfocusSearchBar))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tapGest)
        self.tableView.backgroundView?.isUserInteractionEnabled = true
        
        self.filteredMerchs = self.inventory.merchs
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.inventory.fetch(completion: { [weak self] in
            guard let `self` = self  else { return }
            self.refresh()
        })
        self.unfocusSearchBar()
    }
    
    @objc private func navToAddMerchView() {
        let newMerchVC: NewMerchViewController = {
            if self.onSelectRowDelegate != nil {
                return NewMerchViewController(inventory: self.inventory, onSelectRow: self.onSelectRowDelegate)
            } else {
                return NewMerchViewController(inventory: self.inventory)
            }
        }()
        self.navigationController?.pushViewController(newMerchVC, animated: true)
    }
    
    private func setup() {
        self.view.backgroundColor = .white
        
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
        if let delegate = self.onSelectRowDelegate {
            delegate(self.filteredMerchs[indexPath.row].name)
        } else {
            // navigate to edit
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
        self.filteredMerchs = self.inventory.merchs
        self.tableView.reloadData()
    }
}

extension InventoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.filteredMerchs = self.inventory.merchs.filter({ merch in
                return merch.name.contains(searchText) || merch.remark.contains(searchText)
            })
            self.tableView.reloadData()
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
