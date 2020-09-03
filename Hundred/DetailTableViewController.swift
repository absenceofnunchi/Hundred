//
//  DetailTableViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-12.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class DetailTableViewController: UITableViewController {
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        DispatchQueue.main.async {
//            self.tableView.reloadWithAnimation()
            self.tableView.reloadData()
        }
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
            vc.indexPathRow = indexPath.row
            vc.indexPath = indexPath
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            let progress = self.progresses[indexPath.row]
            
            // check to see if the entry is within the streak and if it is, end the streak
             if let lastUpdatedDate = progress.goal.lastUpdatedDate {
                 if self.dayVariance(date: lastUpdatedDate, value: -Int(progress.goal.streak)) < progress.date && progress.date < lastUpdatedDate && progress.goal.streak > 0 {
                     
                     let ac = UIAlertController(title: "Delete", message: "Deletion of this entry will end the streak it belongs to. Are you sure you want to proceed?", preferredStyle: .alert)
                     ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
                         progress.goal.streak = 0
                        self.deleteAction(progress: progress, indexPath: indexPath)
                     }))
                     ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    if let popoverController = ac.popoverPresentationController {
                          popoverController.sourceView = self.view
                          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                          popoverController.permittedArrowDirections = []
                    }
                    
                    self.present(ac, animated: true)
                 } else {
                    self.deleteAction(progress: progress, indexPath: indexPath)
                 }
             }

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
    
    func deleteAction(progress: Progress, indexPath: IndexPath) {
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
                            }
                        }
                    }
                } catch {
                    print("error :\(error.localizedDescription)")
                }
            }
        }
        
        // deindex from Core Spotlight
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(progress.id)"]) { (error) in
            if let error = error {
                print("Deindexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully deindexed")
            }
        }
        
        // delete the image from the directory
        if let image = progress.image {
            let imagePath = getDocumentsDirectory().appendingPathComponent(image)
            do {
                try FileManager.default.removeItem(at: imagePath)
            } catch {
                print("The image could not be deleted from the directory: \(error.localizedDescription)")
            }
        }
        
        self.context.delete(progress)
        self.progresses.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.saveContext()
        
        if let mainVC = (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.topViewController as? ViewController {
            let dataImporter = DataImporter(goalTitle: nil)
            mainVC.data = dataImporter.loadData(goalTitle: nil)
            
            let mainDataImporter = MainDataImporter()
            mainVC.goals = mainDataImporter.loadData()
        }
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
