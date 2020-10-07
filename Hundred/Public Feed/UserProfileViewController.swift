//
//  UserProfileViewController.swift
//  Hundred
//
//  Created by J C on 2020-10-05.
//  Copyright © 2020 J. All rights reserved.
//

/*
 Abstract:
 A screen to display the user's profile on Public Feed
 It consists of the user's profile image, bio, and the history of the user's posts
 */

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    var username: String!
    var detail: String?
    var userId: String!
    var image: UIImage?
    fileprivate var imageView: UIImageView!
    fileprivate var detailLabel: UILabel!
    fileprivate var detailContainer: UIView!
    fileprivate var detailTextView: UITextView!
    lazy fileprivate var vc: HistoryTableViewController = {
        guard let vc = storyboard?.instantiateViewController(identifier: ViewControllerIdentifiers.history) as? HistoryTableViewController
            else { fatalError("\(Messages.unableToInstantiateProducts)") }
        vc.userId = userId
        return vc
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableVC()
        setConstraints()
    }
    
    // MARK: - Configure UI
    
    func configureUI() {
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        // display user's profile image
        if let image = image {
            imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
            imageView.image = image
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.layer.cornerRadius = imageView.frame.size.height / 2
            imageView.layer.masksToBounds = false
            imageView.clipsToBounds = true
            scrollView.addSubview(imageView)
        } else {
            // if none, show a default image
            imageView = UIImageView()
            let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular, scale: .medium)
            let uiImage = UIImage(systemName: "person.circle", withConfiguration: config)
            imageView.image = uiImage
            imageView.tintColor = .black
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
        }
        
        // personal bio title label
        detailLabel = UILabel()
        detailLabel.text = "Bio"
        detailLabel.textAlignment = .center
        detailLabel.font = UIFont.body.with(weight: .bold)
        detailLabel.textColor = .gray
        scrollView.addSubview(detailLabel)
        
        // bio container as in inset + shadow
        detailContainer = UIView()
        BorderStyle.customShadowBorder(for: detailContainer)
        scrollView.addSubview(detailContainer)
        
        // personal bio
        detailTextView = UITextView()
        detailTextView.isEditable = false
        detailTextView.font = UIFont.body
        detailTextView.isScrollEnabled = true
        detailTextView.clipsToBounds = true
        detailTextView.text = detail ?? "User has no bio"
        detailContainer.addSubview(detailTextView)
    }
    
    // MARK: - Configure Table VC
    
    /// Table view in containment to display the user's post history
    func configureTableVC() {
        addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
        NSLayoutConstraint.activate([vc.view.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor),
                                     vc.view.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor),
                                     vc.view.leadingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.leadingAnchor),
                                     vc.view.trailingAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.trailingAnchor)])
        vc.didMove(toParent: self)
    }
    
    // MARK: - Set Constraints

    func setConstraints() {
        // image for the profile
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        // user detail title label
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40).isActive = true
        detailLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        detailLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        // user detail container for detailTextView
        detailContainer.translatesAutoresizingMaskIntoConstraints = false
        detailContainer.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 20).isActive = true
        detailContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.90).isActive = true
        detailContainer.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -40).isActive = true
        detailContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true

        // user detail
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        detailTextView.topAnchor.constraint(equalTo: detailContainer.topAnchor, constant: 5).isActive = true
        detailTextView.widthAnchor.constraint(equalTo: detailContainer.widthAnchor, multiplier: 0.90).isActive = true
        detailTextView.centerXAnchor.constraint(equalTo: detailContainer.centerXAnchor).isActive = true
        detailTextView.bottomAnchor.constraint(equalTo: detailContainer.bottomAnchor).isActive = true
    }
}
