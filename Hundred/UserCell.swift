//
//  UserCell.swift
//  Hundred
//
//  Created by J C on 2020-09-09.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit

class UserCell: UITableViewCell {

    override func awakeFromNib() {
       super.awakeFromNib()
    }
    
    func set(user: CKRecord) {
        let title = user.object(forKey: "goal") as? String
//        let comment = user.object(forKey: "comment") as? String
        let entryCount = user.object(forKey: "entryCount") as? Int
        let metricsDict = try? user.decode(forKey: "metrics") as [String: String]
        let currentStreak = user.object(forKey: "currentStreak") as? Int
        let longestStreak = user.object(forKey: "longestStreak") as? Int
        let min = user.object(forKey: MetricAnalytics.min.rawValue) as? String
        let max = user.object(forKey: MetricAnalytics.max.rawValue) as? String
        let avg = user.object(forKey: MetricAnalytics.avg.rawValue) as? String
        let sum = user.object(forKey: MetricAnalytics.sum.rawValue) as? String
        
        var analyticsDict: [String: String] = [:]
        if let min = min, let max = max, let avg = avg, let sum = sum {
            analyticsDict.updateValue(min, forKey: MetricAnalytics.min.rawValue)
            analyticsDict.updateValue(max, forKey: MetricAnalytics.max.rawValue)
            analyticsDict.updateValue(avg, forKey: MetricAnalytics.avg.rawValue)
            analyticsDict.updateValue(sum, forKey: MetricAnalytics.sum.rawValue)
        }
        
        let metricCard = MetricCard()
        let (metricContainer, cardHeight) = metricCard.createMetricCard(entryCount: entryCount, goal: nil, metricsDict: metricsDict, currentStreak: currentStreak, longestStreak: longestStreak)
        
        let container = UIView()
        BorderStyle.customShadowBorder(for: container)
        
        let label = UILabel()
        label.text = title
        label.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textAlignment = .left
        
        container.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.9).isActive = true
        label.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10).isActive = true

        container.addSubview(metricContainer)

        metricContainer.backgroundColor = .white
        metricContainer.translatesAutoresizingMaskIntoConstraints = false
        metricContainer.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30).isActive = true
        metricContainer.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier:  0.8).isActive = true
        metricContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30).isActive = true
        metricContainer.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        addSubview(container)
        
        inset(view: container, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        container.heightAnchor.constraint(greaterThanOrEqualToConstant: cardHeight).isActive = true
    }
    
    func inset(view: UIView, insets: UIEdgeInsets) {
      if let superview = view.superview {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: insets.left).isActive = true
        view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: -insets.right).isActive = true
        view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top).isActive = true
        view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom).isActive = true
      }
    }
}
