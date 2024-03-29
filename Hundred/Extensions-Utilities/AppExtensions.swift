/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Creates extensions for the DateFormatter, ProductIdentifiers, Section, SKDownload, and SKProduct classes. Extends NSView and UIView to the
 DiscloseView protocol. Extends UIBarButtonItem to conform to the EnableItem protocol.
*/

#if os (macOS)
import Cocoa
#elseif os (iOS)
import UIKit
#endif
import Foundation
import StoreKit
import CloudKit
import MapKit
import Network
import AuthenticationServices
import CoreSpotlight
import MobileCoreServices
import CoreData
import Charts

// MARK: - DateFormatter

extension DateFormatter {
    /// - returns: A string representation of date using the short time and date style.
    class func short(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    
    /// - returns: A string representation of date using the long time and date style.
    class func long(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        return dateFormatter.string(from: date)
    }
}

// MARK: - Section

extension Section {
    /// - returns: A Section object matching the specified name in the data array.
    static func parse(_ data: [Section], for type: SectionType) -> Section? {
        let section = (data.filter({ (item: Section) in item.type == type }))
        return (!section.isEmpty) ? section.first : nil
    }
}

// MARK: - SKProduct
extension SKProduct {
    /// - returns: The cost of the product formatted in the local currency.
    var regularPrice: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}

// MARK: - SKDownload

extension SKDownload {
    /// - returns: A string representation of the downloadable content length.
    var downloadContentSize: String {
        return ByteCountFormatter.string(fromByteCount: self.expectedContentLength, countStyle: .file)
    }
}

// MARK: - DiscloseView

#if os (macOS)
extension NSView: DiscloseView {
    /// Show the view.
    func show() {
        self.isHidden = false
    }
    
    /// Hide the view.
    func hide() {
        self.isHidden = true
    }
}
#else
extension UIView: DiscloseView {
    /// Show the view.
    func show() {
        self.isHidden = false
    }
    
    /// Hide the view.
    func hide() {
        self.isHidden = true
    }
}

// MARK: - EnableItem

extension UIBarItem: EnableItem {
    /// Enable the bar item.
    func enable() {
        self.isEnabled = true
    }
    
    /// Disable the bar item.
    func disable() {
        self.isEnabled = false
    }
}
#endif

// MARK: - ProductIdentifiers

extension ProductIdentifiers {
    var isEmpty: String {
        return "\(key) from \(store) is empty. \(Messages.updateResource)"
    }
    
    var wasNotFound: String {
        return "\(Messages.couldNotFind) \(key) from \(store)."
    }
    
    /// - returns: An array with the product identifiers to be queried.
    var identifiers: [String]? {
        let keyValStore = NSUbiquitousKeyValueStore.default
        if let dict = keyValStore.array(forKey: key) as? [String] {
            return dict
        } else {
            let productIDs = [ProductIDs.oneMonth.rawValue, ProductIDs.sixMonths.rawValue, ProductIDs.oneYear.rawValue]
            keyValStore.set(productIDs, forKey: key)
            if let dict = keyValStore.array(forKey: key) as? [String] {
                return dict
            } else {
                return nil
            }
        }
    }

}

// MARK: - UIViewController

fileprivate var grayBackground: UIView?

extension UIViewController {
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        // your implementation here.
//    }
//    
    
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
        
        subItem.backgroundColor = UIColor.white
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
        print("\(year).\(month).\(day)")
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
    
    enum Keychain: String {
        case identifier
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
                CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
                    if error != nil {
                        self.permissionDeniedAlert(title: "Permission Error", message: "Sorry! There was an error checking for the permission status for your iCloud user discoverability. Please try again.")
                        monitor.cancel()
                    } else {
//                        self.processUserDiscoverability(status: status, monitor: monitor, completion: completion)
                    }
                }
            } else {
                self.permissionDeniedAlert(title: "Network Error", message: "You're currently not connected to the internet. This section requires an Internet access.")
                monitor.cancel()
            }
        }
    }
    
