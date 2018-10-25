//
//  User+CoreDataProperties.swift
//  
//
//  Created by Jonathan Arnal on 24/10/2018.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var email: String?
    @NSManaged public var age: Int16

}
