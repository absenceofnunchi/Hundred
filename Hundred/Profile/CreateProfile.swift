//
//  CreateProfile.swift
//  Hundred
//
//  Created by J C on 2020-09-30.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class CreateProfile: ProfileBaseViewController {
    let scrollView = UIScrollView()
    lazy var imageButton = createButton(title: nil, image: "camera.circle", cornerRadius: 20, color:  .darkGray, size: 60, tag: 1, selector: #selector(buttonPressed))
    let userTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Enter your username"
        textField.textAlignment = .left
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        BorderStyle.customShadowBorder(for: textField)
        return textField
    }()
    lazy var descTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 15)
        BorderStyle.customShadowBorder(for: textView)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()
        initializeHideKeyboard()
    }
    
    func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageButton)
        
        usernameContainer = UIView()
        scrollView.addSubview(usernameContainer)
        
        usernameLabel = UILabel()
        usernameLabel.text = "username"
        usernameLabel.font = UIFont.body.with(weight: .regular)
        usernameLabel.textColor = .gray
        usernameContainer.addSubview(usernameLabel)
        scrollView.addSubview(userTextField)
        
        descContainer = UIView()
        scrollView.addSubview(descContainer)
        
        descLabel = UILabel()
        descLabel.text = "description"
        descLabel.font = UIFont.body.with(weight: .regular)
        descLabel.textColor = .gray
        descContainer.addSubview(descLabel)
        scrollView.addSubview(descTextView)
    }
    
    func setConstraints() {
        scrollView.pin(to: view)
        
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        imageButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        imageButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 50).isActive = true
        
        usernameContainer.translatesAutoresizingMaskIntoConstraints = false
        usernameContainer.topAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 30).isActive = true
        usernameContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        usernameContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        usernameContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leadingAnchor.constraint(equalTo: usernameContainer.leadingAnchor).isActive = true
        
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        userTextField.topAnchor.constraint(equalTo: usernameContainer.bottomAnchor, constant: 5).isActive = true
        userTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        userTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        descContainer.translatesAutoresizingMaskIntoConstraints = false
        descContainer.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 30).isActive = true
        descContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        descContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        descContainer.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.leadingAnchor.constraint(equalTo: descContainer.leadingAnchor).isActive = true
        
        descTextView.translatesAutoresizingMaskIntoConstraints = false
        descTextView.topAnchor.constraint(equalTo: descContainer.bottomAnchor, constant: 5).isActive = true
        descTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.80).isActive = true
        descTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        descTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    }
    
    @objc func buttonPressed(sender: UIButton!) {
        
    }
    

}
