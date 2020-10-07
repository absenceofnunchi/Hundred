//
//  FeedbackViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-25.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackViewController: UIViewController {
    let instructionLabel: UILabel = {
        let instructionLabel = UILabel()
        instructionLabel.text = "Please provide any questions, feedbacks, crash reports regarding the app.  \n\nThank you!"
        instructionLabel.numberOfLines = 0
        return instructionLabel
    }()
    let containerView = UILabel()
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "lake")
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0
        return imageView
    }()
    var mailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send Feedback", for: .normal)
        button.addTarget(self, action: #selector(openMailComposer), for: .touchUpInside)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.titleEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.imageView.alpha = 1
        })
    }
    
    func configureUI() {
        title = "Feedback"
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        view.insertSubview(self.imageView, at: 0)
        imageView.pin(to: self.view)
        
        view.addSubview(containerView)
        containerView.addSubview(instructionLabel)
        view.addSubview(mailButton)
    }
    
    func setConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        instructionLabel.pin(to: containerView)
        
        mailButton.translatesAutoresizingMaskIntoConstraints = false
        mailButton.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        mailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mailButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }

    @objc func openMailComposer() {
        guard MFMailComposeViewController.canSendMail() else {
            print("can't open")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["jay.manuscript@gmail.com"])
        composer.setSubject("Feedback")
         
        present(composer, animated: true)
    }
}

extension FeedbackViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _  = error {
            controller.dismiss(animated: true)
            return
        }
        
        switch result {
        case .cancelled:
            showAlert(title: "Cancelled")
        case .failed:
            showAlert(title: "Failed to send")
        case .saved:
            showAlert(title: "Saved")
        case .sent:
            print("sent")
        default:
            print("default")
        }
        
//        FeedbackViewController.composer.dismiss(animated: true)
        controller.dismiss(animated: true)
    }
    
    func showAlert(title: String) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
