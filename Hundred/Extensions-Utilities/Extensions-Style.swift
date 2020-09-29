//
//  Style.swift
//  Hundred
//
//  Created by jc on 2020-08-18.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit
import MapKit
import Network
import AuthenticationServices
import CoreSpotlight
import MobileCoreServices
import CoreData

extension UIViewController {
    
    func addCard<T: UIView>(text: String, subItem: T, stackView: UIStackView, containerHeight: CGFloat? = 20, bottomSpacing: CGFloat? = 60, insert: Int? = nil, tag: Int? = 1, topInset: CGFloat? = 30, bottomInset: CGFloat? = -30, widthMultiplier: CGFloat? = 0.8, isShadowBorder: Bool? = true) {
        let container = UIView()
        if let tag = tag {
            container.tag = tag
        }
        
        if let isShadowBorder = isShadowBorder {
            if isShadowBorder {
                BorderStyle.customShadowBorder(for: container)
            } else {
                let borderColor = UIColor.gray
                container.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
                container.layer.borderWidth = 0.8
                container.layer.cornerRadius = 7.0
            }
        }
        
        if let insert = insert {
            stackView.insertArrangedSubview(container, at: insert)
        } else {
            stackView.addArrangedSubview(container)
        }
        
        if let height = containerHeight {
            container.translatesAutoresizingMaskIntoConstraints = false
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: height).isActive = true
        }
        
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textAlignment = .left
        
        container.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9).isActive = true
        label.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true
        
        container.addSubview(subItem)
        
        subItem.backgroundColor = .white
        subItem.translatesAutoresizingMaskIntoConstraints = false
        subItem.topAnchor.constraint(equalTo: label.bottomAnchor, constant: topInset ?? 30).isActive = true
        subItem.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: widthMultiplier ?? 0.8).isActive = true
        subItem.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: bottomInset ?? -30).isActive = true
        subItem.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        if let bottomSpacing = bottomSpacing {
            stackView.setCustomSpacing(bottomSpacing, after: container)
        }
    }
    
    
    func addHeader(text: String, stackView: UIStackView) {
        let label = UILabel()
        label.text = text
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        stackView.addArrangedSubview(label)
        stackView.setCustomSpacing(10, after: label)
        
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.8)
        l.heightAnchor.constraint(equalToConstant: 1).isActive = true
        stackView.addArrangedSubview(l)
        
        stackView.setCustomSpacing(20, after: l)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
