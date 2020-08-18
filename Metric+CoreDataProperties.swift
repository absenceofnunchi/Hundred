//
//  Metric+CoreDataProperties.swift
//  Hundred
//
//  Created by jc on 2020-08-17.
//  Copyright © 2020 J. All rights reserved.
//
//

import Foundation
import CoreData


extension Metric {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Metric> {
        return NSFetchRequest<Metric>(entityName: "Metric")
    }

    @NSManaged public var date: Date
    @NSManaged public var unit: String
    @NSManaged public var value: NSDecimalNumber
    @NSManaged public var progress: Progress
    @NSManaged public var metricToGoal: Goal

}