//
//  ProfileViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-15.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import AuthenticationServices
import Network
import CloudKit
import CoreSpotlight
import MobileCoreServices

enum Keychain: String {
    case userIdentifier
}

class ProfileViewController: UIViewController {
    var authorizationButton = ASAuthorizationAppleIDButton()
    let usernameContainer = UIView()
    let usernameLabel = UILabel()
    let emailContainer = UIView()
    let emailLabel = UILabel()

    var isAuthenticated: Bool = false {
        didSet {
            if isAuthenticated == false {
                DispatchQueue.main.async {
                    self.usernameContainer.removeFromSuperview()
                    self.emailContainer.removeFromSuperview()
                    self.authorizationButton.addTarget(self, action: #selector(self.handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
                    self.view.addSubview(self.authorizationButton)
                    self.authorizationButton.translatesAutoresizingMaskIntoConstraints = false
                    self.authorizationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                    self.authorizationButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.80).isActive = true
                    self.authorizationButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
                    self.authorizationButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100).isActive = true
                }
            } else {
                authorizationButton.removeFromSuperview()
                view.addSubview(usernameContainer)
                usernameContainer.translatesAutoresizingMaskIntoConstraints = false
                usernameContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
                usernameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                usernameContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
                
                let borderColor = UIColor.gray
                usernameContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
                usernameContainer.layer.borderWidth = 0.8
                usernameContainer.layer.cornerRadius = 7.0
                
                let titleLabel = UILabel()
                titleLabel.text = "Username"
                titleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
                titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
                titleLabel.textAlignment = .left
                
                usernameContainer.addSubview(titleLabel)
                
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.widthAnchor.constraint(equalTo: usernameContainer.widthAnchor, multiplier: 0.9).isActive = true
                titleLabel.centerXAnchor.constraint(equalTo: usernameContainer.centerXAnchor).isActive = true
                titleLabel.topAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: 10).isActive = true
                
                usernameContainer.addSubview(usernameLabel)
                
                usernameLabel.backgroundColor = .clear
                usernameLabel.numberOfLines = 0
                usernameLabel.adjustsFontSizeToFitWidth = false
                usernameLabel.lineBreakMode = .byTruncatingTail
                usernameLabel.font = UIFont.preferredFont(forTextStyle: .body)
                usernameLabel.translatesAutoresizingMaskIntoConstraints = false
                usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
                usernameLabel.widthAnchor.constraint(equalTo: usernameContainer.widthAnchor, multiplier: 0.8).isActive = true
                usernameLabel.bottomAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: -30).isActive = true
                usernameLabel.centerXAnchor.constraint(equalTo: usernameContainer.centerXAnchor).isActive = true
                
                view.addSubview(emailContainer)
                emailContainer.translatesAutoresizingMaskIntoConstraints = false
                emailContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
                emailContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                emailContainer.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 50).isActive = true
                
                emailContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
                emailContainer.layer.borderWidth = 0.8
                emailContainer.layer.cornerRadius = 7.0
                
                let emailTitleLabel = UILabel()
                emailTitleLabel.text = "Email"
                emailTitleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
                emailTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
                emailTitleLabel.textAlignment = .left
                
                emailContainer.addSubview(emailTitleLabel)
                
                emailTitleLabel.translatesAutoresizingMaskIntoConstraints = false
                emailTitleLabel.widthAnchor.constraint(equalTo: emailContainer.widthAnchor, multiplier: 0.9).isActive = true
                emailTitleLabel.centerXAnchor.constraint(equalTo: emailContainer.centerXAnchor).isActive = true
                emailTitleLabel.topAnchor.constraint(equalTo: emailContainer.topAnchor, constant: 10).isActive = true
                
                emailContainer.addSubview(emailLabel)
                
                emailLabel.backgroundColor = .clear
                emailLabel.numberOfLines = 0
                emailLabel.adjustsFontSizeToFitWidth = false
                emailLabel.lineBreakMode = .byTruncatingTail
                emailLabel.font = UIFont.preferredFont(forTextStyle: .body)
                emailLabel.translatesAutoresizingMaskIntoConstraints = false
                emailLabel.topAnchor.constraint(equalTo: emailTitleLabel.bottomAnchor, constant: 30).isActive = true
                emailLabel.widthAnchor.constraint(equalTo: emailContainer.widthAnchor, multiplier: 0.8).isActive = true
                emailLabel.bottomAnchor.constraint(equalTo: emailContainer.bottomAnchor, constant: -30).isActive = true
                emailLabel.centerXAnchor.constraint(equalTo: emailContainer.centerXAnchor).isActive = true
            }
        }
    }
        
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "mountain")
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0
        return imageView
    }()

    var monitor: NWPathMonitor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.view.insertSubview(self.imageView, at: 0)
            self.imageView.pin(to: self.view)
        }
        
        getCredentials { (profile) in
            if let profile = profile {
                self.isAuthenticated = true
                self.usernameLabel.text = profile.username
                self.emailLabel.text = profile.email
            } else {
                self.isAuthenticated = false
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
            self.imageView.alpha = 1
        })
    }
}

