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
    
    public func fetch(completion: (() -> Void)? = nil) {
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
            
            self.fetch()
        }
    }
    
    public func existsMerch(name: String, completion: ((Bool) -> Void)) {
        let predicate = NSPredicate(format: "name = %@", name)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Merch")
        fetchRequest.predicate = predicate
        if let result = try? self.persistentContainer.viewContext.fetch(fetchRequest) as? [Merch] {
            completion(result.count > 0)
        } else {
            completion(false)
        }
    }
}
