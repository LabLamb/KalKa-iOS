//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Inventory {
    
    private let persistentContainer: NSPersistentContainer
    var merchs: [Merch]
    
    init() {
        self.merchs = [Merch]()
        self.persistentContainer = CoreStack.shared.persistentContainer
    }
    
    public func fullFetch(completion: (() -> Void)? = nil) {
        let sortDesc = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Merch")
        fetchRequest.sortDescriptors = [sortDesc]
        let result = try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Merch]
        self.merchs = result ?? [Merch]()
        completion?()
    }
    
    public func addMerch(details: MerchDetails) {
        let context = self.persistentContainer.newBackgroundContext()
        if let entity = NSEntityDescription.entity(forEntityName: "Merch", in: context) {
            let newMerch = Merch(entity: entity, insertInto: context)
            newMerch.name = details.name
            newMerch.price = details.price
            newMerch.qty = Int32(details.qty)
            newMerch.remark = details.remark
            newMerch.image = details.image?.pngData()
            
            try? context.save()
            
            self.fullFetch()
        }
    }
    
    private func queryMerch(clause: NSPredicate, incContext: NSManagedObjectContext? = nil) -> [Merch]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Merch")
        fetchRequest.predicate = clause
        if let context = incContext {
            return try? context.fetch(fetchRequest) as? [Merch]
        } else {
            return try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Merch]
        }
        
    }
    
    public func getMerch(name: String) -> MerchDetails? {
        let predicate = NSPredicate(format: "name = %@", name)
        guard let result = self.queryMerch(clause: predicate) else { return nil}
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
    
    public func editMerch(oldName: String, details: MerchDetails, completion: (() -> Void)) {
        let context = self.persistentContainer.newBackgroundContext()
        let predicate = NSPredicate(format: "name = %@", oldName)
        guard let result = self.queryMerch(clause: predicate, incContext: context) else {
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
        
        completion()
    }
    
    public func existsMerch(name: String, completion: ((Bool) -> Void)) {
        let predicate = NSPredicate(format: "name = %@", name)
        if let result = self.queryMerch(clause: predicate) {
            completion(result.count > 0)
        } else {
            completion(false)
        }
    }
}
