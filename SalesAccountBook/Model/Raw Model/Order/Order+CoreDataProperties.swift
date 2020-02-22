//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var number: String
    @NSManaged public var openedOn: Date
    @NSManaged public var status: String
    @NSManaged public var items: NSSet?
    @NSManaged public var customer: Customer

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