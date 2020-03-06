//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import CoreData

class CoreStack {
    
    static let shared = CoreStack()
    
    private init() {}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KalKa")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()

}
