//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

enum DetailsViewActionType {
    case add
    case edit
}

enum LinePosition {
    case top
    case bottom
    case left
    case right
}

enum OrderStatus: String {
    case open = "Open"
    case paymentReceived = "PaymentReceived"
    case delivered = "Delivered"
    case close = "Closed"
}
