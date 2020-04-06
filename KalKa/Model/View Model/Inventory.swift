//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import NotificationCenter

class Inventory: ViewModel {
    
    var persistentContainer: NSPersistentContainer = CoreStack.shared.persistentContainer
    
    var items: [NSManagedObject] = [Merch]()
    
    func fetch(completion: (() -> Void)? = nil) {
        let sortDesc = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Merch")
        fetchRequest.sortDescriptors = [sortDesc]
        let result = try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Merch]
        self.items = result ?? [Merch]()
        completion?()
    }
    
    func add(details: ModelDetails, completion: ((_ success: Bool) -> Void)) {
        guard let `details` = details as? MerchDetails else {
            fatalError("Passed wrong datatype to add.")
        }
        
        self.exists(id: details.name,
                    completion: {exists in
                        if exists {
                            completion(false)
                        } else {
                            let context = self.persistentContainer.newBackgroundContext()
                            if let entity = NSEntityDescription.entity(forEntityName: "Merch", in: context) {
                                let newMerch = Merch(entity: entity, insertInto: context)
                                newMerch.name = details.name
                                newMerch.price = details.price
                                newMerch.qty = Int32(details.qty)
                                newMerch.remark = details.remark
                                newMerch.image = details.image?.pngData()
                                
                                try? context.save()
                                
                                self.fetch()
                            }
                            completion(true)
                        }
        })
        
    }
    
    func query(clause: NSPredicate, incContext: NSManagedObjectContext? = nil) -> [NSManagedObject]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Merch")
        fetchRequest.predicate = clause
        if let context = incContext {
            return try? context.fetch(fetchRequest) as? [Merch]
        } else {
            return try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Merch]
        }
        
    }
    
    func getDetails(id: String) -> ModelDetails? {
        let predicate = NSPredicate(format: "name = %@", id)
        guard let result = self.query(clause: predicate) as? [Merch] else { return nil}
        guard let merch = result.first else { return nil }
        let merchImage: UIImage? = {
            if let imgData = merch.image {
                return UIImage(data: imgData)
            } else {
                return nil
            }
        }()
        
        let merchRestocks: [RestockDetails] = {
            var result = [RestockDetails]()
            merch.restocks?.forEach({
                result.append(RestockDetails(stockTimeStamp: $0.stockTimeStamp, restockQty: Int($0.restockQty)))
            })
            
            result.sort(by: {
                $0.stockTimeStamp > $1.stockTimeStamp
            })
            return result
        }()
        
        return MerchDetails(name: merch.name, price: merch.price, qty: Int(merch.qty), remark: merch.remark, image: merchImage, restocks: merchRestocks)
    }
    
    func edit(oldId: String, details: ModelDetails, completion: ((Bool) -> Void)) {
        guard let `details` = details as? MerchDetails else {
            fatalError("Passed wrong datatype to edit.")
        }
        
        let context = self.persistentContainer.newBackgroundContext()
        let predicate = NSPredicate(format: "name = %@", oldId)
        
        guard let result = self.query(clause: predicate, incContext: context) as? [Merch] else {
            fatalError("Trying to edit an non-existing Merch. (Query returned nil)")
        }
        
        guard let editingMerch = result.first else {
            fatalError("Trying to edit an non-existing Merch. (Array is empty)")
        }
        
        if editingMerch.qty < Int32(details.qty) {
            guard let entity = NSEntityDescription.entity(forEntityName: "Restock", in: context) else { return }
            let newRestock = Restock(entity: entity, insertInto: context)
            newRestock.restockQty = Int32(details.qty) - editingMerch.qty
            newRestock.newQty = Int32(details.qty)
            newRestock.stockingMerch = editingMerch
            newRestock.stockTimeStamp = Date()
            editingMerch.addToRestocks(newRestock)
        }
        
        editingMerch.name = details.name
        editingMerch.price = details.price
        editingMerch.qty = Int32(details.qty)
        editingMerch.remark = details.remark
        editingMerch.image = details.image?.pngData()
        
        
        try? context.save()
        
        completion(true)
    }
    
    func updateInventoryQty(merchId: String, diff: Int32) {
        let context = self.persistentContainer.newBackgroundContext()
        let predicate = NSPredicate(format: "name = %@", merchId)
        guard let result = self.query(clause: predicate, incContext: context)?.first as? Merch else { return }
        result.qty -= diff
        
        try? context.save()
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .inventoryUpdated, object: nil)
        }
    }
    
    func exists(id: String, completion: ((Bool) -> Void)) {
        let predicate = NSPredicate(format: "name = %@", id)
        if let result = self.query(clause: predicate) {
            completion(result.count > 0)
        } else {
            completion(false)
        }
    }
    
    func returnRestock(merchId: String, returnedDetails: [RestockDetails]) {
        let context = self.persistentContainer.newBackgroundContext()
        for details in returnedDetails {
            let predicate = NSPredicate(format: "stockingMerch.name = %@ AND stockTimeStamp = %@", merchId, details.stockTimeStamp as NSDate)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Restock")
            fetchRequest.predicate = predicate
            
            guard let result = try? context.fetch(fetchRequest).first as? Restock else { return }
            context.delete(result)
        }
        try? context.save()
    }
}
