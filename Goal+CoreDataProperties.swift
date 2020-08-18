//
//  Goal+CoreDataProperties.swift
//  Hundred
//
//  Created by jc on 2020-08-17.
//  Copyright © 2020 J. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var date: Date
    @NSManaged public var detail: String?
    @NSManaged public var metrics: [String]?
    @NSManaged public var title: String
    @NSManaged public var progress: Set<Progress>
    @NSManaged public var goalToMetric: Set<Progress>

}

// MARK: Generated accessors for progress
extension Goal {

    @objc(addProgressObject:)
    @NSManaged public func addToProgress(_ value: Progress)

    @objc(removeProgressObject:)
    @NSManaged public func removeFromProgress(_ value: Progress)

    @objc(addProgress:)
    @NSManaged public func addToProgress(_ values: NSSet)

    @objc(removeProgress:)
    @NSManaged public func removeFromProgress(_ values: NSSet)

}

// MARK: Generated accessors for goalToMetric
extension Goal {

    @objc(addGoalToMetricObject:)
    @NSManaged public func addToGoalToMetric(_ value: Metric)

    @objc(removeGoalToMetricObject:)
    @NSManaged public func removeFromGoalToMetric(_ value: Metric)

    @objc(addGoalToMetric:)
    @NSManaged public func addToGoalToMetric(_ values: NSSet)

    @objc(removeGoalToMetric:)
    @NSManaged public func removeFromGoalToMetric(_ values: NSSet)

}
