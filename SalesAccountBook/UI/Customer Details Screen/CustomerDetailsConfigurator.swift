//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

struct CustomerDetailsConfigurator {
    let action: DetailsViewActionType
    let customerName: String?
    let customerList: CustomerList?
    let onSelectRow: ((String) -> Void)?
}
