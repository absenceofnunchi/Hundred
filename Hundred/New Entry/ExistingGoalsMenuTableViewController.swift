//
//  ExistingGoalsMenuTableViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-02.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreData

class ExistingGoalsMenuTableViewController: UITableViewController {
    var goals:[Goal] = []
    var isDismissed: ((Goal) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        do {
            let result = try self.context.fetch(fetchRequest)
            goals = result as! [Goal]
        } catch {
            print("error")
        }
        
        tabBarController?.tabBar.isHidden = true
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
        cell.textLabel?.text = goals[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goal = goals[indexPath.row]
        isDismissed?(goal)
        _ = navigationController?.popViewController(animated: true)
    }

}
