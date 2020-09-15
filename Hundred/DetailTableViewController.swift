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
import MapKit

class DetailTableViewController: UITableViewController, UIContextMenuInteractionDelegate {
    var progresses: [Progress]!
    var goal: Goal! {
        didSet {
            progresses = goal.progress.sorted {$0.date > $1.date}
        }
    }
    var pullControl = UIRefreshControl()
    
    struct Cells {
        static let progressCell = "ProgressCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            //            self.tableView.reloadWithAnimation()
            self.tableView.reloadData()
        }
    }
    
    func configureUI() {
        title = goal.title
        
        tableView.register(ProgressCell.self, forCellReuseIdentifier: Cells.progressCell)
        tableView.rowHeight = 85
        
        let inter = UIContextMenuInteraction(delegate: self)
        self.view.addInteraction(inter)
        
        pullControl.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        pullControl.addTarget(self, action: #selector(refreshFetch), for: .valueChanged)
        tableView.refreshControl = pullControl
        tableView.addSubview(pullControl)
    }
    
    @objc func refreshFetch() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
            self.pullControl.endRefreshing()
        }
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
            vc.indexPathRow = indexPath.row
            vc.indexPath = indexPath
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let progress = self.progresses[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, boolValue) in
            
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
            self.setEditAction(progress: progress)
        }
        editAction.backgroundColor = .systemBlue
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return configuration
    }
    
    func setEditAction (progress: Progress) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditEntry") as? EditEntryViewController {
            
            let geocoder = CLGeocoder()
            
            if let latitude = progress.latitude?.doubleValue, let longitutde = progress.longitude?.doubleValue {
                geocoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitutde)) { (placemarks, error) in
                     if error == nil {
                         let placemark = placemarks?[0]
                         if let placemark = placemark {
                             let firstSpace = (placemark.thoroughfare != nil && placemark.subThoroughfare != nil) ? " ": ""
                             let comma = (placemark.subThoroughfare != nil || placemark.thoroughfare != nil) && (placemark.subAdministrativeArea != nil || placemark.administrativeArea != nil) ? ", ": ""
                             let secondSpace = (placemark.subAdministrativeArea != nil && placemark.administrativeArea != nil) ? " ": ""
                             let addressLine = String(
                                 format: "%@%@%@%@%@%@%@",
                                 // street number
                                 placemark.subThoroughfare ?? "",
                                 firstSpace,
                                 // street name
                                 placemark.thoroughfare ?? "",
                                 comma,
                                 //city
                                 placemark.locality ?? "",
                                 secondSpace,
                                 // state or province
                                 placemark.administrativeArea ?? ""
                             )
                             
                             vc.locationText = addressLine
                         }
                     }
                 }
            }
            
            vc.progress = progress
            self.navigationController?.pushViewController(vc, animated: true)
        }
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

extension DetailTableViewController {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    //    func contextMenuInteraction(_ inter: UIContextMenuInteraction, configurationForMenuAtLocation loc: CGPoint) -> UIContextMenuConfiguration? {
    //        let config = UIContextMenuConfiguration(identifier: "preview" as NSString, previewProvider: { TestViewController() }, actionProvider: { suggestedAction in
    //            return self.makeContextMenu()
    //        })
    //        return config
    //    }
    //
    //    func makeContextMenu() -> UIMenu {
    //
    //        // Create a UIAction for sharing
    //        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
    //            // Show system share sheet
    //        }
    //
    //        let rename = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { action in
    //            // Show rename UI
    //        }
    //
    //        // Here we specify the "destructive" attribute to show that it’s destructive in nature
    //        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
    //            // Delete this photo 😢
    //        }
    //
    //        // The "title" will show up as an action for opening this menu
    //        let edit = UIMenu(title: "Edit...", children: [rename, delete])
    //
    //        // Create and return a UIMenu with the share action
    //        return UIMenu(title: "Main Menu", children: [share, rename, delete, edit])
    //    }
    //
    //    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
    //        animator.preferredCommitStyle = .pop
    //        if let vc = animator.previewViewController {
    //            animator.addCompletion {
    //                self.present(vc, animated: true, completion: nil)
    //            }
    //        }
    //    }
    
    override func tableView(_ tableView: UITableView,contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let progress = progresses[indexPath.row]
        
        // Create a UIAction for sharing
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { action in
            // Show system share sheet
        }
        
        let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { action in
            self.setEditAction(progress: progress)
        }
        
        // Here we specify the "destructive" attribute to show that it’s destructive in nature
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            self.deleteAction(progress: progress, indexPath: indexPath)
        }
        
        func getPreviewVC(indexPath: IndexPath) -> UIViewController? {
            if let destinationVC = storyboard?.instantiateViewController(identifier: "Entry") as? EntryViewController {
                destinationVC.progress = progresses[indexPath.row]
//                destinationVC.metrics = goal.metrics
                destinationVC.indexPathRow = indexPath.row
                destinationVC.indexPath = indexPath
                
                return destinationVC
            }
            
            return nil
        }
        
        return UIContextMenuConfiguration(identifier: "DetailPreview" as NSString, previewProvider: { getPreviewVC(indexPath: indexPath) }) { _ in
            UIMenu(title: "", children: [share, edit, delete])
        }
    }
}

//extension DetailTableViewController {
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { suggestedActions in
//
//            return self.makeContextMenu()
//        })
//    }
//
//    func makeContextMenu() -> UIMenu {
//
//        // Create a UIAction for sharing
//        let share = UIAction(title: "Share Pupper", image: UIImage(systemName: "square.and.arrow.up")) { action in
//            // Show system share sheet
//        }
//
//        let rename = UIAction(title: "Rename Pupper", image: UIImage(systemName: "square.and.pencil")) { action in
//            // Show rename UI
//        }
//
//        // Here we specify the "destructive" attribute to show that it’s destructive in nature
//        let delete = UIAction(title: "Delete Photo", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
//            // Delete this photo 😢
//        }
//
//        // The "title" will show up as an action for opening this menu
//        let edit = UIMenu(title: "Edit...", children: [rename, delete])
//
//        // Create and return a UIMenu with the share action
//        return UIMenu(title: "Main Menu", children: [share])
//    }
//
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
//
//        animator.addCompletion {
//
//            self.show(TestViewController(), sender: self)
//        }
//    }
//}

//extension DetailTableViewController {
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
//
//        let favorite = UIAction(title: "Favorite", image: UIImage(systemName: "heart.fill")) { _ in
//            // Perform action
//        }
//
//        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up.fill")) { action in
//            // Perform action
//        }
//
//        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill"), attributes: [.destructive]) { action in
//            // Perform action
//        }
//
//        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in UIMenu(title: "Actions", children: [favorite, share, delete])
//        }
//    }
//
//    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willCommitWithAnimator animator: UIContextMenuInteractionCommitAnimating) {
//
//        animator.addCompletion {
//
//            self.show(TestViewController(), sender: self)
//        }
//    }
//}
