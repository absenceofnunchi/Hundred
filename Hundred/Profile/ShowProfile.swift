//
//  ShowProfile.swift
//  Hundred
//
//  Created by J C on 2020-09-30.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class ShowProfile: ProfileBaseViewController {
    let titleLabel = UILabel()
    let descTitleLabel = UILabel()
    let borderColor = UIColor.gray
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        usernameContainer = UIView()
        usernameContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        usernameContainer.layer.borderWidth = 0.8
        usernameContainer.layer.cornerRadius = 7.0
        view.addSubview(usernameContainer)
        
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
        descContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        descContainer.layer.borderWidth = 0.8
        descContainer.layer.cornerRadius = 7.0
        view.addSubview(descContainer)
        

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
    }
    
    func setConstraints() {
        usernameContainer.translatesAutoresizingMaskIntoConstraints = false
        usernameContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        usernameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200).isActive = true
        
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
        descContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.80).isActive = true
        descContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descContainer.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 50).isActive = true
     
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.topAnchor.constraint(equalTo: descTitleLabel.bottomAnchor, constant: 30).isActive = true
        descLabel.widthAnchor.constraint(equalTo: descContainer.widthAnchor, multiplier: 0.8).isActive = true
        descLabel.bottomAnchor.constraint(equalTo: descContainer.bottomAnchor, constant: -30).isActive = true
        descLabel.centerXAnchor.constraint(equalTo: descContainer.centerXAnchor).isActive = true
    }
}
