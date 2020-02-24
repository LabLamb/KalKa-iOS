//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

struct DetailsConfigurator {
    let action: DetailsViewActionType
    let id: String
    let viewModel: ViewModel?
    let onSelectRow: ((String) -> Void)?
}
