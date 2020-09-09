//
//  ViewController.swift
//  Hundred
//
//  Created by jc on 2020-07-31.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CalendarHeatmap
import CoreData
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var goals: [Goal]! {
        didSet {
            loadMetricsData(goals: goals)
        }
    }
    
    var data: [String: UIColor]! {
        didSet {
            calendarHeatMap.reload()
        }
    }
    
    var pieChartView: PieChartView! = {
        let pieChartView = PieChartView()
        return pieChartView
    }()
    
    var hBarChartview: HorizontalBarChartView!
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 30, bottom:  50, trailing: 30)
        scrollView.addSubview(stackView)
        return stackView
    }()
    
    lazy var calendarHeatMap: CalendarHeatmap = {
        var config = CalendarHeatmapConfig()
        config.backgroundColor = UIColor(ciColor: .white)
        // config item
        config.selectedItemBorderColor = .white
        config.allowItemSelection = true
        // config month header
        config.monthHeight = 30
        config.monthStrings = DateFormatter().shortMonthSymbols
        config.monthFont = UIFont.systemFont(ofSize: 18)
        config.monthColor = UIColor(ciColor: .black)
        // config weekday label on left
        config.weekDayFont = UIFont.systemFont(ofSize: 12)
        config.weekDayWidth = 30
        config.weekDayColor = UIColor(ciColor: .black)
        
        var dateComponent = DateComponents()
        let yearsBefore = -1
        dateComponent.year = yearsBefore
        if let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()) {
            let calendar = CalendarHeatmap(config: config, startDate: startDate, endDate: Date())
            calendar.delegate = self
            return calendar
        } else {
            let calendar = CalendarHeatmap(config: config, startDate: Date(2019, 1, 1), endDate: Date())
            calendar.delegate = self
            return calendar
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("yes")
        var dataImporter = DataImporter(goalTitle: nil)
        data = dataImporter.data
        
        configureUI()
        setConstraints()
        
        var mainDataImporter = MainDataImporter()
        goals = mainDataImporter.data
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        calendarHeatMap.reload()
    }
    
    func configureUI() {
        title = "Dashboard"
        navigationController?.title = "Dashboard"
//        navigationController?.navigationBar.isHidden = true
        
        addCard(text: "Contribution Calendar", subItem: calendarHeatMap, stackView: stackView, containerHeight: 270)
        addCard(text: "Composition Pie Chart", subItem: pieChartView, stackView: stackView, containerHeight: 300)
    }
    
    func setConstraints() {
        stackView.pin(to: scrollView)
    }
    
    func loadMetricsData(goals: [Goal]?) {
        
        if let goals = goals {
            showSnapshot(goals: goals)
            if goals.count == 0 {
                setupEmptyPieChart()
            } else {
                var sum = 0
                for goal in goals {
                    sum += goal.progress.count
                }
                
                if sum == 0 {
                    setupEmptyPieChart()
                } else {
                    setupPieChart(goals: goals)
                }
            }
        } else {
            setupEmptyPieChart()
        }
    }
    
    func setupBarChart(progress: Set<Progress>) -> BarChartView {
        hBarChartview = HorizontalBarChartView()
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
        
        var dateArr: Set<String> = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        
        for progressEntry in progress {
            dateArr.insert(dateFormatter.string(from: progressEntry.date))
        }
        
        var denominator: Double = 100
        switch Double(dateArr.count)/100 {
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
        
        let barChartData = BarChartDataEntry(x: 0, y: Double(dateArr.count)/100)
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
    
    func setupPieChart(goals: [Goal]?) {
        pieChartView.chartDescription?.enabled = false
        pieChartView.drawHoleEnabled = true
        pieChartView.rotationAngle = 0
        pieChartView.rotationEnabled = true
        pieChartView.isUserInteractionEnabled = true
        pieChartView.legend.enabled = true
        pieChartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        pieChartView.drawEntryLabelsEnabled = false
        pieChartView.centerAttributedText = nil
        
        var entries: [PieChartDataEntry] = Array()
        
        if let goals = goals {
            for goal in goals {
                if goal.progress.count != 0 {
                    entries.append(PieChartDataEntry(value: Double(goal.progress.count), label: goal.title))
                }
            }
        }
        
        let dataSet = PieChartDataSet(entries: entries, label: "")
        
        let c1 = NSUIColor(hex: 0x34ace0)
        let c2 = NSUIColor(hex: 0x40407a)
        let c3 = NSUIColor(hex: 0x706fd3)
        let c4 = NSUIColor(hex: 0xf7f1e3)
        let c5 = NSUIColor(hex: 0x33d9b2)
        let c6 = NSUIColor(hex: 0xff5252)
        let c7 = NSUIColor(hex: 0xff793f)
        let c8 = NSUIColor(hex: 0xd1ccc0)
        let c9 = NSUIColor(hex: 0xffb142)
        let c10 = NSUIColor(hex: 0xffda79)
        let c11 = NSUIColor(hex: 0x78e08f)
        
        dataSet.colors = [c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11]
        dataSet.drawValuesEnabled = true
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
    }
    
    func setupEmptyPieChart() {
        pieChartView.legend.enabled = false
        pieChartView.holeRadiusPercent = 0.58
        pieChartView.transparentCircleRadiusPercent = 0.61
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "No data")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!, .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        pieChartView.centerAttributedText = centerText
        
        let dataSet = PieChartDataSet(entries: [PieChartDataEntry(value: 1.0, label: nil)], label: "")
        
        dataSet.colors = [NSUIColor(hex: 0xff5252)]
        dataSet.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
    }
    
    func showSnapshot(goals: [Goal]) {
        for singleArrangedSubview in stackView.arrangedSubviews {
            if singleArrangedSubview.tag == 5 {
                stackView.removeArrangedSubview(singleArrangedSubview)
                singleArrangedSubview.removeFromSuperview()
            }
        }
        
        //        struct FakeGoal {
        //            var title: String!
        //            var longestStreak: Int16
        //            var streak: Int16
        //        }
        
        //        let goal1 = FakeGoal(title: "Bike", longestStreak: 100, streak: 3)
        //        let goal2 = FakeGoal(title: "Boat", longestStreak: 23, streak: 23)
        //        let goal3 = FakeGoal(title: "Car", longestStreak: 34, streak: 2)
        //        let goal4 = FakeGoal(title: "Running", longestStreak: 56, streak: 45)
        //        let goal5 = FakeGoal(title: "Drum", longestStreak: 78, streak: 6)
        //
        //        let fakeGoals = [goal1, goal2, goal3, goal4, goal5]
        
        
        for goal in goals {
            let containerView = UIView()
            
            let currentStreakTitle = createUnitLabel(labelText: "Current Streak")
            let longestStreakTitle = createUnitLabel(labelText: "Longest Streak")
            
            let currentStreak = UILabel()
            currentStreak.text = String(goal.streak)
            
            let longestStreak = UILabel()
            longestStreak.text = String(goal.longestStreak)
            
            containerView.addSubview(currentStreak)
            containerView.addSubview(longestStreak)
            containerView.addSubview(currentStreakTitle)
            containerView.addSubview(longestStreakTitle)
            
            currentStreakTitle.translatesAutoresizingMaskIntoConstraints = false
            currentStreakTitle.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
            currentStreakTitle.topAnchor.constraint(equalTo: currentStreak.bottomAnchor).isActive = true
            
            longestStreakTitle.translatesAutoresizingMaskIntoConstraints = false
            longestStreakTitle.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
            longestStreakTitle.leadingAnchor.constraint(equalTo: currentStreakTitle.trailingAnchor).isActive = true
            longestStreakTitle.topAnchor.constraint(equalTo: longestStreak.bottomAnchor).isActive = true
            
            currentStreak.translatesAutoresizingMaskIntoConstraints = false
            currentStreak.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
            currentStreak.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            
            longestStreak.translatesAutoresizingMaskIntoConstraints = false
            longestStreak.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
            longestStreak.leadingAnchor.constraint(equalTo: currentStreak.trailingAnchor).isActive = true
            
            if goal.progress.count > 0 {
                let barChart = setupBarChart(progress: goal.progress)
                containerView.addSubview(barChart)
                
                barChart.translatesAutoresizingMaskIntoConstraints = false
                //                barChart.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
                barChart.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: -10).isActive = true
                barChart.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 10).isActive = true
                barChart.topAnchor.constraint(equalTo: currentStreakTitle.bottomAnchor, constant: 30).isActive = true
                barChart.heightAnchor.constraint(equalToConstant: 100).isActive = true
                
                if let metrics = goal.metrics {
                    let metricsStackView = calculateMetrics(metrics: metrics)
                    containerView.addSubview(metricsStackView)
                    
                    metricsStackView.translatesAutoresizingMaskIntoConstraints = false
                    metricsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
                    metricsStackView.topAnchor.constraint(equalTo: barChart.bottomAnchor, constant: 40).isActive = true
                    
                    containerView.layoutIfNeeded()
                    
                    addCard(text: goal.title, subItem: containerView, stackView: stackView, containerHeight: metricsStackView.frame.size.height + barChart.frame.size.height + 200, bottomSpacing: 30, tag: 5)
                } else {
                    containerView.layoutIfNeeded()
                    addCard(text: goal.title, subItem: containerView, stackView: stackView, containerHeight: barChart.frame.size.height + 150 , bottomSpacing: 30, tag: 5)
                }
            }
        }
    }
    
    func calculateMetrics(metrics: [String]) -> UIStackView {
        let metricStackView = UIStackView()
        metricStackView.axis = .vertical
        metricStackView.spacing = 20
        
        let metricFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Metric")
        for metric in metrics {
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
                if let result = try self.context.fetch(metricFetchRequest) as? [[String: NSDecimalNumber]], let dict = result.first {
                    let metricTitleLabel = UILabel()
                    metricTitleLabel.text = metric
                    metricTitleLabel.lineBreakMode = .byTruncatingTail
                    metricTitleLabel.textAlignment = .center
                    metricTitleLabel.textAlignment = .left
                    metricTitleLabel.textColor = .lightGray
                    metricTitleLabel.font = UIFont.body.with(weight: .bold)
                    
                    let imageView = UIImageView()
                    imageView.image = UIImage(systemName: "square.stack.3d.up")
                    imageView.contentMode = .right
                    imageView.tintColor = .gray
                    
                    
                    let titleContainer = UIView()
                    titleContainer.addSubview(imageView)
                    titleContainer.addSubview(metricTitleLabel)
                    
                    let singleMetricContainer = UIView()
                    
                    let pairContainer1 = UIView()
                    let maxValueLabel = createValueLabel(key: "Max", dict: dict)
                    maxValueLabel.textAlignment = .center
                    let maxUnitLabel = createUnitLabel(labelText: "Max")
                    maxUnitLabel.textAlignment = .center

                    pairContainer1.addSubview(maxValueLabel)
                    pairContainer1.addSubview(maxUnitLabel)
                    singleMetricContainer.addSubview(pairContainer1)

                    pairContainer1.translatesAutoresizingMaskIntoConstraints = false
                    pairContainer1.leadingAnchor.constraint(equalTo: singleMetricContainer.leadingAnchor).isActive = true
                    pairContainer1.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.5).isActive = true
                    pairContainer1.topAnchor.constraint(equalTo: singleMetricContainer.topAnchor).isActive = true
                    pairContainer1.heightAnchor.constraint(equalTo: singleMetricContainer.heightAnchor, multiplier: 0.5).isActive = true

                    maxValueLabel.translatesAutoresizingMaskIntoConstraints = false
                    maxValueLabel.topAnchor.constraint(equalTo: pairContainer1.topAnchor).isActive = true
                    maxValueLabel.widthAnchor.constraint(equalTo: pairContainer1.widthAnchor, multiplier: 0.9).isActive = true
                    maxValueLabel.heightAnchor.constraint(equalTo: pairContainer1.heightAnchor, multiplier: 0.5).isActive = true

                    maxUnitLabel.translatesAutoresizingMaskIntoConstraints = false
                    maxUnitLabel.topAnchor.constraint(equalTo: maxValueLabel.bottomAnchor).isActive = true
                    maxUnitLabel.widthAnchor.constraint(equalTo: pairContainer1.widthAnchor, multiplier: 0.9).isActive = true

                    let pairContainer2 = UIView()
                    let minValueLabel = createValueLabel(key: "Min", dict: dict)
                    minValueLabel.textAlignment = .center
                    let minUnitLabel = createUnitLabel(labelText: "Min")
                    minUnitLabel.textAlignment = .center

                    pairContainer2.addSubview(minValueLabel)
                    pairContainer2.addSubview(minUnitLabel)
                    singleMetricContainer.addSubview(pairContainer2)

                    pairContainer2.translatesAutoresizingMaskIntoConstraints = false
                    pairContainer2.trailingAnchor.constraint(equalTo: singleMetricContainer.trailingAnchor).isActive = true
                    pairContainer2.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.5).isActive = true
                    pairContainer2.topAnchor.constraint(equalTo: singleMetricContainer.topAnchor).isActive = true
                    pairContainer2.heightAnchor.constraint(equalTo: singleMetricContainer.heightAnchor, multiplier: 0.5).isActive = true

                    minValueLabel.translatesAutoresizingMaskIntoConstraints = false
                    minValueLabel.topAnchor.constraint(equalTo: pairContainer2.topAnchor).isActive = true
                    minValueLabel.widthAnchor.constraint(equalTo: pairContainer2.widthAnchor, multiplier: 0.9).isActive = true
                    minValueLabel.heightAnchor.constraint(equalTo: pairContainer2.heightAnchor, multiplier: 0.5).isActive = true
                    minValueLabel.centerXAnchor.constraint(equalTo: pairContainer2.centerXAnchor).isActive = true

                    minUnitLabel.translatesAutoresizingMaskIntoConstraints = false
                    minUnitLabel.topAnchor.constraint(equalTo: minValueLabel.bottomAnchor).isActive = true
                    minUnitLabel.widthAnchor.constraint(equalTo: pairContainer2.widthAnchor, multiplier: 0.9).isActive = true
                    minUnitLabel.centerXAnchor.constraint(equalTo: pairContainer2.centerXAnchor).isActive = true

                    let pairContainer3 = UIView()
                    let avgValueLabel = createValueLabel(key: "Average", dict: dict)
                    avgValueLabel.textAlignment = .center
                    let avgUnitLabel = createUnitLabel(labelText: "Avg")
                    avgUnitLabel.textAlignment = .center

                    pairContainer3.addSubview(avgValueLabel)
                    pairContainer3.addSubview(avgUnitLabel)
                    singleMetricContainer.addSubview(pairContainer3)

                    pairContainer3.translatesAutoresizingMaskIntoConstraints = false
                    pairContainer3.leadingAnchor.constraint(equalTo: singleMetricContainer.leadingAnchor).isActive = true
                    pairContainer3.bottomAnchor.constraint(equalTo: singleMetricContainer.bottomAnchor).isActive = true
                    pairContainer3.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.5).isActive = true
                    pairContainer3.heightAnchor.constraint(equalTo: singleMetricContainer.heightAnchor, multiplier: 0.5).isActive = true

                    avgValueLabel.translatesAutoresizingMaskIntoConstraints = false
                    avgValueLabel.topAnchor.constraint(equalTo: pairContainer3.topAnchor).isActive = true
                    avgValueLabel.widthAnchor.constraint(equalTo: pairContainer3.widthAnchor, multiplier: 0.9).isActive = true

                    avgUnitLabel.translatesAutoresizingMaskIntoConstraints = false
                    avgUnitLabel.topAnchor.constraint(equalTo: avgValueLabel.bottomAnchor).isActive = true
                    avgUnitLabel.widthAnchor.constraint(equalTo: pairContainer3.widthAnchor, multiplier: 0.9).isActive = true

                    let pairContainer4 = UIView()
                    let sumValueLabel = createValueLabel(key: "Sum", dict: dict)
                    sumValueLabel.textAlignment = .center
                    let sumUnitLabel = createUnitLabel(labelText: "Sum")
                    sumUnitLabel.textAlignment = .center

                    pairContainer4.addSubview(sumValueLabel)
                    pairContainer4.addSubview(sumUnitLabel)
                    singleMetricContainer.addSubview(pairContainer4)

                    pairContainer4.translatesAutoresizingMaskIntoConstraints = false
                    pairContainer4.trailingAnchor.constraint(equalTo: singleMetricContainer.trailingAnchor).isActive = true
                    pairContainer4.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.5).isActive = true
                    pairContainer4.topAnchor.constraint(equalTo: pairContainer2.bottomAnchor).isActive = true
                    pairContainer4.heightAnchor.constraint(equalTo: singleMetricContainer.heightAnchor, multiplier: 0.5).isActive = true

                    sumValueLabel.translatesAutoresizingMaskIntoConstraints = false
                    sumValueLabel.topAnchor.constraint(equalTo: pairContainer4.topAnchor).isActive = true
                    sumValueLabel.widthAnchor.constraint(equalTo: pairContainer4.widthAnchor, multiplier: 0.9).isActive = true
                    sumValueLabel.centerXAnchor.constraint(equalTo: pairContainer4.centerXAnchor).isActive = true

                    sumUnitLabel.translatesAutoresizingMaskIntoConstraints = false
                    sumUnitLabel.topAnchor.constraint(equalTo: sumValueLabel.bottomAnchor).isActive = true
                    sumUnitLabel.widthAnchor.constraint(equalTo: pairContainer4.widthAnchor, multiplier: 0.9).isActive = true
                    sumUnitLabel.centerXAnchor.constraint(equalTo: pairContainer4.centerXAnchor).isActive = true
                    
                    let unitContainer = UIView()
                    let borderColor = UIColor.gray
                    unitContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
                    unitContainer.layer.borderWidth = 0.8
                    unitContainer.layer.cornerRadius = 7.0
                    
                    unitContainer.addSubview(titleContainer)
