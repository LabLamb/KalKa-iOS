//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import CoreData

class SearchTableViewController: UIViewController {
    
    // MARK: - Variables
    var list: ViewModel
    var fileredList: [NSManagedObject]
    let searchBar: UISearchBar
    let tableView: UITableView
    var onSelectRowDelegate: ((String) -> Void)?
    
    // MARK: - Initializion
    init(onSelectRow: ((String) -> Void)? = nil) {
        self.list = ViewModel()
        self.fileredList = [NSManagedObject]()
        self.searchBar = UISearchBar()
        self.tableView = UITableView()
        self.onSelectRowDelegate = onSelectRow
        super.init(nibName: nil, bundle: nil)
        
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
        self.setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unfocusSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.list.fetch(completion: { [weak self] in
                guard let `self` = self  else { return }
                if let txt = self.searchBar.text, txt != "" {
                    self.filterListByString(txt)
                } else {
                    self.refresh()
                }
            })
        }
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
    
    internal func filterListByString(_ searchText: String) {
        fatalError("Filter list is not implemented.")
    }
    
}


// MARK: - TableView
extension SearchTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fatalError("Did select row is not implemented.")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Did select row is not implemented.")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fileredList.count
    }
}

// MARK: - Refreshable
extension SearchTableViewController: Refreshable {
    func refresh() {
        self.list.fetch(completion: {
            self.searchBar.text = ""
            self.fileredList = self.list.items
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        })
    }
}


//MARK: - SearchBar
extension SearchTableViewController: UISearchBarDelegate {
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            self.filterListByString(searchText)
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
