//
//  Goal+CoreDataProperties.swift
//  Hundred
//
//  Created by jc on 2020-08-01.
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

}
