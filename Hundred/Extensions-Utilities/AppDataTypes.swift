/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Handles the application's configuration information.
*/

import Foundation
import UIKit

// MARK: - Download Information

/// A structure that specifies a downloadable content's information that will be displayed to users.
struct DownloadContentLabels {
    static let contentIdentifier = "Identifier"
    static let contentVersion = "Version"
    static let contentLength = "Length"
    static let transactionDate = "Transaction Date"
    static let transactionIdentifier = "Transaction ID"
}

/// An enumeration that specifies whether a product has associated Apple-hosted content.
enum Hosted: String, CustomStringConvertible {
    case yes = "Yes"
    case not = "No"
    
    var description: String {
        return self.rawValue
    }
}

// MARK: - Message

/// A structure of messages that will be displayed to users.
struct Messages {
    #if os (iOS)
    static let cannotMakePayments = "\(notAuthorized) \(installing)"
    #else
    static let cannotMakePayments = "In-App Purchases are not allowed."
    #endif
    static let couldNotFind = "Could not find resource file:"
    static let deferred = "Allow the user to continue using your app."
    static let deliverContent = "Deliver content for"
    static let emptyString = ""
    static let error = "Error: "
    static let failed = "failed."
    static let installing = "In-App Purchases may be restricted on your device."
    static let invalidIndexPath = "Invalid selected index path"
    static let noRestorablePurchases = "There are no restorable purchases.\n\(previouslyBought)"
    static let noPurchasesAvailable = "No purchases available."
    static let notAuthorized = "You are not authorized to make payments."
    static let okButton = "OK"
    static let cancelButton = "Cancel"
    static let previouslyBought = "Only previously bought non-consumable products and auto-renewable subscriptions can be restored."
    static let productRequestStatus = "Product Request Status"
    static let purchaseOf = "Purchase of"
    static let purchaseStatus = "Purchase Status"
    static let removed = "was removed from the payment queue."
    static let restorable = "All restorable transactions have been processed by the payment queue."
    static let restoreContent = "Restore content for"
    static let status = "Status"
    static let unableToInstantiateAvailableProducts = "Unable to instantiate an AvailableProducts."
    static let unableToInstantiateInvalidProductIds = "Unable to instantiate an InvalidProductIdentifiers."
    static let unableToInstantiateMessages = "Unable to instantiate a MessagesViewController."
    static let unableToInstantiateNavigationController = "Unable to instantiate a navigation controller."
    static let unableToInstantiateProducts = "Unable to instantiate a Products."
    static let unableToInstantiatePurchases = "Unable to instantiate a Purchases."
    static let unableToInstantiateSettings = "Unable to instantiate a Settings."
    static let unknownPaymentTransaction = "Unknown payment transaction case."
    static let unknownDestinationViewController = "Unknown destination view controller."
    static let unknownDetail = "Unknown detail row:"
    static let unknownPurchase = "No selected purchase."
    static let unknownSelectedSegmentIndex = "Unknown selected segment index: "
    static let unknownSelectedViewController = "Unknown selected view controller."
    static let unknownTabBarIndex = "Unknown tab bar index:"
    static let unknownToolbarItem = "Unknown selected toolbar item: "
    static let updateResource = "Update it with your product identifiers to retrieve product information."
    static let useStoreRestore = "Use Store > Restore to restore your previously bought non-consumable products and auto-renewable subscriptions."
    static let viewControllerDoesNotExist = "The main content view controller does not exist."
    static let windowDoesNotExist = "The window does not exist."
    static let fetchError = "There was an error fetching data. Please try again."
    static let emptyUsername = "Username cannot be empty."
    static let delete = "Delete"
    static let deleteProfile = "Are you sure you want to delete your profile? You will lose all your entries on Public Feed and your followers."
    static let cancel = "Cancel"
    static let networkError = "Network Error"
    static let noNetwork = "You're currently not connected to the internet. This section requires an Internet access."
    static let noProfileCreated = "You don't have a profile created"
    static let modifyPublicEntry = "Looks like you've posted this entry on Public Feed as well. Would you like to modify both the local entry and the public entry?"
    static let onlyLocal = "Only the local entry"
    static let createProfile = "You need to either log in or create a profile.  Would you like to login/create a profile?"
    static let noCamera = "Camera Not Available"
    static let noPhotoLibrary = "Photo Library Not Available"
    static let subscriptionExpired = "Looks like your renewable subscription has expired. Would you like to renew it?"
    static let duplicateUsername = "Duplicate Username"
    static let unabletoParseJson = "Unable to parse the json"
    static let subscriptonNotPurchased = "The subscription hasn't been purchased"
    static let expiredSubscription = "The subscription is expired"
    static let unknownError = "Unknown error"
}