//    func processUserDiscoverability(status: CKContainer_Application_PermissionStatus, monitor: NWPathMonitor, completion: @escaping (Profile?) -> Void) {
//        switch status {
//        case .granted:
//            // only if the user grants the permission to obtain the iCloud ID, allow Sign in with Apple ID
//            // this is because the record ID is used in places like subscriptions
//            // it also allows fetching an accurate profile from Core Data using the record ID
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            let currentUserIdentifier = KeychainWrapper.standard.string(forKey: "userIdentifier")
//            appleIDProvider.getCredentialState(forUserID: currentUserIdentifier ?? "") { (credentialState, error) in
//                switch credentialState {
//                case .authorized:
//                    CKContainer.default().fetchUserRecordID { (record, error) in
//                        if error != nil {
//                            self.permissionDeniedAlert(title: "Error", message: "Sorry! There was an error fetching the Record ID of your iCloud account. Please try again")
//                            completion(nil)
//                            monitor.cancel()
//                        }
//                        if let record = record {
//                            // get the user's profile that has the current iCloud's record name in case there are multiple profiles
//                            DispatchQueue.main.async {
//                                let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
//                                fetchRequest.predicate = NSPredicate(format: "userId == %@", record.recordName)
//                                do {
//                                    let profiles = try self.context.fetch(fetchRequest)
//                                    completion(profiles.first)
//                                } catch {
//                                    print("Failed to fetch the user profile: \(error.localizedDescription)")
//                                    self.permissionDeniedAlert(title: "Fetch Error", message: "Sorry! There was an error fetching your profile. Please try again.")
//                                }
//                            }
//                            monitor.cancel()
//                        }
//                    }
//                    break
//                case .revoked:
//                    // The Apple ID credential is revoked, so show the sign-in UI if this is in ProfileVC.
////                    KeychainWrapper.standard.removeObject(forKey: Keychain.userIdentifier.rawValue)
////                    DispatchQueue.main.async {
////                        let fetchRequest = NSFetchRequest<Profile>(entityName: "Profile")
////                        do {
////                            let profiles = try self.context.fetch(fetchRequest)
////                            var emailArr: [String] = []
////                            for profile in profiles {
////                                self.context.delete(profile)
////                                emailArr.append(profile.email)
////                            }
////
////                            // deindex the account from Core Spotlight
////                            CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: emailArr) { (error) in
////                                if let error = error {
////                                    print("Deindexing error: \(error.localizedDescription)")
////                                } else {
////                                    print("Goal successfully deindexed")
////                                }
////                            }
////                        } catch {
////                            print("Fetched failed from revoked: \(error.localizedDescription)")
////                            self.permissionDeniedAlert(title: "Fetch Error", message: "Sorry! There was an error fetching your profile. Please try again.")
////                        }
////                    }
////                    monitor.cancel()
////                    completion(nil)
//                    break
//                case .notFound:
//                    DispatchQueue.main.async {
//                        let ac = UIAlertController(title: "iCloud Keychain", message: "Please ensure that your iCloud Keychain is not enabled in case it's not enabled. iCloud Keychain allows you to post on Public Feed as well as use the app in multiple devices.", preferredStyle: .alert)
//                        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(_) in
//                            monitor.cancel()
//                            completion(nil)
//                        }))
//
//                        if let popoverController = ac.popoverPresentationController {
//                            popoverController.sourceView = self.view
//                            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//                            popoverController.permittedArrowDirections = []
//                        }
//
//                        self.present(ac, animated: true)
//                    }
//                    break
//                default:
//                    completion(nil)
//                    monitor.cancel()
//                }
//            }
//        // the iCloud user discoverability is not granted
//        case .couldNotComplete, .denied:
//            DispatchQueue.main.async {
//                let ac = UIAlertController(title: "", message: "Your permission is required to obtain the unique record ID from your iCloud account.  Please see the FAQ section for more information.", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
//                    monitor.cancel()
//                    completion(nil)
//                }))
//
//                if let popoverController = ac.popoverPresentationController {
//                    popoverController.sourceView = self.view
//                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//                    popoverController.permittedArrowDirections = []
//                }
//
//                self.present(ac, animated: true)
//            }
//
//            break
//        case .initialState:
//            completion(nil)
//            monitor.cancel()
//        default:
//            print("default")
//        }
//    }
    
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
    
    func createButton(title: String?, image: String?, cornerRadius: CGFloat, color: UIColor, size: CGFloat?, tag: Int, selector: Selector) -> UIButton {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius
        
        if title != nil {
            button.setTitle(title, for: .normal)
        }
        
        if let image = image {
            if let size = size {
                let largeConfig = UIImage.SymbolConfiguration(pointSize: size, weight: .medium, scale: .large)
                let uiImage = UIImage(systemName: image, withConfiguration: largeConfig)
                
                button.tintColor = color
                button.setImage(uiImage, for: .normal)
            }
        }
        
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.tag = tag
        
        return button
    }
    
    func initializeHideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: - Fetch Profile

    /// Gets an existing profile from Core Data if there is one
    func fetchProfile() -> Profile? {
        var result: Any?
        let request = NSFetchRequest<Profile>(entityName: "Profile")
        do {
            let results = try self.context.fetch(request)
            if results.count > 0 {
                result = results.first
            } else {
                result = nil
            }
        } catch {
            let ac = UIAlertController(title: "Error", message: Messages.fetchError, preferredStyle: .alert)
            if let popoverController = ac.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.height, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                _ = self.navigationController?.popViewController(animated: true)
            }))
            
            present(ac, animated: true)
        }
        return result as? Profile
    }

    func checkDuplicateUsername(usernameText: String, completion: @escaping (Bool) -> Void) {
        var existingUsernames: [CKRecord] = []

        // Ensure the iCloud account and the network availability before checking for the username duplicate
        guard isICloudContainerAvailable() == true else { return }
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                let publicDatabase = CKContainer.default().publicCloudDatabase
                let predicate: NSPredicate!
                // predicate that matches the newly input username with the existing username on the public cloud container
                predicate = NSPredicate(format: "username == %@", usernameText)
                let query =  CKQuery(recordType: "Progress", predicate: predicate)
                let configuration = CKQueryOperation.Configuration()
                configuration.allowsCellularAccess = true
                configuration.qualityOfService = .userInitiated
                
                let queryOperation = CKQueryOperation(query: query)
                queryOperation.desiredKeys = ["username"]
                queryOperation.queuePriority = .veryHigh
                queryOperation.configuration = configuration
                // only needs to find one that matches the username
                queryOperation.resultsLimit = 1
                queryOperation.recordFetchedBlock = { (record: CKRecord?) -> Void in
                    if let record = record {
                        existingUsernames.append(record)
                        completion(false)
                        // if a matching username exists, show alert
                        let username = record.object(forKey: MetricAnalytics.username.rawValue) as? String
                        DispatchQueue.main.async {
                            self.alert(with: Messages.duplicateUsername, message: "Sorry, \(username ?? "the username") is already taken.")
                        }
                    }
                }
                
                queryOperation.queryCompletionBlock = { (cursor: CKQueryOperation.Cursor?, error: Error?) -> Void in
                    if let error = error {
                        print("queryCompletionBlock error: \(error)")
                        self.alert(with: "", message: Messages.networkError)
                        return
                    }
                    
                    print("completion")
                    if existingUsernames.count == 0 {
                        completion(true)
                        print("completion inside ")
                    }
                }
                
                publicDatabase.add(queryOperation)
                monitor.cancel()
            } else {
                monitor.cancel()
                self.alert(with: Messages.networkError, message: Messages.noNetwork)
            }
        }
    }
    
    // MARK: - Display Alert
    
    /// Creates and displays an alert.
    func alert(with title: String, message: String) {
        let utility = Utilities()
        
        DispatchQueue.main.async {
            let alertController = utility.alert(title, message: message)
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.navigationController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Fetch Public Feed
    
    /// In UsersVC, HistoryTableVC
    func fetchPublicFeed(userId: String?, searchWord: String?, desiredKeys: [String], completion: @escaping (CKRecord) -> Void) {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                let publicDatabase = CKContainer.default().publicCloudDatabase
                let predicate: NSPredicate!
                if let userId = userId {
                    predicate = NSPredicate(format: "userId == %@", userId)
                } else if let searchWord = searchWord, !searchWord.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                      predicate = NSPredicate(format: "%K BEGINSWITH %@", "goal", searchWord)
//                    let usernamePredicate = NSPredicate(format: "username == %@", searchWord.lowercased())
//                    predicate = NSPredicate(format: "title == %@ OR username == %@", searchWord.lowercased(), searchWord.lowercased())
                } else {
                    predicate = NSPredicate(value: true)
                }
                
                let query =  CKQuery(recordType: "Progress", predicate: predicate)
                let configuration = CKQueryOperation.Configuration()
                configuration.allowsCellularAccess = true
                configuration.qualityOfService = .userInitiated
                
                let queryOperation = CKQueryOperation(query: query)
                queryOperation.desiredKeys = desiredKeys
                queryOperation.queuePriority = .veryHigh
                queryOperation.configuration = configuration
                queryOperation.resultsLimit = 30
                queryOperation.recordFetchedBlock = { (record: CKRecord?) -> Void in
                    if let record = record {
                        completion(record)
                    }
                }
                
                queryOperation.queryCompletionBlock = { (cursor: CKQueryOperation.Cursor?, error: Error?) -> Void in
                    if let error = error {
                        print("queryCompletionBlock error: \(error)")
                        return
                    }
                    
                    if let cursor = cursor {
                    }
                }
                publicDatabase.add(queryOperation)
                monitor.cancel()
            } else {
                // if the network is absent
                DispatchQueue.main.async {
                    self.alert(with: Messages.networkError, message: Messages.noNetwork)
                }
                monitor.cancel()
            }
        }
    }
}

