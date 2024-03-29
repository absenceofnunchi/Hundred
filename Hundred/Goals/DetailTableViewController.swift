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
import CloudKit

class DetailTableViewController: UITableViewController, UIContextMenuInteractionDelegate {
    var progresses: [Progress]!
    var goal: Goal! {
        didSet {
            progresses = goal.progress.sorted {$0.date > $1.date}
        }
    }
    var pullControl = UIRefreshControl()

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
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
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
            self.deleteAction(progress: progress, indexPath: indexPath)
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
        deleteSingleItem(progress: progress)
        self.progresses.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension DetailTableViewController {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView,contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let progress = progresses[indexPath.row]
        
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
                destinationVC.indexPathRow = indexPath.row
                destinationVC.indexPath = indexPath
                
                return destinationVC
            }
            
            return nil
        }
        
        return UIContextMenuConfiguration(identifier: "DetailPreview" as NSString, previewProvider: { getPreviewVC(indexPath: indexPath) }) { _ in
            UIMenu(title: "", children: [edit, delete])
        }
    }
}
