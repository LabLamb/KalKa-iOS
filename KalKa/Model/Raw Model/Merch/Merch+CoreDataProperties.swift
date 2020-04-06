//
//  Merch+CoreDataProperties.swift
//  
//
//  Created by LabLamb on 6/4/2020.
//
//

import Foundation
import CoreData


extension Merch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Merch> {
        return NSFetchRequest<Merch>(entityName: "Merch")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String
    @NSManaged public var price: Double
    @NSManaged public var qty: Int32
    @NSManaged public var remark: String
    @NSManaged public var restocks: Set<Restock>?
    @NSManaged public var store: Store?

}

// MARK: Generated accessors for restocks
extension Merch {

    @objc(addRestocksObject:)
    @NSManaged public func addToRestocks(_ value: Restock)

    @objc(removeRestocksObject:)
    @NSManaged public func removeFromRestocks(_ value: Restock)

    @objc(addRestocks:)
    @NSManaged public func addToRestocks(_ values: NSSet)

    @objc(removeRestocks:)
    @NSManaged public func removeFromRestocks(_ values: NSSet)

}
