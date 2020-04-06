//
//  Restock+CoreDataProperties.swift
//  
//
//  Created by LabLamb on 24/3/2020.
//
//

import Foundation
import CoreData


extension Restock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Restock> {
        return NSFetchRequest<Restock>(entityName: "Restock")
    }

    @NSManaged public var stockTimeStamp: Date
    @NSManaged public var restockQty: Int32
    @NSManaged public var newQty: Int32
    @NSManaged public var stockingMerch: Merch

}
