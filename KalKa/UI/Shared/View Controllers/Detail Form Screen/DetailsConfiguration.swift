//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

class DetailsConfiguration {
    let action: DetailsViewActionType
    let id: String
    let viewModel: ViewModel?
    let onSelectRow: ((String) -> Void)?
    let presentingRefreshable: Refreshable?
    
    init(action: DetailsViewActionType,
         id: String,
         viewModel: ViewModel?,
         onSelectRow: ((String) -> Void)?,
         presentingRefreshable: Refreshable? = nil) {
        self.action = action
        self.id = id
        self.viewModel = viewModel
        self.onSelectRow = onSelectRow
        self.presentingRefreshable = presentingRefreshable
    }
}
