//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData

@objc(Order)
public class Order: NSManagedObject {
    override var id: String {
        get {
            return String(self.number)
        }
    }
}
