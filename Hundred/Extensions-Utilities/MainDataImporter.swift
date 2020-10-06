//
//  MainDataImporter.swift
//  Hundred
//
//  Created by jc on 2020-09-01.
//  Copyright © 2020 J. All rights reserved.
//

/*
 Abstract:
 Imports the Goal entity from Core Data
 */

import UIKit
import CoreData

struct MainDataImporter {
    lazy var data: [Goal]? = loadData()
    var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentCloudKitContainer.viewContext
    }
    

    func loadData() -> [Goal]? {
        var result: [Any]?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        do {
            result = try self.context.fetch(fetchRequest)
        } catch {
            print("Goal Data Importer error: \(error.localizedDescription)")
        }
        
        return result as? [Goal]
    }
}
