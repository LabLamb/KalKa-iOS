//
//  Copyright © 2019 LabLambWorks. All rights reserved.
//

import Foundation
import CoreData

@objc(Merch)
public class Merch: NSManagedObject {
    override var id: String {
        get {
            return self.name
        }
    }
}
