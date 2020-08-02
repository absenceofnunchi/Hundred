//
//  Progress+CoreDataProperties.swift
//  Hundred
//
//  Created by jc on 2020-08-02.
//  Copyright © 2020 J. All rights reserved.
//
//

import Foundation
import CoreData


extension Progress {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Progress> {
        return NSFetchRequest<Progress>(entityName: "Progress")
    }

    @NSManaged public var date: Date
    @NSManaged public var comment: String?
    @NSManaged public var firstMetric: Double
    @NSManaged public var secondMetric: Double
    @NSManaged public var location: String?
    @NSManaged public var image: Data?
    @NSManaged public var goal: Goal

}
