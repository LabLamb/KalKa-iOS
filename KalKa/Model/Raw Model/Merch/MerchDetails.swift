//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//


import UIKit

class MerchDetails: ModelDetails {
    
    override var id: String {
        get {
            return self.name
        }
    }
    let name: String
    let price: Double
    let qty: Int
    let remark: String
    var image: UIImage?
    var restocks: [RestockDetails]?
    
    init(name: String, price: Double, qty: Int, remark: String, image: UIImage?, restocks: [RestockDetails]?) {
        self.name = name
        self.price = price
        self.qty = qty
        self.remark = remark
        self.image = image
        self.restocks = restocks
    }
}
