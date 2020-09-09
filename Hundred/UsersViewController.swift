//
//  UsersViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-09.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit
import MapKit

class UsersViewController: UITableViewController {
    var users = [CKRecord]()
    var imageView: UIImageView!
    var commentLabel = UILabel()
    var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        test()
    }

    func fetchData() {
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
                self.users.append(record)
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
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: <#T##String#>)
//    }
}
