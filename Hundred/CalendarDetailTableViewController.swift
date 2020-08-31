//
//  CalendarDetailTableViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-29.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreData

class CalendarDetailTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    struct Cells {
        static let calendarDetailCell = "CalendarDetailCell"
    }
    
    var fetchedResultsController: NSFetchedResultsController<Progress>?
    
    var date: [Int]! {
        didSet {
            let startDate = "\(date[0])-\(date[1])-\(date[2]) 00:00"
            let endDate = "\(date[0])-\(date[1])-\(date[2]) 23:59"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let formattedStartDate = dateFormatter.date(from: startDate)
            let formattedEndDate = dateFormatter.date(from: endDate)
            
            var progressPredicate: NSPredicate!
            
            if fetchedResultsController == nil {
                let request = Progress.createFetchRequest()
                let sort = NSSortDescriptor(key: "date", ascending: false)
                request.sortDescriptors = [sort]
                request.fetchBatchSize = 20
                progressPredicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", formattedStartDate! as CVarArg, formattedEndDate! as CVarArg)
                
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.context, sectionNameKeyPath: nil, cacheName: nil)
                fetchedResultsController?.delegate = self
            }
            
            fetchedResultsController!.fetchRequest.predicate = progressPredicate
            
            do {
                try fetchedResultsController?.performFetch()
            } catch {
                print("Fetch failed")
            }
            
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.register(CalendarCell.self, forCellReuseIdentifier: Cells.calendarDetailCell)
        tableView.rowHeight = 100
        tableView.allowsSelection = false
    }
}

// MARK: - Table view data source

extension CalendarDetailTableViewController {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.calendarDetailCell, for: indexPath) as! CalendarCell
        if let progress = fetchedResultsController?.object(at: indexPath) {
            cell.set(progress: progress)
            cell.animate()
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let goal = fetchedResultsController?.object(at: indexPath) {
                self.context.delete(goal)
                self.saveContext()
            }
        }
    }
    
}
