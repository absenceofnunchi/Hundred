//
//  GoalsTableViewController.swift
//  Hundred
//
//  Created by jc on 2020-07-31.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreData
import CoreSpotlight
import MobileCoreServices

class GoalsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var fetchedResultsController: NSFetchedResultsController<Goal>?
    var pullControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSavedData()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func configureTableView() {
        title = "Goals"
        
        tableView.register(GoalCell.self, forCellReuseIdentifier: Cells.goalCell)
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
        
        let inter = UIContextMenuInteraction(delegate: self)
        self.view.addInteraction(inter)
        
        pullControl.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        pullControl.addTarget(self, action: #selector(refreshFetch), for: .valueChanged)
        tableView.refreshControl = pullControl
        tableView.addSubview(pullControl)
    }
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            let request = NSFetchRequest<Goal>(entityName: "Goal")
            let sort = NSSortDescriptor(key: "date", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = self
        }
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print("Fetch failed")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func refreshFetch() {
        loadSavedData()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
            self.pullControl.endRefreshing()
        }
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
                self.saveContext()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let goal = self.fetchedResultsController?.object(at: indexPath) else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            self.deleteAction(goal: goal)
        }
        deleteAction.backgroundColor = .red
        
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (contextualAction, view, boolValue) in
            self.editAction(goal: goal)
        }
        editAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    func deleteAction(goal: Goal) {
        // deindex goal from Core Spotlight
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(goal.title)"]) { (error) in
            if let error = error {
                print("Deindexing error: \(error.localizedDescription)")
            } else {
                print("Goal successfully deindexed")
            }
        }
        
        var recordIDs: [CKRecord.ID] = []
        
        for progress in goal.progress {
            // deindex the related progresses from Core Spotlight
            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(progress.id)"]) { (error) in
                if let error = error {
                    print("Deindexing error: \(error.localizedDescription)")
                } else {
                    print("Progress successfully deindexed")
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
            
            // get the array of record IDs if they exist
            if let recordName = progress.recordName {
                let recordID = CKRecord.ID(recordName: recordName)
                recordIDs.append(recordID)
            }
        }
        
        // delete from the public container if they exist
        if recordIDs.count > 0 {
            modifyRecords(recordsToSave: nil, recordIDsToDelete: recordIDs)
        }
        
        // delete relevant iCloud key/value for heatmap
        let keyValStore = NSUbiquitousKeyValueStore.default
        if var dict = keyValStore.dictionary(forKey: "heatmap") as? [String : [String : Int] ] {
            dict.removeValue(forKey: goal.title)
            keyValStore.set(dict, forKey: "heatmap")
            keyValStore.synchronize()
        }
        
        self.context.delete(goal)
        self.saveContext()
        
        if let mainVC = (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.topViewController as? ViewController {
            let dataImporter = DataImporter(goalTitle: nil)
            mainVC.data = dataImporter.loadData(goalTitle: nil)

            let mainDataImporter = MainDataImporter()
            mainVC.goals = mainDataImporter.loadData()
        }
    }
    
    func editAction(goal: Goal) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditGoal") as? EditViewController {
            vc.goalDetail = goal
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
    }
}

extension GoalsTableViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView,contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let goal = fetchedResultsController?.object(at: indexPath) else { return nil }
        
        // Create a UIAction for sharing
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
            // Show system share sheet
        }
        
        let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { action in
            self.editAction(goal: goal)
        }
        
        // Here we specify the "destructive" attribute to show that it’s destructive in nature
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            self.deleteAction(goal: goal)
        }
        
        func getPreviewVC(indexPath: IndexPath) -> UIViewController? {
            if let destinationVC = storyboard?.instantiateViewController(identifier: "Detail") as? DetailTableViewController {
                destinationVC.goal = goal

                return destinationVC
            }

            return nil
        }
        
        return UIContextMenuConfiguration(identifier: "DetailPreview" as NSString, previewProvider: { getPreviewVC(indexPath: indexPath) }) { _ in
            UIMenu(title: "", children: [share, edit, delete])
        }
    }
}



extension Date {
    init(_ year:Int, _ month: Int, _ day: Int) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        self.init(timeInterval:0, since: Calendar.current.date(from: dateComponents)!)
    }
}



