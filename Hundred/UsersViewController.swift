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
        
        configureUI()
        fetchData()
    }

    func configureUI() {
        title = "Public Feed"
        navigationItem.title = "Public Feed"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        
        let inter = UIContextMenuInteraction(delegate: self)
        self.view.addInteraction(inter)
        
//        tableView.reloadData()
//        tableView.setNeedsLayout()
//        tableView.layoutIfNeeded()
//        tableView.reloadData()
    }
    
    func fetchData() {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query =  CKQuery(recordType: "Progress", predicate: predicate)
        
        let configuration = CKQueryOperation.Configuration()
        configuration.allowsCellularAccess = true
        configuration.qualityOfService = .userInitiated
        
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["comment", "date", "goal", "metrics", "currentStreak", "longestStreak", "image"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.configuration = configuration
        queryOperation.recordFetchedBlock = { (record: CKRecord?) -> Void in
            if let record = record {
                DispatchQueue.main.async {
                    self.users.append(record)
                    self.tableView.reloadData()
//                    self.tableView.layoutIfNeeded()
//                    self.tableView.beginUpdates()
//                    self.tableView.endUpdates()
                }
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

// MARK: - Table view data source
extension UsersViewController: UIContextMenuInteractionDelegate {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let user: CKRecord! = users[indexPath.row]
        cell.set(user: user)
        cell.selectionStyle = .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = users[indexPath.row]
            
            if let index = users.firstIndex(of: user) {
                users.remove(at: index)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let user = self.users[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            self.deleteAction(user: user)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func deleteAction(user: CKRecord) {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        publicDatabase.delete(withRecordID: user.recordID) { (id, error) in
            if error != nil {
                print("delete error: \(error.debugDescription)")
            } else {
                print("delete completed: \(id!)")
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let selectedPath = tableView.indexPathForSelectedRow else { return }
//        if let target = segue.destination as? UserDetailViewController {
//            let user = users[selectedPath.row]
//            target.user = user
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        DispatchQueue.main.async {
//            self.performSegue(withIdentifier: "UserDetailSegue", sender: self)
//        }

        let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetail") as! UserDetailViewController
        let user = users[indexPath.row]
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
        

        
        // fetch analytics record using the user's reference
//        let user = users[indexPath.row]
//        vc.user = user
//        self.present(vc,animated:true)
        
//        let reference = CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
//        let pred = NSPredicate(format: "owningProgress == %@", reference)
//        let query = CKQuery(recordType: MetricAnalytics.analytics.rawValue, predicate: pred)
//        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { results, error in
//            if let error = error {
//                print("error fetching the Analytics record: \(error.localizedDescription)")
//            } else {
//                if let results = results {
//                    DispatchQueue.main.async {
//                        vc.analytics = results
//                        self.present(vc,animated:true)
//                    }
//                } else {
//                    DispatchQueue.main.async {
//                        self.present(vc,animated:true)
//                    }
//                }
//            }
//        }
    }
}