//                    unitContainer.addSubview(imageView)
//                    unitContainer.addSubview(metricTitleLabel)
                    unitContainer.addSubview(singleMetricContainer)
                    
                    unitContainer.translatesAutoresizingMaskIntoConstraints = false
                    unitContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
                    
//                    metricTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//                    metricTitleLabel.heightAnchor.constraint(equalTo: unitContainer.heightAnchor, multiplier: 0.3).isActive = true
//                    metricTitleLabel.topAnchor.constraint(equalTo: unitContainer.topAnchor).isActive = true
//                    metricTitleLabel.widthAnchor.constraint(equalTo: unitContainer.widthAnchor, multiplier: 0.8).isActive = true
//                    metricTitleLabel.centerXAnchor.constraint(equalTo: unitContainer.centerXAnchor).isActive = true
                    
                    titleContainer.translatesAutoresizingMaskIntoConstraints = false
                    titleContainer.centerXAnchor.constraint(equalTo: unitContainer.centerXAnchor, constant: -10).isActive = true
                    titleContainer.topAnchor.constraint(equalTo: unitContainer.topAnchor).isActive = true
                    titleContainer.heightAnchor.constraint(equalTo: unitContainer.heightAnchor, multiplier: 0.3).isActive = true
                    titleContainer.widthAnchor.constraint(lessThanOrEqualTo: unitContainer.widthAnchor, multiplier: 0.8).isActive = true
                    
                    imageView.translatesAutoresizingMaskIntoConstraints = false
