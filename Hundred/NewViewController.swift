//
//  NewViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-16.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 25, bottom: 0, trailing: 25)
        scrollView.addSubview(stackView)
        return stackView
    }()
    
    var goalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Goal Title"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    var goalButton: UIButton!
    
    var commentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.isSelectable = true
        textView.isScrollEnabled = true
        textView.text = "Comment"
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = UIColor.lightGray
        
        let borderColor = UIColor.gray
        textView.layer.borderColor = borderColor.withAlphaComponent(0.4).cgColor
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.clipsToBounds = false
        return textView
    }()
    
//    var plusButton: UIButton = {
//        let pButton = UIButton()
//        //        pButton.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
//        pButton.setTitle("Testing", for: .normal)
//        pButton.tintColor = UIColor(red: 0, green: 0, blue: 255/255, alpha: 1.0)
//        //        pButton.frame = CGRect(x: pButton.frame.size.width + 60, y: 0, width: 60, height: 60)
//        pButton.frame.size.height = 60
//        pButton.frame.size.width = 60
//        return pButton
//    }()
    var plusButton: UIButton!
    
    lazy var metricPanel: UIView = {
        let metricView = UIView()
        metricView.addSubview(plusButton)
        metricView.backgroundColor = .cyan
        return metricView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextView.delegate = self
        initializeHideKeyboard()
        
//        let someView = UIView()
//        someView.backgroundColor = .red
//        someView.translatesAutoresizingMaskIntoConstraints = false
//        someView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        let someLabel = UILabel()
//        someLabel.text = "hello"
//        someLabel.frame.size.height = 50
//        someLabel.frame.size.width = 50
//        //        someLabel.sizeToFit()
//        //        someView.addSubview(someLabel)
//
//        let someButton = UIButton()
//        someButton.setTitle("Some Button", for: .normal)
//        someButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
//        //        someButton.frame.size.height = 60
//        //        someButton.frame.size.width = 60
//        someView.addSubview(someButton)
//        stackView.addArrangedSubview(someView)
//
//
//
//
        goalButton = createButton(title: "Existing Goal", image: nil, color: UIColor(red: 0, green: 0, blue: 255/255, alpha: 1.0), height: nil, width: nil)
        
        configureStackView()
        setConstraints()
    }
    
    func configureStackView() {
        stackView.addArrangedSubview(goalTextField)
        stackView.addArrangedSubview(goalButton)
        stackView.addArrangedSubview(commentTextView)
        stackView.addArrangedSubview(metricPanel)
    }
    
    func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        goalTextField.translatesAutoresizingMaskIntoConstraints = false
        goalTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        goalButton.translatesAutoresizingMaskIntoConstraints = false
        goalButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        commentTextView.translatesAutoresizingMaskIntoConstraints = false
        commentTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        metricPanel.translatesAutoresizingMaskIntoConstraints = false
        metricPanel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
//        plusButton.leadingAnchor.constraint(equalTo: metricPanel.leadingAnchor).isActive = true
//        plusButton.trailingAnchor.constraint(equalTo: metricPanel.trailingAnchor).isActive = true
        plusButton.centerYAnchor.constraint(equalTo: metricPanel.centerYAnchor).isActive = true
    }
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    func createButton(title: String?, image: UIImage?, color: UIColor, height: CGFloat?, width: CGFloat?) -> UIButton {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        if title != nil {
            button.setTitle(title, for: .normal)
        }
        
        if image != nil {
            button.setImage(image, for: .normal)
        }
        
        button.backgroundColor = color
        
        if let height = height, let width = width {
            button.frame.size.height = height
            button.frame.size.width = width
        }
        
        return button
    }
    
}

extension NewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Comment"
            textView.textColor = UIColor.lightGray
        }
    }
}

