//
//  Copyright © LabLambWorks. All rights reserved.
//

import Foundation
import CoreData

class SalesCalculator {
    
    struct BestSeller {
        let name: String
        var sales: Double
        var sold: Int
    }
    
    func calculateSalesBetween(startDate: Date, endDate: Date) -> Double {
        let orders = self.queryClosedOrderBetween(startDate: startDate, endDate: endDate)
        let sales = orders?.reduce(0.00, { result, order in
            return result + self.accumulateSales(order: order)
        }) ?? 0.00
        return sales
    }
    
    func queryClosedOrderBetween(startDate: Date, endDate: Date) -> [Order]? {
        let orderList = OrderList()
        let predicate = NSPredicate(format: "openedOn >= %@ AND openedOn <= %@ AND isPaid = %@", argumentArray: [startDate, endDate, true])
        return orderList.query(clause: predicate) as? [Order]
    }
    
    func accumulateSales(order: Order) -> Double {
        let orderSales = order.items?.compactMap({ orderItem in
            return orderItem.price * Double(orderItem.qty)
        }).reduce(0.00, +)
        return orderSales ?? 0.00
    }

    func getBestSeller() -> BestSeller {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderItem")
        if let orderItems = try? CoreStack.shared.persistentContainer.viewContext.fetch(fetchRequest) as? [OrderItem] {
            var grouped = Dictionary<String, BestSeller>()
            
            orderItems.forEach({ orderItem in
                if grouped[orderItem.name] == nil {
                    grouped[orderItem.name] = BestSeller(name: orderItem.name, sales: (Double(orderItem.qty) * orderItem.price), sold: Int(orderItem.qty))
                } else {
                    grouped[orderItem.name]?.sales += (Double(orderItem.qty) * orderItem.price)
                    grouped[orderItem.name]?.sold += Int(orderItem.qty)
                }
            })
            
            let bestSeller = grouped.sorted(by: { (kv1, kv2) in
                return kv1.value.sales > kv2.value.sales
            }).first
            
            return bestSeller?.value ?? BestSeller(name: .error, sales: 0.00, sold: 0)
        } else {
            return BestSeller(name: .error, sales: 0.00, sold: 0)
        }
    }
}
