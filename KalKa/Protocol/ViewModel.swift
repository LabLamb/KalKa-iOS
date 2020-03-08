//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import CoreData

protocol ViewModel {
    
    var persistentContainer: NSPersistentContainer { get set }
    var items: [NSManagedObject] { get set }
    
    func fetch(completion: (() -> Void)?)
    func add(details: ModelDetails, completion: ((Bool) -> Void))
    func getDetails(id: String) -> ModelDetails?
    func edit(oldId: String, details: ModelDetails, completion: ((Bool) -> Void))
    func exists(id: String, completion: ((Bool) -> Void))
    func query(clause: NSPredicate, incContext: NSManagedObjectContext?) -> [NSManagedObject]?
}
