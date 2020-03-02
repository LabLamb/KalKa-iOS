//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class OrderDetailsStackView: InputFieldsSection {
    
    func appendView(view: CustomView) {
        self.stackView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            if type(of: view) == IconView.self {
                make.width.equalToSuperview()
                make.height.equalTo(Constants.UI.Sizing.Height.Medium)
            } else {
                make.width.equalToSuperview().multipliedBy(0.95)
            }
            view.backgroundColor = .primary
            view.addLine(position: .bottom, color: self.separatorColor, weight: 1)
        }
    }
    
    //    public func getViews(descText: String) -> [UIView] {
    //        return self.extractFieldsViews().filter({ view in
    //            (view.desc as? String) == descText
    //        })
    //    }
    
    //    private func extractFieldsViews() -> [DescWithValue] {
    //        return self.stackView.arrangedSubviews.filter({ $0 is DescWithValue }) as! [DescWithValue]
    //    }
    
    //    public func prefillValues(values: [OrderItemDetails]) {
    //        self.extractFieldsViews().forEach({ field in
    //            if let desc = field.desc as? String, let value = values[desc] {
    //                field.value = value
    //            }
    //        })
    //    }
    
    //    public func extractValues() -> [OrderItemDetails] {
    //        var result: [String: String] = [:]
    //        self.extractFieldsViews().forEach({ field in
    //            if let desc = field.desc as? String {
    //                result[desc] = field.value
    //            }
    //        })
    //        return result
    //    }
}
