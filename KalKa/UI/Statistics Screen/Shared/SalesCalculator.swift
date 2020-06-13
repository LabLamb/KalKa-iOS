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
    
    struct TopClient {
        let name: String
        var spent: Double
        var orders: Int
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
        fetchRequest.predicate = NSPredicate(format: "order.isPaid = %@", argumentArray: [true])
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
            
            return bestSeller?.value ?? BestSeller(name: .absent, sales: 0.00, sold: 0)
        } else {
            return BestSeller(name: .absent, sales: 0.00, sold: 0)
        }
    }
    
    func getTopClient() -> TopClient {
        let customerList = CustomerList()
        let predicate = NSPredicate(format: "orders.@count > %d", argumentArray: [0])
        if let customers = customerList.query(clause: predicate) as? [Customer] {
            let allCust: [TopClient] = customers.compactMap({ cust in
                let orders = cust.orders as NSArray
                let spent = orders.reduce(0.00, { result, order in
                    guard let order = order as? Order, order.isPaid else { return result }
                    return result + self.accumulateSales(order: order)
                })
                return TopClient(name: cust.name, spent: spent, orders: orders.count)
            })
            
            let topCust = allCust.sorted(by: { t1, t2 in
                t1.spent > t2.spent
            }).first
            
            return topCust ?? TopClient(name: .absent, spent: 0.00, orders: 0)
        }
        
        return TopClient(name: .absent, spent: 0.00, orders: 0)
    }
}
