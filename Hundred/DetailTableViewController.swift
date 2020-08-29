//
//  DetailTableViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-12.
//  Copyright © 2020 J. All rights reserved.
//

// Hundred`closure #1 in DetailTableViewController.goal.didset:

import UIKit

class DetailTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {
    
    var fetchedResult: Progress!
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
        tabBarController?.tabBar.isHidden = true

        configureTableView()
        registerForPreviewing(with: self, sourceView: tableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    func configureTableView() {
        tableView.register(ProgressCell.self, forCellReuseIdentifier: Cells.progressCell)
        tableView.rowHeight = 85
    }
    
    // MARK: - Peek and pop
    
    func entryViewController(progress: Progress, metrics: [String]?) -> EntryViewController {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Entry") as? EntryViewController else {
            preconditionFailure("Expected a EntryViewController")
        }
        
        vc.progress = progress
        vc.metrics = metrics
        return vc
    }

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        // First, get the index path and view for the previewed cell.
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath)
            else { return nil }

        // Enable blurring of other UI elements, and a zoom in animation while peeking.
        previewingContext.sourceRect = cell.frame

        return entryViewController(progress: progresses[indexPath.row], metrics: goal.metrics)
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            let progress = self.progresses[indexPath.row]
            let formattedDate = self.dateForPlist(date: progress.date)
            if let url = self.pListURL() {
                if FileManager.default.fileExists(atPath: url.path) {
                    do {
                        let dataContent = try Data(contentsOf: url)
                        if var dict = try PropertyListSerialization.propertyList(from: dataContent, format: nil) as? [String: [String: Int]] {
                            if var count = dict[self.goal.title]?[formattedDate] {
                                if count > 0 {
                                    count -= 1
                                    dict[self.goal.title]?[formattedDate] = count
                                    self.write(dictionary: dict)
                                    if let mainVC = (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.topViewController as? ViewController {
                                        let dataImporter = DataImporter(goalTitle: nil)
                                        mainVC.data = dataImporter.loadData(goalTitle: nil)
                                    }
                                }
                            }
                        }
                    } catch {
                        print("error :\(error.localizedDescription)")
                    }
                }
            }
            
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