// MARK: - Resource File
enum ProductIDs: String {
    case oneMonth = "com.noName.Hundred"
    case sixMonths = "com.noName.Hundred6months"
    case oneYear = "com.noName.Hundred1year"
}

/// A structure that specifies the property name and NSUbiquitousKeyValueStore from iCloud, which contains the product identifiers to be queried.
struct ProductIdentifiers {
    /// Name of the key for the array of product identifiers.
    let key = "productIds"
    /// iCloud key/value store
    let store = "NSUbiquitousKeyValueStore"
}

// MARK: - Data Management

/// An enumeration of all the types of products or purchases.
enum SectionType: String, CustomStringConvertible {
    #if os (macOS)
    case availableProducts = "Available Products"
    case invalidProductIdentifiers = "Invalid Product Identifiers"
    case purchased = "Purchased"
    case restored = "Restored"
    #else
    case availableProducts = "AVAILABLE PRODUCTS"
    case invalidProductIdentifiers = "INVALID PRODUCT IDENTIFIERS"
    case purchased = "PURCHASED"
    case restored = "RESTORED"
    #endif
    case download = "DOWNLOAD"
    case originalTransaction = "ORIGINAL TRANSACTION"
    case productIdentifier = "PRODUCT IDENTIFIER"
    case transactionDate = "TRANSACTION DATE"
    case transactionIdentifier = "TRANSACTION ID"
    
    var description: String {
        return self.rawValue
    }
}

/// A structure that is used to represent a list of products or purchases.
struct Section {
    /// Products/Purchases are organized by category.
    var type: SectionType
    /// List of products/purchases.
    var elements = [Any]()
}

// MARK: - View Controllers

/// A structure that specifies all the view controller identifiers.
struct ViewControllerIdentifiers {
    static let availableProducts = "availableProducts"
    static let invalidProductdentifiers = "invalidProductIdentifiers"
    static let messages = "messages"
    static let products = "products"
    static let purchases = "purchases"
    static let createProfile = "createProfile"
    static let showProfile = "showProfile"
    static let map = "Map"
    static let profile = "Profile"
    static let calenderDetail = "CalendarDetail"
    static let userProfile = "userProfile"
    static let history = "history"
}

/// An enumeration of view controller names.
enum ViewControllerNames: String, CustomStringConvertible {
    case messages = "Messages"
    case products = "Products"
    case purchases = "Purchases"
    
    var description: String {
        return self.rawValue
    }
}

// MARK: - Custom Cells

/// Custom cells for table views
struct Cells {
    static let goalCell = "GoalCell"
    static let calendarDetailCell = "CalendarDetailCell"
    static let userCell = "UserCell"
    static let progressCell = "ProgressCell"
    static let moreCell = "MoreCell"
    static let FAQCell = "FAQCell"
    static let priceCell = "PriceCell"
    static let purchases = "purchases"
    static let cell = "Cell"
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
//        object.layer.borderWidth = 1
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

enum ReceiptValidationError: Error {
    case receiptNotFound
    case jsonResponseIsNotValid(description: String)
    case notBought
    case expired
}

// MARK: - MetricAnalytics

/// for public cloud container
enum MetricAnalytics: String {
    case Progress
    case goal
    case comment
    case metrics
    case image
    case longitude, latitude
    case date
    case Min, Max, Average, Sum
    case analytics
    case entryCount
    case longestStreak, currentStreak
    case metricTitle
    case username, detail, userId
    case profileImage, profileDetail
}

// MARK: - Endpoints

struct Endpoint {
    static let sandbox = "https://sandbox.itunes.apple.com/verifyReceipt"
    static let itunes = "https://buy.itunes.apple.com/verifyReceipt"
}
