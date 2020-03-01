//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

struct OrderDetails {
    let number: String
    let remark: String
    let openedOn: Date
    let isShipped: Bool
    let isPaid: Bool
    let isDeposit: Bool
    let isClosed: Bool
    let customerName: String
    var items: [OrderItemDetails]?
}
