//
//  AddGoalViewController.swift
//  Hundred
//
//  Created by jc on 2020-07-31.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit

class AddGoalViewController: UIViewController {
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        let aView = UIView()
        aView.backgroundColor = .yellow
        stackView.addArrangedSubview(aView)
        
        aView.translatesAutoresizingMaskIntoConstraints = false
        aView.heightAnchor.constraint(equalToConstant: 11200).isActive = true
    }
    
    func setConstraints() {
        scrollView.pin(to: view)
        stackView.pin(to: scrollView)
    }
    
    func fetchData() {
        print("fetch started")
        let cloudContainer = CKContainer.default()
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query =  CKQuery(recordType: "Progress", predicate: predicate)
        
        let configuration = CKQueryOperation.Configuration()
        configuration.allowsCellularAccess = true
        configuration.qualityOfService = .userInitiated
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["comment", "date", "goal", "metrics"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.configuration = configuration
        queryOperation.recordFetchedBlock = { (record: CKRecord?) -> Void in
            if let record = record {
                print("fetched record: \(record)")
            }
        }
        
        queryOperation.queryCompletionBlock = { (cursor: CKQueryOperation.Cursor?, error: Error?) -> Void in
            if let error = error {
                print("queryCompletionBlock error: \(error)")
                return
            }
            
            if let cursor = cursor {
                print("cursor: \(cursor)")
            }
        }
        
        publicDatabase.add(queryOperation)
    }

}
