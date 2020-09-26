//
//  ManagedObjectContext.swift
//  Hundred
//
//  Created by jc on 2020-08-02.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {

    var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentCloudKitContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    //    lazy var viewContext: NSManagedObjectContext = {
    //        return self.persistentContainer.viewContext
    //    }()
    //
    //    lazy var cacheContext: NSManagedObjectContext = {
    //        return self.persistentContainer.newBackgroundContext()
    //    }()
    //
//        lazy var updateContext: NSManagedObjectContext = {
//            let _updateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//            _updateContext.parent = self.viewContext
//            return _updateContext
//        }()
    
    var updateContext: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentCloudKitContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        let _updateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        _updateContext.parent = self.context
        return _updateContext
    }
    
    func saveContext() {
        if self.context.hasChanges {
            do {
//                try self.context.save()
                try self.updateContext.save()
            } catch {
                print("An error occurred while saving: \(error.localizedDescription)")
            }
        }
    }
}

