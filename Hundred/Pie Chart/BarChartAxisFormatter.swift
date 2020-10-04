//
//  BarChartAxisFormatter.swift
//  Hundred
//
//  Created by jc on 2020-09-02.
//  Copyright © 2020 J. All rights reserved.
//

import Charts

class BarChartAxisFormatter: NSObject, IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "\(Int(value))%"
    }
}
