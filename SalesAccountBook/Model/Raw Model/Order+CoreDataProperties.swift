//
//  Order+CoreDataProperties.swift
//  
//
//  Created by LabLamb on 13/2/2020.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var isShipped: Bool
    @NSManaged public var number: Int32
    @NSManaged public var openedOn: Date
    @NSManaged public var customer: Customer?
    @NSManaged public var merch: NSSet?

}

// MARK: Generated accessors for merch
extension Order {

    @objc(addMerchObject:)
    @NSManaged public func addToMerch(_ value: Merch)

    @objc(removeMerchObject:)
    @NSManaged public func removeFromMerch(_ value: Merch)

    @objc(addMerch:)
    @NSManaged public func addToMerch(_ values: NSSet)

    @objc(removeMerch:)
    @NSManaged public func removeFromMerch(_ values: NSSet)

}
