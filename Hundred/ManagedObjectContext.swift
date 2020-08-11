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
        return appDelegate.persistentContainer.viewContext
    }
    
//    var container : NSPersistentContainer {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegate.persistentContainer
//    }
    
    func saveContext() {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                print("An error occurred while saving: \(error.localizedDescription)")
            }
        }
    }
}

