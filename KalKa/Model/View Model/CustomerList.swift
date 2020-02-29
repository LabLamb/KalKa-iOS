//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CustomerList: ViewModel {
    
    var persistentContainer: NSPersistentContainer = CoreStack.shared.persistentContainer
    var items: [NSManagedObject] = [Customer]()
    
    func fetch(completion: (() -> Void)? = nil) {
        let sortDesc = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
        fetchRequest.sortDescriptors = [sortDesc]
        let result = try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Customer]
        self.items = result ?? [Customer]()
        completion?()
    }
    
    func add(details: Any, completion: ((Bool) -> Void)) {
        guard let `details` = details as? CustomerDetails else {
            fatalError("Passed wrong datatype to add.")
        }
        
        self.exists(id: details.name, completion: { exists in
            if !exists {
                let context = self.persistentContainer.newBackgroundContext()
                if let entity = NSEntityDescription.entity(forEntityName: "Customer", in: context) {
                    let newCustomer = Customer(entity: entity, insertInto: context)
                    
                    newCustomer.name = details.name
                    newCustomer.address = details.address
                    newCustomer.phone = details.phone
                    newCustomer.remark = details.remark
                    newCustomer.lastContacted = Date()
                    newCustomer.image = details.image?.pngData()
                    
                    try? context.save()
                    
                    self.fetch()
                }
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func query(clause: NSPredicate, incContext: NSManagedObjectContext? = nil) -> [Any]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
        fetchRequest.predicate = clause
        if let context = incContext {
            return try? context.fetch(fetchRequest) as? [Customer]
        } else {
            return try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Customer]
        }
    }
    
    func getDetails(id: String) -> Any? {
        let predicate = NSPredicate(format: "name = %@", id)
        guard let result = self.query(clause: predicate) as? [Customer] else { return nil}
        guard let customer = result.first else { return nil }
        let customerImage: UIImage? = {
            if let imgData = customer.image {
                return UIImage(data: imgData)
            } else {
                return nil
            }
        }()
        
        return (image: customerImage, address: customer.address, lastContacted: customer.lastContacted, name: customer.name, phone: customer.phone, orders: customer.orders, remark: customer.remark)
    }
    
    func getCustomer(id: String) -> Customer? {
        let predicate = NSPredicate(format: "name = %@", id)
        guard let result = self.query(clause: predicate) as? [Customer] else { return nil }
        guard let customer = result.first else { return nil }
        return customer
    }
    
    
    func edit(oldId: String, details: Any, completion: ((Bool) -> Void)) {
        guard let `details` = details as? CustomerDetails else {
            fatalError("Passed wrong datatype to add.")
        }
        
        if oldId == details.name {
            self.storeEdit(oldId: oldId, details: details)
            completion(true)
        } else {
            self.exists(id: details.name) { exists in
                if exists {
                    completion(false)
                } else {
                    self.storeEdit(oldId: oldId, details: details)
                    completion(true)
                }
            }
        }
    }
    
    private func storeEdit(oldId: String, details: CustomerDetails) {
        let context = self.persistentContainer.newBackgroundContext()
        let predicate = NSPredicate(format: "name = %@", oldId)
        
        guard let result = self.query(clause: predicate, incContext: context) as? [Customer] else {
            fatalError("Trying to edit an non-existing Customer. (Query returned nil)")
        }
        
        guard let editingCustomer = result.first else {
            fatalError("Trying to edit an non-existing Customer. (Array is empty)")
        }
        
        editingCustomer.name = details.name
        editingCustomer.address = details.address
        editingCustomer.phone = details.phone
        editingCustomer.remark = details.remark
        editingCustomer.lastContacted = details.lastContacted
        editingCustomer.image = details.image?.pngData()
        
        try? context.save()
    }
    
    func exists(id: String, completion: ((Bool) -> Void)) {
        let predicate = NSPredicate(format: "name = %@", id)
        guard let result = self.query(clause: predicate) else { return }
        completion(result.count > 0)
    }
}
