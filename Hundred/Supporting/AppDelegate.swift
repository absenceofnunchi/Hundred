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
import StoreKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }

        // Attach an observer to the payment queue.
        SKPaymentQueue.default().add(StoreObserver.shared)
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
         print("user clicked on the notification2")
        let userInfo = response.notification.request.content.userInfo
        if let ck = userInfo["ck"] as? [String: NSObject], let qry = ck["qry"] as? [String: NSObject], let rid = qry["rid"]  {
            let publicDatabase = CKContainer.default().publicCloudDatabase
            let configuration = CKQueryOperation.Configuration()
            configuration.allowsCellularAccess = true
            configuration.qualityOfService = .userInitiated
            let recordId = CKRecord.ID(recordName: rid as! String)
            let predicate = NSPredicate(format: "recordID == %@", recordId)
            let query =  CKQuery(recordType: "Progress", predicate: predicate)
            let queryOperation = CKQueryOperation(query: query)
            queryOperation.desiredKeys = ["comment", "date", "goal", "metrics", "currentStreak", "longestStreak", "image", "longitude", "latitude", "username", "userId", "entryCount", "profileImage", "profileDetail"]
            queryOperation.queuePriority = .veryHigh
            queryOperation.configuration = configuration
            queryOperation.resultsLimit = 1
            queryOperation.recordFetchedBlock = { (record: CKRecord?) -> Void in
                if let record = record {
                    DispatchQueue.main.async {
                        // retrieve the root view controller (which is a tab bar controller)
                        guard let rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
                            return
                        }
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if  let UserDetailVC = storyboard.instantiateViewController(withIdentifier: "UserDetail") as? UserDetailViewController,
                            let tabBarController = rootViewController as? UITabBarController,
                            let navController = tabBarController.selectedViewController as? UINavigationController {
                                UserDetailVC.user = record
                                navController.pushViewController(UserDetailVC, animated: true)
                        }
                    }
                }
            }

            queryOperation.queryCompletionBlock = { (cursor: CKQueryOperation.Cursor?, error: Error?) -> Void in
                if let error = error {
                    print("queryCompletionBlock error: \(error)")
                    return
                }

            }
            publicDatabase.add(queryOperation)
        }
        
        completionHandler()
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("userInfo: \(userInfo)")
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Remove the observer.
        SKPaymentQueue.default().remove(StoreObserver.shared)
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
}
