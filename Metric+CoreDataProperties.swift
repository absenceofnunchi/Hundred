//
//  Metric+CoreDataProperties.swift
//  Hundred
//
//  Created by jc on 2020-09-03.
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
    @NSManaged public var id: UUID
    @NSManaged public var unit: String
    @NSManaged public var value: NSDecimalNumber
    @NSManaged public var metricToGoal: Goal
    @NSManaged public var progress: Progress

}
