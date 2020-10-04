//
//  UsersViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-09.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit
import CoreData
import Network

class UsersViewController: UITableViewController {
    var users = [CKRecord]()
    var userId: String?
    var utility = Utilities()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        if userId != nil {
            fetchPublicFeed(userId: userId)
        } else {
            fetchPublicFeed(userId: nil)
        }
    }

    func configureUI() {
        title = "Public Feed"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: Cells.userCell)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        
        let inter = UIContextMenuInteraction(delegate: self)
        self.view.addInteraction(inter)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshFetch))
        if userId == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(filterFeed))
        }
    }
    
    @objc func filterFeed() {
        let ac = UIAlertController(title: "Filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "All", style: .default, handler: { (_) in
            self.fetchPublicFeed(userId: nil)
            DispatchQueue.main.async {
                self.title = "Public Feed"
            }
            
        }))
        
        ac.addAction(UIAlertAction(title: "My Public Entries Only", style: .default, handler: { (_) in
            if let profile = self.fetchProfile() {
                self.fetchPublicFeed(userId: profile.userId)
                DispatchQueue.main.async {
                    self.title = "My Entries Only"
                }
            } else {
                self.alert(with: Messages.status, message: Messages.noProfileCreated)
            }
        }))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.minX, y: 0, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(ac, animated: true, completion: {() -> Void in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
            ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        })
    }
    
    func fetchPublicFeed(userId: String?) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                let publicDatabase = CKContainer.default().publicCloudDatabase
                let predicate: NSPredicate!
                if let userId = userId {
                    predicate = NSPredicate(format: "userId == %@", userId)
                } else {
                    predicate = NSPredicate(value: true)
                }
                
                let query =  CKQuery(recordType: "Progress", predicate: predicate)
                
                let configuration = CKQueryOperation.Configuration()
                configuration.allowsCellularAccess = true
                configuration.qualityOfService = .userInitiated
                
                let queryOperation = CKQueryOperation(query: query)
                queryOperation.desiredKeys = ["comment", "date", "goal", "metrics", "currentStreak", "longestStreak", "image", "longitude", "latitude", "username", "userId"]
                queryOperation.queuePriority = .veryHigh
                queryOperation.configuration = configuration
                queryOperation.resultsLimit = 50
                queryOperation.recordFetchedBlock = { (record: CKRecord?) -> Void in
                    if let record = record {
                        DispatchQueue.main.async {
                            self.users.append(record)
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
                                
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                publicDatabase.add(queryOperation)
                monitor.cancel()
            } else {
                // if the network is absent
                DispatchQueue.main.async {
                    self.alert(with: Messages.networkError, message: Messages.noNetwork)
                }
            }
        }
    }
    
    // MARK: - Display Alert
    
    /// Creates and displays an alert.
    fileprivate func alert(with title: String, message: String) {
        let alertController = utility.alert(title, message: message)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.navigationController?.present(alertController, animated: true, completion: nil)
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
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let user = users[indexPath.row]
//            if let index = users.firstIndex(of: user) {
//                users.remove(at: index)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let user = self.users[indexPath.row]
        var configArr: [UIContextualAction] = []
        if user.wasCreatedByThisUser {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
                self.deleteAction(user: user)
                
                if let index = self.users.firstIndex(of: user) {
                    self.users.remove(at: index)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
            deleteAction.backgroundColor = .red
            configArr.append(deleteAction)
        }

        
        let configuration = UISwipeActionsConfiguration(actions: configArr)
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
                if let id = id {
                    DispatchQueue.main.async {
                        // delete the record name from the corresponding Core Data item
                        let progressRequest = NSFetchRequest<Progress>(entityName: "Progress")
                        progressRequest.predicate = NSPredicate(format: "recordName == %@", id.recordName as CVarArg)
                        if let fetchedProgress = try? self.context.fetch(progressRequest) {
                            if fetchedProgress.count > 0 {
                                fetchedProgress.first?.recordName = nil
                                self.saveContext()
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserDetail") as! UserDetailViewController
        
        // fetch analytics record using the user's reference
        let user = users[indexPath.row]
        vc.user = user
        
        let reference = CKRecord.Reference(recordID: user.recordID, action: .deleteSelf)
        let pred = NSPredicate(format: "owningProgress == %@", reference)
        let query = CKQuery(recordType: MetricAnalytics.analytics.rawValue, predicate: pred)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { results, error in
            if let error = error {
                print("error fetching the Analytics record: \(error.localizedDescription)")
            } else {
                if let results = results {
                    DispatchQueue.main.async {
                        vc.analytics = results
                        self.navigationController?.pushViewController(vc, animated: true, completion: {
                            self.tableView.isUserInteractionEnabled = true
                        })
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc, animated: true, completion: {
                            self.tableView.isUserInteractionEnabled = true
                        })
                    }
                }
            }
        }
    }
    
    @objc func refreshFetch() {
        self.users.removeAll()
        fetchPublicFeed(userId: userId)
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.tintColor = UIColor.black
        spinner.startAnimating()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { (_) in
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            spinner.stopAnimating()
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshFetch))
        }
        
    }
}

extension UINavigationController {
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
