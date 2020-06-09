//
//  Copyright © LabLambWorks. All rights reserved.
//

import Foundation
import CoreData

class SalesCalculator {
    
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

    func getBestSeller() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderItem")
        if let orderItems = try? CoreStack.shared.persistentContainer.viewContext.fetch(fetchRequest) as? [OrderItem] {
            let grouped = Dictionary(grouping: orderItems, by: { $0.name })
            print(orderItems.count)
        }
    }
}
