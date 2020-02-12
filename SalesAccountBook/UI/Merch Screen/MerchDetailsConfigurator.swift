//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

struct MerchDetailsConfigurator {
    let action: DetailsViewActionType
    let merchName: String?
    let inventory: Inventory?
    let onSelectRow: ((String) -> Void)?
}
