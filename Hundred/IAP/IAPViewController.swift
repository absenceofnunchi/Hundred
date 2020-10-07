/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A base table view controller to share a data model between subclasses. Allows its subclasses to display product and purchase information.
 */

import UIKit

class IAPViewController: UITableViewController {
    // MARK: - Properties
    
    /// Data model used by all BaseViewController subclasses.
    var data = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Returns the number of sections.
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Returns the number of rows in the section.
        return data[section].elements.count
    }
}

// MARK: - BaseViewController Extension

/// Extends BaseViewController to refresh the UI with new data.
extension IAPViewController {
    func reload(with data: [Section]) {
        self.data = data
        tableView.reloadData()
    }
}
