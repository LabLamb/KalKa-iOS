//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class OrderList: ViewModel {
    
    override func fetch(completion: (() -> Void)? = nil) {
        let sortDesc = NSSortDescriptor(key: "number", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        fetchRequest.sortDescriptors = [sortDesc]
        let result = try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Order]
        self.items = result ?? [Order]()
        completion?()
    }
    
    override func add(details: Any, completion: ((Bool) -> Void)) {
        guard let `details` = details as? OrderDetails else {
            fatalError("Passed wrong datatype to add.")
        }
        
        self.exists(id: details.number, completion: { exists in
            if !exists {
                let context = self.persistentContainer.newBackgroundContext()
                if let entity = NSEntityDescription.entity(forEntityName: "Order", in: context) {
                    let newOrder = Order(entity: entity, insertInto: context)
                    
                    newOrder.number = details.number
                    
                    try? context.save()
                    
                    self.fetch()
                }
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    override func query(clause: NSPredicate, incContext: NSManagedObjectContext? = nil) -> [Any]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        fetchRequest.predicate = clause
        if let context = incContext {
            return try? context.fetch(fetchRequest) as? [Order]
        } else {
            return try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Order]
        }
        
    }
    
    override func get(id: String) -> Any? {
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
            status: order.status,
            items: order.items,
            customer: order.customer
        )
    }
    
    override func edit(oldId: String, details: Any, completion: ((Bool) -> Void)) {
        guard let `details` = details as? OrderDetails else {
            fatalError("Passed wrong datatype to add.")
        }
        
        if oldId == details.number {
            self.storeEdit(oldId: oldId, details: details)
            completion(true)
        } else {
            self.exists(id: details.number) { exists in
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
        
        editingOrder.number = details.number
//        editingOrder.address = details.address
//        editingOrder.phone = details.phone
//        editingOrder.remark = details.remark
//        editingOrder.lastContacted = details.lastContacted
//        editingOrder.image = details.image?.pngData()
        
        try? context.save()
    }
    
    override func exists(id: String, completion: ((Bool) -> Void)) {
        let predicate = NSPredicate(format: "number = %@", id)
        guard let result = self.query(clause: predicate) else { return }
        completion(result.count > 0)
    }
}
