//
//  Progress+CoreDataProperties.swift
//  Hundred
//
//  Created by jc on 2020-08-17.
//  Copyright © 2020 J. All rights reserved.
//
//

import Foundation
import CoreData


extension Progress {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Progress> {
        return NSFetchRequest<Progress>(entityName: "Progress")
    }

    @NSManaged public var comment: String?
    @NSManaged public var date: Date
    @NSManaged public var image: String?
    @NSManaged public var location: String?
    @NSManaged public var goal: Goal
    @NSManaged public var metric: Set<Metric>

}

// MARK: Generated accessors for metric
extension Progress {

    @objc(addMetricObject:)
    @NSManaged public func addToMetric(_ value: Metric)

    @objc(removeMetricObject:)
    @NSManaged public func removeFromMetric(_ value: Metric)

    @objc(addMetric:)
    @NSManaged public func addToMetric(_ values: NSSet)

    @objc(removeMetric:)
    @NSManaged public func removeFromMetric(_ values: NSSet)

}
