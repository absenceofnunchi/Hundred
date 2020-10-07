/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Creates the DiscloseView, EnableItem, SettingsDelegate, StoreManagerDelegate, and StoreObserverDelegate protocols that allow you to
 show/hide UI elements, enable/disable UI elements, notifies a listener about restoring purchases, manage StoreManager operations, and handle
 StoreObserver operations, respectively.
*/

import Foundation
import MapKit

// MARK: - DiscloseView

protocol DiscloseView {
    func show()
    func hide()
}

// MARK: - EnableItem

protocol EnableItem {
    func enable()
    func disable()
}

// MARK: - StoreManagerDelegate

protocol StoreManagerDelegate: AnyObject {
    /// Provides the delegate with the App Store's response.
    func storeManagerDidReceiveResponse(_ response: [Section])
    
    /// Provides the delegate with the error encountered during the product request.
    func storeManagerDidReceiveMessage(_ message: String)
}

// MARK: - StoreObserverDelegate

protocol StoreObserverDelegate: AnyObject {
    /// Tells the delegate that the restore operation was successful.
    func storeObserverRestoreDidSucceed()
    
    /// Provides the delegate with messages.
    func storeObserverDidReceiveMessage(_ message: String)
}

// MARK: - SettingsDelegate

protocol SettingsDelegate: AnyObject {
    /// Tells the delegate that the user has requested the restoration of their purchases.
    func settingDidSelectRestore()
}

// MARK: - CreateProfileProtocol

protocol CreateProfileProtocol: AnyObject {
    func runFetchProfile()
}

// MARK: - PassProfileProtocol

protocol PassProfileProtocol: AnyObject {
    func passProfile(profile: Profile)
}

// MARK: - HandleLocation

protocol HandleLocation {
    func fetchPlacemark(placemark: MKPlacemark)
}

// MARK: - CallBackDelegeat

/// for EntryVC
protocol CallBackDelegate {
    func callBack(value: Progress, location: CLLocationCoordinate2D?, locationLabel: String?)
}
