//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

class DetailsConfiguration {
    let action: DetailsViewActionType
    let id: String
    let viewModel: ViewModel?
    let onSelectRow: ((String) -> Void)?
    
    init(action: DetailsViewActionType,
         id: String,
         viewModel: ViewModel?,
         onSelectRow: ((String) -> Void)?) {
        self.action = action
        self.id = id
        self.viewModel = viewModel
        self.onSelectRow = onSelectRow
    }
}
