////
////  Copyright © 2019 LabLambWorks. All rights reserved.
////
//
//import SnapKit
//
//class IconWithTextLabel: DescWithText {
//
//    init(icon: UIImage, text: String = "", textAlign: NSTextAlignment = .left) {
//        self.tagView = UIImageView(image: icon)
//        self.textView = UILabel()
//        self.spacing = 0
//
//        super.init(frame: .zero)
//
//        self.textLabel.text = text
//        self.textLabel.textAlignment = textAlign
//    }
//
//    func setupLayout() {
//        self.addSubview(self.icon)
//        self.icon.snp.makeConstraints({ make in
//            make.top.left.equalToSuperview()
//            make.height.equalToSuperview()
//            make.width.equalTo(self.icon.snp.height)
//        })
//        self.addSubview(self.textLabel)
//        self.textLabel.snp.makeConstraints({ make in
//            make.left.equalTo(self.icon.snp.right).offset(self.spacing)
//            make.top.right.bottom.equalToSuperview()
//        })
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//}
