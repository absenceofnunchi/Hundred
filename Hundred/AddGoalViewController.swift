//
//  AddGoalViewController.swift
//  Hundred
//
//  Created by jc on 2020-07-31.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreData

class AddGoalViewController: UIViewController {
    var container: NSPersistentContainer!
    var metrics: [String]!
    var isDismissed: (() -> Void)?
    
    @IBOutlet var textView: UITextView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var metric1TextField: UITextField!
    @IBOutlet var metric2TextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.isScrollEnabled = false
        let borderColor = UIColor.gray
        textView.layer.borderColor = borderColor.withAlphaComponent(0.4).cgColor
        textView.layer.cornerRadius = 4
        textView.layer.borderWidth = 1
        textView.clipsToBounds = false
        //        textView.layer.shadowColor = UIColor.lightGray.cgColor
        //        textView.layer.shadowOpacity = 0.3
        //        textView.layer.shadowOffset = .zero
        //        textView.layer.shadowRadius = 4
        
    }
    
    @IBAction func addGoalPressed(_ sender: Any) {
        metrics = [String]()
        
        let goal = Goal(context: container.viewContext)
        
        if let title = textField.text, let detail = textView.text {
            goal.title = title
            goal.detail = detail
        }
        
        if let metric1 = metric1TextField?.text {
            metrics.append(metric1)
        }
        
        if let metric2 = metric2TextField?.text {
            metrics.append(metric2)
        }
        
        saveContext()
        dismiss(animated: true, completion: {
            self.isDismissed?()
        })
    }
    
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occured whlie saving: \(error.localizedDescription)")
            }
        }
    }
    
}

