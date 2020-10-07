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
        controller.delegate = self
        return controller
    }()
    
    fileprivate lazy var showProfile: ShowProfile = {
        let identifier = ViewControllerIdentifiers.showProfile
        guard let controller = storyboard?.instantiateViewController(withIdentifier: identifier) as? ShowProfile
            else { fatalError("\(Messages.unableToInstantiatePurchases)") }
        controller.delegate = self
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurUI()
        processFetch()
    }
    
    func configurUI() {
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
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
                                     viewController.view.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
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
    fileprivate func processFetch() {
        if let profile = fetchProfile() {
            isProfileCreated = true
            showProfile.profile = profile
        } else {
            isProfileCreated = false
        }
    }
}

extension ProfileViewController: CreateProfileProtocol {
    func runFetchProfile() {
        processFetch()
    }
}
