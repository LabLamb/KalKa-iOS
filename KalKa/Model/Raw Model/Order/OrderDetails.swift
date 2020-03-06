//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

class OrderDetails: ModelDetails {
    override var id: String {
        get {
            return self.number
        }
    }
    let number: String
    let remark: String
    let openedOn: Date
    let isShipped: Bool
    let isPreped: Bool
    let isPaid: Bool
    let isDeposit: Bool
    let isClosed: Bool
    let customerName: String
    var items: [OrderItemDetails]?
    
    init(number: String, remark: String, openedOn: Date, isShipped: Bool, isPreped: Bool, isPaid: Bool, isDeposit: Bool, isClosed: Bool, customerName: String, items: [OrderItemDetails]?) {
        self.number = number
        self.remark = remark
        self.openedOn = openedOn
        self.isShipped = isShipped
        self.isPreped = isPreped
        self.isPaid = isPaid
        self.isDeposit = isDeposit
        self.isClosed = isClosed
        self.customerName = customerName
        self.items = items
    }
}