// MARK: - SKRequestDelegate

/// fetches App Store receipt and handles the response
extension UIViewController: SKRequestDelegate {
    func getAppReceipt(completion: @escaping (Bool) -> Void) {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let receiptData = try! Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                try validateReceipt(receiptData, completion: completion)
            } catch ReceiptValidationError.receiptNotFound {
                // There is no receipt on the device 😱
                print("There is no receipt on the device")
                alert(with: Messages.status, message: Messages.subscriptonNotPurchased)
                let appReceiptRefreshRequest = SKReceiptRefreshRequest(receiptProperties: nil)
                appReceiptRefreshRequest.delegate = self
                appReceiptRefreshRequest.start()
                // If all goes well control will land in the requestDidFinish() delegate method.
                // If something bad happens control will land in didFailWithError.
            } catch ReceiptValidationError.jsonResponseIsNotValid(let description) {
                // unable to parse the json 🤯
                alert(with: Messages.unabletoParseJson, message: description)
            } catch ReceiptValidationError.notBought {
                // the subscription hasn't being purchased 😒
                alert(with: Messages.status, message: Messages.subscriptonNotPurchased)
            } catch ReceiptValidationError.expired {
                // the subscription is expired 😵
                alert(with: Messages.status, message: Messages.expiredSubscription)
            } catch {
                print("Unexpected error: \(error).")
                alert(with: Messages.error, message: error.localizedDescription)
            }
        }
    }
    
    func validateReceipt(_ receiptData: Data, completion: @escaping (Bool) -> Void) throws {
        let base64encodedReceipt = receiptData.base64EncodedString()
        let requestDictionary = ["receipt-data":base64encodedReceipt, "password": "373aadbe71f24b4683da337912748a3c"]
        guard JSONSerialization.isValidJSONObject(requestDictionary) else {  print("requestDictionary is not valid JSON");  return }
        do {
            let requestData = try JSONSerialization.data(withJSONObject: requestDictionary)
            #if DEBUG
            let validationURLString = Endpoint.sandbox
            #else
            let validationURLString = Endpoint.itunes
            #endif
            guard let validationURL = URL(string: validationURLString) else { print("the validation url could not be created, unlikely error"); return }
            let session = URLSession(configuration: URLSessionConfiguration.default)
            var request = URLRequest(url: validationURL)
            request.httpMethod = "POST"
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
            let task = session.uploadTask(with: request, from: requestData) { (data, response, error) in
                guard let data = data, let httpResponse = response as? HTTPURLResponse, error == nil, httpResponse.statusCode == 200 else { return }
                guard let jsonResponse = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [AnyHashable: Any] else { return }
                guard let receiptInfo = (jsonResponse["latest_receipt_info"] as? [[AnyHashable: Any]]) else { return }
                guard let lastReceipt = receiptInfo.last else { return }
                        
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss VV"
                
                if let expiresString = lastReceipt["expires_date"] as? String {
                    if let formattedDate = formatter.date(from: expiresString) {
                        let isValid = formattedDate > Date().toLocalTime()
                        completion(isValid)
                    }
                }
            }
            task.resume()
        } catch let error as NSError {
            print("json serialization failed with error: \(error)")
        }
    }
    
