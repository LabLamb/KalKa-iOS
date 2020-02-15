//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Inventory: ViewModel {
    
    public override func fetch(completion: (() -> Void)? = nil) {
        let sortDesc = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Merch")
        fetchRequest.sortDescriptors = [sortDesc]
        let result = try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Merch]
        self.items = result ?? [Merch]()
        completion?()
    }
    
    public override func add(details: Any, completion: ((_ success: Bool) -> Void)) {
        guard let `details` = details as? MerchDetails else {
            fatalError("Passed wrong datatype to add.")
        }
        
        self.exists(name: details.name,
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
    
    override func query(clause: NSPredicate, incContext: NSManagedObjectContext? = nil) -> [Any]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Merch")
        fetchRequest.predicate = clause
        if let context = incContext {
            return try? context.fetch(fetchRequest) as? [Merch]
        } else {
            return try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Merch]
        }
        
    }
    
    public override func get(name: String) -> Any? {
        let predicate = NSPredicate(format: "name = %@", name)
        guard let result = self.query(clause: predicate) as? [Merch] else { return nil}
        guard let merch = result.first else { return nil }
        let merchImage: UIImage? = {
            if let imgData = merch.image {
                return UIImage(data: imgData)
            } else {
                return nil
            }
        }()
        
        return (name: merch.name, price: merch.price, qty: Int(merch.qty), remark: merch.remark, image: merchImage)
    }
    
    public override func edit(oldId: String, details: Any, completion: ((Bool) -> Void)) {
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
        
        editingMerch.name = details.name
        editingMerch.price = details.price
        editingMerch.qty = Int32(details.qty)
        editingMerch.remark = details.remark
        editingMerch.image = details.image?.pngData()
        
        try? context.save()
        
        completion(true)
    }
    
    public override func exists(name: String, completion: ((Bool) -> Void)) {
        let predicate = NSPredicate(format: "name = %@", name)
        if let result = self.query(clause: predicate) {
            completion(result.count > 0)
        } else {
            completion(false)
        }
    }
}
