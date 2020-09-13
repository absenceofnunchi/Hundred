//
//  UserCell.swift
//  Hundred
//
//  Created by J C on 2020-09-09.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit
import Charts

struct FetchedAnalytics {
    var metricName: String
    var min: String
    var max: String
    var average: String
    var sum: String
}

class UserCell: UITableViewCell {
    var outerContainerView = UIView()
    var containerView = UIStackView()
    var coverImageView = UIImageView()
    var imageConstraints: [NSLayoutConstraint] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(user: CKRecord) {
        let metricCard = MetricCard()
        
        let title = user.object(forKey: MetricAnalytics.goal.rawValue) as? String
        let comment = user.object(forKey: "comment") as? String
        let entryCount = user.object(forKey: MetricAnalytics.entryCount.rawValue) as? Int
        // today's metric/value pair, not the analytics
        let metricsDict = try? user.decode(forKey: MetricAnalytics.metrics.rawValue) as [String: String]
        let currentStreak = user.object(forKey: MetricAnalytics.currentStreak.rawValue) as? Int
        let longestStreak = user.object(forKey: MetricAnalytics.longestStreak.rawValue) as? Int
        let fetchedAnalytics = try? user.decode(forKey: MetricAnalytics.analytics.rawValue) as [String : [String : String]]
        
        let titleLabelTheme = UILabelTheme(font: UIFont.body.with(weight: .bold), color: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0), lineBreakMode: .byTruncatingTail, textAlignment: .left)
        let titleLabel = UILabel(theme: titleLabelTheme, text: title ?? "")

        containerView.axis = .vertical
        containerView.spacing = 10
        
        containerView.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let commentLabel = CustomLabel()
        commentLabel.adjustsFontSizeToFitWidth = true
        commentLabel.sizeToFit()
        commentLabel.textColor = .darkGray
        commentLabel.numberOfLines = 0
        commentLabel.text = comment ?? ""
        
        let borderColor = UIColor.gray
        commentLabel.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        commentLabel.layer.borderWidth = 0.8
        commentLabel.layer.cornerRadius = 7.0
        
        containerView.addArrangedSubview(commentLabel)
        commentLabel.layoutIfNeeded()
        
        var barChart = BarChartView()
        barChart = metricCard.setupBarChart(entryCount: entryCount ?? 0)

        containerView.addArrangedSubview(barChart)
        barChart.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        let currentMetricsContainer = UIStackView()
        currentMetricsContainer.axis = .vertical
        currentMetricsContainer.spacing = 10
        currentMetricsContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        currentMetricsContainer.layer.borderWidth = 0.8
        currentMetricsContainer.layer.cornerRadius = 7.0
        currentMetricsContainer.translatesAutoresizingMaskIntoConstraints = false
        currentMetricsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = "Today's Metrics"
        subTitleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        subTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        subTitleLabel.textAlignment = .left
        
        currentMetricsContainer.addArrangedSubview(subTitleLabel)
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        subTitleLabel.widthAnchor.constraint(equalTo: currentMetricsContainer.widthAnchor, multiplier: 0.9).isActive = true
//        subTitleLabel.centerXAnchor.constraint(equalTo: currentMetricsContainer.centerXAnchor).isActive = true
//        subTitleLabel.topAnchor.constraint(equalTo: currentMetricsContainer.topAnchor, constant: 10).isActive = true
        
        if let metricsDict = metricsDict {
            print("metricsDict: \(metricsDict)")
            let metricsDictt = ["lbs": "23", "km": "223", "kg": "30", "jik": "209", "dkj": "2090"]
            for currentMetricPair in metricsDictt {
                let currentMetricLabel = UILabel()
                currentMetricLabel.text = currentMetricPair.key
                currentMetricsContainer.addArrangedSubview(currentMetricLabel)
                
//                currentMetricLabel.translatesAutoresizingMaskIntoConstraints = false
//                currentMetricLabel.leadingAnchor.constraint(equalTo: currentMetricsContainer.leadingAnchor).isActive = true
                
                let currentMetricValue = UILabel()
                currentMetricValue.text = currentMetricPair.value
                currentMetricsContainer.addArrangedSubview(currentMetricValue)
                
//                currentMetricValue.translatesAutoresizingMaskIntoConstraints = false
//                currentMetricValue.leadingAnchor.constraint(equalTo: currentMetricLabel.trailingAnchor).isActive = true
            }
        }
        
        containerView.addArrangedSubview(currentMetricsContainer)

        if let imageAsset = user.object(forKey: MetricAnalytics.image.rawValue) as? CKAsset {
            metricCard.loadCoverPhoto(imageAsset: imageAsset) { (image) in
                if let image = image {
                    self.coverImageView.image = image
                    self.coverImageView.contentMode = .scaleAspectFill
                    self.coverImageView.clipsToBounds = true
                }
            }
            
            self.outerContainerView.addSubview(self.coverImageView)
            NSLayoutConstraint.deactivate(imageConstraints)
                        
            self.coverImageView.translatesAutoresizingMaskIntoConstraints = false
            imageConstraints = [
                self.coverImageView.topAnchor.constraint(equalTo: self.outerContainerView.topAnchor),
                self.coverImageView.widthAnchor.constraint(equalTo: self.outerContainerView.widthAnchor),
                self.coverImageView.heightAnchor.constraint(equalTo: self.coverImageView.widthAnchor, multiplier: 9/16),
                self.containerView.topAnchor.constraint(equalTo: self.coverImageView.bottomAnchor, constant: 30),
                self.containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: commentLabel.frame.size.height + 20),
                //                self.outerContainerView.heightAnchor.constraint(equalToConstant: (outerContainerView.frame.size.width * 9/16) + containerView.frame.height + 30)
            ]
            NSLayoutConstraint.activate(imageConstraints)
            
        } else {
            NSLayoutConstraint.deactivate(imageConstraints)
            imageConstraints = [
                containerView.topAnchor.constraint(equalTo: outerContainerView.topAnchor, constant: 30),
                outerContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 250)
            ]
            NSLayoutConstraint.activate(imageConstraints)
        }
    }
    
    func configureUI() {
        addSubview(outerContainerView)
        BorderStyle.customShadowBorder(for: outerContainerView)
        outerContainerView.addSubview(containerView)
    }
    
    func setConstraints() {
        outerContainerView.translatesAutoresizingMaskIntoConstraints = false
        outerContainerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        outerContainerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        outerContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        outerContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.widthAnchor.constraint(equalTo: outerContainerView.widthAnchor, multiplier: 0.8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: outerContainerView.bottomAnchor, constant: -30).isActive = true
        containerView.centerXAnchor.constraint(equalTo: outerContainerView.centerXAnchor).isActive = true
    }
    
    //    override func didMoveToSuperview() {
    //        super.didMoveToSuperview()
    //        layoutIfNeeded()
    //    }
}

