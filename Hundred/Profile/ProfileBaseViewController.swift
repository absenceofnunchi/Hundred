//
//  ProfileBaseViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-30.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class ProfileBaseViewController: UIViewController {
    var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "tree")
        imageView.contentMode = .scaleToFill
        imageView.alpha = 0
        return imageView
    }()
    
    var usernameContainer: UIView!
    var usernameLabel: UILabel!
    var descContainer: UIView!
    var descLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.view.insertSubview(self.imageView, at: 0)
            self.imageView.pin(to: self.view)
        }
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2, delay: 0, options: [], animations: {
            self.imageView.alpha = 1
        })
    }
}
