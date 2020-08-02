//
//  DetailViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-01.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var goal: Goal!
    
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = goal.title
        tabBarController?.tabBar.isHidden = true
        
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }

}