extension ProfileViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    // 1. if the discoverability is authorized and the sign in goes through, create a new Profile entity, spotlight index, Keychain, and set isAuthorized to true
    // 2. if the discoverabiliy is not granted, inform the choice to say yes again or decline. If declined, set isAuthorized to false
    @objc func handleAuthorizationAppleIDButtonPress() {
        CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (status, error) in
            if error != nil {
                self.permissionDeniedAlert(title: "Permission Error", message: "Sorry! There was an error checking for the permission status for your iCloud user discoverability. Please try again.")
            } else {
                self.processApplicationPermission(status: status)
            }
        }
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func processApplicationPermission(status: CKContainer_Application_PermissionStatus) {
        switch status {
        case .granted:
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        case .couldNotComplete, .denied, .initialState:
            DispatchQueue.main.async {
                let ac = UIAlertController(title: "", message: "Sorry! You permission is required to obtain the unique record ID from your iCloud account.  You are not required to display the iCloud email or your name on the Public Feed and can be changed to your preference. Please see the FAQ section for more information.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
                    // ask for the permission again since the user has been informed of the need and is OK with it
                    CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
                        // recursive to ensure the integrity
                        self.processApplicationPermission(status: status)
                    }
                }))
                
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    // the user doesn't want to grant the permission so go back to showing the Apple Sign in button
                    self.isAuthenticated = false
                }))
                
                if let popoverController = ac.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                
                self.present(ac, animated: true)
            }
        default:
            self.isAuthenticated = false
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // since the permission to fetch the record ID is granted, use it to create Profile in Core Data, KeyChain, and Spotlight
            CKContainer.default().fetchUserRecordID { (record, error) in
                if error != nil {
                    self.permissionDeniedAlert(title: "Error", message: "Sorry! There was an error fetching the Record ID of your iCloud account. Please try again")
                }
                
                if let record = record {
                    DispatchQueue.main.async {
                        // Create an account in your system.
                        let profile = Profile(context: self.context)
                        if let fullName = appleIDCredential.fullName {
                            if let givenName = fullName.givenName, let familyName = fullName.familyName {
                                profile.username = "\(givenName) \(familyName)"
                                self.usernameLabel.text = "\(givenName) \(familyName)"
                            }
                        }

                        if let email = appleIDCredential.email {
                            profile.email = email
                            self.emailLabel.text = email
                        }
                        profile.userId = record.recordName
                        
                        let userIdentifier = appleIDCredential.user
                        KeychainWrapper.standard.set(userIdentifier, forKey: Keychain.userIdentifier.rawValue)
                        
                        self.saveContext()
                        
                        // Core Spotlight indexing
                        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
                        attributeSet.title = self.usernameLabel.text
                        attributeSet.contentCreationDate = Date()
                        attributeSet.contentDescription = self.emailLabel.text
                        
                        let item = CSSearchableItem(uniqueIdentifier: self.emailLabel.text, domainIdentifier: "com.noName.Hundred", attributeSet: attributeSet)
                        item.expirationDate = Date.distantFuture
                        CSSearchableIndex.default().indexSearchableItems([item]) { (error) in
                            if let error = error {
                                print("Indexing error: \(error.localizedDescription)")
                            } else {
                                print("Search item for the new account successfully indexed")
                            }
                        }
                        
                        self.isAuthenticated = true
                    }
                }
            }
        case let passwordCredential as ASPasswordCredential:

            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("username from icloud keychain: \(username)")
            print("password from icloud keychain: \(password)")
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let ac = UIAlertController(title: "Authorization Error", message: "Sorry! The authorization attempt with your Apple ID credential has failed. Please try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(ac, animated: true)
        self.isAuthenticated = false
        print("The authorization attempt with your Apple ID credential has failed. Please try again.")

    }
}
