//
//  UserDataSourceEntityHandler.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 24/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import ListDataSourcesKit

/// User data source using DatSourceEntityHandler
class UserDataSourceEntityHandler: DataSourceEntityDataHandler<UITableView, RealmUser, UserCell> {
    
    override func buildViewModel(withEntity entity: RealmUser) -> UserCellViewModel {
        return UserCellViewModel(firstName: entity.firstName, lastName: entity.lastName)
    }
    
}