//                    imageView.heightAnchor.constraint(equalTo: titleContainer.heightAnchor, multiplier: 0.3).isActive = true
//                    imageView.topAnchor.constraint(equalTo: titleContainer.topAnchor).isActive = true
                    imageView.widthAnchor.constraint(equalTo: titleContainer.widthAnchor, multiplier: 0.2).isActive = true
//                    imageView.trailingAnchor.constraint(equalTo: metricTitleLabel.leadingAnchor).isActive = true
                    imageView.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor).isActive = true
                    
                    metricTitleLabel.translatesAutoresizingMaskIntoConstraints = false
//                    metricTitleLabel.heightAnchor.constraint(equalTo: titleContainer.heightAnchor, multiplier: 0.3).isActive = true
//                    metricTitleLabel.topAnchor.constraint(equalTo: titleContainer.topAnchor).isActive = true
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
            } catch {
                print("metric fetch error: \(error.localizedDescription)")
            }
        }
        return metricStackView
    }
    
    func createValueLabel(key: String, dict: [String: NSDecimalNumber]) -> UILabel {
        let valueLabel = UILabel()
        valueLabel.textAlignment = .center
        valueLabel.lineBreakMode = .byTruncatingTail
        let behavior = NSDecimalNumberHandler(roundingMode: .plain, scale: 1, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
        if let max = dict[key] {
            valueLabel.text = String(describing: max.rounding(accordingToBehavior: behavior))
        } else {
            valueLabel.text = "0"
        }
        return valueLabel
    }
    
    func createUnitLabel(labelText: String) -> UILabel {
        let unitLabel = UILabel()
        unitLabel.font = UIFont.caption.with(weight: .bold)
        unitLabel.textColor = .lightGray
        unitLabel.lineBreakMode = .byTruncatingTail
        unitLabel.text = labelText
        return unitLabel
    }
}

extension ViewController: CalendarHeatmapDelegate {
    func didSelectedAt(dateComponents: DateComponents) {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return }
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CalendarDetail") as? CalendarDetailTableViewController {
            let date = [year, month, day]
            let startDate = "\(date[0])-\(date[1])-\(date[2]) 00:00"
            let endDate = "\(date[0])-\(date[1])-\(date[2]) 23:59"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let formattedStartDate = dateFormatter.date(from: startDate)
            let formattedEndDate = dateFormatter.date(from: endDate)
            
            vc.progressPredicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", formattedStartDate! as CVarArg, formattedEndDate! as CVarArg)
            present(vc, animated: true)
        }
    }
    
    func colorFor(dateComponents: DateComponents) -> UIColor {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return .clear}
        let dateString = "\(year).\(month).\(day)"
        return data[dateString] ?? UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
    }
    
    func finishLoadCalendar() {
        calendarHeatMap.scrollTo(date: Date(), at: .right, animated: true)
    }
}
