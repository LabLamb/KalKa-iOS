//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Inventory {
    
    private let managedObjectContext: NSManagedObjectContext
    var merchs: [Merch]
    
    init() {
        self.merchs = [Merch]()
        let container = CoreStack.shared.persistentContainer
        self.managedObjectContext = container.viewContext
    }
    
    public func fetch(completion: (() -> Void)? = nil) {
        let sortDesc = NSSortDescriptor(key: "name", ascending: true)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Merch")
        fetchRequest.sortDescriptors = [sortDesc]
        let result = try? self.managedObjectContext.fetch(fetchRequest) as? [Merch]
        self.merchs = result ?? [Merch]()
        completion?()
    }
    
    public func addMerch(name: String, price: Double, qty: Int, remark: String, image: UIImage?) {
        let context = CoreStack.shared.persistentContainer.newBackgroundContext()
        if let entity = NSEntityDescription.entity(forEntityName: "Merch", in: context) {
            let newMerch = Merch(entity: entity, insertInto: context)
            newMerch.name = name
            newMerch.price = price
            newMerch.qty = Int32(qty)
            newMerch.remark = remark
            newMerch.image = image?.pngData()
            
            try? context.save()
            
            self.fetch()
        }
    }
}
