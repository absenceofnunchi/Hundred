////
////  ProfileViewController.swift
////  Hundred
////
////  Created by J C on 2020-09-15.
////  Copyright © 2020 J. All rights reserved.
////
//
//import UIKit
//import AuthenticationServices
//
//class ProfileViewController1: UIViewController {
//    @IBOutlet weak var scrollView: UIScrollView!
//    var isAuthenticated: Profile?
//    lazy var stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.alignment = .fill
//        stackView.spacing = 20
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 25, bottom: 5, trailing: 25)
//        scrollView.addSubview(stackView)
//        stackView.pin(to: scrollView)
//        return stackView
//    }()
//
//    var symbolButton: UIButton = {
//        let symbolButton = UIButton()
//        //        symbolButton.clipsToBounds = true
//        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular, scale: .large)
//        let uiImage = UIImage(systemName: "person.crop.circle", withConfiguration: symbolConfig)?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
//        symbolButton.setImage(uiImage, for: .normal)
//        symbolButton.tag = 1
//        symbolButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        return symbolButton
//    }()
//
//    var imagePath: URL!
//    var imageName: String!
//    var buttonContainer = UIView()
//
//    var usernameLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .gray
//        label.text = "Username"
//        return label
//    }()
//
//    var usernameTextField: CustomTextField = {
//        let textField = CustomTextField()
//        textField.layer.borderWidth = 1
//        textField.layer.masksToBounds = false
//        textField.layer.cornerRadius = 6.0;
//        let borderColor = UIColor.gray
//        textField.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
//        return textField
//    }()
//
//    var commentLabel: UILabel = {
//        let label = UILabel()
//        label.text = "About me"
//        label.textColor = .gray
//        return label
//    }()
//
//    var commentTextView: UITextView = {
//        let textView = UITextView()
//        textView.isEditable = true
//        textView.isSelectable = true
//        textView.isScrollEnabled = true
//        textView.font = UIFont.preferredFont(forTextStyle: .body)
//        textView.textColor = UIColor.gray
//        textView.layer.borderWidth = 1
//        textView.layer.masksToBounds = false
//        textView.clipsToBounds = true
//        textView.layer.cornerRadius = 6.0;
//        let borderColor = UIColor.gray
//        textView.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
//        textView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10)
//        return textView
//    }()
//
//    var profileImageView: UIImageView!
//    var profileImageContainer: UIView!
//    var usernameDisplay: UILabel!
//    var aboutMeLabel: UILabel!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//        loginPortal()
////        if isAuthenticated != nil {
////            if let profile = isAuthenticated {
////                configureAuthenticatedUI(profile: profile)
////                setAuthenticatedConstraints()
////            }
////        } else {
////
////            loginPortal()
////
////
////            initializeHideKeyboard()
////            configureUnauthenticatedUI()
////            setUnauthenticatedConstraints()
////
////            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
////            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
////        }
//    }
//
//    func configureAuthenticatedUI(profile: Profile) {
//        profileImageView = UIImageView()
//        profileImageContainer = UIView()
//        profileImageContainer.addSubview(profileImageView)
//        stackView.addArrangedSubview(profileImageContainer)
//        stackView.setCustomSpacing(50, after: profileImageContainer)
//
//        if let image = profile.image {
//            let imagePath = getDocumentsDirectory().appendingPathComponent(image)
//            if let data = try? Data(contentsOf: imagePath) {
//                if let uiImage = UIImage(data: data) {
//                    profileImageView.image = UIImageView(image: uiImage).image?.resizeImageWith(newSize: CGSize(width: 100, height: 100))
//                    profileImageView.contentMode = .scaleAspectFill
//                    profileImageView.layer.borderColor = UIColor.black.cgColor
//                    profileImageView.layer.borderWidth = 2.0
//                    profileImageView.layer.cornerRadius = ((profileImageView.image?.size.height)!) / 2
//                    profileImageView.layer.masksToBounds = false
//                    profileImageView.clipsToBounds = true
//                }
//            }
//        } else {
//            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .unspecified)
//            profileImageView.image = UIImage(systemName: "person.crop.circle", withConfiguration: symbolConfig)?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
//
//        }
//
//        //  username
//        usernameDisplay = UILabel()
//        usernameDisplay.adjustsFontSizeToFitWidth = false
//        usernameDisplay.lineBreakMode = .byTruncatingTail
//        usernameDisplay.font = UIFont.preferredFont(forTextStyle: .body)
//        usernameDisplay.text = profile.username
//        addCard(text: "Username", subItem: usernameDisplay, stackView: stackView, containerHeight: 50, bottomSpacing: 50, insert: nil, tag: nil, topInset: nil, bottomInset: nil, widthMultiplier: nil, isShadowBorder: false)
//
//        if let aboutMe = profile.aboutme {
//            aboutMeLabel = UILabel()
//            aboutMeLabel.numberOfLines = 0
//            aboutMeLabel.adjustsFontSizeToFitWidth = false
//            aboutMeLabel.lineBreakMode = .byTruncatingTail
//            aboutMeLabel.font = UIFont.preferredFont(forTextStyle: .body)
//            aboutMeLabel.text = aboutMe
//            addCard(text: "About Me", subItem: aboutMeLabel, stackView: stackView, containerHeight: 100, bottomSpacing: nil, insert: nil, tag: nil, topInset: nil, bottomInset: nil, widthMultiplier: nil, isShadowBorder: false)
//        }
//
//    }
//
//    func setAuthenticatedConstraints() {
//        // the profile image
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        profileImageView.centerXAnchor.constraint(equalTo: profileImageContainer.centerXAnchor).isActive = true
//        profileImageView.centerYAnchor.constraint(equalTo: profileImageContainer.centerYAnchor).isActive = true
//        profileImageContainer.translatesAutoresizingMaskIntoConstraints = false
//        profileImageContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
//    }
//
//    func configureUnauthenticatedUI() {
//        title = "Profile"
//
//        // done button in the tool bar
//        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
//        let flexSpace = UIBarButtonItem(barButtonSystemItem:  .flexibleSpace, target: nil, action: nil)
//        let doneBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(buttonPressed))
//        doneBtn.tag = 2
//        toolbar.setItems([flexSpace, doneBtn], animated: false)
//        toolbar.sizeToFit()
//        self.usernameTextField.inputAccessoryView = toolbar
//        self.commentTextView.inputAccessoryView = toolbar
//
//        // button for the profile image
//        buttonContainer.addSubview(symbolButton)
//        stackView.addArrangedSubview(buttonContainer)
//
//        // username label
//        stackView.addArrangedSubview(usernameLabel)
//
//        // text field for the username
//        stackView.addArrangedSubview(usernameTextField)
//        stackView.setCustomSpacing(50, after: usernameTextField)
//
//        // about me comment label
//        stackView.addArrangedSubview(commentLabel)
//
//        // comment text view
//        stackView.addArrangedSubview(commentTextView)
//    }
//
//    func setUnauthenticatedConstraints() {
//        // button for the profile image
//        symbolButton.translatesAutoresizingMaskIntoConstraints = false
//        symbolButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        symbolButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        symbolButton.centerXAnchor.constraint(equalTo: buttonContainer.centerXAnchor).isActive = true
//        symbolButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
//        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
//        buttonContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        // username label
//        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
//        usernameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        // text field for the username
//        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
//        usernameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//        // about me comment label
//        commentLabel.translatesAutoresizingMaskIntoConstraints = false
//        commentLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        // comment text view
//        commentTextView.translatesAutoresizingMaskIntoConstraints = false
//        commentTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//    }
//
//
//    @objc func buttonPressed(sender: UIButton!) {
//        switch sender.tag {
//        case 1:
//            let ac = UIAlertController(title: "Pick an image", message: nil, preferredStyle: .actionSheet)
//            ac.addAction(UIAlertAction(title: "Photos", style: .default, handler: openPhoto))
//            ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
//
//            if imageName != nil {
//                ac.addAction(UIAlertAction(title: "No Image", style: .default, handler: { action in
//                    let symbolConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .regular, scale: .large)
//                    let uiImage = UIImage(systemName: "person.crop.circle", withConfiguration: symbolConfig)?.withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
//                    self.symbolButton.setImage(uiImage, for: .normal)
//                }))
//                self.imageName = nil
//            }
//
//            if let popoverController = ac.popoverPresentationController {
//                popoverController.sourceView = self.view
//                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
//                popoverController.permittedArrowDirections = []
//            }
//
//            present(ac, animated: true, completion: {() -> Void in
//                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
//                ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
//            })
//        case 2:
//            view.endEditing(true)
//
//            if let text = usernameTextField.text, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
//                let profile = Profile(context: self.context)
//
//                profile.username = usernameTextField.text ?? ""
//
//                if let imageName = imageName {
//                    profile.image = imageName
//                }
//
//                if let comment = commentTextView.text {
//                    profile.aboutme = comment
//                }
//
//                self.saveContext()
//
//                self.showSpinner(container: self.scrollView)
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    _ = self.navigationController?.popViewController(animated: true)
//                    self.removeSpinner()
//                }
//
//            } else {
//                let ac = UIAlertController(title: "Username cannot be empty", message: nil, preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//                if let popoverController = ac.popoverPresentationController {
//                    popoverController.sourceView = self.view
//                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
//                    popoverController.permittedArrowDirections = []
//                }
//
//                present(ac, animated: true, completion: {() -> Void in
//                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
//                    ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
//                })
//            }
//
//        default:
//            print("default")
//        }
//    }
//
//    @objc func keyboardWillHide() {
//        self.view.frame.origin.y = 0
//    }
//
//    @objc func keyboardWillChange(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if commentTextView.isFirstResponder {
//                let difference = keyboardSize.height - commentTextView.frame.origin.y + commentTextView.frame.size.height
//                self.view.frame.origin.y = -difference
////                self.view.frame.origin.y = -keyboardSize.height
//            }
//        }
//    }
//
//    func initializeHideKeyboard(){
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
//            target: self,
//            action: #selector(dismissMyKeyboard))
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissMyKeyboard(){
//        view.endEditing(true)
//    }
//}
//
//extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        guard let image = info[.editedImage] as? UIImage else { return }
//
//        let tempImageName = UUID().uuidString
//        imagePath = getDocumentsDirectory().appendingPathComponent(tempImageName)
//        if let jpegData = image.jpegData(compressionQuality: 0.8) {
//            try? jpegData.write(to: imagePath!)
//        }
//        imageName = tempImageName
//
//        let imageView = UIImageView(image: image)
//        imageView.image = imageView.image?.resizeImageWith(newSize: CGSize(width: 100, height: 100))
//        symbolButton.setImage(imageView.image, for: .normal)
//        symbolButton.imageView?.contentMode = .scaleAspectFill
//        symbolButton.imageView?.layer.borderColor = UIColor.black.cgColor
//        symbolButton.imageView?.layer.borderWidth = 2.0
//        symbolButton.imageView?.layer.cornerRadius = (symbolButton.imageView?.frame.width)! / 2
//        symbolButton.imageView?.layer.masksToBounds = true
//        symbolButton.alpha = 0
//
//        dismiss(animated: true, completion: nil)
//
//        UIView.animate(withDuration: 1.3, animations: {
//            self.symbolButton.alpha = 1
//        })
//    }
//
//    func openPhoto(action: UIAlertAction) {
//        let picker = UIImagePickerController()
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            picker.allowsEditing = true
//            picker.delegate = self
//            present(picker, animated: true)
//        } else {
//            let ac = UIAlertController(title: "Photo Library Not Available", message: nil, preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//            present(ac, animated: true)
//        }
//    }
//
//    func openCamera(action: UIAlertAction) {
//        let picker = UIImagePickerController()
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            picker.sourceType = .camera
//            picker.allowsEditing = true
//            picker.delegate = self
//            present(picker, animated: true)
//        } else {
//            let ac = UIAlertController(title: "Camera Not Available", message: nil, preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//            if let popoverController = ac.popoverPresentationController {
//                popoverController.sourceView = self.view
//                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
//                popoverController.permittedArrowDirections = []
//            }
//
//            present(ac, animated: true)
//        }
//    }
//}
//
//extension UIImage{
//    // resizing the profile into a circular shape
//    func resizeImageWith(newSize: CGSize) -> UIImage {
//
//        let horizontalRatio = newSize.width / size.width
//        let verticalRatio = newSize.height / size.height
//
//        let ratio = max(horizontalRatio, verticalRatio)
//        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
//        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
//        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
//}
//
//extension ProfileViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//    func loginPortal() {
//        let authorizationButton = ASAuthorizationAppleIDButton()
//        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//        self.stackView.addArrangedSubview(authorizationButton)
//    }
//
//    @objc func handleAuthorizationAppleIDButtonPress() {
//        let appleIDProvider = ASAuthorizationAppleIDProvider()
//        let request = appleIDProvider.createRequest()
//        request.requestedScopes = [.fullName, .email]
//
//        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//        authorizationController.delegate = self
//        authorizationController.presentationContextProvider = self
//        authorizationController.performRequests()
//    }
//
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//
//            // Create an account in your system.
//            let userIdentifier = appleIDCredential.user
//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//
//            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
////            self.saveUserInKeychain(userIdentifier)
//
//            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
////            self.showResultViewController(userIdentifier: userIdentifier, fullName: fullName, email: email)
//
//        case let passwordCredential as ASPasswordCredential:
//
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//
//            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
////                self.showPasswordCredentialAlert(username: username, password: password)
//            }
//
//        default:
//            break
//        }
//    }
//}
