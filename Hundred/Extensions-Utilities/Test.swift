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
//import Network
//import CloudKit
//import CoreSpotlight
//import MobileCoreServices
//
//enum Keychain: String {
//    case userIdentifier
//}
//
//class ProfileViewController: UIViewController {
//    var authorizationButton = ASAuthorizationAppleIDButton()
//    let usernameContainer = UIView()
//    let usernameLabel = UILabel()
//    let emailContainer = UIView()
//    let emailLabel = UILabel()
//    let resetButton = UIButton()
//
//    var isAuthenticated: Bool = false {
//        didSet {
//            if isAuthenticated == false {
//                DispatchQueue.main.async {
//                    self.usernameContainer.removeFromSuperview()
//                    self.emailContainer.removeFromSuperview()
//                    self.authorizationButton.addTarget(self, action: #selector(self.handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
//                    self.view.addSubview(self.authorizationButton)
//                    self.authorizationButton.translatesAutoresizingMaskIntoConstraints = false
//                    self.authorizationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//                    self.authorizationButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
//                    self.authorizationButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
//                    self.authorizationButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//                    self.authorizationButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
//                    
//                    self.resetButton.setTitle("Reset iCloud Keychain", for: .normal)
//                    self.resetButton.setTitleColor(UIColor.white, for: .normal)
//                    let buttonImage = UIImage(systemName: "key.icloud.fill")?.withRenderingMode(.alwaysTemplate)
//                    self.resetButton.setImage(buttonImage, for: .normal)
//                    self.resetButton.imageEdgeInsets.left = -10
//                    self.resetButton.tintColor = .white
//                    self.resetButton.backgroundColor = .darkGray
//                    self.resetButton.addTarget(self, action: #selector(self.resetKeychain), for: .touchUpInside)
//                    self.resetButton.layer.cornerRadius = 7
//                    self.view.addSubview(self.resetButton)
//                    self.resetButton.translatesAutoresizingMaskIntoConstraints = false
//                    self.resetButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//                    self.resetButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50).isActive = true
//                    self.resetButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50).isActive = true
//                    self.resetButton.topAnchor.constraint(equalTo: self.authorizationButton.bottomAnchor, constant: 20).isActive = true
//                }
//            } else {
//                authorizationButton.removeFromSuperview()
//                resetButton.removeFromSuperview()
//                view.addSubview(usernameContainer)
//                usernameContainer.translatesAutoresizingMaskIntoConstraints = false
//                usernameContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
//                usernameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//                usernameContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
//                
//                let borderColor = UIColor.gray
//                usernameContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
//                usernameContainer.layer.borderWidth = 0.8
//                usernameContainer.layer.cornerRadius = 7.0
//                
//                let titleLabel = UILabel()
//                titleLabel.text = "Username"
//                titleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
//                titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
//                titleLabel.textAlignment = .left
//                
//                usernameContainer.addSubview(titleLabel)
//                
//                titleLabel.translatesAutoresizingMaskIntoConstraints = false
//                titleLabel.widthAnchor.constraint(equalTo: usernameContainer.widthAnchor, multiplier: 0.9).isActive = true
//                titleLabel.centerXAnchor.constraint(equalTo: usernameContainer.centerXAnchor).isActive = true
//                titleLabel.topAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: 10).isActive = true
//                
//                usernameContainer.addSubview(usernameLabel)
//                
//                usernameLabel.backgroundColor = .clear
//                usernameLabel.numberOfLines = 0
//                usernameLabel.adjustsFontSizeToFitWidth = false
//                usernameLabel.lineBreakMode = .byTruncatingTail
//                usernameLabel.font = UIFont.preferredFont(forTextStyle: .body)
//                usernameLabel.translatesAutoresizingMaskIntoConstraints = false
//                usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
//                usernameLabel.widthAnchor.constraint(equalTo: usernameContainer.widthAnchor, multiplier: 0.8).isActive = true
//                usernameLabel.bottomAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: -30).isActive = true
//                usernameLabel.centerXAnchor.constraint(equalTo: usernameContainer.centerXAnchor).isActive = true
//                
//                view.addSubview(emailContainer)
//                emailContainer.translatesAutoresizingMaskIntoConstraints = false
//                emailContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
//                emailContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//                emailContainer.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 50).isActive = true
//                
//                emailContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
//                emailContainer.layer.borderWidth = 0.8
//                emailContainer.layer.cornerRadius = 7.0
//                
//                let emailTitleLabel = UILabel()
//                emailTitleLabel.text = "Email"
//                emailTitleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
//                emailTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
//                emailTitleLabel.textAlignment = .left
//                
//                emailContainer.addSubview(emailTitleLabel)
//                
//                emailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//                emailTitleLabel.widthAnchor.constraint(equalTo: emailContainer.widthAnchor, multiplier: 0.9).isActive = true
//                emailTitleLabel.centerXAnchor.constraint(equalTo: emailContainer.centerXAnchor).isActive = true
//                emailTitleLabel.topAnchor.constraint(equalTo: emailContainer.topAnchor, constant: 10).isActive = true
//                
//                emailContainer.addSubview(emailLabel)
//                
//                emailLabel.backgroundColor = .clear
//                emailLabel.numberOfLines = 0
//                emailLabel.adjustsFontSizeToFitWidth = false
//                emailLabel.lineBreakMode = .byTruncatingTail
//                emailLabel.font = UIFont.preferredFont(forTextStyle: .body)
//                emailLabel.translatesAutoresizingMaskIntoConstraints = false
//                emailLabel.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 30).isActive = true
//                emailLabel.widthAnchor.constraint(equalTo: emailContainer.widthAnchor, multiplier: 0.8).isActive = true
//                emailLabel.bottomAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: -30).isActive = true
//                emailLabel.centerXAnchor.constraint(equalTo: emailContainer.centerXAnchor).isActive = true
//            }
//        }
//    }
//        
//    var imageView: UIImageView = {
//        let imageView = UIImageView(frame: .zero)
//        imageView.image = UIImage(named: "mountain")
//        imageView.contentMode = .scaleToFill
//        imageView.alpha = 0
//        return imageView
//    }()
//
//    var monitor: NWPathMonitor!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        DispatchQueue.main.async {
//            self.view.insertSubview(self.imageView, at: 0)
//            self.imageView.pin(to: self.view)
//        }
//        
//        getCredentials { (profile) in
//            if let profile = profile {
//                self.isAuthenticated = true
//                self.usernameLabel.text = profile.username
//                self.emailLabel.text = profile.email
//            } else {
//                self.isAuthenticated = false
//            }
//        }
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upgrade", style: .plain, target: self, action: #selector(goToUpgrade))
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
//            self.imageView.alpha = 1
//        })
//    }
//    
//    @objc func goToUpgrade() {
//        if let vc = storyboard?.instantiateViewController(identifier: "parent") as? ParentViewController {
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//    
//    @objc func resetKeychain() {
//        let isSuccessful = KeychainWrapper.standard.removeObject(forKey: Keychain.userIdentifier.rawValue)
//        
//        let ac: UIAlertController
//        if isSuccessful == true {
//            ac = UIAlertController(title: "Successful!", message: nil, preferredStyle: .alert)
//        } else {
//            ac = UIAlertController(title: "Error", message: "Sorry, either the iCloud Keychain for this app is already empty or there was an error attempting to delete it.", preferredStyle: .alert)
//        }
//        
//        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        
//        if let popoverController = ac.popoverPresentationController {
//            popoverController.sourceView = self.view
//            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
//        }
//        
//        self.present(ac, animated: true)
//    }
//}
//
//extension ProfileViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
//    // 1. if the discoverability is authorized and the sign in goes through, create a new Profile entity, spotlight index, Keychain, and set isAuthorized to true
//    // 2. if the discoverabiliy is not granted, inform the choice to say yes again or decline. If declined, set isAuthorized to false
//    @objc func handleAuthorizationAppleIDButtonPress() {
//        CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (status, error) in
//            if error != nil {
//                self.permissionDeniedAlert(title: "Permission Error", message: "Sorry! There was an error checking for the permission status for your iCloud user discoverability. Please try again.")
//            } else {
//                self.processApplicationPermission(status: status)
//            }
//        }
//    }
//
//    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return self.view.window!
//    }
//    
//    func processApplicationPermission(status: CKContainer_Application_PermissionStatus) {
//        switch status {
//        case .granted:
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            let request = appleIDProvider.createRequest()
//            request.requestedScopes = [.fullName, .email]
//
//            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//            authorizationController.delegate = self
//            authorizationController.presentationContextProvider = self
//            authorizationController.performRequests()
//        case .couldNotComplete, .denied, .initialState:
//            DispatchQueue.main.async {
//                let ac = UIAlertController(title: "", message: "Your permission is required to obtain the unique record ID from your iCloud account. Please see the FAQ section for more information.", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "Go Back", style: .default, handler: {(_) in
//                    _ = self.navigationController?.popViewController(animated: true)
//                }))
//                
//                if let popoverController = ac.popoverPresentationController {
//                    popoverController.sourceView = self.view
//                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//                    popoverController.permittedArrowDirections = []
//                }
//                
//                self.present(ac, animated: true)
//            }
//        default:
//            self.isAuthenticated = false
//        }
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//        switch authorization.credential {
//        case let appleIDCredential as ASAuthorizationAppleIDCredential:
//            // since the permission to fetch the record ID is granted, use it to create Profile in Core Data, KeyChain, and Spotlight
//            CKContainer.default().fetchUserRecordID { (record, error) in
//                if error != nil {
//                    self.permissionDeniedAlert(title: "Error", message: "Sorry! There was an error fetching the Record ID of your iCloud account. Please try again")
//                }
//                
//                if let record = record {
//                    DispatchQueue.main.async {
//                        // Create an account in your system.
//                        let profile = Profile(context: self.context)
//                        if let fullName = appleIDCredential.fullName {
//                            if let givenName = fullName.givenName, let familyName = fullName.familyName {
//                                profile.username = "\(givenName) \(familyName)"
//                                self.usernameLabel.text = "\(givenName) \(familyName)"
//                            }
//                        }
//
//                        if let email = appleIDCredential.email {
//                            profile.email = email
//                            self.emailLabel.text = email
//                        }
//                        profile.userId = record.recordName
//                        
//                        let userIdentifier = appleIDCredential.user
//                        KeychainWrapper.standard.set(userIdentifier, forKey: Keychain.userIdentifier.rawValue)
//                        
//                        self.saveContext()
//                        
//                        // Core Spotlight indexing
//                        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
//                        attributeSet.title = self.usernameLabel.text
//                        attributeSet.contentCreationDate = Date()
//                        attributeSet.contentDescription = self.emailLabel.text
//                        
//                        let item = CSSearchableItem(uniqueIdentifier: self.emailLabel.text, domainIdentifier: "com.noName.Hundred", attributeSet: attributeSet)
//                        item.expirationDate = Date.distantFuture
//                        CSSearchableIndex.default().indexSearchableItems([item]) { (error) in
//                            if let error = error {
//                                print("Indexing error: \(error.localizedDescription)")
//                            } else {
//                                print("Search item for the new account successfully indexed")
//                            }
//                        }
//                        
//                        self.isAuthenticated = true
//                    }
//                }
//            }
//        case let passwordCredential as ASPasswordCredential:
//
//            // Sign in using an existing iCloud Keychain credential.
//            let username = passwordCredential.user
//            let password = passwordCredential.password
//            print("username from icloud keychain: \(username)")
//            print("password from icloud keychain: \(password)")
//        default:
//            break
//        }
//    }
//
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        let ac = UIAlertController(title: "Authorization Error", message: "Sorry! The authorization attempt with your Apple ID credential has failed. Please try again.", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//        if let popoverController = ac.popoverPresentationController {
//            popoverController.sourceView = self.view
//            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
//        }
//
//        present(ac, animated: true)
//        self.isAuthenticated = false
//        print("The authorization attempt with your Apple ID credential has failed. Please try again.")
//
//    }
//}



//
//  ProfileViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-15.
//  Copyright © 2020 J. All rights reserved.
//

//import UIKit
//import CloudKit
//import CoreSpotlight
//import MobileCoreServices
//
//class ProfileViewController: UIViewController {
//    let scrollView = UIScrollView()
//    let usernameContainer = UIView()
//    let usernameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "username"
//        label.font = UIFont.body.with(weight: .regular)
//        label.textColor = .gray
//        return label
//    }()
//    let emailContainer = UIView()
//    let emailLabel = UILabel()
//    lazy var imageButton = createButton(title: nil, image: "camera.circle", cornerRadius: 20, color:  .darkGray, size: 60, tag: 1, selector: #selector(buttonPressed))
//    let userTextField: CustomTextField = {
//        let textField = CustomTextField()
//        textField.placeholder = "Enter your username"
//        textField.textAlignment = .left
//        textField.autocapitalizationType = .none
//        textField.autocorrectionType = .no
//        BorderStyle.customShadowBorder(for: textField)
//        return textField
//    }()
//    let descContainer = UIView()
//    let descLabel: UILabel = {
//        let label = UILabel()
//        label.text = "description"
//        label.font = UIFont.body.with(weight: .regular)
//        label.textColor = .gray
//        return label
//    }()
//    lazy var descTextView: UITextView = {
//        let textView = UITextView()
//        textView.isEditable = true
//        textView.isSelectable = true
//        textView.isScrollEnabled = true
//        textView.font = UIFont.preferredFont(forTextStyle: .body)
//        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 15)
//        BorderStyle.customShadowBorder(for: textView)
//        return textView
//    }()
//
//    var isAuthenticated: Bool = false {
//        didSet {
//            if isAuthenticated == false {
//                usernameContainer.removeFromSuperview()
//                emailContainer.removeFromSuperview()
//
//                view.addSubview(imageButton)
//                imageButton.translatesAutoresizingMaskIntoConstraints = false
//                imageButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
//                imageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//                imageButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
//
//                view.addSubview(usernameContainer)
//                usernameContainer.translatesAutoresizingMaskIntoConstraints = false
//                usernameContainer.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 30).isActive = true
//                usernameContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
//                usernameContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
//                usernameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//                usernameContainer.addSubview(usernameLabel)
//                usernameLabel.translatesAutoresizingMaskIntoConstraints = false
//                usernameLabel.leadingAnchor.constraint(equalTo: usernameContainer.leadingAnchor).isActive = true
//
//                view.addSubview(userTextField)
//                userTextField.translatesAutoresizingMaskIntoConstraints = false
//                userTextField.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 5).isActive = true
//                userTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
//                userTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
//                userTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//                view.addSubview(descContainer)
//                descContainer.translatesAutoresizingMaskIntoConstraints = false
//                descContainer.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 30).isActive = true
//                descContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
//                descContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
//                descContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//
//                descContainer.addSubview(descLabel)
//                descLabel.translatesAutoresizingMaskIntoConstraints = false
//                descLabel.leadingAnchor.constraint(equalTo: descContainer.leadingAnchor).isActive = true
//
//                view.addSubview(descTextView)
//                descTextView.translatesAutoresizingMaskIntoConstraints = false
//                descTextView.topAnchor.constraint(equalTo: descContainer.bottomAnchor, constant: 5).isActive = true
//                descTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
//                descTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//                descTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//            } else {
//                view.addSubview(usernameContainer)
//                usernameContainer.translatesAutoresizingMaskIntoConstraints = false
//                usernameContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
//                usernameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//                usernameContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
//
//                let borderColor = UIColor.gray
//                usernameContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
//                usernameContainer.layer.borderWidth = 0.8
//                usernameContainer.layer.cornerRadius = 7.0
//
//                let titleLabel = UILabel()
//                titleLabel.text = "Username"
//                titleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
//                titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
//                titleLabel.textAlignment = .left
//
//                usernameContainer.addSubview(titleLabel)
//
//                titleLabel.translatesAutoresizingMaskIntoConstraints = false
//                titleLabel.widthAnchor.constraint(equalTo: usernameContainer.widthAnchor, multiplier: 0.9).isActive = true
//                titleLabel.centerXAnchor.constraint(equalTo: usernameContainer.centerXAnchor).isActive = true
//                titleLabel.topAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: 10).isActive = true
//
//                usernameContainer.addSubview(usernameLabel)
//
//                usernameLabel.backgroundColor = .clear
//                usernameLabel.numberOfLines = 0
//                usernameLabel.adjustsFontSizeToFitWidth = false
//                usernameLabel.lineBreakMode = .byTruncatingTail
//                usernameLabel.font = UIFont.preferredFont(forTextStyle: .body)
//                usernameLabel.translatesAutoresizingMaskIntoConstraints = false
//                usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
//                usernameLabel.widthAnchor.constraint(equalTo: usernameContainer.widthAnchor, multiplier: 0.8).isActive = true
//                usernameLabel.bottomAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: -30).isActive = true
//                usernameLabel.centerXAnchor.constraint(equalTo: usernameContainer.centerXAnchor).isActive = true
//
//                view.addSubview(emailContainer)
//                emailContainer.translatesAutoresizingMaskIntoConstraints = false
//                emailContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
//                emailContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//                emailContainer.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 50).isActive = true
//
//                emailContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
//                emailContainer.layer.borderWidth = 0.8
//                emailContainer.layer.cornerRadius = 7.0
//
//                let emailTitleLabel = UILabel()
//                emailTitleLabel.text = "Email"
//                emailTitleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
//                emailTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
//                emailTitleLabel.textAlignment = .left
//
//                emailContainer.addSubview(emailTitleLabel)
//
//                emailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//                emailTitleLabel.widthAnchor.constraint(equalTo: emailContainer.widthAnchor, multiplier: 0.9).isActive = true
//                emailTitleLabel.centerXAnchor.constraint(equalTo: emailContainer.centerXAnchor).isActive = true
//                emailTitleLabel.topAnchor.constraint(equalTo: emailContainer.topAnchor, constant: 10).isActive = true
//
//                emailContainer.addSubview(emailLabel)
//
//                emailLabel.backgroundColor = .clear
//                emailLabel.numberOfLines = 0
//                emailLabel.adjustsFontSizeToFitWidth = false
//                emailLabel.lineBreakMode = .byTruncatingTail
//                emailLabel.font = UIFont.preferredFont(forTextStyle: .body)
//                emailLabel.translatesAutoresizingMaskIntoConstraints = false
//                emailLabel.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 30).isActive = true
//                emailLabel.widthAnchor.constraint(equalTo: emailContainer.widthAnchor, multiplier: 0.8).isActive = true
//                emailLabel.bottomAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: -30).isActive = true
//                emailLabel.centerXAnchor.constraint(equalTo: emailContainer.centerXAnchor).isActive = true
//            }
//        }
//    }
//
//    var imageView: UIImageView = {
//        let imageView = UIImageView(frame: .zero)
//        imageView.image = UIImage(named: "mountain")
//        imageView.contentMode = .scaleToFill
//        imageView.alpha = 0
//        return imageView
//    }()
//
//    var firstResponder: UIView? /// To handle textField position when keyboard is visible.
//    var isKeyboardVisible = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        DispatchQueue.main.async {
//            self.view.insertSubview(self.imageView, at: 0)
//            self.imageView.pin(to: self.view)
//        }
//
//        initializeHideKeyboard()
//
////        getCredentials { (profile) in
////            if let profile = profile {
////                self.isAuthenticated = true
////                self.usernameLabel.text = profile.username
////                self.emailLabel.text = profile.email
////            } else {
////                self.isAuthenticated = false
////            }
////        }
//        self.isAuthenticated = false
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upgrade", style: .plain, target: self, action: #selector(goToUpgrade))
//
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(keyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        notificationCenter.addObserver(self, selector: #selector(keyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
//            self.imageView.alpha = 1
//        })
//    }
//
//    @objc func goToUpgrade() {
//        if let vc = storyboard?.instantiateViewController(identifier: "parent") as? ParentViewController {
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//
//    @objc func buttonPressed(sender: UIButton!) {
//
//    }
//
//    @objc
//    fileprivate func keyboardNotification(_ notification: Notification) {
//
//        self.isKeyboardVisible.toggle()
//
//        if notification.name == UIResponder.keyboardWillShowNotification {
//            guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//
//            let keyboardFrame = keyboardValue.cgRectValue
//
//            // Note that textView delegate gets called later that keyboard notification unlike TextFields.
//            // So if firstResponder variable is nil it means our textView is firstRespnder.
//            if let textField = self.firstResponder ?? self.textView {
//                let textFieldPoints = textField.convert(textField.frame.origin, to: self.view.window)
//                let textFieldRect   = textField.convert(textField.frame, to: self.view.window)
//
//                let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height + textField.frame.height, right: 0)
//
//                self.scrollView.contentInset = contentInset
//                self.scrollView.scrollIndicatorInsets = contentInset
//
//                // visible part of the view, where is not covered by the keyboard.
//                var windowFrame = self.view.frame
//                windowFrame.size.height -= keyboardFrame.height
//
//                // if you don't see the firstResponder view in visible part, means the view is beneth the keyboard.
//                if !windowFrame.contains(textFieldPoints) {
//                    self.scrollView.scrollRectToVisible(textFieldRect, animated: true)
//                }
//            }
//        }
//
//        if notification.name == UIResponder.keyboardWillHideNotification {
//            self.scrollView.contentInset = .zero
//            self.scrollView.scrollIndicatorInsets = .zero
//        }
//    }
//}
//
//extension ProfileViewController: UITextFieldDelegate {
//
//    // MARK: TextField Delegate
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.firstResponder = textField // We set the firstResponder variable to active textField,
//        // This then will be handled in keyboardNotification()
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        self.firstResponder = nil
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//}
