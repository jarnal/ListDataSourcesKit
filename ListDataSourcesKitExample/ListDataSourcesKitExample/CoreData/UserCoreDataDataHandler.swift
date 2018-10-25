//
//  UserCoreDataDataHandler.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 24/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import ListDataSourcesKit
import CoreData

/// User data source using CoreDataEntityDataHandler
class UserCoreDataDataHandler: CoreDataEntityDataHandler<UITableView, User, UserCell> {
    
    /// Initialization overriden to set a sort descriptor for NSFetchResultController (mandatory)
    override init(forDataView dataView: UITableView, managedObjectContext: NSManagedObjectContext) {
        super.init(forDataView: dataView, managedObjectContext: managedObjectContext)
        sortDescriptors = [NSSortDescriptor(key: #keyPath(User.firstname), ascending: true)]
    }
    
    /// Model building
    ///
    /// - Parameter entity: entity
    /// - Returns: cell view model
    override func buildViewModel(withEntity entity: User) -> UserCellViewModel {
        return UserCellViewModel(firstName: entity.firstname!, lastName: entity.lastname!)
    }
    
}
