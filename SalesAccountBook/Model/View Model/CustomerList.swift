//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CustomerList {
    
    private let persistentContainer: NSPersistentContainer
    var customers: [Customer]
    
    init() {
        self.customers = [Customer]()
        self.persistentContainer = CoreStack.shared.persistentContainer
    }
    
    public func fullFetch(completion: (() -> Void)? = nil) {
        let sortDesc = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
        fetchRequest.sortDescriptors = [sortDesc]
        let result = try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Customer]
        self.customers = result ?? [Customer]()
        completion?()
    }
    
    public func addCustomer(details: CustomerDetails) {
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
            
            self.fullFetch()
        }
    }
    
    private func queryCustomer(clause: NSPredicate, incContext: NSManagedObjectContext? = nil) -> [Customer]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
        fetchRequest.predicate = clause
        if let context = incContext {
            return try? context.fetch(fetchRequest) as? [Customer]
        } else {
            return try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Customer]
        }
        
    }
    
    public func getCustomer(name: String) -> CustomerDetails? {
        let predicate = NSPredicate(format: "name = %@", name)
        guard let result = self.queryCustomer(clause: predicate) else { return nil}
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
    
    public func editCustomer(oldName: String, details: CustomerDetails, completion: (() -> Void)) {
        let context = self.persistentContainer.newBackgroundContext()
        let predicate = NSPredicate(format: "name = %@", oldName)
        guard let result = self.queryCustomer(clause: predicate, incContext: context) else {
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
        
        completion()
    }
    
    public func existsCustomer(name: String, completion: ((Bool) -> Void)) {
        let predicate = NSPredicate(format: "name = %@", name)
        if let result = self.queryCustomer(clause: predicate) {
            completion(result.count > 0)
        } else {
            completion(false)
        }
    }
}
