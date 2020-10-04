//
//  Subscription+CoreDataProperties.swift
//  Hundred
//
//  Created by J C on 2020-09-23.
//  Copyright © 2020 J. All rights reserved.
//
//

import Foundation
import CoreData


extension Subscription {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Subscription> {
        return NSFetchRequest<Subscription>(entityName: "Subscription")
    }

    @NSManaged public var userId: String
    @NSManaged public var username: String
    @NSManaged public var subscriptionId: String

}

extension Subscription : Identifiable {

}
