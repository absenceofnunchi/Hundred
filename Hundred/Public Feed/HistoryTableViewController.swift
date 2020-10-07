//
//  HistoryTableViewController.swift
//  Hundred
//
//  Created by J C on 2020-10-05.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit
import Network

class HistoryTableViewController: UITableViewController {
    var users = [CKRecord]()
    var userId: String! {
        didSet {
            fetchPublicFeed(userId: userId)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        tableView.register(UserCell.self, forCellReuseIdentifier: Cells.userCell)
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
    }

    func fetchPublicFeed(userId: String?) {
        self.users.removeAll()
        tableView.reloadData()
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
                queryOperation.desiredKeys = ["comment", "date", "goal", "metrics", "currentStreak", "longestStreak", "image", "longitude", "latitude", "username", "userId", "entryCount", "profileImage", "profileDetail"]
                queryOperation.queuePriority = .veryHigh
                queryOperation.configuration = configuration
                queryOperation.resultsLimit = 20
                queryOperation.recordFetchedBlock = { (record: CKRecord?) -> Void in
                    if let record = record {
                        DispatchQueue.main.async {
                            print("record: \(record)")
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
//                    self.alert(with: Messages.networkError, message: Messages.noNetwork)
                }
            }
        }
    }
    
}

// MARK: - Table view data source
extension HistoryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.userCell, for: indexPath) as! UserCell
        let user: CKRecord! = users[indexPath.row]
        cell.set(user: user)
        cell.selectionStyle = .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.80, height: 20))
        containerView.backgroundColor = UIColor.white
        
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.80, height: 20))
        let label = UILabel()
        label.text = "History"
        label.font = UIFont.body.with(weight: .bold)
        label.textColor = .gray
        label.textAlignment = .center
        containerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
//        label.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.80).isActive = true
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        let line = UIView()
        line.layer.borderWidth = 1
        line.layer.borderColor = UIColor.lightGray.cgColor
        containerView.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.90).isActive = true
        line.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        
        return containerView
    }
}
