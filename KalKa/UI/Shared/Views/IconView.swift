//
//  Copyright © 2020 LabLambWorks. All rights reserved.
//

import SnapKit

class IconView: CustomView {
    
    let iconImage: UIImageView
    let defaultImage: UIImage
    weak var cameraOptionPresenter: UIViewController?
    
    override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0, height: Constants.UI.Sizing.Height.Medium)
        }
    }
    
    init(image: UIImage) {
        self.defaultImage = image
        self.iconImage = UIImageView(image: self.defaultImage)
        
        super.init()
        
        let tapGest = UITapGestureRecognizer(target: self, action: #selector(self.showImageUploadOption))
        self.iconImage.addGestureRecognizer(tapGest)
        self.iconImage.isUserInteractionEnabled = true
    }
    
    override func setupLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(Constants.UI.Sizing.Height.Medium)
        }
        
        self.addSubview(self.iconImage)
        self.iconImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.UI.Spacing.Height.Medium)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constants.UI.Spacing.Height.Medium)
            make.width.equalTo(self.iconImage.snp.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconImage.backgroundColor = .accent
        self.iconImage.clipsToBounds = true
        self.iconImage.layer.cornerRadius = (self.iconImage.frame.width + self.iconImage.frame.height) / 4
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Camera
extension IconView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc private func showImageUploadOption() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: .cameraRoll, style: .default, handler: { _ in
            self.uploadByLibrary()
        }))
        
        let resetBtn = UIAlertAction(title: .remove, style: .destructive, handler: { _ in
            self.resetIconDefault()
        })
        actionSheet.addAction(resetBtn)
        
        actionSheet.addAction(UIAlertAction(title: .cancel, style: .cancel, handler: nil))
        
        resetBtn.isEnabled = !(self.iconImage.image?.isEqual(self.defaultImage) ?? false)
        
        self.cameraOptionPresenter?.present(actionSheet, animated: true, completion: nil)
    }
    
    private func uploadByLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.cameraOptionPresenter?.present(picker, animated: true, completion: nil)
        }
    }
    
    private func resetIconDefault() {
        self.iconImage.image = self.defaultImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.iconImage.image = img
        }
        self.cameraOptionPresenter?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.cameraOptionPresenter?.dismiss(animated: true, completion: nil)
    }
}
