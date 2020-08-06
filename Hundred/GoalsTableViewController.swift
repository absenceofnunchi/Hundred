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
    var fetchedResultsController: NSFetchedResultsController<Goal>!
    var goalPredicate: NSPredicate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Goals"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGoals))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSavedData()
        
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        let goal = fetchedResultsController.object(at: indexPath)
    //        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController,
    //            let progress = goal.progress.first(where: {$0.goal.title == goal.title}) {
    //            vc.goalTitle = goal.title
    //            vc.date = progress.date
    //
    //            if let comment = progress.comment {
    //                vc.comment = comment
    //            }
    //
    //            if let firstMetric = progress.firstMetric, let secondMetric = progress.secondMetric {
    //                vc.firstMetric = firstMetric
    //                vc.secondMetric = secondMetric
    //            }
    //
    //            if let image = progress.image {
    //                vc.image = image
    //            }
    //
    //            if let location = progress.location {
    //                vc.location = location
    //            }
    //
    //            navigationController?.pushViewController(vc, animated: true)
    //        }
    //    }
    
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
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: "title", cacheName: nil)
            fetchedResultsController.delegate = self
        }
        
        fetchedResultsController.fetchRequest.predicate = goalPredicate
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch failed")
        }
        
        tableView.reloadData()
    }
}

extension GoalsTableViewController {
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let goal = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = goal.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = fetchedResultsController.object(at: indexPath)
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.goal = fetchedResultsController.object(at: indexPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
