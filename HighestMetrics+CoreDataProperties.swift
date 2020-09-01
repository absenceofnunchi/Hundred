//
//  HighestMetrics+CoreDataProperties.swift
//  Hundred
//
//  Created by jc on 2020-08-31.
//  Copyright © 2020 J. All rights reserved.
//
//

import Foundation
import CoreData


extension HighestMetrics {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<HighestMetrics> {
        return NSFetchRequest<HighestMetrics>(entityName: "HighestMetrics")
    }

    @NSManaged public var unit: String
    @NSManaged public var value: NSDecimalNumber
    @NSManaged public var highestToGoal: Goal

}
