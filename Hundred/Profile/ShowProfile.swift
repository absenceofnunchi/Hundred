//
//  ShowProfile.swift
//  Hundred
//
//  Created by J C on 2020-09-30.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class ShowProfile: ProfileBaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    fileprivate var profileImageView = UIImageView()
    fileprivate var noImage = UIView()
    fileprivate let titleLabel = UILabel()
    fileprivate let descTitleLabel = UILabel()
    fileprivate let borderColor = UIColor.gray
    var profile: Profile! {
        didSet {
            if let image = profile?.image, image != "" {
                print("image: \(image)")
                let imagePath = getDocumentsDirectory().appendingPathComponent(image)
                if let data = try? Data(contentsOf: imagePath) {
                    profileImageView.image = UIImage(data: data)
                    profileImageView.layer.borderWidth = 1.0
                }
            } else {
                let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular, scale: .medium)
                let uiImage = UIImage(systemName: "camera.circle", withConfiguration: config)
                profileImageView.image = uiImage
                profileImageView.tintColor = .black
                profileImageView.contentMode = .scaleAspectFit
                profileImageView.layer.borderWidth = 0
            }
            usernameLabel.text = profile?.username
            descLabel.text = profile?.detail ?? ""
        }
    }
    fileprivate let buttonContainer = UIView()
    fileprivate let editButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large)
        let editImage = UIImage(systemName: "pencil.circle", withConfiguration: config)
        button.setImage(editImage, for: .normal)
        button.tintColor = .systemBlue
        button.tag = 1
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    fileprivate let deleteButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium, scale: .large)
        let deleteImage = UIImage(systemName: "trash.circle", withConfiguration: config)
        button.setImage(deleteImage, for: .normal)
        button.tintColor = .systemRed
        button.tag = 2
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    var delegate: CreateProfileProtocol? = nil
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: 900)

        profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.layer.masksToBounds = false
        profileImageView.clipsToBounds = true
        scrollView.addSubview(profileImageView)
        
        usernameContainer = UIView()
        usernameContainer.backgroundColor = .white
        usernameContainer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 7.0, opacity: 0.35, bgColor: UIColor.white)
        usernameContainer.layer.cornerRadius = 7.0
        scrollView.addSubview(usernameContainer)
        
        titleLabel.text = "Username"
        titleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.textAlignment = .left
        usernameContainer.addSubview(titleLabel)
        
        usernameLabel = UILabel()
        usernameLabel.backgroundColor = .clear
        usernameLabel.numberOfLines = 0
        usernameLabel.adjustsFontSizeToFitWidth = false
        usernameLabel.lineBreakMode = .byTruncatingTail
        usernameLabel.font = UIFont.preferredFont(forTextStyle: .body)
        usernameContainer.addSubview(usernameLabel)
        
        descContainer = UIView()
        descContainer.backgroundColor = .white
        descContainer.addShadow(offset: CGSize.init(width: 0, height: 3), color: UIColor.black, radius: 7.0, opacity: 0.35, bgColor: UIColor.white)
        descContainer.layer.cornerRadius = 7.0
        scrollView.addSubview(descContainer)
        descContainer.layoutIfNeeded()
        
        descTitleLabel.text = "Description"
        descTitleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        descTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        descTitleLabel.textAlignment = .left
        descContainer.addSubview(descTitleLabel)
        
        descLabel = UILabel()
        descLabel.backgroundColor = .clear
        descLabel.numberOfLines = 0
        descLabel.adjustsFontSizeToFitWidth = false
        descLabel.lineBreakMode = .byTruncatingTail
        descLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descContainer.addSubview(descLabel)
        
        scrollView.addSubview(buttonContainer)
        buttonContainer.addSubview(editButton)
        buttonContainer.addSubview(deleteButton)
    }
    
    func setConstraints() {
        scrollView.pin(to: view)

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true

        usernameContainer.translatesAutoresizingMaskIntoConstraints = false
        usernameContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        usernameContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        usernameContainer.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.widthAnchor.constraint(equalTo: usernameContainer.widthAnchor, multiplier: 0.9).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: usernameContainer.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: usernameContainer.topAnchor, constant: 10).isActive = true
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        usernameLabel.widthAnchor.constraint(equalTo: usernameContainer.widthAnchor, multiplier: 0.8).isActive = true
        usernameLabel.bottomAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: -30).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: usernameContainer.centerXAnchor).isActive = true
     
        descTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        descTitleLabel.widthAnchor.constraint(equalTo: descContainer.widthAnchor, multiplier: 0.9).isActive = true
        descTitleLabel.centerXAnchor.constraint(equalTo: descContainer.centerXAnchor).isActive = true
        descTitleLabel.topAnchor.constraint(equalTo: descContainer.topAnchor, constant: 10).isActive = true
        
        descContainer.translatesAutoresizingMaskIntoConstraints = false
        descContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        descContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        descContainer.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 50).isActive = true
     
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.topAnchor.constraint(equalTo: descTitleLabel.bottomAnchor, constant: 30).isActive = true
        descLabel.widthAnchor.constraint(equalTo: descContainer.widthAnchor, multiplier: 0.8).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: descContainer.bottomAnchor, constant: -30).isActive = true
        descLabel.centerXAnchor.constraint(equalTo: descContainer.centerXAnchor).isActive = true
        
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.topAnchor.constraint(equalTo: descContainer.bottomAnchor, constant: 50).isActive = true
        buttonContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.40).isActive = true
        buttonContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor).isActive = true
        
    }
    
    @objc
    func buttonPressed(sender: UIButton!) {
        switch sender.tag {
        case 1:
            if let vc = storyboard?.instantiateViewController(identifier: "editProfile") as? EditProfile {
                vc.profile = profile
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            let ac = UIAlertController(title: Messages.delete, message: Messages.deleteProfile, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: Messages.okButton, style: .default, handler: { (_) in
                if let profile = self.profile {
                    self.context.delete(profile)
                    self.saveContext()
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }))
            ac.addAction(UIAlertAction(title: Messages.cancel, style: .cancel, handler: nil))
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            present(ac, animated: true)
        default:
            print("default")
        }
    }
}

extension ShowProfile: PassProfileProtocol {
    func passProfile(profile: Profile) {
        self.profile = profile
    }
}


//noImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//noImage.layer.cornerRadius = noImage.frame.size.width / 2
//noImage.clipsToBounds = true
//noImage.layer.borderColor = UIColor.black.cgColor
//noImage.layer.borderWidth = 2.0
//scrollView.addSubview(noImage)
//
//let noImageLabel = UILabel()
//noImageLabel.text = "No Image"
//noImageLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//noImageLabel.textAlignment = .center
//noImage.addSubview(noImageLabel)
