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
    var data: [String: UIColor]!
    var chartView: PieChartView! = {
        let pieChartView = PieChartView()
        return pieChartView
    }()
    
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
        
        var dataImporter = DataImporter(goalTitle: nil)
        data = dataImporter.data
        
        configureUI()
        setConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarHeatMap.reload()
        
        if let goals = loadData() {
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
    
    func configureUI() {
        navigationController?.title = "Home"
        navigationController?.navigationBar.isHidden = true
        
        addCard(text: "Calendar", subItem: calendarHeatMap, stackView: stackView, containerHeight: 270)
        addCard(text: "Pie Chart", subItem: chartView, stackView: stackView, containerHeight: 300)
    }
    
    func setConstraints() {
        stackView.pin(to: scrollView)
    }
    
    func setupPieChart(goals: [Goal]?) {
        chartView.chartDescription?.enabled = false
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.isUserInteractionEnabled = true
        chartView.legend.enabled = true
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        chartView.drawEntryLabelsEnabled = false
        chartView.centerAttributedText = nil
        
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
        chartView.data = data
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .none
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
    }
    
    func setupEmptyPieChart() {
        chartView.legend.enabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "No data")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!, .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        chartView.centerAttributedText = centerText
        
        let dataSet = PieChartDataSet(entries: [PieChartDataEntry(value: 1.0, label: nil)], label: "")
        
        dataSet.colors = [NSUIColor(hex: 0xff5252)]
        dataSet.drawValuesEnabled = false
        
        let data = PieChartData(dataSet: dataSet)
        chartView.data = data
    }
    
    func loadData() -> [Goal]? {
        var result: [Any]?
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        do {
            result = try self.context.fetch(fetchRequest)
        } catch {
            print("Goal Data Importer error: \(error.localizedDescription)")
        }
        
        return result as? [Goal]
    }
    
    func showSnapshot(goals: [Goal]) {
        struct FakeGoal {
            var title: String!
            var longestStreak: Int16
            var streak: Int16
        }
        
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
                
                let metricsStackView = calculateMetrics(goal: goal)
                containerView.addSubview(metricsStackView)
                
                metricsStackView.translatesAutoresizingMaskIntoConstraints = false
                metricsStackView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
                metricsStackView.topAnchor.constraint(equalTo: currentStreakTitle.bottomAnchor, constant: 20).isActive = true
                containerView.layoutIfNeeded()
 
                addCard(text: goal.title, subItem: containerView, stackView: stackView, containerHeight: metricsStackView.frame.size.height + 150, bottomSpacing: 30)
            }
    }
    
    func calculateMetrics(goal: Goal) -> UIStackView {
        let metricStackView = UIStackView()
        metricStackView.axis = .vertical
        metricStackView.spacing = 20
        
        let metricFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Metric")
        if let metrics = goal.metrics {
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
                
                metricFetchRequest.propertiesToFetch = [maxExpressionDescription, minExpressionDescription, avgExpressionDescription]
                
                do {
                    if let result = try self.context.fetch(metricFetchRequest) as? [[String: NSDecimalNumber]], let dict = result.first {
                        let metricTitleLabel = UILabel()
                           metricTitleLabel.text = metric
                           metricTitleLabel.lineBreakMode = .byTruncatingTail
                           metricTitleLabel.textAlignment = .center
                           metricTitleLabel.textColor = .darkGray

                           let singleMetricContainer = UIView()
                        
                        let pairContainer1 = UIView()
                        let maxValueLabel = createValueLabel(key: "Max", dict: dict)
                        maxValueLabel.textAlignment = .center
                        let maxUnitLabel = createUnitLabel(labelText: "Max")

                        pairContainer1.addSubview(maxValueLabel)
                        pairContainer1.addSubview(maxUnitLabel)
                        singleMetricContainer.addSubview(pairContainer1)

                        pairContainer1.translatesAutoresizingMaskIntoConstraints = false
                        pairContainer1.leadingAnchor.constraint(equalTo: singleMetricContainer.leadingAnchor).isActive = true
                        pairContainer1.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.33).isActive = true

                        maxValueLabel.translatesAutoresizingMaskIntoConstraints = false
                        maxValueLabel.topAnchor.constraint(equalTo: pairContainer1.topAnchor).isActive = true
                        maxValueLabel.widthAnchor.constraint(equalTo: pairContainer1.widthAnchor, multiplier: 0.9).isActive = true

                        maxUnitLabel.translatesAutoresizingMaskIntoConstraints = false
                        maxUnitLabel.topAnchor.constraint(equalTo: maxValueLabel.bottomAnchor).isActive = true
                        maxUnitLabel.widthAnchor.constraint(equalTo: pairContainer1.widthAnchor).isActive = true

                        let pairContainer2 = UIView()
                        let minValueLabel = createValueLabel(key: "Min", dict: dict)
                        minValueLabel.textAlignment = .center
                        let minUnitLabel = createUnitLabel(labelText: "Min")
                        
                        pairContainer2.addSubview(minValueLabel)
                        pairContainer2.addSubview(minUnitLabel)
                        singleMetricContainer.addSubview(pairContainer2)
                        
                        pairContainer2.translatesAutoresizingMaskIntoConstraints = false
                        pairContainer2.leadingAnchor.constraint(equalTo: pairContainer1.trailingAnchor).isActive = true
                        pairContainer2.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.33).isActive = true
                        
                        minValueLabel.translatesAutoresizingMaskIntoConstraints = false
                        minValueLabel.topAnchor.constraint(equalTo: pairContainer2.topAnchor).isActive = true
                        minValueLabel.widthAnchor.constraint(equalTo: pairContainer2.widthAnchor, multiplier: 0.9).isActive = true
                        
                        minUnitLabel.translatesAutoresizingMaskIntoConstraints = false
                        minUnitLabel.topAnchor.constraint(equalTo: minValueLabel.bottomAnchor).isActive = true
                        minUnitLabel.widthAnchor.constraint(equalTo: pairContainer2.widthAnchor).isActive = true
                                                
                        let pairContainer3 = UIView()
                        let avgValueLabel = createValueLabel(key: "Average", dict: dict)
                        avgValueLabel.textAlignment = .center
                        let avgUnitLabel = createUnitLabel(labelText: "Average")
                        
                        pairContainer3.addSubview(avgValueLabel)
                        pairContainer3.addSubview(avgUnitLabel)
                        singleMetricContainer.addSubview(pairContainer3)
                        
                        pairContainer3.translatesAutoresizingMaskIntoConstraints = false
                        pairContainer3.leadingAnchor.constraint(equalTo: pairContainer2.trailingAnchor).isActive = true
                        pairContainer3.widthAnchor.constraint(equalTo: singleMetricContainer.widthAnchor, multiplier: 0.33).isActive = true
                        
                        avgValueLabel.translatesAutoresizingMaskIntoConstraints = false
                        avgValueLabel.topAnchor.constraint(equalTo: pairContainer3.topAnchor).isActive = true
                        avgValueLabel.widthAnchor.constraint(equalTo: pairContainer3.widthAnchor, multiplier: 0.9).isActive = true
                        
                        avgUnitLabel.translatesAutoresizingMaskIntoConstraints = false
                        avgUnitLabel.topAnchor.constraint(equalTo: avgValueLabel.bottomAnchor).isActive = true
                        avgUnitLabel.widthAnchor.constraint(equalTo: pairContainer3.widthAnchor).isActive = true
                        
                        let unitContainer = UIView()
                        let borderColor = UIColor.gray
                        unitContainer.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
                        unitContainer.layer.borderWidth = 0.8
                        unitContainer.layer.cornerRadius = 7.0
                        
                        unitContainer.addSubview(metricTitleLabel)
                        unitContainer.addSubview(singleMetricContainer)
                        
                        unitContainer.translatesAutoresizingMaskIntoConstraints = false
                        unitContainer.heightAnchor.constraint(equalToConstant: 180).isActive = true
                        
                        metricTitleLabel.translatesAutoresizingMaskIntoConstraints = false
                        metricTitleLabel.heightAnchor.constraint(equalTo: unitContainer.heightAnchor, multiplier: 0.5).isActive = true
                        metricTitleLabel.topAnchor.constraint(equalTo: unitContainer.topAnchor).isActive = true
                        metricTitleLabel.widthAnchor.constraint(equalTo: unitContainer.widthAnchor).isActive = true
                        
                        singleMetricContainer.translatesAutoresizingMaskIntoConstraints = false
                        singleMetricContainer.heightAnchor.constraint(equalTo: unitContainer.heightAnchor, multiplier: 0.5).isActive = true
                        singleMetricContainer.topAnchor.constraint(equalTo: metricTitleLabel.bottomAnchor).isActive = true
                        singleMetricContainer.widthAnchor.constraint(equalTo: unitContainer.widthAnchor).isActive = true
                        
                        metricStackView.addArrangedSubview(unitContainer)
                        
                    }
                } catch {
                    print("metric fetch error: \(error.localizedDescription)")
                }
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
            vc.date = [year, month, day]
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
        calendarHeatMap.scrollTo(date: Date(), at: .right, animated: false)
    }
}
