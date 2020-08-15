//
//  ViewController.swift
//  Hundred
//
//  Created by jc on 2020-07-31.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit
import CalendarHeatmap

class ViewController: UIViewController {
    var data: [String: UIColor]!
    
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
        
        view.addSubview(calendarHeatMap)
        calendarHeatMap.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            calendarHeatMap.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 6),
            calendarHeatMap.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 6),
            calendarHeatMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadHeatmap))
        
        let dataImporter = DataImporter()
        data = dataImporter.data
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarHeatMap.reload()
    }

    @objc private func reloadHeatmap() {
        calendarHeatMap.reload()
    }
}

extension ViewController: CalendarHeatmapDelegate {
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

extension Date {
    init(_ year:Int, _ month: Int, _ day: Int) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        self.init(timeInterval:0, since: Calendar.current.date(from: dateComponents)!)
    }
}
