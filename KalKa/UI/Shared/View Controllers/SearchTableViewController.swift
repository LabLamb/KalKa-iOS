//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit
import CoreData

class SearchTableViewController: UIViewController {
    
    // MARK: - Variables
    var list: ViewModel?
    var filteredList: [NSManagedObject] {
        didSet {
            self.filteredList = self.filteredList.filter({
                (self.preFilterIds?.contains($0.id) ?? false) == false
            })
        }
    }
    let preFilterIds: [String]?
    let searchBar: UISearchBar
    let tableView: UITableView
    var onSelectRowDelegate: ((String) -> Void)?
    var cellIdentifier: String
    let betweenCellPadding = Constants.UI.Spacing.Height.Medium * 0.75
    
    // MARK: - Initializion
    init(onSelectRow: ((String) -> Void)? = nil,
         preFilterIds: [String]? = nil) {
        self.searchBar = UISearchBar()
        self.tableView = UITableView()
        self.onSelectRowDelegate = onSelectRow
        self.cellIdentifier = ""
        self.preFilterIds = preFilterIds
        self.filteredList = [NSManagedObject]()
        
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        
        DispatchQueue.main.async {
            self.refresh()
        }
        
        self.searchBar.delegate = self
        self.searchBar.placeholder = .search
        self.searchBar.showsScopeBar = true
        self.searchBar.inputAccessoryView = UIToolbar.makeKeyboardToolbar(target: self, doneAction: #selector(self.unfocusSearchBar))
        self.searchBar.backgroundImage = UIImage()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidAppear(noti:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.navToAddDetailView))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.unfocusSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.list?.fetch(completion: { [weak self] in
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
        
        self.view.backgroundColor = .background
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .buttonIcon
        if var textAttributes = navigationController?.navigationBar.titleTextAttributes {
            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.text
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        } else {
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
        
        self.view.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.view.layoutMarginsGuide.snp.top)
            make.left.right.equalToSuperview()
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(self.searchBar.snp.bottom).offset(Constants.UI.Spacing.Height.ExSmall)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    @objc private func navToAddDetailView() {
        let config = self.makeAddDetailConfig()
        self.navigateToDetailView(detailVC: self.makeDetailViewController(config: config))
    }
    
    internal func makeAddDetailConfig() -> DetailsConfiguration {
        return DetailsConfiguration(action: .add, id: "", viewModel: self.list, onSelectRow: self.onSelectRowDelegate, presentingRefreshable: self)
    }
    
    internal func makeEditDetailConfig(data: NSManagedObject) -> DetailsConfiguration {
        return DetailsConfiguration(action: .edit, id: data.id, viewModel: self.list, onSelectRow: nil)
    }
    
    internal func makeDetailViewController(config: DetailsConfiguration) -> DetailFormViewController {
        return DetailFormViewController(config: config)
    }
    
    internal func navigateToDetailView(detailVC: DetailFormViewController) {
        if detailVC.actionType == .add {
            self.present(UINavigationController(rootViewController: detailVC), animated: true, completion: nil)
        } else {
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc private func keyboardDidAppear(noti: NSNotification) {
        guard let info = noti.userInfo else { return }
        let rect: CGRect = info[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let kbHeight = rect.size.height - (self.tabBarController?.tabBar.frame.height ?? 0)
        self.tableView.contentInset.bottom = kbHeight
        self.tableView.scrollIndicatorInsets.bottom = kbHeight
    }
    
    @objc private func keyboardDidDisappeared() {
        self.tableView.contentInset.bottom = 0
        self.tableView.scrollIndicatorInsets.bottom = 0
    }
    
    internal func filterListByString(_ searchText: String) {
        fatalError("Filter list is not implemented.")
    }
    
}


// MARK: - TableView
extension SearchTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.filteredList[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! CustomCell
        cell.setup(data: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (Constants.UI.Sizing.Height.Small * 1.25) + self.betweenCellPadding
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.betweenCellPadding
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.filteredList[indexPath.row]
        if let delegate = self.onSelectRowDelegate {
            delegate(data.id)
        } else {
            let detailConfig = self.makeEditDetailConfig(data: data)
            self.navigateToDetailView(detailVC: self.makeDetailViewController(config: detailConfig))
        }
    }
}

// MARK: - Refreshable
extension SearchTableViewController: Refreshable {
    func refresh() {
        self.list?.fetch(completion: {
            self.filterListByString(self.searchBar.text ?? "")
        })
    }
}


//MARK: - SearchBar
extension SearchTableViewController: UISearchBarDelegate {
    
    internal func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterListByString(searchText)
    }
    
    @objc private func unfocusSearchBar() {
        self.searchBar.resignFirstResponder()
    }
}
