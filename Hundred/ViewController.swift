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
    
    lazy var data: [String: UIColor] = {
        guard let data = readHeatmap() else { return [:] }
        return data.mapValues { (colorIndex) -> UIColor in
            switch colorIndex {
            case 0:
                return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
            case 1:
                return UIColor(red: 204/255, green: 204/255, blue: 255/255, alpha: 1.0)
            case 2:
                return UIColor(red: 153/255, green: 153/255, blue: 255/255, alpha: 1.0)
            case 3:
                return UIColor(red: 102/255, green: 102/255, blue: 255/255, alpha: 1.0)
            case 4:
                return UIColor(red: 51/255, green: 51/255, blue: 255/255, alpha: 1.0)
            case 5:
                return UIColor(red: 0, green: 0, blue: 255/255, alpha: 1.0)
            case 6:
                return UIColor(red: 0, green: 0, blue: 204/255, alpha: 1.0)
            case 7:
                return UIColor(red: 0, green: 0, blue: 153/255, alpha: 1.0)
            case 8:
                return UIColor(red: 0, green: 0, blue: 102/255, alpha: 1.0)
            case 9:
                return UIColor(red: 0, green: 0, blue: 51/255, alpha: 1.0)
            default:
                return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            }
        }
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
        
        //        view.backgroundColor = UIColor(ciColor: .white)
        
        view.addSubview(calendarHeatMap)
        calendarHeatMap.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            calendarHeatMap.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 6),
            calendarHeatMap.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 6),
            calendarHeatMap.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reloadHeatmap))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarHeatMap.reload()
    }
    
    @objc private func reloadHeatmap() {
        calendarHeatMap.reload()
    }
    
    private func readHeatmap() -> [String: Int]? {
        guard let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("Heatmap.plist") else { return nil }
        return NSDictionary(contentsOf: url) as? [String: Int]
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
        calendarHeatMap.scrollTo(date: Date(), at: .right, animated: true)
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
