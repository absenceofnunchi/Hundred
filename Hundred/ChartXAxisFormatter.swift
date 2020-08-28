//
//  ChartXAxisFormatter.swift
//  Hundred
//
//  Created by jc on 2020-08-26.
//  Copyright © 2020 J. All rights reserved.
//

import Foundation
import Charts

class ChartXAxisFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd")
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date)
    }
}

//public class ChartXAxisFormatter: NSObject, IAxisValueFormatter {
//    private let dateFormatter = DateFormatter()
//    private let objects:[Double]
//
//    init(objects: [Double]) {
//        self.objects = objects
//        super.init()
//        dateFormatter.dateFormat = "dd MMM"
//    }
//
//    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        print("value: \(Int(value))")
//        print("objects: \(objects)")
//        if value >= 0 && Int(value) < objects.count {
//            let object = objects[Int(value)]
//            let date = Date(timeIntervalSince1970: object)
//            return dateFormatter.string(from: date)
//        }
//        return ""
//    }
//}

//class ChartXAxisFormatter: NSObject, IAxisValueFormatter {
//    private var metricsArr: [Metric]?
//    private var dateFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd")
//        return dateFormatter
//    }()
//
//    convenience init(usingMetrics metricsArr: [Metric]) {
//        self.init()
//        self.metricsArr = metricsArr
//    }
//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        let index = Int(value)
//        guard let metricsArr = metricsArr, index < metricsArr.count else {
//            return "?"
//        }
//
//        let date = metricsArr[index].date
//        print("date: \(date)")
//        print("date: \(dateFormatter.string(from: date))")
//        return dateFormatter.string(from: date)
//    }
//}
