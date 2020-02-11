//
//  Copyright © 2019 LabLambWorks. All rights reserved.
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

}
