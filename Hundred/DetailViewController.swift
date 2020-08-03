//
//  DetailViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-01.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var fetchedResult: Progress!
    var progress: Progress!
    var goalTitle: String!
    var comment: String!
    var date: Date!
    var firstMetric: NSDecimalNumber!
    var secondMetric: NSDecimalNumber!
    var image: String!
    var location: String!
    var goal: Goal!
    
    @IBOutlet var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
        if let goal = goal {
            title = goal.title
            for progress in goal.progress {
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }

//    func loadProgress() {
//        let progressRequest = Progress.createFetchRequest()
//        progressRequest.predicate = NSPredicate(format: "ANY goal == %@", goal)
//
//        if let progress = try? self.context.fetch(progressRequest) {
//            print("progress: \(progress)")
//
//            if progress.count > 0 {
//                fetchedResult = progress[0]
//                print("fetchedResult: \(fetchedResult)")
//            }
//        }
//    }
}

