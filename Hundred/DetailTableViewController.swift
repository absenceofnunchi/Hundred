//
//  DetailTableViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-12.
//  Copyright © 2020 J. All rights reserved.
//

// Hundred`closure #1 in DetailTableViewController.goal.didset:

import UIKit

class DetailTableViewController: UITableViewController {
    
    var fetchedResult: Progress!
    var goalTitle: String!
    var progresses: [Progress]!
    var goal: Goal! {
        didSet {
            progresses = goal.progress.sorted {$0.date > $1.date}
        }
    }
    
    struct Cells {
        static let progressCell = "ProgressCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = goal.title
        configureTableView()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    func configureTableView() {
        tableView.register(ProgressCell.self, forCellReuseIdentifier: Cells.progressCell)
        tableView.rowHeight = 85
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return progresses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.progressCell, for: indexPath) as! ProgressCell
        let progress = progresses[indexPath.row]
        cell.set(progress: progress)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Entry") as? EntryViewController {
            vc.progress = progresses[indexPath.row]
            vc.metrics = goal.metrics
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let progress = progresses[indexPath.row]
//            self.context.delete(progress)
//            progresses.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//            self.saveContext()
//        } else if editingStyle == .none {
//            print("insert")
//        }
//    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            let progress = self.progresses[indexPath.row]
            self.context.delete(progress)
            self.progresses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.saveContext()
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (contextualAction, view, boolValue) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditEntry") as? EditEntryViewController {
                vc.progress = self.progresses[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        editAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
}



//extension DetailTableViewController: UIViewControllerPreviewingDelegate {
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        if let indexPath = tableView.indexPathForRow(at: location) {
//            previewingContext.sourceRect = tableView.rectForRow(at: indexPath)
//            if let vc = storyboard?.instantiateViewController(identifier: "Entry") as? EntryViewController {
//                vc.progress = progresses[indexPath.row]
//                vc.metrics = goal.metrics
//                return vc
//            }
//        }
//        
//        return nil
//    }
//    
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        navigationController?.pushViewController(viewControllerToCommit, animated: true)
//    }
//}
