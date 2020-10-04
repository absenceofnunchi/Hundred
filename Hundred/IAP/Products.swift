/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A BaseViewController subclass that displays a list of products available for sale in the App Store. Displays the localized title and price
 of each of these products using SKProduct. Also shows a list of product identifiers not recognized by the App Store if applicable. Calls
 StoreObserver to implement a purchase when a user taps a product.
*/

import UIKit
import StoreKit

class Products: IAPViewController {
    // MARK: - Types
    
    fileprivate struct CellIdentifiers {
        static let availableProduct = "available"
        static let invalidIdentifier = "invalid"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(PriceCell.self, forCellReuseIdentifier: Cells.priceCell)
        tableView.rowHeight = 150
        tableView.separatorStyle = .none
    }
    
    // MARK: - UITable​View​Data​Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.priceCell, for: indexPath) as! PriceCell
        let section = data[indexPath.section]
        
        if section.type == .availableProducts, let content = section.elements as? [SKProduct]  {
            let product = content[indexPath.row]
            cell.set(product: product, invalidProduct: nil)
            return cell
        } else if section.type == .invalidProductIdentifiers, let content = section.elements as? [String] {
            let invalidProduct = content[indexPath.row]
            cell.set(product: nil, invalidProduct: invalidProduct)
            return cell
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let section = data[indexPath.section]
//        
//        // If there are available products, show them.
//        if section.type == .availableProducts, let content = section.elements as? [SKProduct] {
//            let product = content[indexPath.row]
//
//            cell.set(product: product)
//
//        } else if section.type == .invalidProductIdentifiers, let content = section.elements as? [String] {
//            // if there are invalid product identifiers, show them.
////            cell.textLabel!.text = content[indexPath.row]
//        }
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20)) //set these values as necessary
        returnedView.backgroundColor = UIColor.white
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
        label.text = data[section].type.description
        label.textAlignment = .center
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    /// Starts a purchase when the user taps an available product row.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = data[indexPath.section]
        
        // Only available products can be bought.
        if section.type == .availableProducts, let content = section.elements as? [SKProduct] {
            let product = content[indexPath.row]
            
            // Attempt to purchase the tapped product.
            StoreObserver.shared.buy(product)
        }
    }
}
