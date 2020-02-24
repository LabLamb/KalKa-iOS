//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData


extension OrderItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderItem> {
        return NSFetchRequest<OrderItem>(entityName: "OrderItem")
    }

    @NSManaged public var name: String
    @NSManaged public var qty: Int32
    @NSManaged public var price: Double
    @NSManaged public var order: Order

}
