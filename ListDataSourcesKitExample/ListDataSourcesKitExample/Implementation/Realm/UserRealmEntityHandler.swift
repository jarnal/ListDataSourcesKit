//
//  UserRealmEntityHandler.swift
//  ListDataSourcesKitExample
//
//  Created by Jonathan Arnal on 25/10/2018.
//  Copyright © 2018 Jonathan Arnal. All rights reserved.
//

import ListDataSourcesKit
import RealmSwift

/// User data source using DatSourceEntityHandler
class UserRealmEntityHandler: RealmEntityDataHandler<UITableView, RealmUser, UserCell> {
    
    override func buildViewModel(withEntity entity: RealmUser) -> UserCellViewModel {
        return UserCellViewModel(firstName: entity.firstName, lastName: entity.lastName)
    }
    
}
