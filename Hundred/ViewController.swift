//
//  ViewController.swift
//  Hundred
//
//  Created by jc on 2020-07-31.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CalendarHeatmap
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
            let metricCard = MetricCard()
            let (containerView, cardHeight) = metricCard.createMetricCard(entryCount: goal.progress.count, goal: goal, metricsDict: nil, fetchedAnalytics: nil, currentStreak: nil, longestStreak: nil)
            addCard(text: goal.title, subItem: containerView, stackView: stackView, containerHeight: cardHeight, bottomSpacing: 30, tag: 5)
        }
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
