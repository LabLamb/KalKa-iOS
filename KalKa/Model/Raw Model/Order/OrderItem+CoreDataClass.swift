//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData

@objc(OrderItem)
public class OrderItem: NSManagedObject {
    override var id: String {
        get {
            return self.name
        }
    }
}
