//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation

class RestockDetails {
    
    let stockTimeStamp: Date
    var restockQty: Int
    
    init(stockTimeStamp: Date, restockQty: Int) {
        self.stockTimeStamp = stockTimeStamp
        self.restockQty = restockQty
    }
}
