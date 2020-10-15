/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Manages the child view controllers: Products and Purchases. Displays a Restore button that allows you to restore all previously purchased
 non-consumable and auto-renewable subscription products. Requests product information about a list of product identifiers using StoreManager. Calls
 StoreObserver to implement the restoration of purchases.
*/

import UIKit

class ParentViewController: UIViewController {
    // MARK: - Types
    fileprivate enum Segment: Int {
        case products, purchases
    }
    
    // MARK: - Properties
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var restoreButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// contains the privacy button
    fileprivate let infoContainerView = UIView()
    fileprivate let privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Privacy Policy", for: .normal)
        button.titleLabel?.font = UIFont.caption
        button.setTitleColor(.black, for: .normal)
        button.tag = 1
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    fileprivate let termsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Terms of Use", for: .normal)
        button.titleLabel?.font = UIFont.caption
        button.setTitleColor(.black, for: .normal)
        button.tag = 2
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    fileprivate let infoBox: UIView = {
        let infoBox = UIView()
        return infoBox
    }()
    fileprivate let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Fine Print\n\nThe subscription allows you to post your entries on Public Feed so that you can share your progress with likeminded achievers. You can modify or delete your entries at any time.  Once you subscribe to one of the plans above, it will renew within 24 hours before the subscription period ends and you will be charged through your iTunes account.  You can manage your subscription in Account Settings and you can cancel your subscription at any time you want."
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.adjustsFontSizeToFitWidth = false
        return label
    }()
    
    fileprivate var utility = Utilities()
    fileprivate lazy var products: Products = {
        let identifier = ViewControllerIdentifiers.products
        guard let controller = storyboard?.instantiateViewController(withIdentifier: identifier) as? Products
            else { fatalError("\(Messages.unableToInstantiateProducts)") }
        return controller
    }()
    fileprivate lazy var purchases: Purchases = {
        let identifier = ViewControllerIdentifiers.purchases
        guard let controller = storyboard?.instantiateViewController(withIdentifier: identifier) as? Purchases
            else { fatalError("\(Messages.unableToInstantiatePurchases)") }
        return controller
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        // Disable or hide the button.
        restoreButton.disable()
        
        StoreManager.shared.delegate = self
        StoreObserver.shared.delegate = self
        
        // Fetch product information from App Store.
        fetchProductInformation()
        
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
    }
    
    // MARK: - Configure UI
    
    func configureUI() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: 950)
        
        scrollView.addSubview(infoBox)
        BorderStyle.customShadowBorder(for: infoBox)
        infoBox.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoBox.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 550),
            infoBox.heightAnchor.constraint(equalToConstant: 300),
            infoBox.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.85),
            infoBox.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        infoBox.addSubview(infoLabel)
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoLabel.widthAnchor.constraint(equalTo: infoBox.widthAnchor, multiplier: 0.90),
            infoLabel.heightAnchor.constraint(equalTo: infoBox.heightAnchor, multiplier: 0.90),
            infoLabel.centerXAnchor.constraint(equalTo: infoBox.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: infoBox.centerYAnchor)
        ])
        
        scrollView.addSubview(infoContainerView)
        infoContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoContainerView.heightAnchor.constraint(equalToConstant: 30),
            infoContainerView.topAnchor.constraint(equalTo: infoBox.bottomAnchor, constant: 20),
            infoContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.90),
            infoContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])

        infoContainerView.addSubview(privacyButton)
        privacyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privacyButton.widthAnchor.constraint(equalToConstant: 150),
            privacyButton.heightAnchor.constraint(equalToConstant: 30),
            privacyButton.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor)
        ])
        
        infoContainerView.addSubview(termsButton)
        termsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            termsButton.widthAnchor.constraint(equalToConstant: 150),
            termsButton.heightAnchor.constraint(equalToConstant: 30),
            termsButton.centerYAnchor.constraint(equalTo: infoContainerView.centerYAnchor),
            termsButton.trailingAnchor.constraint(equalTo: infoContainerView.trailingAnchor)
        ])
    }
    
    // MARK: Button Pressed for links
    
    @objc func buttonPressed(sender: UIButton!) {
        switch sender.tag {
        case 1:
            if let url = URL(string: "https://sites.google.com/view/thehundredapp/home") {
                UIApplication.shared.open(url)
            }
        case 2:
            if let url = URL(string: "https://sites.google.com/view/thehundredappterms/home") {
                UIApplication.shared.open(url)
            }
        default:
            print("default")
        }
    }
    
    // MARK: - Switching Between View Controllers
    
    /// Adds a child view controller to the container.
    fileprivate func addBaseViewController(_ viewController: IAPViewController) {
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.frame = scrollView.bounds
        scrollView.addSubview(viewController.view)
        
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            viewController.view.heightAnchor.constraint(equalToConstant: 500),
            viewController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.95),
            viewController.view.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        viewController.didMove(toParent: self)
    }
    
    /// Removes a child view controller from the container.
    fileprivate func removeBaseViewController(_ viewController: IAPViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    /// Switches between the Products and Purchases view controllers.
    fileprivate func switchToViewController(segment: Segment) {
        switch segment {
        case .products:
            removeBaseViewController(purchases)
            addBaseViewController(products)
        case .purchases:
            removeBaseViewController(products)
            addBaseViewController(purchases)
        }
    }
    
    // MARK: - Fetch Product Information
    
    /// Retrieves product information from the App Store.
    fileprivate func fetchProductInformation() {
        // First, let's check whether the user is allowed to make purchases. Proceed if they are allowed. Display an alert, otherwise.
        if StoreObserver.shared.isAuthorizedForPayments {
            restoreButton.enable()
            
            let resourceFile = ProductIdentifiers()
            guard let identifiers = resourceFile.identifiers else {
                // Warn the user that the resource file could not be found.
                alert(with: Messages.status, message: resourceFile.wasNotFound)
                return
            }
                        
            if !identifiers.isEmpty {
                switchToViewController(segment: .products)
                // Refresh the UI with identifiers to be queried.
                products.reload(with: [Section(type: .invalidProductIdentifiers, elements: identifiers)])
                
                // Fetch product information.
                StoreManager.shared.startProductRequest(with: identifiers)
            } else {
                // Warn the user that the resource file does not contain anything.
                alert(with: Messages.status, message: resourceFile.isEmpty)
            }
        } else {
            // Warn the user that they are not allowed to make purchases.
            alert(with: Messages.status, message: Messages.cannotMakePayments)
        }
    }
    
    // MARK: - Restore All Appropriate Purchases
    
    /// Called when tapping the "Restore" button in the UI.
    @IBAction func restore(_ sender: UIBarButtonItem) {
        // Calls StoreObserver to restore all restorable purchases.
        StoreObserver.shared.restore()
    }

    // MARK: - Handle Segmented Control Tap
    
    /// Called when tapping any segmented control in the UI.
    @IBAction func segmentedControlSelectionDidChange(_ sender: UISegmentedControl) {
        guard let segment = Segment(rawValue: sender.selectedSegmentIndex)
            else { fatalError("\(Messages.unknownSelectedSegmentIndex)\(sender.selectedSegmentIndex)).") }
        
        switchToViewController(segment: segment)
        switch segment {
        case .products: fetchProductInformation()
        case .purchases: purchases.reload(with: utility.dataSourceForPurchasesUI)
        }
    }
    
    // MARK: - Handle Restored Transactions
    
    /// Handles successful restored transactions. Switches to the Purchases view.
    fileprivate func handleRestoredSucceededTransaction() {
        utility.restoreWasCalled = true
        
        // Refresh the Purchases view with the restored purchases.
        switchToViewController(segment: .purchases)
        purchases.reload(with: utility.dataSourceForPurchasesUI)
        segmentedControl.selectedSegmentIndex = 1
    }
}

// MARK: - StoreManagerDelegate

/// Extends ParentViewController to conform to StoreManagerDelegate.
extension ParentViewController: StoreManagerDelegate {
    func storeManagerDidReceiveResponse(_ response: [Section]) {
        switchToViewController(segment: .products)
        // Switch to the Products view controller.
        products.reload(with: response)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    func storeManagerDidReceiveMessage(_ message: String) {
        alert(with: Messages.productRequestStatus, message: message)
    }
}

// MARK: - StoreObserverDelegate

/// Extends ParentViewController to conform to StoreObserverDelegate.
extension ParentViewController: StoreObserverDelegate {
    func storeObserverDidReceiveMessage(_ message: String) {
        alert(with: Messages.purchaseStatus, message: message)
    }
    
    func storeObserverRestoreDidSucceed() {
        handleRestoredSucceededTransaction()
    }
}
