//
//  AppDelegate.swift
//  Hundred
//
//  Created by jc on 2020-07-31.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
//    lazy var persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "Hundred")
//        container.loadPersistentStores { description, error in
//            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//            if let error = error {
//                fatalError("Unable to load persistent stores: \(error)")
//            }
//        }
//        return container
//    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("D'oh: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
        
        UNUserNotificationCenter.current().delegate = self

        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentCloudKitContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Hundred")
        
        //get the store description
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Could not retrieve a pesistent store description")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let cloudContext = persistentCloudKitContainer.viewContext
//        let context = persistentContainer.viewContext
        if cloudContext.hasChanges {
            do {
                try cloudContext.save()
//                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Spotlight
    
//    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        print("userActivity: \(userActivity)")
//        if userActivity.activityType == CSSearchableItemActionType {
//            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
//                print("uniqueIdentifier: \(uniqueIdentifier)")
//                if let navigationController = window?.rootViewController as? UINavigationController {
//                    print("navigationController: \(navigationController)")
//                    if let viewController = navigationController.topViewController as? DetailTableViewController {
//                        print("viewController: \(viewController)")
//                        let goalRequest = Goal.createFetchRequest()
//                        goalRequest.predicate = NSPredicate(format: "title == %@", uniqueIdentifier)
//                        if let fetchedGoal = try? persistentContainer.viewContext.fetch(goalRequest) {
//                            print("fetchedGoal: \(fetchedGoal)")
//                            if fetchedGoal.count > 0 {
//                                viewController.goal = fetchedGoal.first
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        return true
//    }

}

