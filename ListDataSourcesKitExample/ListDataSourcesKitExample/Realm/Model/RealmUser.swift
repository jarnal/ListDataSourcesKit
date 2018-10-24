//
//  User.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 23/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUser: Object {
    
    // **************************************************************
    // MARK: - Variables
    // **************************************************************
    
    @objc dynamic var id = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var email = ""
    @objc dynamic var age = 0
    
    var fullName: String {
        return firstName
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
