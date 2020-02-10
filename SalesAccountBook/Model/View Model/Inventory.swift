//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation

struct Inventory {
    var merchs: [Merch]
    
    init() {
        var m = [Merch(name: "千層餅", price: 155.5, qty: 2, remark: "原味法式千層蛋糕", image: #imageLiteral(resourceName: "MerchDefault")),
        Merch(name: "草莓蛋糕", price: 108, qty: 1, remark: "", image: #imageLiteral(resourceName: "MerchDefault"))]
        self.merchs = m
    }
    
    private func fetch() {
        
    }
}
