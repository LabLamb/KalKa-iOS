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
    
    func add(details: ModelDetails, completion: ((Bool) -> Void)) {
        guard let `details` = details as? OrderDetails else {
            fatalError("Passed wrong datatype to add.")
        }
        
        self.exists(id: String(details.number), completion: { exists in
            if !exists {
                let context = self.persistentContainer.newBackgroundContext()
                
                let customer: Customer? = {
                    let predicate = NSPredicate(format: "name = %@", details.customerName)
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
                    fetchRequest.predicate = predicate
                    if let result = try? context.fetch(fetchRequest),
                        let customer = result.first as? Customer {
                        return customer
                    } else {
                        return nil
                    }
                }()
                
                if let `customer` = customer,
                    let entity = NSEntityDescription.entity(forEntityName: "Order", in: context),
                    let num = Int64(details.number),
                    let items = details.items {
                    let newOrder = Order(entity: entity, insertInto: context)
                    newOrder.number = num
                    newOrder.openedOn = details.openedOn
                    newOrder.customer = customer
                    newOrder.isClosed = details.isClosed
                    newOrder.isDeposit = details.isDeposit
                    newOrder.isShipped = details.isShipped
                    newOrder.isPreped = details.isPreped
                    newOrder.isPaid = details.isPaid
                    newOrder.remark = details.remark
                    newOrder.items = {
                        guard let entity = NSEntityDescription.entity(forEntityName: "OrderItem", in: context) else { return nil }
                        var result = [OrderItem]()
                        for item in items {
                            let newOrderItem = OrderItem(entity: entity, insertInto: context)
                            newOrderItem.name = item.name
                            newOrderItem.price = item.price
                            newOrderItem.qty = item.qty
                            result.append(newOrderItem)
                        }
                        return Set(result)
                    }()
                    
                    try? context.save()
                    
                    for item in items {
                        Inventory().updateInventoryQty(merchId: item.name, diff: item.qty)
                    }
                    
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
    
    func query(clause: NSPredicate, incContext: NSManagedObjectContext? = nil) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Order")
        fetchRequest.predicate = clause
        if let context = incContext {
            return try? context.fetch(fetchRequest) as? [Order]
        } else {
            return try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Order]
        }
        
    }
    
    func getDetails(id: String) -> ModelDetails? {
        let predicate = NSPredicate(format: "number = %@", id)
        guard let result = self.query(clause: predicate) as? [Order] else { return nil}
        guard let order = result.first else { return nil }
        guard let issueDate = order.openedOn else { return nil }
        
        let orderitemDetails = order.items?.compactMap({ orderItem in
            return OrderItemDetails(name: orderItem.name, qty: orderItem.qty, price: orderItem.price)
        })
        
        return OrderDetails(
            number: String(order.number),
            remark: order.remark,
            openedOn: issueDate,
            isShipped: order.isShipped,
            isPreped: order.isPreped,
            isPaid: order.isPaid,
            isDeposit: order.isDeposit,
            isClosed: order.isClosed,
            customerName: order.customer.name,
            items: orderitemDetails
        )
    }
    
    func edit(oldId: String, details: ModelDetails, completion: ((Bool) -> Void)) {
        guard let `details` = details as? OrderDetails else {
            fatalError("Passed wrong datatype to add.")
        }
        
        if oldId == details.number {
            self.storeEdit(oldId: oldId, details: details)
            completion(true)
        } else {
            fatalError("Order number changed, which it should not.")
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
        
        editingOrder.remark = details.remark
        editingOrder.openedOn = details.openedOn
        editingOrder.isClosed = details.isClosed
        editingOrder.isPreped = details.isPreped
        editingOrder.isPaid = details.isPaid
        editingOrder.isShipped = details.isShipped
        editingOrder.isDeposit = details.isDeposit
        
        let customer: Customer? = {
            let predicate = NSPredicate(format: "name = %@", details.customerName)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Customer")
            fetchRequest.predicate = predicate
            if let result = try? context.fetch(fetchRequest),
                let customer = result.first as? Customer {
                return customer
            } else {
                return nil
            }
        }()
        
        if let `customer` = customer {
            editingOrder.customer = customer
        } else {
            fatalError("Attempted to attach a customer that does not exists.")
        }
        
        var itemQtyChanges: [(name: String, diff: Int32)] = []
        
        details.items?.forEach({ itemDet in
            let matchingItem = editingOrder.items?.first(where: { itemObj in
                itemObj.name == itemDet.name
            })
            
            if let `matchingItem` = matchingItem {
                itemQtyChanges.append((name: matchingItem.name,
                                       diff: itemDet.qty - matchingItem.qty))
                matchingItem.price = itemDet.price
                matchingItem.qty = itemDet.qty
            } else {
                if let entity = NSEntityDescription.entity(forEntityName: "OrderItem", in: context) {
                    let newOrderItem = OrderItem(entity: entity, insertInto: context)
                    newOrderItem.name = itemDet.name
                    newOrderItem.price = itemDet.price
                    newOrderItem.qty = itemDet.qty
                    editingOrder.addToItems(newOrderItem)
                    itemQtyChanges.append((name: newOrderItem.name,
                                           diff: newOrderItem.qty))
                }
            }
        })
        
        editingOrder.items = editingOrder.items?.filter({ itemObj in
            let hasDetails = (details.items?.contains(where: { $0.name == itemObj.name }) ?? false)
            if !hasDetails {
                itemQtyChanges.append((name: itemObj.name,
                    diff: -itemObj.qty))
            }
            return hasDetails
        })
        
        try? context.save()
        
        let inv = Inventory()
        for changes in itemQtyChanges {
            inv.updateInventoryQty(merchId: changes.name, diff: changes.diff)
        }
    }
    
    func removeOrder(id: String, completion: ((Bool) -> Void)) {
        let predicate = NSPredicate(format: "number = %@", id)
        let context = self.persistentContainer.newBackgroundContext()
        if let result = self.query(clause: predicate, incContext: context)?.first as? Order {
            if let items = result.items {
                let inv = Inventory()
                for item in items {
                    inv.updateInventoryQty(merchId: item.name, diff: -item.qty)
                }
            }
            context.delete(result)
            try? context.save()
            completion(true)
        } else {
            completion(false)
        }
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
