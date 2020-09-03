//
//  Progress+CoreDataProperties.swift
//  Hundred
//
//  Created by jc on 2020-08-31.
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
    @NSManaged public var id: UUID
    @NSManaged public var goal: Goal
    @NSManaged public var metric: Set<Metric>

    public override func prepareForDeletion() {
        if let image = image {
            let fm = FileManager.default
            let paths = fm.urls(for: .documentDirectory, in: .userDomainMask)
            let imagePath = paths[0].appendingPathComponent(image)
            do {
                print("image removed")
                try fm.removeItem(at: imagePath)
            } catch {
                print("The image could not be deleted from the directory: \(error.localizedDescription)")
            }
        }
    }
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
