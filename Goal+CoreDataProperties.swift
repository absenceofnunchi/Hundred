//
//  Goal+CoreDataProperties.swift
//  Hundred
//
//  Created by jc on 2020-08-02.
//  Copyright © 2020 J. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var detail: String
    @NSManaged public var metrics: [String]?
    @NSManaged public var title: String
    @NSManaged public var date: Date
    @NSManaged public var progress: NSSet?

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
