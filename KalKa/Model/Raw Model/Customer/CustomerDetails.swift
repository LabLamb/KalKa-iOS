//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import UIKit

struct CustomerDetails {
    var image: UIImage?
    let address: String
    let lastContacted: Date
    let name: String
    let phone: String
    var orders: [Order]?
    let remark: String
}
