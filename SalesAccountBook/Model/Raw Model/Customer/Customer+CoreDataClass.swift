//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData

@objc(Customer)
public class Customer: NSManagedObject {
    override var id: String {
        get {
            return self.name
        }
    }
}
