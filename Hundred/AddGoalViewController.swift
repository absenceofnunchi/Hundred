//
//  AddGoalViewController.swift
//  Hundred
//
//  Created by jc on 2020-07-31.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class AddGoalViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var vStackView: UIStackView!
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.layer.shadowColor = UIColor.lightGray.cgColor
        textField.layer.shadowOpacity = 0.3
        textField.layer.shadowOffset = .zero
        textField.layer.shadowRadius = 4
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 0
        textField.clipsToBounds = false
        
        textView.isScrollEnabled = false
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOpacity = 0.3
        textView.layer.shadowOffset = .zero
        textView.layer.shadowRadius = 4
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 0
        textView.clipsToBounds = false
        
    }
    
    @IBAction func addGoalPressed(_ sender: Any) {
        
    }
    
}
