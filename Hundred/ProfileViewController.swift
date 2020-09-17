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

enum Keychain: String {
    case userIdentifier
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var isAuthenticated: Profile?
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 25, bottom: 5, trailing: 25)
        scrollView.addSubview(stackView)
        stackView.pin(to: scrollView)
        return stackView
    }()
    
    var authorizationButton: ASAuthorizationAppleIDButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCredentials()
    }
    
    func setConstraints() {
        authorizationButton.translatesAutoresizingMaskIntoConstraints = false
        authorizationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension ProfileViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func getCredentials() {
        // without checking for the internet access, the credential state will return .revoked or .notFound resulting in the deletion of the user identifier in Keychain
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let currentUserIdentifier = KeychainWrapper.standard.string(forKey: Keychain.userIdentifier.rawValue)

                appleIDProvider.getCredentialState(forUserID: currentUserIdentifier ?? "") { (credentialState, error) in
                    switch credentialState {
                    case .authorized:
                        
                        break // The Apple ID credential is valid.
                    case .revoked, .notFound:
                        // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                        KeychainWrapper.standard.removeObject(forKey: Keychain.userIdentifier.rawValue)
                        
                        DispatchQueue.main.async {
                            self.loginPortal()
                            self.setConstraints()
                        }
                    default:
                        break
                    }
                }
                
                
                
            } else {
                    let ac = UIAlertController(title: "Network Error", message: "You're currently not connected to the Internet. This section requires an Internet access.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
            
                    if let popoverController = ac.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
            
                self.present(ac, animated: true)
            }
        }
    }
    
    func loginPortal() {
        authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.stackView.addArrangedSubview(authorizationButton)
    }
    
    @objc func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            KeychainWrapper.standard.set(userIdentifier, forKey: Keychain.userIdentifier.rawValue)
            print("fullName: \(fullName)")
            print("email: \(email)")
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("username: \(username)")
            print("password: \(password)")
            // For the purpose of this demo app, show the password credential as an alert.
//            DispatchQueue.main.async {
//
//            }
            
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        let ac = UIAlertController(title: "Authorization Error", message: "The authorization attempt with your Apple ID credential has failed. Please try again.", preferredStyle: .alert)
//        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//
//        if let popoverController = ac.popoverPresentationController {
//            popoverController.sourceView = self.view
//            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
//        }
//
//        present(ac, animated: true)
        
    }
}