//    func requestDidFinish(_ request: SKRequest) {
//        // a fresh receipt should now be present at the url
//        do {
//            let receiptData = try Data(contentsOf: appStoreReceiptURL!) //force unwrap is safe here, control can't land here if receiptURL is nil
//            try validateReceipt(receiptData)
//        } catch {
//            // still no receipt, possible but unlikely to occur since this is the "success" delegate method
//        }
//    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("app receipt refresh request did fail with error: \(error)")
    }
}

// MARK: - UILabelTheme

struct UILabelTheme {
    var font: UIFont?
    var color: UIColor?
    var lineBreakMode: NSLineBreakMode?
    var textAlignment: NSTextAlignment = .left
}

// MARK: - UILabel

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

// MARK: - UITableView

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

// MARK: - UIFont

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

// MARK: - UIView

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

// MARK: - CKRecord

extension CKRecord{
    var wasCreatedByThisUser: Bool{
        return (creatorUserRecordID == nil) || (creatorUserRecordID?.recordName == "__defaultOwner__")
    }
}

private let encoder: JSONEncoder = .init()
private let decoder: JSONDecoder = .init()

extension CKRecord {
    func decode<T>(forKey key: FieldKey) throws -> T where T: Decodable {
        guard let data = self[key] as? Data else {
            throw CocoaError(.coderValueNotFound)
        }
        
        return try decoder.decode(T.self, from: data)
    }
    
