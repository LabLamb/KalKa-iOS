//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class OrderList: ViewModel {
    
    var persistentContainer: NSPersistentContainer = CoreStack.shared.persistentContainer
    var items: [NSManagedObject] = [Order]()
    var groupedItems: [String: [Order]] = [:]
    
    func fetch(completion: (() -> Void)? = nil) {
        let sortDesc = NSSortDescriptor(key: "number", ascending: false)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        fetchRequest.sortDescriptors = [sortDesc]
        if let result = try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Order] {
            self.items = result
            self.groupedItems = Dictionary(grouping: result, by: {
                if $0.isClosed {
                    return "Closed"
                } else {
                    return "Open"
                }
            })
        }
        completion?()
    }
    
    func add(details: Any, completion: ((Bool) -> Void)) {
        guard let `details` = details as? OrderDetails else {
            fatalError("Passed wrong datatype to add.")
        }
        
        self.exists(id: String(details.number), completion: { exists in
            if !exists {
                let context = self.persistentContainer.newBackgroundContext()
                let predicate = NSPredicate(format: "name = %@", details.customerName)
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
                fetchRequest.predicate = predicate
                if let entity = NSEntityDescription.entity(forEntityName: "Order", in: context),
                    let result = try? context.fetch(fetchRequest),
                    let customer = result.first,
                    let num = Int64(details.number) {
                    let newOrder = Order(entity: entity, insertInto: context)
                    newOrder.number = num
                    newOrder.openedOn = details.openedOn
                    newOrder.items = details.items
                    newOrder.customer = customer as! Customer
                    newOrder.isClosed = details.isClosed
                    try? context.save()
                    self.fetch()
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        })
    }
    
    func query(clause: NSPredicate, incContext: NSManagedObjectContext? = nil) -> [Any]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        fetchRequest.predicate = clause
        if let context = incContext {
            return try? context.fetch(fetchRequest) as? [Order]
        } else {
            return try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Order]
        }
        
    }
    
    func getDetails(id: String) -> Any? {
        let predicate = NSPredicate(format: "number = %@", id)
        guard let result = self.query(clause: predicate) as? [Order] else { return nil}
        guard let order = result.first else { return nil }
        //        let OrderImage: UIImage? = {
        //            if let imgData = Order.image {
        //                return UIImage(data: imgData)
        //            } else {
        //                return nil
        //            }
        //        }()
        
        return (
            number: order.number,
            openedOn: order.openedOn,
            isShipped: order.isShipped,
            isPaid: order.isPaid,
            isDeposit: order.isDeposit,
            isClosed: order.isClosed,
            customerName: order.customer.name,
            items: order.items
        )
    }
    
    func edit(oldId: String, details: Any, completion: ((Bool) -> Void)) {
        guard let `details` = details as? OrderDetails else {
            fatalError("Passed wrong datatype to add.")
        }
        
        if oldId == details.number {
            self.storeEdit(oldId: oldId, details: details)
            completion(true)
        } else {
            self.exists(id: String(details.number)) { exists in
                if exists {
                    completion(false)
                } else {
                    self.storeEdit(oldId: oldId, details: details)
                    completion(true)
                }
            }
        }
    }
    
    private func storeEdit(oldId: String, details: OrderDetails) {
        let context = self.persistentContainer.newBackgroundContext()
        let predicate = NSPredicate(format: "number = %@", oldId)
        
        guard let result = self.query(clause: predicate, incContext: context) as? [Order] else {
            fatalError("Trying to edit an non-existing Order. (Query returned nil)")
        }
        
        guard let editingOrder = result.first else {
            fatalError("Trying to edit an non-existing Order. (Array is empty)")
        }
        
        guard let num = Int64(details.number) else {
            fatalError("Id unable to be cast as Integer.")
        }
        
        editingOrder.number = num
        //        editingOrder.address = details.address
        //        editingOrder.phone = details.phone
        //        editingOrder.remark = details.remark
        //        editingOrder.lastContacted = details.lastContacted
        //        editingOrder.image = details.image?.pngData()
        
        try? context.save()
    }
    
    func exists(id: String, completion: ((Bool) -> Void)) {
        let predicate = NSPredicate(format: "number = %@", id)
        guard let result = self.query(clause: predicate) else { return }
        completion(result.count > 0)
    }
    
    public func getNextId() -> String {
        let sortDesc = NSSortDescriptor(key: "number", ascending: false)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = [sortDesc]
        if let result = try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Order],
            let num = result.first?.number {
            return String(num + 1)
        } else {
            return "1";
        }
    }
}
