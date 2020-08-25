//
//  GoalsTableViewController.swift
//  Hundred
//
//  Created by jc on 2020-07-31.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreData

class GoalsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    struct Cells {
        static let goalCell = "GoalCell"
    }
    
    var fetchedResultsController: NSFetchedResultsController<Goal>?
    //    var goalPredicate: NSPredicate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Goals"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGoals))
        
        loadSavedData()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }
    
    func configureTableView() {
        tableView.register(GoalCell.self, forCellReuseIdentifier: Cells.goalCell)
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @objc func addGoals() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddGoal") as? AddGoalViewController {
            vc.isDismissed = { [weak self] in
                self?.loadSavedData()
            }
            present(vc, animated: true)
        }
    }
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = Goal.createFetchRequest()
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = self
        }
        
        //        fetchedResultsController.fetchRequest.predicate = goalPredicate
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Fetch failed")
        }
        
        tableView.reloadData()
    }
}

// MARK: - Table view data source
extension GoalsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = fetchedResultsController?.sections![section] {
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.goalCell, for: indexPath) as! GoalCell
        if let goal = fetchedResultsController?.object(at: indexPath) {
            cell.set(goal: goal)
        }
        
        //        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController {
            vc.goal = fetchedResultsController?.object(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let goal = fetchedResultsController?.object(at: indexPath) {
                self.context.delete(goal)
            }
            
            self.saveContext()
        } 
        
        // delete plist
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            if let goal = self.fetchedResultsController?.object(at: indexPath) {
                self.context.delete(goal)
            }
            
            self.saveContext()
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (contextualAction, view, boolValue) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditGoal") as? EditViewController {
                
                vc.goalDetail = self.fetchedResultsController?.object(at: indexPath)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        editAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let section = IndexSet(integer: sectionIndex)
        switch type {
        case .delete:
            tableView.deleteSections(section, with: .automatic)
        default:
            break
        }
    }
}


extension UIViewController {
    func configureNavigationBar(largeTitleColor: UIColor, backgoundColor: UIColor, tintColor: UIColor, title: String, preferredLargeTitle: Bool) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.titleTextAttributes = [.foregroundColor: largeTitleColor]
            navBarAppearance.backgroundColor = backgoundColor
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.compactAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            
            navigationController?.navigationBar.prefersLargeTitles = preferredLargeTitle
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.tintColor = tintColor
            navigationItem.title = title
            
        } else {
            // Fallback on earlier versions
            navigationController?.navigationBar.barTintColor = backgoundColor
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.isTranslucent = false
            navigationItem.title = title
        }
    }}
