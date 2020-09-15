//
//  ProfileViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-15.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var isAuthenticated: Bool! = false
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        scrollView.addSubview(stackView)
        stackView.pin(to: scrollView)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 25, bottom: 5, trailing: 25)
        return stackView
    }()
    
    var symbolButton: UIButton = {
        let symbolButton = UIButton()
        //        symbolButton.clipsToBounds = true
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular, scale: .large)
        let uiImage = UIImage(systemName: "person.crop.circle", withConfiguration: symbolConfig)?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
        symbolButton.setImage(uiImage, for: .normal)
        symbolButton.tag = 1
        symbolButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return symbolButton
    }()
    
    var imagePath: URL!
    var imageName: String!
    var buttonContainer = UIView()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "Username"
        return label
    }()
    
    var usernameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 6.0;
        let borderColor = UIColor.gray
        textField.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        return textField
    }()
    
    var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "About me"
        label.textColor = .gray
        return label
    }()
    
    var commentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = UIColor.gray
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = false
        textView.clipsToBounds = true
        textView.layer.cornerRadius = 6.0;
        let borderColor = UIColor.gray
        textView.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isAuthenticated {
            configureAuthenticatedUI()
        } else {
            configureUnauthenticatedUI()
            setUnauthenticatedConstraints()
        }
    }
    
    func configureAuthenticatedUI() {
        print("logged in")
    }
    
    func setAuthenticatedConstraints() {
        
    }
    
    func configureUnauthenticatedUI() {
        title = "Profile"

        // button for the profile image
        buttonContainer.addSubview(symbolButton)
        stackView.addArrangedSubview(buttonContainer)
        
        // username label
        stackView.addArrangedSubview(usernameLabel)
        
        // text field for the username
        stackView.addArrangedSubview(usernameTextField)
        stackView.setCustomSpacing(50, after: usernameTextField)
        
        // about me comment label
        stackView.addArrangedSubview(commentLabel)
        
        // comment text view
        stackView.addArrangedSubview(commentTextView)
    }
    
    func setUnauthenticatedConstraints() {
        // button for the profile image
        symbolButton.translatesAutoresizingMaskIntoConstraints = false
        symbolButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        symbolButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        symbolButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor).isActive = true
        symbolButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // username label
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // text field for the username
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        // about me comment label
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // comment text view
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    @objc func buttonPressed(sender: UIButton!) {
        switch sender.tag {
        case 1:
            let ac = UIAlertController(title: "Pick an image", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Photos", style: .default, handler: openPhoto))
            ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
            
            if imageName != nil {
                ac.addAction(UIAlertAction(title: "No Image", style: .default, handler: { action in
                    let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular, scale: .large)
                    let uiImage = UIImage(systemName: "person.crop.circle", withConfiguration: symbolConfig)?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
                    self.symbolButton.setImage(uiImage, for: .normal)
                }))
                self.imageName = nil
            }
            
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            present(ac, animated: true, completion: {() -> Void in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
                ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            })
        default:
            print("default")
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let tempImageName = UUID().uuidString
        imagePath = getDocumentsDirectory().appendingPathComponent(tempImageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath!)
        }
        imageName = tempImageName
        
        let imageView = UIImageView(image: image)
        imageView.image = imageView.image?.resizeImageWith(newSize: CGSize(width: 100, height: 100))
        symbolButton.setImage(imageView.image, for: .normal)
        symbolButton.imageView?.contentMode = .scaleAspectFill
        symbolButton.imageView?.layer.borderColor = UIColor.black.cgColor
        symbolButton.imageView?.layer.borderWidth = 2.0
        symbolButton.imageView?.layer.cornerRadius = (symbolButton.imageView?.frame.width)! / 2
        symbolButton.imageView?.layer.masksToBounds = true
        symbolButton.alpha = 0
        
        //        if image.size.width > image.size.height {
        //            symbolButton.imageView?.contentMode = .scaleAspectFit
        //        } else {
        //            symbolButton.imageView?.contentMode = .scaleAspectFill
        //        }
        
        dismiss(animated: true, completion: nil)
        
        UIView.animate(withDuration: 1.3, animations: {
            self.symbolButton.alpha = 1
        })
    }
    
    func openPhoto(action: UIAlertAction) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        } else {
            let ac = UIAlertController(title: "Photo Library Not Available", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(ac, animated: true)
        }
    }
    
    func openCamera(action: UIAlertAction) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        } else {
            let ac = UIAlertController(title: "Camera Not Available", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            present(ac, animated: true)
        }
    }
}

extension UIImage{
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
