//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class InputFieldsSection: CustomView {
    
    let stackView: UIStackView
    private let separatorColor: UIColor = .groupTableViewBackground
    
    init(fields: [CustomView]) {
        self.stackView = UIStackView()
        
        super.init()
        
        self.stackView.axis = .vertical
        self.stackView.alignment = .fill
        self.stackView.distribution = .fill
        self.stackView.alignment = .center
        fields.forEach { view in
            self.stackView.addArrangedSubview(view)
        }
    }
    
    override func setupLayout() {
        self.addLine(position: .LINE_POSITION_BOTTOM, color: self.separatorColor, width: 1)
        
        self.addSubview(self.stackView)
        self.stackView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
        
        self.stackView.arrangedSubviews.forEach { view in
            view.snp.makeConstraints { make in
                if type(of: view) == IconView.self {
                    make.width.equalToSuperview()
                    make.height.equalTo(Constants.UI.Sizing.Height.Medium)
                } else {
                    make.width.equalTo(Constants.System.SupportedMiniumScreenWidth - (Constants.UI.Spacing.Width.Medium * 2))
                    make.height.equalTo(Constants.UI.Sizing.Height.TextFieldDefault)
                }
                view.backgroundColor = .white
                view.addLine(position: .LINE_POSITION_BOTTOM, color: self.separatorColor, width: 1)
            }
        }
    }
    
    public func getView<T>(viewType: T) -> [UIView] {
        return self.stackView.arrangedSubviews.filter({ view in
            type(of: view) == type(of: viewType)
        })
    }
    
    private func extractFieldsViews() -> [DescWithText] {
        return self.stackView.arrangedSubviews.filter({ $0 is DescWithText }) as! [DescWithText]
    }
    
    public func prefillValues(values: [String: String]) {
        self.extractFieldsViews().forEach({ field in
            if let desc = field.desc as? String, let value = values[desc] {
                field.text = value
            }
        })
    }
    
    public func extractValues(valMapping: [String]) -> [String: String] {
        var result: [String: String] = [:]
        self.extractFieldsViews().forEach({ field in
            if let desc = field.desc as? String {
                result[desc] = field.text
            }
        })
        return result
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
