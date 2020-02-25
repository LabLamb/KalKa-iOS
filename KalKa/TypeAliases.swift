//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

typealias MerchDetails = (
    name: String,
    price: Double,
    qty: Int,
    remark: String,
    image: UIImage?
)

typealias CustomerDetails = (
    image: UIImage?,
    address: String,
    lastContacted: Date,
    name: String,
    phone: String,
    orders: [Order]?,
    remark: String
)

typealias OrderDetails = (
    number: String,
    remark: String,
    openedOn: Date,
    isShipped: Bool,
    isPaid: Bool,
    isDeposit: Bool,
    isClosed: Bool,
    customerName: String,
    items: [OrderItem]?
)
