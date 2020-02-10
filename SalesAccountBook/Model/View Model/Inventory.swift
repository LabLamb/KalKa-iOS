//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation

struct Inventory {
    let merchs: [Merch]
    
    init() {
        var m = [Merch(name: "213", price: 123.2, qty: 213, remark: "wdsada", image: #imageLiteral(resourceName: "MerchDefault")),
            Merch(name: "213", price: 123.2, qty: 213, remark: "wdsada", image: #imageLiteral(resourceName: "MerchDefault")),
            Merch(name: "213", price: 123.2, qty: 213, remark: "wdsada", image: #imageLiteral(resourceName: "MerchDefault")),
            Merch(name: "213", price: 123.2, qty: 213, remark: "wdsada", image: #imageLiteral(resourceName: "MerchDefault")),
            Merch(name: "213", price: 123.2, qty: 213, remark: "wdsada", image: #imageLiteral(resourceName: "MerchDefault"))]
        self.merchs = m
        
    }
    
    private func fetch() {
        
    }
}
