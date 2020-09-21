//
//  MetricCard.swift
//  Hundred
//
//  Created by J C on 2020-09-10.
//  Copyright © 2020 J. All rights reserved.
//

import Foundation
import Charts
import CoreData
import CloudKit

enum MetricAnalytics: String {
    case Progress
    case goal
    case comment
    case metrics
    case image
    case longitude, latitude
    case date
    case Min, Max, Average, Sum
    case analytics
    case entryCount
    case longestStreak, currentStreak
    case metricTitle
    case username, email
}

struct MetricCard {
    func createMetricCard(entryCount: Int?, goal: Goal?, metricsDict: [String: String]?, fetchedAnalytics: [[String: [String: String]]]?, currentStreak: Int?, longestStreak: Int?) -> (UIView, CGFloat) {
        let containerView = UIView()
        let currentStreakTitle  = self.createStreakCard(containerView: containerView, goal: goal, currentStreak: nil, longestStreak: nil)
        
        var barChart = BarChartView()
        if let entryCount = entryCount {
            barChart = self.setupBarChart(entryCount: entryCount)
        } else if let goal = goal {
            let entryCount = MetricCard.getEntryCount(progress: goal.progress)
            barChart = self.setupBarChart(entryCount: entryCount)
        }
        
        containerView.addSubview(barChart)
        barChart.translatesAutoresizingMaskIntoConstraints = false
        barChart.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -10).isActive = true
        barChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10).isActive = true
        barChart.topAnchor.constraint(equalTo: currentStreakTitle.bottomAnchor, constant: 30).isActive = true
        barChart.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        if let metricsDict = metricsDict {
            var metricsArr: [String] = []
            for singleMetric in metricsDict {
                metricsArr.append(singleMetric.key)
            }
            
            let metricsStackView = self.calculateMetrics(metrics: nil, metricDict: metricsDict)
            containerView.addSubview(metricsStackView)
            metricsStackView.translatesAutoresizingMaskIntoConstraints = false
            metricsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
            metricsStackView.topAnchor.constraint(equalTo: barChart.bottomAnchor, constant: 40).isActive = true
            
            containerView.layoutIfNeeded()
            
            return (containerView, metricsStackView.frame.size.height + barChart.frame.size.height + 200)
            
        } else if let metrics = goal?.metrics {
            let metricsStackView = self.calculateMetrics(metrics: metrics, metricDict: nil)
            containerView.addSubview(metricsStackView)
            metricsStackView.translatesAutoresizingMaskIntoConstraints = false
            metricsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
            metricsStackView.topAnchor.constraint(equalTo: barChart.bottomAnchor, constant: 40).isActive = true
            
            containerView.layoutIfNeeded()
            
            return (containerView, metricsStackView.frame.size.height + barChart.frame.size.height + 200)
            //            addCard(text: goal.title, subItem: containerView, stackView: stackView, containerHeight: metricsStackView.frame.size.height + barChart.frame.size.height + 200, bottomSpacing: 30, tag: 5)
        } else {
            containerView.layoutIfNeeded()
            
            return (containerView, barChart.frame.size.height + 150)
            //            addCard(text: goal.title, subItem: containerView, stackView: stackView, containerHeight: barChart.frame.size.height + 150 , bottomSpacing: 30, tag: 5)
        }
    }
    
    func createPublicMetricCard(user: CKRecord, cell: UITableViewCell) {
//        let imageAsset = user.object(forKey: MetricAnalytics.image.rawValue) as? CKAsset
//        let imageAsset = user.object(forKey: "") as? CKAsset
//        let title = user.object(forKey: MetricAnalytics.goal.rawValue) as? String
////        let comment = user.object(forKey: "comment") as? String
//        let entryCount = user.object(forKey: MetricAnalytics.entryCount.rawValue) as? Int
//        
//        // today's metric/value pair, not the analytics
//        let metricsDict = try? user.decode(forKey: MetricAnalytics.metrics.rawValue) as [String: String]
//        let currentStreak = user.object(forKey: MetricAnalytics.currentStreak.rawValue) as? Int
//        let longestStreak = user.object(forKey: MetricAnalytics.longestStreak.rawValue) as? Int
//
//        let fetchedAnalytics = try? user.decode(forKey: MetricAnalytics.analytics.rawValue) as [String : [String : String]]
// 
//        let outerContainerView = UIView()
//        cell.addSubview(outerContainerView)
//        inset(view: outerContainerView, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
//        BorderStyle.customShadowBorder(for: outerContainerView)
//        
//        // outer container so that the image can span the entire width
//        // and the inner container with metrics can have paddings
//        let outerContainerView = UIView()
//        BorderStyle.customShadowBorder(for: outerContainerView)
//        cell.addSubview(outerContainerView)
//
//        let imageView = UIImageView()
//        if let imageAsset = imageAsset {
//            loadCoverPhoto(imageAsset: imageAsset) { (image) in
//                if let image = image {
//                    imageView.image = image
//                }
//            }
//
//            outerContainerView.addSubview(imageView)
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.topAnchor.constraint(equalTo: outerContainerView.topAnchor).isActive = true
//            imageView.widthAnchor.constraint(equalTo: outerContainerView.widthAnchor).isActive = true
//            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 9/16).isActive = true
//        }
//
//        let containerView = UIView()
//        outerContainerView.addSubview(containerView)
//
//        let titleLabelTheme = UILabelTheme(font: UIFont.body.with(weight: .bold), color: UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0), lineBreakMode: .byTruncatingTail, textAlignment: .left)
//        let titleLabel = UILabel(theme: titleLabelTheme, text: title ?? "")
//
//        containerView.addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//
//        if imageAsset != nil {
//            containerView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
//        } else {
//            containerView.topAnchor.constraint(equalTo: outerContainerView.topAnchor).isActive = true
//        }
//
////        let currentStreakTitle  = self.createStreakCard(containerView: containerView, goal: nil, currentStreak: currentStreak ?? 0, longestStreak: longestStreak ?? 0)
//
//        let unitLabelTheme = UILabelTheme(font: UIFont.caption.with(weight: .bold), color: .lightGray, lineBreakMode: .byTruncatingTail)
//        let currentStreakTitle = UILabel(theme: unitLabelTheme, text: "Current Streak")
//        let longestStreakTitle = UILabel(theme: unitLabelTheme, text: "Longest Streak")
//
//        let currentStreakLabel = UILabel()
//        currentStreakLabel.text = String(currentStreak ?? 0)
//
//        let longestStreakLabel = UILabel()
//        longestStreakLabel.text = String(longestStreak ?? 0)
//
//        containerView.addSubview(currentStreakLabel)
//        containerView.addSubview(longestStreakLabel)
//        containerView.addSubview(currentStreakTitle)
//        containerView.addSubview(longestStreakTitle)
//
//        currentStreakLabel.translatesAutoresizingMaskIntoConstraints = false
//        currentStreakLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
//        currentStreakLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
//        currentStreakLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
//
//        longestStreakLabel.translatesAutoresizingMaskIntoConstraints = false
//        longestStreakLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
//        longestStreakLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
//        longestStreakLabel.leadingAnchor.constraint(equalTo: currentStreakLabel.trailingAnchor).isActive = true
//
//        currentStreakTitle.translatesAutoresizingMaskIntoConstraints = false
//        currentStreakTitle.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
//        currentStreakTitle.topAnchor.constraint(equalTo: currentStreakLabel.bottomAnchor).isActive = true
//
//        longestStreakTitle.translatesAutoresizingMaskIntoConstraints = false
//        longestStreakTitle.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
//        longestStreakTitle.leadingAnchor.constraint(equalTo: currentStreakTitle.trailingAnchor).isActive = true
//        longestStreakTitle.topAnchor.constraint(equalTo: longestStreakLabel.bottomAnchor).isActive = true
//
//        var barChart = BarChartView()
//        barChart = self.setupBarChart(entryCount: entryCount ?? 0)
//        containerView.addSubview(barChart)
//        barChart.translatesAutoresizingMaskIntoConstraints = false
//        barChart.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -10).isActive = true
//        barChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10).isActive = true
//        barChart.topAnchor.constraint(equalTo: currentStreakTitle.bottomAnchor, constant: 20).isActive = true
//        barChart.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        let metricsStackView = UIStackView()
//
//        if let fetchedAnalytics = fetchedAnalytics {
//            metricsStackView.axis = .vertical
//            metricsStackView.spacing = 20
//
//            for analytics in fetchedAnalytics {
//
//                let converetdAnalytics = analytics.value.mapValues { UnitConversion.stringToDecimal(string: $0)}
//                displayMetrics(metricStackView: metricsStackView, metric: analytics.key, dict: converetdAnalytics)
//            }
//
//            containerView.addSubview(metricsStackView)
//            metricsStackView.translatesAutoresizingMaskIntoConstraints = false
//            metricsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//            metricsStackView.topAnchor.constraint(equalTo: barChart.bottomAnchor, constant: 40).isActive = true
//        }
//
//        containerView.backgroundColor = .white
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        if imageAsset != nil {
//            containerView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
//        } else {
//            containerView.topAnchor.constraint(equalTo: outerContainerView.bottomAnchor, constant: 30).isActive = true
//        }
//
//        containerView.widthAnchor.constraint(equalTo: outerContainerView.widthAnchor, multiplier: 0.8).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: outerContainerView.bottomAnchor, constant: -30).isActive = true
//        containerView.centerXAnchor.constraint(equalTo: outerContainerView.centerXAnchor).isActive = true
//        containerView.layoutIfNeeded()
//
//        inset(view: outerContainerView, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
//
//
//        print("metricsStackView.frame.size.height: \(metricsStackView.frame.size.height)")
//        print("barChart.frame.size.height: \(barChart.frame.size.height)")
//
//        if imageAsset != nil {
//            imageView.layoutIfNeeded()
//            outerContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: imageView.frame.height + metricsStackView.frame.size.height + barChart.frame.size.height + 150).isActive = true
//        } else {
//            outerContainerView.heightAnchor.constraint(greaterThanOrEqualToConstant: metricsStackView.frame.size.height + barChart.frame.size.height + 150).isActive = true
//        }
//

    }
    
    func loadCoverPhoto(imageAsset: CKAsset, completion: @escaping (_ photo: UIImage?) -> ()) {
      // 1.
      DispatchQueue.global(qos: .utility).async {
        var image: UIImage?
        // 5.
        defer {
          DispatchQueue.main.async {
            completion(image)
          }
        }
        // 2.
        guard
          let fileURL = imageAsset.fileURL
          else {
            return
        }
        let imageData: Data
        do {
          // 3.
          imageData = try Data(contentsOf: fileURL)
        } catch {
          return
        }
        // 4.
        image = UIImage(data: imageData)
      }
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
    
    func setupBarChart(entryCount: Int) -> BarChartView {
        let hBarChartview = HorizontalBarChartView()
        hBarChartview.drawBarShadowEnabled = false
        hBarChartview.drawValueAboveBarEnabled = true
        hBarChartview.maxVisibleCount = 60
        hBarChartview.chartDescription?.enabled = false
        hBarChartview.dragEnabled = true
        hBarChartview.setScaleEnabled(true)
        hBarChartview.pinchZoomEnabled = false
        hBarChartview.fitBars = true
        hBarChartview.isUserInteractionEnabled = false
        
        let xAxis = hBarChartview.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        xAxis.granularity = 1
        xAxis.enabled = false
        
        let leftAxis = hBarChartview.leftAxis
        leftAxis.enabled = false
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.axisMaximum = 1.1
        
        let rightAxis = hBarChartview.rightAxis
        rightAxis.enabled = false
        rightAxis.labelFont = .systemFont(ofSize: 100)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0
        rightAxis.valueFormatter = BarChartAxisFormatter()
        
        let l = hBarChartview.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        
        var denominator: Double = 100
        switch Double(entryCount)/100 {
        case 0..<1.1:
            denominator = 100
        case 1.1..<2.1:
            denominator = 200
        case 2.1..<3.1:
            denominator = 300
        case 3.1..<4.1:
            denominator = 400
        case 4.1..<5.1:
            denominator = 500
        case 5.1..<6.1:
            denominator = 600
        case 6.1..<7.1:
            denominator = 700
        case 7.1..<8.1:
            denominator = 800
        case 8.1..<9.1:
            denominator = 900
        case 9.1..<10.1:
            denominator = 1000
        case 10.1..<11.1:
            denominator = 1100
        case 11.1..<12.1:
            denominator = 1200
        case 12.1..<13.1:
            denominator = 1300
        case 13.1..<14.1:
            denominator = 1400
        case 14.1..<15.1:
            denominator = 1500
        default:
            denominator = 100
        }
        
        let barChartData = BarChartDataEntry(x: 0, y: Double(entryCount)/100)
        let barChartDataSet = BarChartDataSet(entries: [barChartData], label: "# of contributed days out of \(Int(denominator)) days")
        
        barChartDataSet.colors = [NSUIColor(hex: 0xd1ccc0)]
        
        let valFormatter = NumberFormatter()
        valFormatter.numberStyle = .percent
        valFormatter.maximumFractionDigits = 0
        valFormatter.percentSymbol = "%"
        barChartDataSet.valueFormatter = DefaultValueFormatter(formatter: valFormatter)
        
        let data = BarChartData(dataSet: barChartDataSet)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
        data.barWidth = 1.0
        
        hBarChartview.data = data
        
        return hBarChartview
    }
    
    func createStreakCard(containerView: UIView, goal: Goal?, currentStreak: Int?, longestStreak: Int?) -> UILabel {
        let unitLabelTheme = UILabelTheme(font: UIFont.caption.with(weight: .bold), color: .lightGray, lineBreakMode: .byTruncatingTail)
        let currentStreakTitle = UILabel(theme: unitLabelTheme, text: "Current Streak")
        let longestStreakTitle = UILabel(theme: unitLabelTheme, text: "Longest Streak")
        
        let currentStreakLabel = UILabel()
        if let goalStreak = goal?.streak {
            currentStreakLabel.text = String(goalStreak)
        } else if let currentStreak = currentStreak {
            currentStreakLabel.text = String(currentStreak)
        }
        
        let longestStreakLabel = UILabel()
        if let lStreak = goal?.longestStreak {
            longestStreakLabel.text = String(lStreak)
        } else if let lstreak = longestStreak {
            longestStreakLabel.text = String(lstreak)
        }
        
        containerView.addSubview(currentStreakLabel)
        containerView.addSubview(longestStreakLabel)
        containerView.addSubview(currentStreakTitle)
        containerView.addSubview(longestStreakTitle)
        
        currentStreakLabel.translatesAutoresizingMaskIntoConstraints = false
        currentStreakLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        currentStreakLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        currentStreakLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        
        longestStreakLabel.translatesAutoresizingMaskIntoConstraints = false
        longestStreakLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        longestStreakLabel.leadingAnchor.constraint(equalTo: currentStreakLabel.trailingAnchor, constant: 5).isActive = true
        longestStreakLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        
        currentStreakTitle.translatesAutoresizingMaskIntoConstraints = false
        currentStreakTitle.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        currentStreakTitle.topAnchor.constraint(equalTo: currentStreakLabel.bottomAnchor).isActive = true
        currentStreakTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
        
        longestStreakTitle.translatesAutoresizingMaskIntoConstraints = false
        longestStreakTitle.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        longestStreakTitle.leadingAnchor.constraint(equalTo: currentStreakTitle.trailingAnchor, constant: 5).isActive = true
        longestStreakTitle.topAnchor.constraint(equalTo: longestStreakLabel.bottomAnchor).isActive = true
        
        return currentStreakTitle
    }
    
    func displayMetrics(metricStackView: UIStackView, metric: String, dict: [String: NSDecimalNumber]) {
        let metricTitleTheme = UILabelTheme(font: UIFont.body.with(weight: .bold), color: .lightGray, lineBreakMode: .byTruncatingTail, textAlignment: .left)
        let metricTitleLabel = UILabel(theme: metricTitleTheme, text: metric)
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.stack.3d.up")
        imageView.contentMode = .right
        imageView.tintColor = .gray
        
        let titleContainer = UIView()
        titleContainer.addSubview(imageView)
        titleContainer.addSubview(metricTitleLabel)
        
        let singleMetricContainer = UIView()
        
        // max label
        let maxPairContainer = createMetricPair(text: "Max", dict: dict)
        singleMetricContainer.addSubview(maxPairContainer)
        maxPairContainer.translatesAutoresizingMaskIntoConstraints = false
        maxPairContainer.leadingAnchor.constraint(equalTo: singleMetricContainer.leadingAnchor).isActive = true
        maxPairContainer.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.5).isActive = true
        maxPairContainer.topAnchor.constraint(equalTo: singleMetricContainer.topAnchor).isActive = true
        maxPairContainer.heightAnchor.constraint(equalTo: singleMetricContainer.heightAnchor, multiplier: 0.5).isActive = true
        
        // min label
        let minPairContainer = createMetricPair(text: "Min", dict: dict)
        singleMetricContainer.addSubview(minPairContainer)
        minPairContainer.translatesAutoresizingMaskIntoConstraints = false
        minPairContainer.trailingAnchor.constraint(equalTo: singleMetricContainer.trailingAnchor).isActive = true
        minPairContainer.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.5).isActive = true
        minPairContainer.topAnchor.constraint(equalTo: singleMetricContainer.topAnchor).isActive = true
        minPairContainer.heightAnchor.constraint(equalTo: singleMetricContainer.heightAnchor, multiplier: 0.5).isActive = true
        
        // avg label
        let avgPairContainer = createMetricPair(text: "Average", dict: dict)
        singleMetricContainer.addSubview(avgPairContainer)
        avgPairContainer.translatesAutoresizingMaskIntoConstraints = false
        avgPairContainer.leadingAnchor.constraint(equalTo: singleMetricContainer.leadingAnchor).isActive = true
        avgPairContainer.bottomAnchor.constraint(equalTo: singleMetricContainer.bottomAnchor).isActive = true
        avgPairContainer.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.5).isActive = true
        avgPairContainer.heightAnchor.constraint(equalTo: singleMetricContainer.heightAnchor, multiplier: 0.5).isActive = true
        
        let sumPairContainer = createMetricPair(text: "Sum", dict: dict)
        singleMetricContainer.addSubview(sumPairContainer)
        sumPairContainer.translatesAutoresizingMaskIntoConstraints = false
        sumPairContainer.trailingAnchor.constraint(equalTo: singleMetricContainer.trailingAnchor).isActive = true
        sumPairContainer.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.5).isActive = true
        sumPairContainer.topAnchor.constraint(equalTo: minPairContainer.bottomAnchor).isActive = true
        sumPairContainer.heightAnchor.constraint(equalTo: singleMetricContainer.heightAnchor, multiplier: 0.5).isActive = true
        
        let unitContainer = UIView()
        let borderColor = UIColor.gray
        unitContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        unitContainer.layer.borderWidth = 0.8
        unitContainer.layer.cornerRadius = 7.0
        
        unitContainer.addSubview(titleContainer)
        unitContainer.addSubview(singleMetricContainer)
        unitContainer.translatesAutoresizingMaskIntoConstraints = false
        unitContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.centerXAnchor.constraint(equalTo: unitContainer.centerXAnchor, constant: -10).isActive = true
        titleContainer.topAnchor.constraint(equalTo: unitContainer.topAnchor).isActive = true
        titleContainer.heightAnchor.constraint(equalTo: unitContainer.heightAnchor, multiplier: 0.3).isActive = true
        titleContainer.widthAnchor.constraint(lessThanOrEqualTo: unitContainer.widthAnchor, multiplier: 0.8).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalTo: titleContainer.widthAnchor, multiplier: 0.2).isActive = true
        imageView.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor).isActive = true
        
        metricTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        metricTitleLabel.widthAnchor.constraint(greaterThanOrEqualTo: titleContainer.widthAnchor, multiplier: 0.5).isActive = true
        metricTitleLabel.widthAnchor.constraint(lessThanOrEqualTo: titleContainer.widthAnchor, multiplier: 0.8).isActive = true
        metricTitleLabel.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor).isActive = true
        metricTitleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5).isActive = true
        metricTitleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor).isActive = true
        
        singleMetricContainer.translatesAutoresizingMaskIntoConstraints = false
        singleMetricContainer.heightAnchor.constraint(equalTo: unitContainer.heightAnchor, multiplier: 0.7).isActive = true
        singleMetricContainer.topAnchor.constraint(equalTo: titleContainer.bottomAnchor).isActive = true
        singleMetricContainer.widthAnchor.constraint(equalTo: unitContainer.widthAnchor).isActive = true
        
        metricStackView.addArrangedSubview(unitContainer)
    }
    
    func calculateMetrics(metrics: [String]?, metricDict: [String: String]?) -> UIStackView {
        let metricStackView = UIStackView()
        metricStackView.axis = .vertical
        metricStackView.spacing = 20
        
        if let metrics = metrics {
            for metric in metrics {
                if let dict = MetricCard.getAnalytics(metric: metric) {
                    displayMetrics(metricStackView: metricStackView, metric: metric, dict: dict)
                }
            }
        }
        
        return metricStackView
    }
    
    func createMetricPair(text: String, dict: [String: NSDecimalNumber]) -> UIView {
        let pairContainer = UIView()
        let unitLabelTheme = UILabelTheme(font: UIFont.caption.with(weight: .bold), color: .lightGray, lineBreakMode: .byTruncatingTail, textAlignment: .center)
        let unitLabel = UILabel(theme: unitLabelTheme, text: text)
        let metricValueTheme = UILabelTheme(font: nil, color: nil, lineBreakMode: .byTruncatingTail, textAlignment: .center)
        var valueLabel: UILabel!
        if let metricValue = dict[text] {
            valueLabel = UILabel(theme: metricValueTheme, text: UnitConversion.decimalToString(decimalNumber: metricValue))
        } else {
            valueLabel = UILabel(theme: metricValueTheme, text: "0")
        }
        pairContainer.addSubview(valueLabel)
        pairContainer.addSubview(unitLabel)
        
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.topAnchor.constraint(equalTo: pairContainer.topAnchor).isActive = true
        valueLabel.widthAnchor.constraint(equalTo: pairContainer.widthAnchor, multiplier: 0.9).isActive = true
        valueLabel.heightAnchor.constraint(equalTo: pairContainer.heightAnchor, multiplier: 0.5).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: pairContainer.centerXAnchor).isActive = true
        
        unitLabel.translatesAutoresizingMaskIntoConstraints = false
        unitLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor).isActive = true
        unitLabel.widthAnchor.constraint(equalTo: pairContainer.widthAnchor, multiplier: 0.9).isActive = true
        unitLabel.centerXAnchor.constraint(equalTo: pairContainer.centerXAnchor).isActive = true
        
        return pairContainer
    }
    
    static func getAnalytics(metric: String) -> [String: NSDecimalNumber]? {
        let metricFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Metric")
        metricFetchRequest.predicate = NSPredicate(format: "unit == %@", metric)
        metricFetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        
        // max
        let keypathExpression = NSExpression(forKeyPath: "value")
        let maxExpression = NSExpression(forFunction: "max:", arguments: [keypathExpression])
        let maxKey = "Max"
        
        let maxExpressionDescription = NSExpressionDescription()
        maxExpressionDescription.name = maxKey
        maxExpressionDescription.expression = maxExpression
        maxExpressionDescription.expressionResultType = .decimalAttributeType
        
        // min
        let minExpression =  NSExpression(forFunction: "min:", arguments: [keypathExpression])
        let minKey = "Min"
        
        let minExpressionDescription = NSExpressionDescription()
        minExpressionDescription.name = minKey
        minExpressionDescription.expression = minExpression
        minExpressionDescription.expressionResultType = .decimalAttributeType
        
        // average
        let avgExpression =  NSExpression(forFunction: "average:", arguments: [keypathExpression])
        let avgKey = "Average"
        
        let avgExpressionDescription = NSExpressionDescription()
        avgExpressionDescription.name = avgKey
        avgExpressionDescription.expression = avgExpression
        avgExpressionDescription.expressionResultType = .decimalAttributeType
        
        // sum
        let sumExpression =  NSExpression(forFunction: "sum:", arguments: [keypathExpression])
        let sumKey = "Sum"
        
        let sumExpressionDescription = NSExpressionDescription()
        sumExpressionDescription.name = sumKey
        sumExpressionDescription.expression = sumExpression
        sumExpressionDescription.expressionResultType = .decimalAttributeType
        
        // median
        let mdnExpression =  NSExpression(forFunction: "median:", arguments: [keypathExpression])
        let mdnKey = "mdnValue"
        
        let mdnExpressionDescription = NSExpressionDescription()
        mdnExpressionDescription.name = mdnKey
        mdnExpressionDescription.expression = mdnExpression
        mdnExpressionDescription.expressionResultType = .decimalAttributeType
        
        // standar deviation
        let stdExpression =  NSExpression(forFunction: "stddev:", arguments: [keypathExpression])
        let stdKey = "stdValue"
        
        let stdExpressionDescription = NSExpressionDescription()
        stdExpressionDescription.name = stdKey
        stdExpressionDescription.expression = stdExpression
        stdExpressionDescription.expressionResultType = .decimalAttributeType
        
        metricFetchRequest.propertiesToFetch = [maxExpressionDescription, minExpressionDescription, avgExpressionDescription, sumExpressionDescription]
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentCloudKitContainer.viewContext
            context.automaticallyMergesChangesFromParent = true
            if let result = try context.fetch(metricFetchRequest) as? [[String: NSDecimalNumber]], let dict = result.first {
                return dict
            }
        } catch {
            print(error.localizedDescription)
        }
        
        
        return nil
    }
    
    static func getEntryCount(progress: Set<Progress>) -> Int {
        var dateArr: Set<String> = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        for progressEntry in progress {
            dateArr.insert(dateFormatter.string(from: progressEntry.date))
        }
        
        return dateArr.count
    }
}

extension NSUIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red cmoponent")
        assert(green >= 0 && green <= 255, "Invalid green cmoponent")
        assert(blue >= 0 && blue <= 255, "Invalid blue cmoponent")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}
