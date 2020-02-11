//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation

struct Inventory {
    var merchs: [Merch]
    
    init() {
        let m = [Merch(name: "千層餅", price: 180, qty: 10000, remark: "原味法式千層蛋糕", image: #imageLiteral(resourceName: "MerchDefault")),
        Merch(name: "草莓蛋糕", price: 108, qty: 1, remark: "", image: #imageLiteral(resourceName: "MerchDefault")),
        Merch(name: "紐約芝士蛋糕", price: 80, qty: 4, remark: "紐約直送", image: #imageLiteral(resourceName: "MerchDefault")),
        Merch(name: "說謊蛋糕", price: 58, qty: 3, remark: "", image: #imageLiteral(resourceName: "MerchDefault")),
        Merch(name: "沒茶蛋糕", price: 48, qty: 1, remark: "", image: #imageLiteral(resourceName: "MerchDefault")),
        Merch(name: "紙杯蛋糕", price: 38, qty: 16, remark: "最快到貨日 2020-02-15", image: #imageLiteral(resourceName: "MerchDefault")),
        Merch(name: "香蕉糕", price: 28, qty: 200, remark: "", image: #imageLiteral(resourceName: "MerchDefault")),
        Merch(name: "瑞士卷", price: 20, qty: 48, remark: "", image: #imageLiteral(resourceName: "MerchDefault")),
        Merch(name: "黑森林蛋糕", price: 138, qty: 12, remark: "到期日 2020-03-24", image: #imageLiteral(resourceName: "MerchDefault")),
        Merch(name: "三層芝士漢堡", price: 38, qty: 24, remark: "已斷貨 2020-01-04", image: #imageLiteral(resourceName: "MerchDefault"))]
        self.merchs = m
    }
    
    private func fetch() {
        
    }
}
