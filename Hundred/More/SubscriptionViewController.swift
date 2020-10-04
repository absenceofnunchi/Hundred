//
//  SubscriptionViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-25.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreData

class SubscriptionViewController: UITableViewController {
    var subscriptionArr = [Subscription]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "People I follow"
        let inter = UIContextMenuInteraction(delegate: self)
        self.view.addInteraction(inter)
        
        fetchData()
    }
    
    func fetchData() {
        let request = NSFetchRequest<Subscription>(entityName: "Subscription")
        do {
            let result = try self.context.fetch(request)
            print("result: \(result)")
            subscriptionArr = result
            
        } catch {
            let ac = UIAlertController(title: "Error", message: "There was an error fetching data. Please try again", preferredStyle: .alert)
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                _ = self.navigationController?.popViewController(animated: true)
            }))
            
            present(ac, animated: true, completion: {() -> Void in
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
                ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subscriptionArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = subscriptionArr[indexPath.row].username
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Users") as? UsersViewController {
            vc.userId = subscriptionArr[indexPath.row].userId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension SubscriptionViewController: UIContextMenuInteractionDelegate {
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let subscription = self.subscriptionArr[indexPath.row]
        var configArr: [UIContextualAction] = []
        let deleteAction = UIContextualAction(style: .destructive, title: "Unsubscribe") { (contextualAction, view, boolValue) in
            self.deleteAction(subscription: subscription)
            
            if let index = self.subscriptionArr.firstIndex(of: subscription) {
                self.subscriptionArr.remove(at: index)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        deleteAction.backgroundColor = .red
        configArr.append(deleteAction)

        let configuration = UISwipeActionsConfiguration(actions: configArr)
        return configuration
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    func deleteAction(subscription: Subscription) {
        let subscriptionRequest = NSFetchRequest<Subscription>(entityName: "Subscription")
        subscriptionRequest.predicate = NSPredicate(format: "userId == %@", subscription.userId)
        if let fetchedSubscriptions = try? self.context.fetch(subscriptionRequest) {
            if fetchedSubscriptions.count > 0 {
                var IDsToBeDeleted: [CKSubscription.ID] = []
                for fetchedSubscription in fetchedSubscriptions {
                    IDsToBeDeleted.append(fetchedSubscription.subscriptionId)
                }
                
                let operation = CKModifySubscriptionsOperation(subscriptionsToSave: nil, subscriptionIDsToDelete: IDsToBeDeleted)
                operation.modifySubscriptionsCompletionBlock = { saved, deleted, error in
                  if let error = error{
                    print("error from modifySubscriptionsCompletionBlock: \(error.localizedDescription)")
                    let ac = UIAlertController(title: "Error", message: "Sorry, there was an error unsubscribing from this user. Please try again", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                        DispatchQueue.main.async {
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }))
                    
                    if let popoverController = ac.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    
                    self.present(ac, animated: true)
                  }else{
                    print("Subscriptions saved: \(String(describing: saved))\nSubscriptions deleted: \(String(describing: deleted))")
                    DispatchQueue.main.async {
                        // only save the newly updated data to Core Data if the subscription update is successful
                        for fetchedSubscription in fetchedSubscriptions {
                            self.context.delete(fetchedSubscription)
                        }
                        self.saveContext()
                    }
                  }
                }

                let database = CKContainer.default().publicCloudDatabase
                database.add(operation)
            }
        }
    }
}
