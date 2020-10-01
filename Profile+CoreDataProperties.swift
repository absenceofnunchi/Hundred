//
//  Profile+CoreDataProperties.swift
//  Hundred
//
//  Created by J C on 2020-09-23.
//  Copyright © 2020 J. All rights reserved.
//
//

import Foundation
import CoreData


extension Profile {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Profile> {
        return NSFetchRequest<Profile>(entityName: "Profile")
    }

    @NSManaged public var username: String!
    @NSManaged public var detail: String
    @NSManaged public var image: String
    @NSManaged public var userId: UUID!
    @NSManaged public var subscription: [String]?

}

extension Profile : Identifiable {

}
