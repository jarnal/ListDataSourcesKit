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
class UserCoreDataDataHandler<ListDataView: CellParentViewProtocol, DataCellView: ConfigurableNibReusableCell>: CoreDataEntityDataHandler<ListDataView, User, DataCellView> {
    
    override var sortDescriptors: [NSSortDescriptor]? {
        get { return [NSSortDescriptor(key: #keyPath(User.firstname), ascending: true)] }
        set { /*🔴*/ }
    }
    
    override func buildViewModel(withEntity entity: User) -> DataCellView.Model {
        return UserCellViewModel(firstName: entity.firstname!, lastName: entity.lastname!) as! DataCellView.Model
    }
    
}
