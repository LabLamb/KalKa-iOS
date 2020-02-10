//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

class InventoryViewController: UITableViewController {
    
    let inventory: Inventory
    
    init() {
        self.inventory = Inventory()
        super.init(nibName: nil, bundle: nil)
        self.tableView.register(InventoryCell.self, forCellReuseIdentifier: "InventoryCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.navigationItem.title = NSLocalizedString("Inventory", comment: "The collections of goods.")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addMerch))
    }
    
    @objc private func addMerch() {}
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked on \(indexPath)")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.inventory.merchs[indexPath.row]
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath) as! InventoryCell
        cell.setup(data: data)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inventory.merchs.count
    }
    
}
