//
//  EntryViewController.swift
//  Hundred
//
//  Created by jc on 2020-08-06.
//  Copyright © 2020 J. All rights reserved.
//

import CalendarHeatmap
import Charts
import UIKit

protocol CallBackDelegate {
    func callBack(value: Progress)
}

class EntryViewController: UIViewController, CallBackDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var uiImage: UIImage!
    var progress: Progress! {
        didSet {
            commentLabel.text = progress.comment
            if let image = progress.image {
                let imagePath = getDocumentsDirectory().appendingPathComponent(image)
                if let data = try? Data(contentsOf: imagePath) {
                    uiImage = UIImage(data: data)
                    imageView.image = uiImage
                }
            }
        }
    }
    var metrics: [String]?
    var data: [String: UIColor]!
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 25, bottom: 0, trailing: 25)
        scrollView.addSubview(stackView)
        return stackView
    }()
    
    var imageView = UIImageView()
    
    private var commentLabel: UILabel = {
        let comment = UILabel()
        comment.numberOfLines = 0
        comment.adjustsFontSizeToFitWidth = false
        comment.lineBreakMode = .byTruncatingTail
        comment.font = UIFont.preferredFont(forTextStyle: .body)
        return comment
    }()
    
    private lazy var calendarHeatMap: CalendarHeatmap = {
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
    
    private lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.rightAxis.enabled = false
        chartView.pinchZoomEnabled = true
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = UIColor(red: 0, green: 0, blue: 255/255, alpha: 1.0)
        yAxis.axisLineColor = UIColor(white: 0.2, alpha: 0.4)
        yAxis.labelPosition = .outsideChart
        yAxis.gridColor = UIColor(white: 0.8, alpha: 0.4)
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .boldSystemFont(ofSize: 12)
        xAxis.setLabelCount(6, force: false)
        xAxis.labelTextColor = UIColor(red: 0, green: 0, blue: 255/255, alpha: 1.0)
        xAxis.axisLineColor = UIColor(white: 0.2, alpha: 0.4)
        xAxis.gridColor = UIColor(white: 0.8, alpha: 0.4)
        
        chartView.animate(xAxisDuration: 1.5)
        
        return chartView
    }()
    
    lazy var buttonPanel: UIView = {
        let bView = UIView()
        return bView
    }()
    
    lazy var editButton: UIButton = {
        let gButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)
        let uiImage = UIImage(systemName: "pencil.circle", withConfiguration: largeConfig)
        gButton.tintColor = UIColor(red: 75/255, green: 123/255, blue: 236/255, alpha: 0.9)
        gButton.setImage(uiImage, for: .normal)
        gButton.tag = 1
        gButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.buttonPanel.addSubview(gButton)
        return gButton
    }()
    
    lazy var deleteButton: UIButton = {
        let gButton = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)
        let uiImage = UIImage(systemName: "trash.circle", withConfiguration: largeConfig)
        gButton.tintColor = UIColor(red: 252/255, green: 92/255, blue: 101/255, alpha: 0.9)
        gButton.setImage(uiImage, for: .normal)
        gButton.tag = 2
        gButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        self.buttonPanel.addSubview(gButton)
        return gButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataImporter = DataImporter()
        data = dataImporter.data
                
        configureStackView()
        setStackViewConstraints()
        setData()
    }
    
    func callBack(value: Progress) {
        progress = value
    }

    func configureStackView() {
        scrollView.addSubview(imageView)
        
        addHeader(text: "Comment", stackView: stackView)
        stackView.addArrangedSubview(commentLabel)
        stackView.setCustomSpacing(50, after: commentLabel)
        
        addHeader(text: "Calendar", stackView: stackView)
        stackView.addArrangedSubview(calendarHeatMap)
        stackView.setCustomSpacing(50, after: calendarHeatMap)
        
        addHeader(text: "Progress Chart", stackView: stackView)
        stackView.addArrangedSubview(lineChartView)
        stackView.setCustomSpacing(100, after: lineChartView)
        
        stackView.addArrangedSubview(buttonPanel)
        stackView.setCustomSpacing(80, after: buttonPanel)
    }
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if progress.image != nil {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, constant: 9/16).isActive = true
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
            if uiImage.size.width > uiImage.size.height {
                imageView.contentMode = .scaleAspectFit
            } else {
                imageView.contentMode = .scaleAspectFill
            }
        } else {
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        }
        
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        calendarHeatMap.translatesAutoresizingMaskIntoConstraints = false
        calendarHeatMap.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        buttonPanel.translatesAutoresizingMaskIntoConstraints = false
        buttonPanel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.centerXAnchor.constraint(equalTo: buttonPanel.centerXAnchor, constant: -50).isActive = true
        editButton.centerYAnchor.constraint(equalTo: buttonPanel.centerYAnchor).isActive = true
        
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.centerXAnchor.constraint(equalTo: buttonPanel.centerXAnchor, constant: 50).isActive = true
        deleteButton.centerYAnchor.constraint(equalTo: buttonPanel.centerYAnchor).isActive = true
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: yValues, label: "Subscribers")
        set1.drawCirclesEnabled = false
        set1.lineWidth = 3
        set1.mode = .cubicBezier
        set1.setColor(.white)
        set1.fill = Fill(color: .lightGray)
        set1.fillAlpha = 0.4
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    let yValues: [ChartDataEntry] = [
        ChartDataEntry(x: 0.0, y: 10.0),
        ChartDataEntry(x: 1.0, y: 14.0),
        ChartDataEntry(x: 2.0, y: 4.0),
        ChartDataEntry(x: 3.0, y: 19.0),
        ChartDataEntry(x: 4.0, y: 34.0),
        ChartDataEntry(x: 5.0, y: 29.0),
    ]
    
    @objc func buttonPressed(sender: UIButton!) {
        switch sender.tag {
        case 1:
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditEntry") as? EditEntryViewController {
                vc.progress = progress
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case 2:
            let ac = UIAlertController(title: "Delete", message: "Are you sure you want to delete your entry?", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
                self.context.delete(self.progress)
                self.saveContext()
                _ = self.navigationController?.popViewController(animated: true)
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(ac, animated: true)
        default:
            print("default")
        }
    }
    
}

extension EntryViewController: CalendarHeatmapDelegate {
    func didSelectedAt(dateComponents: DateComponents) {
        guard let year = dateComponents.year,
            let month = dateComponents.month,
            let day = dateComponents.day else { return }
        print(year, month, day)
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

//extension EntryViewController: UINavigationControllerDelegate {
//
//    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//        (viewController as? DetailTableViewController)?.tableView.reloadData()
//    }
//}


