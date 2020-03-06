//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

class OrderItemDetails: ModelDetails {
    
    override var id: String {
        get {
            return self.name
        }
    }
    let name: String
    let qty: Int32
    let price: Double
    
    init(name: String, qty: Int32, price: Double) {
        self.name = name
        self.qty = qty
        self.price = price
    }
}
