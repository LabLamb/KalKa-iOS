//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import Foundation

extension NSNumber {
    func toLocalCurrency(fractDigits: Int = 2) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = fractDigits
        return formatter.string(from: self)
    }
    
    func toLocalCurrencyWithoutFractionDigits() -> String? {
        return toLocalCurrency(fractDigits: 0)
    }
}

extension Numeric {
    func toLocalCurrency(fractDigits: Int = 2) -> String? {
        return (self as? NSNumber)?.toLocalCurrency(fractDigits: fractDigits)
    }
    
    func toLocalCurrencyWithoutFractionDigits() -> String? {
        return toLocalCurrency(fractDigits: 0)
    }
}
