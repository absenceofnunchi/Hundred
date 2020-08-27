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
//        let index = value.rounded()
        let index = Int(value)
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MM/dd")
        let date = Date(timeIntervalSince1970: index)
        return dateFormatter.string(from: date)
    }
}
