//
//  UserCell.swift
//  Hundred
//
//  Created by J C on 2020-09-09.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit

struct FetchedAnalytics {
    var metricName: String
    var min: String
    var max: String
    var average: String
    var sum: String
}

class UserCell: UITableViewCell {

    override func awakeFromNib() {
       super.awakeFromNib()
    }
    
    func set(user: CKRecord) {
        let metricCard = MetricCard()
        metricCard.createPublicMetricCard(user: user, cell: self)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }
}
