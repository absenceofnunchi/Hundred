//
//  MoreCollectionViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-24.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

struct Menu {
    var title: String
    var image: String
    var tag: Int
}

enum SegueIdentifier: String {
    case SubscriptionSegue, FAQSegue, AccountSegue, FeedbackSegue
}

class MoreCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let follows = Menu(title: "Follows", image:"person.2", tag: 1)
    let FAQ = Menu(title: "FAQ", image: "questionmark.circle", tag: 2)
    let account = Menu(title: "Account", image: "person.crop.circle", tag: 3)
    let feedback = Menu(title: "Feedback", image: "exclamationmark.bubble", tag: 4)
    
    lazy var menus = [
        follows,
        FAQ,
        account,
        feedback
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(MoreCollectionViewCell.self, forCellWithReuseIdentifier: Cells.moreCell)
        if #available(iOS 13.0, *) {
            // Always adopt a light interface style.
            overrideUserInterfaceStyle = .light
        }
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

    }

    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return menus.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.moreCell, for: indexPath) as! MoreCollectionViewCell
        cell.data = menus[indexPath.row]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = view.frame.size.height
        let width = view.frame.size.width
        return CGSize(width: width * 0.4, height: height * 0.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = view.frame.size.width * 0.4
        let numberOfCells = floor(collectionView.frame.size.width / cellWidth)
        let edgeInsets = (collectionView.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        
        return UIEdgeInsets(top: 10, left: edgeInsets, bottom: 10, right: edgeInsets)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let segueIdentifier: String
        switch indexPath.row {
        case 0:
            segueIdentifier = SegueIdentifier.SubscriptionSegue.rawValue
        case 1:
            segueIdentifier = SegueIdentifier.FAQSegue.rawValue
        case 2:
            segueIdentifier = SegueIdentifier.AccountSegue.rawValue
        case 3:
            segueIdentifier = SegueIdentifier.FeedbackSegue.rawValue
        default:
            segueIdentifier = SegueIdentifier.SubscriptionSegue.rawValue
        }
        self.performSegue(withIdentifier: segueIdentifier, sender: self)
    }

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
