//
//  ProfileViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-15.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var profileInfo: String! {
        didSet {
            if profileInfo != nil {
                print("logged in")
            } else {
                print("not logged in")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
