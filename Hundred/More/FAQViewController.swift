//
//  FAQViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-25.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

struct QandA {
    var question: String
    var answer: String
}

class FAQViewController: UITableViewController {
    let qanda1 = QandA(question: "How do I sign out?", answer: "The app uses the Sign in with Apple technology and in order to sign out you have to follow this simple procedure: \n \n1. Open the iOS Settings (outside of the app) \n2. Enter your iCloud settings \n3. Password & Security \n4. Apps using Apple ID \n5. Select the current app \n6. Stop using Apple ID")
    let qanda2 = QandA(question: "How do I change my username?", answer: "In the same way as above! You'll have to sign out first and you will be asked to create another username when you sign back in.")
    let qanda11 = QandA(question: "Will signing out of Sign in with Apple delete all of my data?", answer: "Nope!")
    let qanda3 = QandA(question: "Can I use the app without the iCloud account?", answer: "Absolutely! The iCloud account allows you to use the app in multiple different devices seamlessly and allows you to post your progress on the Public Feed, but if you only want to use the app in a single device and offline, then iCloud is not needed")
    let qanda4 = QandA(question: "Will any of my iCloud information show if I choose to post any entries on the Public Feed?", answer: "No. You get to choose any username you want through Sign in with Apple and your email will not be displayed.")
    let qanda5 = QandA(question: "What's the different between the contribution calendar and the horizontal bar chart?", answer: "The contribution calendar counts each entry as 1 contribution, which will be reflected on the calendar in incremental color gradients.  \nOn the other hand, the horizontal bar chart counts each day you create an entry as 1, which means 3 entries made in a single day will be counted as 1. The former focuses more on the total amount of effort where as the latter focuses on where you stand in the linear timeline.")
    let qanda6 = QandA(question: "What happens after 100 days in the horizontal bar chart?", answer: "The x-axis will increase in 100-day increments, which means it will jump to 200, 300, 400, and so on.")
    let qanda7 = QandA(question: "Where is all my progress information kept?", answer: "All of your information is kept locally on your phone and your own iCloud account only.  If you choose to post entries on the Public Feed, they get encrypted and stored very securely on Apple's server.")
    let qanda8 = QandA(question: "Why is iCloud Keychain needed?", answer: "This is only needed 1) if you want to use the app in multiple devices and 2) if you want to use the same username to post your entries on the Public Feed.  iCloud Keychain is Apple's own password management system and it securely stores the password you enter into Sign in with Apple.")
    let qanda9 = QandA(question: "What is Public Feed?", answer: "Public Feed is a way to share the progress towards your goals with others to create an encouraging community.  If you choose to post your entries on it, they will mirror your local entries.  Editing or deleting your local entry will also edit and delete the public entry.  Deleting the public entry, however, will not delete the local entry.")
    let qanda10 = QandA(question: "How do I edit my public entry?", answer: "As mentioned in the previous answer, the public entry mirrors the local entry. A local entry is what shows under the Goals tab.  If you edit your local entry, the public entry will also get edited.  However, editing or deleting the public entry will not edit or delete the local entry.")
    let qanda12 = QandA(question: "How do I change my metrics?", answer: "If you want to change the value of a metric from a specific Progress entry, you'll have to edit that very entry, either from the Progress menu (under the Goals tab) or the individual entry screen.  If you want to change what metrics you want to track per goal, you'll have to edit the Goal itself which can be done on the list of Goals on the Goals tab.  Changing the name of the metric will delete all the metric values tied to the previous metric name.")
    let qanda13 = QandA(question: "Can multiple people use the app on the same device?", answer: "Unfortunately, not at the moment.  If you absolutely must, have your iCloud enabled on your device to back up the current data (not to be confused with Sign in with Apple), delete the app, sign out of your iCloud accout and log back in with another account that belongs to the person that wants to use the app, and re-install the app. All of the Goal and Progress information tied to that particular person's iCloud account will be restored if there is any.")
    let qanda14 = QandA(question: "Does deleting an entry effect the contribution calendar?", answer: "Yes, deleting a local entry substracts from the contribution calendar count where as deleting the public entry won't.  Any entry edits will not have any effects on the calendar.")
    lazy var FAQarr = [
        qanda1,
        qanda2,
        qanda11,
        qanda3,
        qanda4,
        qanda5,
        qanda6,
        qanda7,
        qanda8,
        qanda9,
        qanda10,
        qanda12,
        qanda13,
        qanda14
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureUI()
    }
    
    func configureUI() {
        title = "FAQ"
        
        tableView.register(FAQTableViewCell.self, forCellReuseIdentifier: Cells.FAQCell)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.separatorStyle = .none
    }
}

// MARK: - Table view data source

extension FAQViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FAQarr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.FAQCell, for: indexPath) as! FAQTableViewCell
        cell.data = FAQarr[indexPath.row]
        return cell
    }
}