    func encode<T>(_ encodable: T, forKey key: FieldKey) throws where T: Encodable {
        self[key] = try encoder.encode(encodable)
    }
}

// MARK: - Sequence

extension Sequence where Element: Hashable {
    /// Returns true if no element is equal to any other element.
    func isDistinct() -> Bool {
        var set = Set<Element>()
        for e in self {
            if set.insert(e).inserted == false { return false }
        }
        return true
    }
}

// MARK: - Remove duplicates from an array

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

// MARK: - Date

// for calculating streaks in MetricCard.swift
extension Date {
    // break the date down to day, month, year
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    // adds a day to the date
    func addDay() -> Date {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return tomorrow!
    }
    
    // substracts a day from the date
    func subtractDay() -> Date {
        let tomorrow = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return tomorrow!
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // initialize with year, month, and day
    init(_ year:Int, _ month: Int, _ day: Int) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        self.init(timeInterval:0, since: Calendar.current.date(from: dateComponents)!)
    }
}

// MARK: - NSUIColor

// the colors for Charts
extension NSUIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}

// MARK: - String

// slice used in UserDetailViewController to extract a segment of String from an error message
extension String {
    func slice(from: String, to: String) -> String? {
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

// MARK: - UINavigationController

/// allows you to have an escaping closure after pushing a view controller
extension UINavigationController {
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: @escaping () -> Void) {
        pushViewController(viewController, animated: animated)

        guard animated, let coordinator = transitionCoordinator else {
            DispatchQueue.main.async { completion() }
            return
        }

        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
}