//    
//    func pListURL() -> URL? {
//        guard let result = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Heatmap.plist") else { return nil  }
//        return result
//    }
//    
//    func write(dictionary: [String: [String: Int]]) {
//        if let url = pListURL() {
//            do {
//                let plistData = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0)
//                try plistData.write(to: url)
//            } catch {
//                print(error)
//            }
//        }
//    }
    
    func dateForPlist(date: Date) -> String {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return "\(year).\(month).\(day)"
    }
    
    func dayVariance(date: Date, value: Int) -> Date {
        let calendar = Calendar.current
        if let tomorrow = calendar.date(byAdding: .day, value: -1, to: date) {
            var components = calendar.dateComponents([.day, .year, .month, .hour, .minute, .second], from: tomorrow)
            components.hour = 23
            components.minute = 59
            components.second = 59
            
            guard let convertedDate = calendar.date(from: components) else {
                return date
            }
            
            return convertedDate
        }
        
        return date
    }
    
    
    func showSpinner<T: UIView>(container: T) {
        grayBackground = UIView(frame: self.view.bounds)
        grayBackground?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        grayBackground?.layer.cornerRadius = 10
        
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        
        grayBackground?.addSubview(activityIndicator)
        self.view.addSubview(grayBackground!)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        grayBackground?.translatesAutoresizingMaskIntoConstraints = false
        grayBackground?.widthAnchor.constraint(equalToConstant: 150).isActive = true
        grayBackground?.heightAnchor.constraint(equalToConstant: 150).isActive = true
        grayBackground?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        grayBackground?.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func removeSpinner() {
        grayBackground?.removeFromSuperview()
        grayBackground = nil
    }
    
    func parseAddress<T: MKPlacemark>(selectedItem: T) -> String {
        let firstSpace = (selectedItem.thoroughfare != nil && selectedItem.subThoroughfare != nil) ? " ": ""
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", ": ""
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " ": ""
        let addressLine = String(
            format: "%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            //city
            selectedItem.locality ?? "",
            secondSpace,
            // state or province
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    // get the previous vc in the nav stack
    var previousViewController: UIViewController? {
        if let vcs = navigationController?.viewControllers {
            return vcs.count > 1 ? vcs[vcs.count - 2] : nil
        }
        return nil
    }
    
    
    func isICloudContainerAvailable()->Bool {
        
        CKContainer.default().accountStatus { (accountStatus, error) in
            switch accountStatus {
            case .available:
                print("iCloud Available")
            case .noAccount:
                DispatchQueue.main.async {
                    self.iCloudAlert(message: "No iCloud account available")
                }
            case .restricted:
                DispatchQueue.main.async {
                    self.iCloudAlert(message: "The iCloud account seems to be restricted")
                }
            case .couldNotDetermine:
                DispatchQueue.main.async {
                    self.iCloudAlert(message: "Unable to determine the iCloud status")
                }
            default:
                DispatchQueue.main.async {
                    self.iCloudAlert(message: "Unable to determine the iCloud status")
                }
            }
        }
        
        
        if FileManager.default.ubiquityIdentityToken != nil {
            //print("User logged in")
            return true
        }
        else {
            //print("User is not logged in")
            return false
        }
    }
    
    func iCloudAlert(message: String) {
        let ac = UIAlertController(title: "Requires you to log into your iCloud", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(ac, animated: true, completion: {() -> Void in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.alertClose))
            ac.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
        })
    }
    
    @objc func alertClose(_ alert:UIAlertController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func permissionDeniedAlert(title: String, message: String) {
        DispatchQueue.main.async {
//            let ac = UIAlertController(title: "Permission Denied for Discoverability", message: "Since you have denied the discoverability through iCloud, others won't be able to subscribe to your postings, but you will still be able to subscribe to others who have given this permission. Your iCloud ID will not be visible to others, should you change your mind in the future. Please refer to the FAQ section more information.", preferredStyle: .alert)
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                _ = self.navigationController?.popViewController(animated: true)
            }))
            
//            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//            if var topController = keyWindow?.rootViewController {
//                while let presentedViewController = topController.presentedViewController {
//                    topController = presentedViewController
//                }
//
//                // topController should now be your topmost view controller
//                print("topController: \(topController.)")
//                if (topController is ProfileViewController) {
//
//                } else {
//                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
//                }
//            }
            
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(ac, animated: true)
        }
    }
    
    // 1. checks the iCloud availability
    // 2. checks the internet connectivity
    // 3. checks the status of the user discoverabiliy
    // 4. checks the Apple sign in from iCloud Keychain
    // 5. if yes to all, returns the profile from Core Data
    func getCredentials(completion: @escaping (Profile?) -> Void) {
        // check if the iCloud is available
        guard isICloudContainerAvailable() == true else { return }
        
        // if no internet access, the credential state will return .revoked or .notFound resulting in the potential deletion of the user identifier in Keychain
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // now that the internet is connected, check the status of user discoverability
                CKContainer.default().status(forApplicationPermission: .userDiscoverability) { (status, error) in
                    if error != nil {
                        self.permissionDeniedAlert(title: "Permission Error", message: "Sorry! There was an error checking for the permission status for your iCloud user discoverability. Please try again.")
                        monitor.cancel()
                    } else {
                        self.processUserDiscoverability(status: status, monitor: monitor, completion: completion)
                    }
                }
            } else {
                self.permissionDeniedAlert(title: "Network Error", message: "You're currently not connected to the internet. This section requires an Internet access.")
                monitor.cancel()
            }
        }
    }
    
    func processUserDiscoverability(status: CKContainer_Application_PermissionStatus, monitor: NWPathMonitor, completion: @escaping (Profile?) -> Void) {
        switch status {
        case .granted:
            // only if the user grants the permission to obtain the iCloud ID, allow Sign in with Apple ID
            // this is because the record ID is used in places like subscriptions
            // it also allows fetching an accurate profile from Core Data using the record ID
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let currentUserIdentifier = KeychainWrapper.standard.string(forKey: Keychain.userIdentifier.rawValue)
            appleIDProvider.getCredentialState(forUserID: currentUserIdentifier ?? "") { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    CKContainer.default().fetchUserRecordID { (record, error) in
                        if error != nil {
                            self.permissionDeniedAlert(title: "Error", message: "Sorry! There was an error fetching the Record ID of your iCloud account. Please try again")
                            completion(nil)
                            monitor.cancel()
                        }
                        if let record = record {
                            // get the user's profile that has the current iCloud's record name in case there are multiple profiles
                            DispatchQueue.main.async {
                                let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
                                fetchRequest.predicate = NSPredicate(format: "userId == %@", record.recordName)
                                do {
                                    let profiles = try self.context.fetch(fetchRequest)
                                    completion(profiles.first)
                                } catch {
                                    print("Failed to fetch the user profile: \(error.localizedDescription)")
                                    self.permissionDeniedAlert(title: "Fetch Error", message: "Sorry! There was an error fetching your profile. Please try again.")
                                }
                            }
                            monitor.cancel()
                        }
                    }
                    break
                case .revoked:
                    // The Apple ID credential is revoked, so show the sign-in UI if this is in ProfileVC.
                    KeychainWrapper.standard.removeObject(forKey: Keychain.userIdentifier.rawValue)
                    DispatchQueue.main.async {
                        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
                        do {
                            let profiles = try self.context.fetch(fetchRequest)
                            var emailArr: [String] = []
                            for profile in profiles {
                                self.context.delete(profile)
                                emailArr.append(profile.email)
                            }
                            
                            // deindex the account from Core Spotlight
                            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: emailArr) { (error) in
                                if let error = error {
                                    print("Deindexing error: \(error.localizedDescription)")
                                } else {
                                    print("Goal successfully deindexed")
                                }
                            }
                        } catch {
                            print("Fetched failed from revoked: \(error.localizedDescription)")
                            self.permissionDeniedAlert(title: "Fetch Error", message: "Sorry! There was an error fetching your profile. Please try again.")
                        }
                    }
                    monitor.cancel()
                    completion(nil)
                    break
                case .notFound:
                    DispatchQueue.main.async {
                        let ac = UIAlertController(title: "iCloud Keychain", message: "Please ensure that your iCloud Keychain is not enabled in case it's not enabled. iCloud Keychain allows you to post on Public Feed as well as use the app in multiple devices.", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(_) in
                            monitor.cancel()
                            completion(nil)
                        }))
                        
                        if let popoverController = ac.popoverPresentationController {
                            popoverController.sourceView = self.view
                            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                            popoverController.permittedArrowDirections = []
                        }
                        
                        self.present(ac, animated: true)
                    }
                    break
                default:
                    print("default")
                    completion(nil)
                    monitor.cancel()
                }
            }
        // the iCloud user discoverability is not granted
        case .couldNotComplete, .denied:
            DispatchQueue.main.async {
                let ac = UIAlertController(title: "", message: "Sorry! You permission is required to obtain the unique record ID from your iCloud account.  You are not required to display the iCloud email or your name on the Public Feed and can be changed to your preference. Please see the FAQ section for more information.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
                    CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
                        // recursive to ensure the integrity
                        self.processUserDiscoverability(status: status, monitor: monitor, completion: completion)
                    }
                }))
                
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    monitor.cancel()
                    completion(nil)
                }))
                
                if let popoverController = ac.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                
                self.present(ac, animated: true)
            }

            break
        case .initialState:
            completion(nil)
            monitor.cancel()
        default:
            print("default")
        }
    }
    
    // GoalVC, DetailVC, EntryVC
    func modifyRecords(recordsToSave: [CKRecord]?, recordIDsToDelete: [CKRecord.ID]?) {
        let operation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: recordIDsToDelete)
        let operationConfiguration = CKOperation.Configuration()
        
        operationConfiguration.allowsCellularAccess = true
        operationConfiguration.qualityOfService = .userInitiated
        operation.configuration = operationConfiguration
        
        operation.perRecordProgressBlock = {(record, progress) in
            print("perRecordProgressBlock: \(progress)")
        }
        
        operation.perRecordCompletionBlock = {(record, error) in
            print("Upload complete")
            print("perRecordCompletionBlock error: \(String(describing: error))")
        }
        
        operation.modifyRecordsCompletionBlock = { (savedRecords, deletedRecordIDs, error) in
            print("savedRecords: \(String(describing: savedRecords))")
            print("deletedRecordIDs: \(String(describing: deletedRecordIDs))")
            print("modifyRecordsCompletionBlock error: \(String(describing: error))")
        }
        
        let publicCloudDatabase = CKContainer.default().publicCloudDatabase
        publicCloudDatabase.add(operation)
    }
    
    // EntryVC, DetailTableVC
    func deleteSingleItem(progress: Progress) {
        // delete from the public container if it exists
        if let recordName = progress.recordName {
            let recordID = CKRecord.ID(recordName: recordName)
            modifyRecords(recordsToSave: nil, recordIDsToDelete: [recordID])
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
        
        // delete key/value for heatmap
        let formattedDate = self.dateForPlist(date: progress.date)
        let keyValStore = NSUbiquitousKeyValueStore.default
        if var dict = keyValStore.dictionary(forKey: "heatmap") as? [String : [String : Int]] {
            if var count = dict[progress.goal.title]?[formattedDate] {
                if count > 0 {
                    count -= 1
                    dict[progress.goal.title]?[formattedDate] = count
                    keyValStore.set(dict, forKey: "heatmap")
                    keyValStore.synchronize()
                }
            }
        }
        
//        if let url = self.pListURL() {
//            if FileManager.default.fileExists(atPath: url.path) {
//                do {
//                    let dataContent = try Data(contentsOf: url)
//                    if var dict = try PropertyListSerialization.propertyList(from: dataContent, format: nil) as? [String: [String: Int]] {
//                        if var count = dict[progress.goal.title]?[formattedDate] {
//                            if count > 0 {
//                                count -= 1
//                                dict[progress.goal.title]?[formattedDate] = count
//                                self.write(dictionary: dict)
//                            }
//                        }
//                    }
//                } catch {
//                    print("error :\(error.localizedDescription)")
//                }
//            }
//        }
        
        self.context.delete(progress)
        self.saveContext()
        
        if let mainVC = (self.tabBarController?.viewControllers?[0] as? UINavigationController)?.topViewController as? ViewController {
            // data for plist
            let dataImporter = DataImporter(goalTitle: nil)
            mainVC.data = dataImporter.loadData(goalTitle: nil)
            
            // Goal from Core Data
            let mainDataImporter = MainDataImporter()
            mainVC.goals = mainDataImporter.loadData()
        }
    }
    
    func alertForUsername() {
        let ac = UIAlertController(title: "No username", message: "A username is needed to post publicly. Would you like to create one?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if let vc = self.storyboard?.instantiateViewController(identifier: "Profile") as? ProfileViewController {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = ac.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(ac, animated: true)
    }
}

struct UILabelTheme {
    var font: UIFont?
    var color: UIColor?
    var lineBreakMode: NSLineBreakMode?
    var textAlignment: NSTextAlignment = .left
}

extension UILabel {
    convenience init(theme: UILabelTheme, text: String) {
        self.init()
        self.font = theme.font
        self.textColor = theme.color
        self.lineBreakMode = theme.lineBreakMode ?? .byTruncatingTail
        self.textAlignment = theme.textAlignment
        self.text = text
    }
}

struct UnitConversion {
    static func decimalToString(decimalNumber: NSDecimalNumber) -> String {
        let behavior = NSDecimalNumberHandler(roundingMode: .plain, scale: 1, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        return String(describing: decimalNumber.rounding(accordingToBehavior: behavior))
    }
    
    static func stringToDecimal(string: String) -> NSDecimalNumber {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: string) as? NSDecimalNumber ?? 0
    }
}

struct BorderStyle {
    static func customShadowBorder<T: UIView>(for object: T) {
        let borderColor = UIColor.gray
        object.layer.borderWidth = 1
        object.layer.masksToBounds = false
        object.layer.cornerRadius = 7.0;
        object.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        object.layer.shadowColor = UIColor.black.cgColor
        object.layer.shadowOffset = CGSize(width: 0, height: 0)
        object.layer.shadowOpacity = 0.2
        object.layer.shadowRadius = 4.0
        object.layer.backgroundColor = UIColor.white.cgColor
    }
}

fileprivate var grayBackground: UIView?

class CustomTextField: UITextField {
    let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
}

class CustomLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        super.drawText(in: rect.inset(by: insets))
    }
}

extension UITableView {
    func reloadWithAnimation() {
        self.reloadData()
        let cells = self.visibleCells
        var delayCounter = 0
        
        for cell in cells {
            cell.alpha = 0
            //            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        for cell in cells {
            UIView.animate(withDuration: 1.5, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
                cell.alpha = 1
            }, completion: nil)
            delayCounter += 1
        }
    }
}

extension UIFont {
    
    static var title1: UIFont {
        return UIFont.preferredFont(forTextStyle: .title1)
    }
    
    static var body: UIFont {
        return UIFont.preferredFont(forTextStyle: .body)
    }
    
    static var subheadline: UIFont {
        return UIFont.preferredFont(forTextStyle: .subheadline)
    }
    
    static var caption: UIFont {
        return UIFont.preferredFont(forTextStyle: .caption2)
    }
    
    func with(weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: pointSize, weight: weight)
    }
}

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float, bgColor: UIColor) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        backgroundColor = .white
        layer.backgroundColor =  bgColor.cgColor
    }
}
