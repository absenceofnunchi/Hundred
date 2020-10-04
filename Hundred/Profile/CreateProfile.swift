//
//  CreateProfile.swift
//  Hundred
//
//  Created by J C on 2020-09-30.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class CreateProfile: ProfileBaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    lazy fileprivate var imageButton = createButton(title: nil, image: "camera.circle", cornerRadius: 0, color:  .darkGray, size: 60, tag: 2, selector: #selector(buttonPressed))
    fileprivate let userTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Enter your username"
        textField.textAlignment = .left
        textField.autocorrectionType = .no
        BorderStyle.customShadowBorder(for: textField)
        return textField
    }()
    lazy fileprivate var descTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 15)
        textView.layer.masksToBounds = true
        BorderStyle.customShadowBorder(for: textView)
        return textView
    }()
    fileprivate var imageName: String!
    fileprivate var firstResponder: UIView? /// To handle textField position when keyboard is visible.
    fileprivate var isKeyboardVisible = false
    fileprivate lazy var doneButton: UIButton = {
        let dButton = UIButton()
        dButton.setTitle("Done", for: .normal)
        dButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        dButton.layer.cornerRadius = 7
        dButton.tag = 1
        dButton.backgroundColor = .black
        dButton.addTarget(self, action: #selector(buttonPressed) , for: .touchUpInside)
        return dButton
    }()
    fileprivate var utility = Utilities()
    weak var delegate: CreateProfileProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()
        initializeHideKeyboard()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureUI() {
        scrollView.addSubview(imageButton)
        
        usernameContainer = UIView()
        scrollView.addSubview(usernameContainer)
        
        usernameLabel = UILabel()
        usernameLabel.text = "username"
        usernameLabel.font = UIFont.body.with(weight: .regular)
        usernameLabel.textColor = .gray
        usernameContainer.addSubview(usernameLabel)
        scrollView.addSubview(userTextField)
        
        descContainer = UIView()
        scrollView.addSubview(descContainer)
        
        descLabel = UILabel()
        descLabel.text = "description"
        descLabel.font = UIFont.body.with(weight: .regular)
        descLabel.textColor = .gray
        descContainer.addSubview(descLabel)
        scrollView.addSubview(descTextView)
        scrollView.addSubview(doneButton)
    }
    
    func setConstraints() {
        scrollView.pin(to: view)
        
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        
        usernameContainer.translatesAutoresizingMaskIntoConstraints = false
        usernameContainer.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 30).isActive = true
        usernameContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        usernameContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        usernameContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leadingAnchor.constraint(equalTo: usernameContainer.leadingAnchor).isActive = true
        
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 5).isActive = true
        userTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        userTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        descContainer.translatesAutoresizingMaskIntoConstraints = false
        descContainer.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 30).isActive = true
        descContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        descContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        descContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.leadingAnchor.constraint(equalTo: descContainer.leadingAnchor).isActive = true
        
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        descTextView.topAnchor.constraint(equalTo: descContainer.bottomAnchor, constant: 5).isActive = true
        descTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        descTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        descTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.topAnchor.constraint(equalTo: descTextView.bottomAnchor, constant: 20).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
    
    @objc func buttonPressed(sender: UIButton!) {
        switch sender.tag {
        case 1:
            if let usernameText = userTextField.text, !usernameText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                let profile = Profile(context: self.context)
                if let imageName = imageName {
                    profile.image = imageName
                }
                profile.username = userTextField.text
                if let desc = descTextView.text {
                    profile.detail = desc
                }
                profile.userId = UUID().uuidString

                self.saveContext()
                
                delegate?.runFetchProfile()
            } else {
                alert(with: Messages.status, message: Messages.emptyUsername)
            }
        case 2:
            let ac = UIAlertController(title: "Pick an image", message: nil, preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "Photos", style: .default, handler: openPhoto))
            ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
            
            if imageName != nil {
                ac.addAction(UIAlertAction(title: "No Image", style: .default, handler: { action in
                    let largeConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium, scale: .large)
                    let uiImage = UIImage(systemName: "camera.circle", withConfiguration: largeConfig)
                    self.imageButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
                    self.imageButton.setImage(uiImage, for: .normal)
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 110
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // MARK: - Display Alert
    
    /// Creates and displays an alert.
    fileprivate func alert(with title: String, message: String) {
        let alertController = utility.alert(title, message: message)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.navigationController?.present(alertController, animated: true, completion: nil)
    }
}


extension CreateProfile: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        imageButton.alpha = 0
        imageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: imageButton.bounds.width - imageButton.bounds.height)
        imageButton.imageView?.layer.cornerRadius = imageButton.bounds.height/2.0
        imageButton.imageView?.layer.masksToBounds = true
        imageButton.setImage(image, for: .normal)
        
        dismiss(animated: true, completion: nil)
        
        UIView.animate(withDuration: 1.5, animations: {
            self.imageButton.alpha = 1
        })
    }
}

extension CreateProfile {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 500
    }
}
