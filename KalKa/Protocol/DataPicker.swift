//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

protocol DataPicker: AnyObject {
    func pickCustomer()
    func pickOrderItem()
    func removeOrderItem(id: String)
}
