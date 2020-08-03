//
//  Progress+CoreDataProperties.swift
//  Hundred
//
//  Created by jc on 2020-08-03.
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
    @NSManaged public var firstMetric: NSDecimalNumber?
    @NSManaged public var image: String?
    @NSManaged public var location: String?
    @NSManaged public var secondMetric: NSDecimalNumber?
    @NSManaged public var goal: Goal

}
