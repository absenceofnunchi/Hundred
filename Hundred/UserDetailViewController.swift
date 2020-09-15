//
//  UserDetailViewController.swift
//  Hundred
//
//  Created by J C on 2020-09-13.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CloudKit
import Charts

class UserDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var stackView: UIStackView!
    var user: CKRecord?
    var analytics: [CKRecord]?
    var coverImageView = UIImageView()
    var imageConstraints: [NSLayoutConstraint] = []
    let metricCard = MetricCard()
//    var titleLabel: UILabel!
    var commentLabel: CustomLabel!
    var streakContainer: UIView!
    var currentStreakLabel: UILabel!
    var longestStreakLabel: UILabel!
    var currentStreakTitle: UILabel!
    var longestStreakTitle: UILabel!
    var subTitleLabel: CustomLabel!
    var goalTitle: String?
    var comment: String?
    var entryCount: Int?
    var metricsDict: [String: String]?
    var currentStreak: Int?
    var longestStreak: Int?
    var currentMetricsContainer: UIStackView!
    var barChart: BarChartView!
    var commentContainer = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
         configureUI()
         setConstraints()
    }
    
    func configureUI() {
        scrollView.addSubview(coverImageView)
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 25, bottom: 0, trailing: 25)
        scrollView.addSubview(stackView)

        // image
        if let user = user, let imageAsset = user.object(forKey: MetricAnalytics.image.rawValue) as? CKAsset {
            metricCard.loadCoverPhoto(imageAsset: imageAsset) { (image) in
                if let image = image {
                    self.coverImageView.image = image
                    self.coverImageView.contentMode = .scaleAspectFill
                    self.coverImageView.clipsToBounds = true
                }
            }
        }
        
        if let user = user {
            self.title = user.object(forKey: MetricAnalytics.goal.rawValue) as? String
            comment = user.object(forKey: "comment") as? String
            entryCount = user.object(forKey: MetricAnalytics.entryCount.rawValue) as? Int
            // today's metric/value pair, not the analytics
            metricsDict = try? user.decode(forKey: MetricAnalytics.metrics.rawValue) as [String: String]
            currentStreak = user.object(forKey: MetricAnalytics.currentStreak.rawValue) as? Int
            longestStreak = user.object(forKey: MetricAnalytics.longestStreak.rawValue) as? Int
        }
        
        // title
//        let titleLabelTheme = UILabelTheme(font: UIFont.body.with(weight: .bold), color: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0), lineBreakMode: .byTruncatingTail, textAlignment: .left)
//        titleLabel = UILabel(theme: titleLabelTheme, text: goalTitle ?? "")
//        stackView.addArrangedSubview(titleLabel)
        
        
        // comment
        commentLabel = CustomLabel()
        let borderColor = UIColor.gray
        commentLabel.adjustsFontSizeToFitWidth = false
        commentLabel.sizeToFit()
        commentLabel.textColor = .darkGray
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = .byWordWrapping
        commentLabel.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        commentLabel.layer.borderWidth = 0.8
        commentLabel.layer.cornerRadius = 7.0
        commentLabel.text = comment ?? " "
        
        stackView.addArrangedSubview(commentContainer)
        commentContainer.addSubview(commentLabel)
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.widthAnchor.constraint(equalTo: commentContainer.widthAnchor).isActive = true
        commentLabel.centerXAnchor.constraint(equalTo: commentContainer.centerXAnchor).isActive = true
        commentLabel.topAnchor.constraint(equalTo: commentContainer.topAnchor, constant: 10).isActive = true
                
        streakContainer = UIView()
        streakContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        streakContainer.layer.borderWidth = 0.8
        streakContainer.layer.cornerRadius = 7.0
        stackView.addArrangedSubview(streakContainer)
        streakContainer.translatesAutoresizingMaskIntoConstraints = false
        streakContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //longest, current streaks
        let unitLabelTheme = UILabelTheme(font: UIFont.caption.with(weight: .bold), color: .lightGray, lineBreakMode: .byTruncatingTail)
        currentStreakTitle = UILabel(theme: unitLabelTheme, text: "Current Streak")
        longestStreakTitle = UILabel(theme: unitLabelTheme, text: "Longest Streak")
        
        currentStreakLabel = UILabel()
        currentStreakLabel.text = String(currentStreak ?? 0)
        
        longestStreakLabel = UILabel()
        longestStreakLabel.text = String(longestStreak ?? 0)
        
        streakContainer.addSubview(currentStreakLabel)
        streakContainer.addSubview(longestStreakLabel)
        streakContainer.addSubview(currentStreakTitle)
        streakContainer.addSubview(longestStreakTitle)
        
        // bar chart
        barChart = BarChartView()
        barChart = metricCard.setupBarChart(entryCount: entryCount ?? 0)
        stackView.addArrangedSubview(barChart)
        
        // current metrics
        currentMetricsContainer = UIStackView()
        currentMetricsContainer.axis = .vertical
        currentMetricsContainer.alignment = .fill
        currentMetricsContainer.spacing = 10
        currentMetricsContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        currentMetricsContainer.layer.borderWidth = 0.8
        currentMetricsContainer.layer.cornerRadius = 7.0
        currentMetricsContainer.translatesAutoresizingMaskIntoConstraints = false
        currentMetricsContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        
        subTitleLabel = CustomLabel()
        subTitleLabel.text = "Today's Metrics"
        subTitleLabel.textColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
        subTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        subTitleLabel.textAlignment = .left
        currentMetricsContainer.addArrangedSubview(subTitleLabel)
        
//        print("metricsDict: \(metricsDict)")
        if let metricsDict = metricsDict {
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
        }
        
        stackView.addArrangedSubview(currentMetricsContainer)
        
        if let analytics = analytics {
            for result in analytics {
                let metricTitle = result.object(forKey: MetricAnalytics.metricTitle.rawValue) as! String
                let max = result.object(forKey: MetricAnalytics.Max.rawValue) as! String
                let min = result.object(forKey: MetricAnalytics.Min.rawValue) as! String
                let average = result.object(forKey: MetricAnalytics.Average.rawValue) as! String
                let sum = result.object(forKey: MetricAnalytics.Sum.rawValue) as! String
                let dict: [String: NSDecimalNumber] = [
                    MetricAnalytics.Max.rawValue: UnitConversion.stringToDecimal(string: max),
                    MetricAnalytics.Min.rawValue: UnitConversion.stringToDecimal(string: min),
                    MetricAnalytics.Average.rawValue: UnitConversion.stringToDecimal(string: average),
                    MetricAnalytics.Sum.rawValue: UnitConversion.stringToDecimal(string: sum)
                ]
                
                DispatchQueue.main.async {
                    self.metricCard.displayMetrics(metricStackView: self.stackView, metric: metricTitle, dict: dict)
                }
            }
        }
    }
    
    func setConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        if let user = user, let _ = user.object(forKey: MetricAnalytics.image.rawValue) as? CKAsset {
            coverImageView.translatesAutoresizingMaskIntoConstraints = false
            coverImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            coverImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            coverImageView.heightAnchor.constraint(equalTo: coverImageView.widthAnchor, multiplier: 9/16).isActive = true
            stackView.topAnchor.constraint(equalTo: coverImageView.bottomAnchor, constant: 30).isActive = true
        } else {
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30).isActive = true
        }

//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        commentContainer.translatesAutoresizingMaskIntoConstraints = false
        commentContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: commentLabel.frame.size.height).isActive = true
        
        barChart.translatesAutoresizingMaskIntoConstraints = false
        barChart.heightAnchor.constraint(equalToConstant: 100).isActive = true

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
        
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
