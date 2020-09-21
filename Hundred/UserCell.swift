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
    var imageConstraints: [NSLayoutConstraint] = []
    var coverImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(outerContainerView: UIView, containerView: UIView) {
        addSubview(outerContainerView)
        BorderStyle.customShadowBorder(for: outerContainerView)
        outerContainerView.addSubview(containerView)
    }
    
    func setConstraints(outerContainerView: UIView, containerView: UIView) {
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
    
    
    func set(user: CKRecord) {
//        CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
//            CKContainer.default().fetchUserRecordID { (record, error) in
//                CKContainer.default().discoverUserIdentity(withUserRecordID: user.recordID, completionHandler: { (userID, error) in
//                    print("hasiCloudAccount: \(userID?.hasiCloudAccount)")
//                    print(userID?.lookupInfo?.phoneNumber)
//                    print(userID?.lookupInfo?.emailAddress)
//                    print((userID?.nameComponents ?? ""))
//                })
//            }
//        }
        
//        CKContainer.default().fetchUserRecordID(completionHandler: { (recordId, error) in
//            print("fetchUserRecordID: \(recordId)")
//
//            if let name = recordId?.recordName {
//               print("iCloud ID: " + name)
//            } else if let error = error {
//               print(error.localizedDescription)
//            }
//        })
        
        // includes the image and the containerView
        let outerContainerView = UIView()
        // excludes the image
        let containerView = UIStackView()
        containerView.axis = .vertical
        containerView.spacing = 20
        let metricCard = MetricCard()
        
        configureUI(outerContainerView: outerContainerView, containerView: containerView)
        setConstraints(outerContainerView: outerContainerView, containerView: containerView)
        
        let title = user.object(forKey: MetricAnalytics.goal.rawValue) as? String
        let date = user.object(forKey: MetricAnalytics.date.rawValue) as? Date
        let username = user.object(forKey: MetricAnalytics.username.rawValue) as? String
        let comment = user.object(forKey: MetricAnalytics.comment.rawValue) as? String
        let entryCount = user.object(forKey: MetricAnalytics.entryCount.rawValue) as? Int
        // today's metric/value pair, not the analytics
        let metricsDict = try? user.decode(forKey: MetricAnalytics.metrics.rawValue) as [String: String]
        let currentStreak = user.object(forKey: MetricAnalytics.currentStreak.rawValue) as? Int
        let longestStreak = user.object(forKey: MetricAnalytics.longestStreak.rawValue) as? Int
        
        // title
        let titleLabelTheme = UILabelTheme(font: UIFont.body.with(weight: .bold), color: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0), lineBreakMode: .byTruncatingTail, textAlignment: .left)
        let titleLabel = UILabel(theme: titleLabelTheme, text: title ?? "")
        
        containerView.addArrangedSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // date
        if let date = date {
            let dateLabelTheme = UILabelTheme(font: UIFont.caption.with(weight: .regular), color: .gray, lineBreakMode: .byTruncatingTail, textAlignment: .right)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d y"
            let dateLabel = UILabel(theme: dateLabelTheme, text: dateFormatter.string(from: date))
            containerView.addArrangedSubview(dateLabel)
            dateLabel.translatesAutoresizingMaskIntoConstraints = false
            dateLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
            containerView.setCustomSpacing(0, after: dateLabel)
        }

        // username
        if let username = username {
            let usernameLabelTheme = UILabelTheme(font: UIFont.caption, color: .darkGray, lineBreakMode: .byTruncatingTail, textAlignment: .right)
            let usernameLabel = UILabel(theme: usernameLabelTheme, text: username)
            containerView.addArrangedSubview(usernameLabel)
            usernameLabel.translatesAutoresizingMaskIntoConstraints = false
            usernameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        
        // comment
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
        
        let streakContainer = UIView()
        streakContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        streakContainer.layer.borderWidth = 0.8
        streakContainer.layer.cornerRadius = 7.0
        containerView.addArrangedSubview(streakContainer)
        
        streakContainer.translatesAutoresizingMaskIntoConstraints = false
        streakContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //longest, current streaks
        let unitLabelTheme = UILabelTheme(font: UIFont.caption.with(weight: .bold), color: .lightGray, lineBreakMode: .byTruncatingTail)
        let currentStreakTitle = UILabel(theme: unitLabelTheme, text: "Current Streak")
        let longestStreakTitle = UILabel(theme: unitLabelTheme, text: "Longest Streak")
        
        let currentStreakLabel = UILabel()
        currentStreakLabel.text = String(currentStreak ?? 0)
        
        let longestStreakLabel = UILabel()
        longestStreakLabel.text = String(longestStreak ?? 0)
        
        streakContainer.addSubview(currentStreakLabel)
        streakContainer.addSubview(longestStreakLabel)
        streakContainer.addSubview(currentStreakTitle)
        streakContainer.addSubview(longestStreakTitle)
        
        currentStreakLabel.translatesAutoresizingMaskIntoConstraints = false
        currentStreakLabel.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        currentStreakLabel.leadingAnchor.constraint(equalTo: streakContainer.leadingAnchor, constant: 15).isActive = true
        currentStreakLabel.topAnchor.constraint(equalTo: streakContainer.topAnchor, constant: 10).isActive = true
        
        longestStreakLabel.translatesAutoresizingMaskIntoConstraints = false
        longestStreakLabel.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        longestStreakLabel.leadingAnchor.constraint(equalTo: currentStreakLabel.trailingAnchor, constant: 5).isActive = true
        longestStreakLabel.topAnchor.constraint(equalTo: streakContainer.topAnchor, constant: 10).isActive = true
        
        currentStreakTitle.translatesAutoresizingMaskIntoConstraints = false
        currentStreakTitle.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        currentStreakTitle.topAnchor.constraint(equalTo: currentStreakLabel.bottomAnchor).isActive = true
        currentStreakTitle.leadingAnchor.constraint(equalTo: streakContainer.leadingAnchor, constant: 15).isActive = true
        currentStreakTitle.bottomAnchor.constraint(greaterThanOrEqualTo: streakContainer.bottomAnchor, constant: -10).isActive = true
        
        longestStreakTitle.translatesAutoresizingMaskIntoConstraints = false
        longestStreakTitle.widthAnchor.constraint(equalTo: streakContainer.widthAnchor, multiplier: 0.5).isActive = true
        longestStreakTitle.leadingAnchor.constraint(equalTo: currentStreakTitle.trailingAnchor, constant: 5).isActive = true
        longestStreakTitle.topAnchor.constraint(equalTo: longestStreakLabel.bottomAnchor).isActive = true
        longestStreakTitle.bottomAnchor.constraint(greaterThanOrEqualTo: streakContainer.bottomAnchor, constant: -10).isActive = true
        
        // bar chart
        var barChart = BarChartView()
        barChart = metricCard.setupBarChart(entryCount: entryCount ?? 0)
        
        containerView.addArrangedSubview(barChart)
        barChart.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // current metrics
        let currentMetricsContainer = UIStackView()
        currentMetricsContainer.axis = .vertical
        currentMetricsContainer.alignment = .fill
        currentMetricsContainer.spacing = 10
        currentMetricsContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        currentMetricsContainer.layer.borderWidth = 0.8
        currentMetricsContainer.layer.cornerRadius = 7.0
        currentMetricsContainer.translatesAutoresizingMaskIntoConstraints = false
        currentMetricsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        
        if let metricsDict = metricsDict, !metricsDict.isEmpty {
            let subTitleLabel = CustomLabel()
            subTitleLabel.text = "Today's Metrics"
            subTitleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
            subTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
            subTitleLabel.textAlignment = .left
            
            currentMetricsContainer.addArrangedSubview(subTitleLabel)
//            let metricsDictt = ["lbs": "23", "km": "223", "kg": "30", "jik": "209", "dkj": "2090"]
            for currentMetricPair in metricsDict {
                let pairContainer = UIView()
                
                currentMetricsContainer.addArrangedSubview(pairContainer)
                pairContainer.translatesAutoresizingMaskIntoConstraints = false
                pairContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
                let currentMetricLabel = UILabel()
                currentMetricLabel.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
                currentMetricLabel.layer.borderWidth = 0.8
                //                currentMetricLabel.layer.cornerRadius = 7.0
                currentMetricLabel.text = currentMetricPair.key
                currentMetricLabel.textAlignment = .center
                currentMetricLabel.lineBreakMode = .byTruncatingTail
                currentMetricLabel.backgroundColor = UIColor(red: 104/255, green: 144/255, blue: 136/255, alpha: 1.0)
                currentMetricLabel.textColor = .white
                pairContainer.addSubview(currentMetricLabel)
                
                let currentMetricValue = UILabel()
                currentMetricValue.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
                currentMetricValue.layer.borderWidth = 0.8
                currentMetricValue.text = currentMetricPair.value
                currentMetricValue.textAlignment = .center
                currentMetricValue.lineBreakMode = .byTruncatingTail
                pairContainer.addSubview(currentMetricValue)
                
                currentMetricLabel.translatesAutoresizingMaskIntoConstraints = false
                currentMetricLabel.leadingAnchor.constraint(equalTo: pairContainer.leadingAnchor, constant: 13).isActive = true
                currentMetricLabel.trailingAnchor.constraint(equalTo: currentMetricValue.leadingAnchor).isActive = true
                currentMetricLabel.widthAnchor.constraint(greaterThanOrEqualTo: pairContainer.widthAnchor, multiplier: 0.45).isActive = true
                currentMetricLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
                
                currentMetricValue.translatesAutoresizingMaskIntoConstraints = false
                currentMetricValue.leadingAnchor.constraint(equalTo: currentMetricLabel.trailingAnchor).isActive = true
                currentMetricValue.trailingAnchor.constraint(equalTo: pairContainer.trailingAnchor, constant: -13).isActive = true
                currentMetricValue.widthAnchor.constraint(greaterThanOrEqualTo: pairContainer.widthAnchor, multiplier: 0.45).isActive = true
                currentMetricValue.heightAnchor.constraint(equalToConstant: 30).isActive = true
            }
        } else {
            let subTitleLabel = CustomLabel()
            subTitleLabel.text = "No Metrics"
            subTitleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
            subTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
            subTitleLabel.textAlignment = .center
            
            currentMetricsContainer.addArrangedSubview(subTitleLabel)
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
            
            outerContainerView.addSubview(coverImageView)
            NSLayoutConstraint.deactivate(imageConstraints)
            
            coverImageView.translatesAutoresizingMaskIntoConstraints = false
            imageConstraints = [
                coverImageView.topAnchor.constraint(equalTo: outerContainerView.topAnchor),
                coverImageView.widthAnchor.constraint(equalTo: outerContainerView.widthAnchor),
                coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 9/16),
                containerView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 30),
                containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: commentLabel.frame.size.height + 20),
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil

    }
    
    //    override func didMoveToSuperview() {
    //        super.didMoveToSuperview()
    //        layoutIfNeeded()
    //    }
    
}

