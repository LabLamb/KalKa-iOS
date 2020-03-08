//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }

    @NSManaged public var image: Data?
    @NSManaged public var address: String
    @NSManaged public var lastContacted: Date
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var orders: [Order]
    @NSManaged public var remark: String
    @NSManaged public var store: String

}

// MARK: Generated accessors for orders
extension Customer {

    @objc(addOrdersObject:)
    @NSManaged public func addToOrders(_ value: Order)

    @objc(removeOrdersObject:)
    @NSManaged public func removeFromOrders(_ value: Order)

    @objc(addOrders:)
    @NSManaged public func addToOrders(_ values: NSSet)

    @objc(removeOrders:)
    @NSManaged public func removeFromOrders(_ values: NSSet)

}
