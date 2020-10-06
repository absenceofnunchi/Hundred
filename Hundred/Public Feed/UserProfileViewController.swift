//
//  UserProfileViewController.swift
//  Hundred
//
//  Created by J C on 2020-10-05.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    var username: String!
    var detail: String?
    var userId: String!
    var image: UIImage?
    var imageView: UIImageView!
    var detailLabel: UILabel!
    var detailTextView: UITextView!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTableVC()
        setConstraints()
    }
    
    func configureUI() {
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
        detailLabel.textAlignment = .left
        detailLabel.font = UIFont.caption.with(weight: .bold)
        detailLabel.textColor = .gray
        scrollView.addSubview(detailLabel)
        
        // personal bio
        detailTextView = UITextView()
        detailTextView.isEditable = false
        detailTextView.font = UIFont.body
        BorderStyle.customShadowBorder(for: detailTextView)
//        detailTextView.layer.borderWidth = 1
//        detailTextView.layer.cornerRadius = 7
//        detailTextView.layer.borderColor = UIColor.lightGray.cgColor
        detailTextView.text = detail ?? "User has no bio"
        scrollView.addSubview(detailTextView)
    }
    
    func configureTableVC() {        
        guard let vc = storyboard?.instantiateViewController(identifier: ViewControllerIdentifiers.history) as? HistoryTableViewController
            else { fatalError("\(Messages.unableToInstantiateProducts)") }
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
        
        // user detail
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        detailTextView.topAnchor.constraint(equalTo: detailLabel.bottomAnchor, constant: 5).isActive = true
        detailTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        detailTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        detailTextView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -40).isActive = true
    }
    
}
