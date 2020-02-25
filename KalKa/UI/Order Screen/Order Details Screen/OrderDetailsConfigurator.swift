//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

class OrderDetailsConfigurator: DetailsConfigurator {
    let isClosed: Bool
    
    init(action: DetailsViewActionType,
         id: String,
         viewModel: ViewModel?,
         onSelectRow: ((String) -> Void)?,
         isClosed: Bool) {
        self.isClosed = isClosed
        super.init(action: action,
                   id: id,
                   viewModel: viewModel,
                   onSelectRow: onSelectRow)
    }
}
