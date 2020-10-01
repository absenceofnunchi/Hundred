//
//  ProfileViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-15.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class ProfileViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    fileprivate lazy var createProfile: CreateProfile = {
        let identifier = ViewControllerIdentifiers.createProfile
        guard let controller = storyboard?.instantiateViewController(withIdentifier: identifier) as? CreateProfile
            else { fatalError("\(Messages.unableToInstantiateProducts)") }
        return controller
    }()
    
    fileprivate lazy var showProfile: ShowProfile = {
        let identifier = ViewControllerIdentifiers.showProfile
        guard let controller = storyboard?.instantiateViewController(withIdentifier: identifier) as? ShowProfile
            else { fatalError("\(Messages.unableToInstantiatePurchases)") }
        return controller
    }()
    
    fileprivate var utility = Utilities()
    
    fileprivate var isProfileCreated: Bool = false {
        didSet {
            if isProfileCreated == true {
                removeBaseViewController(createProfile)
                addBaseViewController(showProfile)
            } else {
                removeBaseViewController(showProfile)
                addBaseViewController(createProfile)
            }
        }
    }

    var firstResponder: UIView? /// To handle textField position when keyboard is visible.
    var isKeyboardVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        getCredentials { (profile) in
//            if let profile = profile {
//                self.isAuthenticated = true
//                self.usernameLabel.text = profile.username
//                self.emailLabel.text = profile.email
//            } else {
//                self.isAuthenticated = false
//            }
//        }
//        fetchProfile()
        isProfileCreated = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Upgrade", style: .plain, target: self, action: #selector(goToUpgrade))
    }
    
    @objc func goToUpgrade() {
        if let vc = storyboard?.instantiateViewController(identifier: "parent") as? ParentViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Switching Between View Controllers
    
    /// Adds a child view controller to the container.
    fileprivate func addBaseViewController(_ viewController: ProfileBaseViewController) {
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.frame = containerView.bounds
        containerView.addSubview(viewController.view)
        
        NSLayoutConstraint.activate([viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
                                     viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                                     viewController.view.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
                                     viewController.view.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor)])
        viewController.didMove(toParent: self)
    }
    
    /// Removes a child view controller from the container.
    fileprivate func removeBaseViewController(_ viewController: ProfileBaseViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    // MARK: - Fetch Profile
    
    /// Gets an existing profile from Core Data if there is one
    fileprivate func fetchProfile() {
        let request = NSFetchRequest<Profile>(entityName: "Profile")
        do {
            let results = try self.context.fetch(request)
            if results.count > 0 {
                isProfileCreated = true
                print("results--------------------: \(results)")
            } else {
                print("isProfileCreated false")
                isProfileCreated = false
            }
        } catch {
            let ac = UIAlertController(title: "Error", message: Messages.fetchError, preferredStyle: .alert)
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                _ = self.navigationController?.popViewController(animated: true)
            }))
            
            present(ac, animated: true)
        }
    }
}


// newVC filter
// newVC new public cloud post
// editentry
