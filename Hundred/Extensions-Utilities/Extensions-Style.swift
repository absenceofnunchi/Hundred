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
    
    func pListURL() -> URL? {
        guard let result = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Heatmap.plist") else { return nil  }
        return result
    }
    
    func write(dictionary: [String: [String: Int]]) {
        if let url = pListURL() {
            do {
                let plistData = try PropertyListSerialization.data(fromPropertyList: dictionary, format: .xml, options: 0)
                try plistData.write(to: url)
            } catch {
                print(error)
            }
        }
    }
    
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
    
    func getCredentials(completion: @escaping (Profile?) -> Void) {
        // without checking for the internet access, the credential state will return .revoked or .notFound resulting in the deletion of the user identifier in Keychain
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let currentUserIdentifier = KeychainWrapper.standard.string(forKey: Keychain.userIdentifier.rawValue)
                appleIDProvider.getCredentialState(forUserID: currentUserIdentifier ?? "") { (credentialState, error) in
                    switch credentialState {
                    case .authorized:
                        DispatchQueue.main.async {
                            let request = Profile.createFetchRequest()
                            do {
                                let profiles = try self.context.fetch(request)
                                print("profiles.first \(profiles.first)")
                                completion(profiles.first)
                            } catch {
                                print("Fetch failed")
                            }
                        }
                        monitor.cancel()
                        break // The Apple ID credential is valid.
                    case .revoked:
                        print("revoked)")
                        // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                        KeychainWrapper.standard.removeObject(forKey: Keychain.userIdentifier.rawValue)
                        DispatchQueue.main.async {
                            let request = Profile.createFetchRequest()
                            do {
                                let profiles = try self.context.fetch(request)
                                for profile in profiles {
                                    self.context.delete(profile)
                                }
                            } catch {
                                print("Fetched failed from revoked")
                            }
                        }
                        monitor.cancel()
                        completion(nil)
                    case .notFound:
                        print("not found")
                        DispatchQueue.main.async {
                            let ac = UIAlertController(title: "iCloud Keychain", message: "If your iCloud keychain not enabled, please enable it. It allows you to use the follow feature on Public Feed as well as use the app in multiple devices.", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(_) in
                                KeychainWrapper.standard.removeObject(forKey: Keychain.userIdentifier.rawValue)
                                DispatchQueue.main.async {
                                    let request = Profile.createFetchRequest()
                                    do {
                                        let profiles = try self.context.fetch(request)
                                        for profile in profiles {
                                            self.context.delete(profile)
                                        }
                                    } catch {
                                        print("Fetched failed from revoked")
                                    }
                                }
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
                    default:
                        monitor.cancel()
                        break
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    let ac = UIAlertController(title: "Network Error", message: "You're currently not connected to the internet. This section requires an Internet access.", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                        _ = self.navigationController?.popViewController(animated: true)
                    }))
                    
                    if let popoverController = ac.popoverPresentationController {
                        popoverController.sourceView = self.view
                        popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                        popoverController.permittedArrowDirections = []
                    }
                    
                    self.present(ac, animated: true)
                    monitor.cancel()
                }
            }
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
            print("perRecordCompletionBlock error: \(error)")
        }
        
        operation.modifyRecordsCompletionBlock = { (savedRecords, deletedRecordIDs, error) in
            print("savedRecords: \(savedRecords)")
            print("deletedRecordIDs: \(deletedRecordIDs)")
            print("modifyRecordsCompletionBlock error: \(error)")
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
        
        // delete plist
        let formattedDate = self.dateForPlist(date: progress.date)
        if let url = self.pListURL() {
            if FileManager.default.fileExists(atPath: url.path) {
                do {
                    let dataContent = try Data(contentsOf: url)
                    if var dict = try PropertyListSerialization.propertyList(from: dataContent, format: nil) as? [String: [String: Int]] {
                        if var count = dict[progress.goal.title]?[formattedDate] {
                            if count > 0 {
                                count -= 1
                                dict[progress.goal.title]?[formattedDate] = count
                                self.write(dictionary: dict)
                            }
                        }
                    }
                } catch {
                    print("error :\(error.localizedDescription)")
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
