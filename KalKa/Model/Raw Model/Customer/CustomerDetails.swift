//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

class CustomerDetails: ModelDetails {
    override var id: String {
        get {
            return self.name
        }
    }
    var image: UIImage?
    let address: String
    let lastContacted: Date
    let name: String
    let phone: String
    var orders: [Order]?
    let remark: String
    
    init(image: UIImage?, address: String, lastContacted: Date, name: String, phone: String, orders: [Order]?, remark: String) {
        self.image = image
        self.address = address
        self.lastContacted = lastContacted
        self.name = name
        self.phone = phone
        self.orders = orders
        self.remark = remark
    }
}
