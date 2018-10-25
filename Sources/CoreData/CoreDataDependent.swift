//
//  CoreDataDependent.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 23/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataDependent {

    var sortDescriptors: [NSSortDescriptor]? { get set }
    var predicate: NSPredicate? { get set }
    var sectionNameKeyPath: String? { get set }
    var cacheName: String? { get set }

    var sectionChanges: [() -> Void] { get set }
    var objectChanges: [() -> Void] { get set }
}
