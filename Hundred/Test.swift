////
////  EntryViewController.swift
////  Hundred
////
////  Created by jc on 2020-08-06.
////  Copyright © 2020 J. All rights reserved.
////
//
//import CalendarHeatmap
//import Charts
//import UIKit
//
//class EntryViewController1: UIViewController, CallBackDelegate, ChartViewDelegate {
//    
//    @IBOutlet weak var scrollView: UIScrollView!
//    var uiImage: UIImage!
//    var progress: Progress! {
//        didSet {
//            commentLabel.text = progress.comment
//            if let image = progress.image {
//                let imagePath = getDocumentsDirectory().appendingPathComponent(image)
//                if let data = try? Data(contentsOf: imagePath) {
//                    uiImage = UIImage(data: data)
//                    imageView.image = uiImage
//                }
//            }
//        }
//    }
//    var metrics: [String]?
//    var data: [String: UIColor]!
//    
//    private lazy var stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fill
//        stackView.alignment = .fill
//        stackView.spacing = 10
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 25, bottom: 0, trailing: 25)
//        scrollView.addSubview(stackView)
//        return stackView
//    }()
//    
//    var imageView = UIImageView()
//    
//    private lazy var dateLabel: UILabel = {
//        let dLabel = UILabel()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd"
//        dLabel.text = dateFormatter.string(from: progress.date)
//        dLabel.textAlignment = .right
//        dLabel.textColor = .lightGray
//        return dLabel
//    }()
//    
//    private var commentLabel: UILabel = {
//        let comment = UILabel()
//        comment.numberOfLines = 0
//        comment.adjustsFontSizeToFitWidth = false
//        comment.lineBreakMode = .byTruncatingTail
//        comment.font = UIFont.preferredFont(forTextStyle: .body)
//        return comment
//    }()
//    
//    private lazy var calendarHeatMap: CalendarHeatmap = {
//        var config = CalendarHeatmapConfig()
//        config.backgroundColor = UIColor(ciColor: .white)
////        config.backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
//        // config item
//        config.selectedItemBorderColor = .white
//        config.allowItemSelection = true
//        // config month header
//        config.monthHeight = 30
//        config.monthStrings = DateFormatter().shortMonthSymbols
//        config.monthFont = UIFont.systemFont(ofSize: 18)
//        config.monthColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
//        // config weekday label on left
//        config.weekDayFont = UIFont.systemFont(ofSize: 12)
//        config.weekDayWidth = 30
//        config.weekDayColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
//        
//        var dateComponent = DateComponents()
//        let yearsBefore = -1
//        dateComponent.year = yearsBefore
//        if let startDate = Calendar.current.date(byAdding: dateComponent, to: Date()) {
//            let calendar = CalendarHeatmap(config: config, startDate: startDate, endDate: Date())
//            return calendar
//        } else {
//            let calendar = CalendarHeatmap(config: config, startDate: Date(2019, 1, 1), endDate: Date())
//            return calendar
//        }
//    }()
//    
//    var buttonPanel = UIView()
//    
//    private lazy var editButton: UIButton = {
//        let gButton = UIButton()
//        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)
//        let uiImage = UIImage(systemName: "pencil.circle", withConfiguration: largeConfig)
//        gButton.tintColor = UIColor(red: 75/255, green: 123/255, blue: 236/255, alpha: 0.9)
//        gButton.setImage(uiImage, for: .normal)
//        gButton.tag = 1
//        gButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        self.buttonPanel.addSubview(gButton)
//        return gButton
//    }()
//    
//    private lazy var deleteButton: UIButton = {
//        let gButton = UIButton()
//        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)
//        let uiImage = UIImage(systemName: "trash.circle", withConfiguration: largeConfig)
//        gButton.tintColor = UIColor(red: 252/255, green: 92/255, blue: 101/255, alpha: 0.9)
//        gButton.setImage(uiImage, for: .normal)
//        gButton.tag = 2
//        gButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        self.buttonPanel.addSubview(gButton)
//        return gButton
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        title = progress.goal.title
//        
//        var dataImporter = DataImporter(goalTitle: progress.goal.title)
//        data = dataImporter.data
//        
//        configureUI()
//        setConstraints()
//        
//        if let importedMetrics = metrics {
//            if importedMetrics.count > 0 {
////                stackView.setCustomSpacing(80, after: calendarHeatMap)
////
////                let lineChartView = LineChartView()
////                lineChartView.data = loadMetricsData()
////                lineChartView.rightAxis.enabled = false
////                lineChartView.pinchZoomEnabled = true
////                lineChartView.dragEnabled = true
////                lineChartView.setScaleEnabled(true)
////                lineChartView.drawBordersEnabled = false
////                lineChartView.delegate = self
////
////                let l = lineChartView.legend
////                l.form = .circle
////                l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
////                l.textColor = .black
////                l.horizontalAlignment = .right
////                l.verticalAlignment = .top
////                l.orientation = .horizontal
////                l.drawInside = false
////                l.xEntrySpace = 7
////
////                let yAxis = lineChartView.leftAxis
////                yAxis.labelFont = .boldSystemFont(ofSize: 12)
////                yAxis.setLabelCount(6, force: false)
////                yAxis.labelTextColor = .gray
////                yAxis.axisLineColor = UIColor(white: 0.2, alpha: 0.4)
////                yAxis.labelPosition = .outsideChart
////                yAxis.gridColor = UIColor(white: 0.8, alpha: 0.4)
////
////                let xAxis = lineChartView.xAxis
////                xAxis.labelPosition = .bottom
////                xAxis.labelFont = .boldSystemFont(ofSize: 10)
////                xAxis.labelTextColor = .gray
////                xAxis.axisLineColor = UIColor(white: 0.2, alpha: 0.4)
////                xAxis.gridColor = UIColor(white: 0.8, alpha: 0.4)
////                xAxis.drawLimitLinesBehindDataEnabled = true
////                xAxis.drawAxisLineEnabled = false
////                xAxis.granularityEnabled = true
////                xAxis.granularity = 86400
//////                xAxis.valueFormatter = ChartXAxisFormatter(usingMetrics: metricsArr)
////                xAxis.valueFormatter = ChartXAxisFormatter()
////
////                let chartContainer = UIStackView()
////                chartContainer.axis = .vertical
////                chartContainer.distribution = .fill
////                chartContainer.alignment = .fill
////
////                addHeader(text: "Progress Chart", stackView: chartContainer)
////                chartContainer.addArrangedSubview(lineChartView)
////                stackView.insertArrangedSubview(chartContainer, at: 7)
////                stackView.setCustomSpacing(100, after: chartContainer)
////
////                lineChartView.translatesAutoresizingMaskIntoConstraints = false
////                lineChartView.heightAnchor.constraint(equalToConstant: 250).isActive = true
//            } else {
//                stackView.setCustomSpacing(150, after: calendarHeatMap)
//            }
//        } else {
//            stackView.setCustomSpacing(150, after: calendarHeatMap)
//        }
//    }
//    
//    func callBack(value: Progress) {
//        progress = value
//    }
//    
//    func configureUI() {
//        scrollView.addSubview(imageView)
//
//        stackView.addArrangedSubview(dateLabel)
//        stackView.setCustomSpacing(30, after: dateLabel)
//        addCard(text: "Comment", subItem: commentLabel, stackView: stackView, containerHeight: nil)
//        addCard(text: "Calendar", subItem: calendarHeatMap, stackView: stackView, containerHeight: 270)
//
////
////        stackView.addArrangedSubview(buttonPanel)
////        stackView.setCustomSpacing(80, after: buttonPanel)
//    }
//    
//    func setConstraints() {
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        if progress.image != nil {
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
//            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 9/16).isActive = true
//            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
//            if uiImage.size.width > uiImage.size.height {
//                imageView.contentMode = .scaleAspectFit
//            } else {
//                imageView.contentMode = .scaleAspectFill
//            }
//        } else {
//            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        }
//        
//        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
//        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
//        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        
////        calendarHeatMap.translatesAutoresizingMaskIntoConstraints = false
////        calendarHeatMap.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        
//        buttonPanel.translatesAutoresizingMaskIntoConstraints = false
//        buttonPanel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        
//        editButton.translatesAutoresizingMaskIntoConstraints = false
//        editButton.centerXAnchor.constraint(equalTo: buttonPanel.centerXAnchor, constant: -50).isActive = true
//        editButton.centerYAnchor.constraint(equalTo: buttonPanel.centerYAnchor).isActive = true
//        
//        deleteButton.translatesAutoresizingMaskIntoConstraints = false
//        deleteButton.centerXAnchor.constraint(equalTo: buttonPanel.centerXAnchor, constant: 50).isActive = true
//        deleteButton.centerYAnchor.constraint(equalTo: buttonPanel.centerYAnchor).isActive = true
//    }
//    
//    var metricDict = [String: [ChartDataEntry]]()
//    var metricsArr: [Metric] = []
//    
//    func loadMetricsData() -> LineChartData {
//        let metricsRequest = Metric.createFetchRequest()
//        metricsRequest.predicate = NSPredicate(format: "metricToGoal.title == %@", progress.goal.title)
//        let sort = NSSortDescriptor(key: "date", ascending: true)
//        metricsRequest.sortDescriptors = [sort]
//        if let fetchedMetrics = try? self.context.fetch(metricsRequest) {
//            if fetchedMetrics.count > 0 {
//                metricsArr = fetchedMetrics
//                for fetchedMetric in fetchedMetrics {
//                    let date = fetchedMetric.date.timeIntervalSince1970
//                    if var yValues = metricDict[fetchedMetric.unit] {
//                        yValues.append(ChartDataEntry(x: date, y: Double(truncating: fetchedMetric.value)))
//                        metricDict.updateValue(yValues, forKey: fetchedMetric.unit)
//                    } else {
//                        metricDict.updateValue([ChartDataEntry(x: date, y: Double(truncating: fetchedMetric.value))], forKey: fetchedMetric.unit)
//                    }
//                }
//                
//                let dataSet = metricDict.map { (set) -> LineChartDataSet in
//                    let lineChartDataSet = LineChartDataSet(entries: set.value, label: set.key)
//                    lineChartDataSet.drawIconsEnabled = false
//                    lineChartDataSet.lineDashLengths = [5, 2.5]
//                    lineChartDataSet.highlightLineDashLengths = [5, 2.5]
//                    let randomColour = UIColor(red: CGFloat.random(in: 50..<255)/255, green: CGFloat.random(in: 0..<220)/255, blue: CGFloat.random(in: 0..<220)/255, alpha: 0.8)
//                    lineChartDataSet.setColor(randomColour)
//                    lineChartDataSet.setCircleColor(randomColour)
//                    lineChartDataSet.lineWidth = 1
//                    lineChartDataSet.circleRadius = 3
//                    lineChartDataSet.drawCircleHoleEnabled = false
//                    lineChartDataSet.valueFont = .systemFont(ofSize: 9)
//                    lineChartDataSet.formLineDashLengths = [5, 2.5]
//                    lineChartDataSet.formLineWidth = 1
//                    lineChartDataSet.formSize = 15
//                    return lineChartDataSet
//                }
//                
//                let data = LineChartData(dataSets: dataSet)
//                data.setValueTextColor(.white)
//                data.setValueFont(.systemFont(ofSize: 9))
//                return data
//            }
//        }
//        return LineChartData(dataSets: nil)
//    }
//    
//    
//    @objc func buttonPressed(sender: UIButton!) {
//        switch sender.tag {
//        case 1:
//            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditEntry") as? EditEntryViewController {
//                vc.progress = progress
//                vc.delegate = self
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        case 2:
//            let ac = UIAlertController(title: "Delete", message: "Are you sure you want to delete your entry?", preferredStyle: .alert)
//            ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
//                self.context.delete(self.progress)
//                self.saveContext()
//                _ = self.navigationController?.popViewController(animated: true)
//            }))
//            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            present(ac, animated: true)
//        default:
//            print("default")
//        }
//    }
//    
//}
//
////extension EntryViewController: UINavigationControllerDelegate {
////
////    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
////        (viewController as? DetailTableViewController)?.tableView.reloadData()
////    }
////}
//
////                let yAxis = [
////                    ChartDataEntry(x: 10, y: 10),
////                    ChartDataEntry(x: 20, y: 20),
////                    ChartDataEntry(x: 30, y: 30),
////                    ChartDataEntry(x: 40, y: 40),
////                    ChartDataEntry(x: 50, y: 50)
////                ]
////
////                let set = LineChartDataSet(entries: yAxis, label: "Yellow")
////                set.drawIconsEnabled = false
////                set.lineDashLengths = [5, 2.5]
////                set.highlightLineDashLengths = [5, 2.5]
////                let randomColour = UIColor(red: CGFloat.random(in: 50..<255)/255, green: CGFloat.random(in: 0..<220)/255, blue: CGFloat.random(in: 0..<220)/255, alpha: 0.8)
////                set.setColor(randomColour)
////                set.setCircleColor(randomColour)
////                set.lineWidth = 1
////                set.circleRadius = 3
////                set.drawCircleHoleEnabled = false
////                set.valueFont = .systemFont(ofSize: 9)
////                set.formLineDashLengths = [5, 2.5]
////                set.formLineWidth = 1
////                set.formSize = 15
////
////                let data = LineChartData(dataSet: set)
//
