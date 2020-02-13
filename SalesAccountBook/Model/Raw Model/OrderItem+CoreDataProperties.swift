//
//  OrderItem+CoreDataProperties.swift
//  
//
//  Created by LabLamb on 13/2/2020.
//
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
    @NSManaged public var remark: String
    @NSManaged public var order: Order

}
