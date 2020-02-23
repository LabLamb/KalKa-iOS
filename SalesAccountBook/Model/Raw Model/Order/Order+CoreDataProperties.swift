//
//  Order+CoreDataProperties.swift
//  
//
//  Created by LabLamb on 23/2/2020.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var number: Int64
    @NSManaged public var remark: String
    @NSManaged public var openedOn: Date?
    @NSManaged public var isShipped: Bool
    @NSManaged public var isPaid: Bool
    @NSManaged public var isDeposit: Bool
    @NSManaged public var isClosed: Bool
    @NSManaged public var customer: Customer
    @NSManaged public var items: [OrderItem]?

}

// MARK: Generated accessors for items
extension Order {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: OrderItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: OrderItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
