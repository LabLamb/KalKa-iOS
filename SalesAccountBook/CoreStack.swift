//
//  CoreStack.swift
//  SalesAccountBook
//
//  Created by LabLamb on 11/2/2020.
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import CoreData

class CoreStack {
    
    static let shared = CoreStack()
    
    private init() {}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SalesAccountBook")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()

}
