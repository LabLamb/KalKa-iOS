//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ViewModel {
    
    let persistentContainer: NSPersistentContainer
    var items: [NSManagedObject]
    
    init() {
        self.items = [NSManagedObject]()
        self.persistentContainer = CoreStack.shared.persistentContainer
    }
    
    public func fetch(completion: (() -> Void)? = nil) {
        fatalError("fetch is not implemented.")
    }

    public func add(details: Any, completion: ((Bool) -> Void)) {
        fatalError("Add is not implemented.")
    }

    public func get(name: String) -> Any? {
        fatalError("Get is not implemented.")
    }

    func edit(oldName: String, details: Any, completion: ((Bool) -> Void)) {
        fatalError("Edit is not implemented.")
    }

    func exists(name: String, completion: ((Bool) -> Void)) {
        fatalError("Exists is not implemented.")
    }
    
    internal func query(clause: NSPredicate, incContext: NSManagedObjectContext? = nil) -> [Any]? {
        fatalError("Query is not implemented.")
    }
}
